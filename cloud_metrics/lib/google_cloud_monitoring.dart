// Copyright 2022 Google LLC
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     https://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import 'dart:async';
import 'dart:io' show IOException;

import 'package:clock/clock.dart';
import 'package:collection/collection.dart';
import 'package:googleapis/monitoring/v3.dart' as monitoring;
import 'package:http/http.dart' as http;
import 'package:logging/logging.dart';
import 'package:pool/pool.dart';

import 'exporter.dart';
import 'src/retry_client.dart' show retryClient;

final _log = Logger('metrics');

/// Start exporting metrics to Google Cloud Monitoring.
///
/// The [monitoredResourceType] and [monitoredResourceLabels] must match a
/// resource type defined in:
/// https://cloud.google.com/monitoring/api/resources
Future<MetricsExporter> googleCloudMonitoringExporter({
  required http.Client client,
  required String projectId,
  required String monitoredResourceType,
  Map<String, Object> monitoredResourceLabels = const {},
  Duration interval = const Duration(minutes: 1),
  String metricTypePrefix = '',
}) async {
  if (interval.inSeconds < 5) {
    throw ArgumentError.value(interval, 'interval', 'must be >= 5 seconds');
  }
  if (metricTypePrefix.isNotEmpty && !metricTypePrefix.endsWith('/')) {
    throw ArgumentError.value(
      metricTypePrefix,
      'metricTypePrefix',
      'must end with a slash (/)',
    );
  }

  final api = monitoring.MonitoringApi(retryClient(client: client));

  try {
    final rd = await api.projects.monitoredResourceDescriptors.get(
      'projects/$projectId/monitoredResourceDescriptors/$monitoredResourceType',
    );
    final requiredLabels = (rd.labels ?? []).map((ld) => ld.key!).toSet();

    final forbiddenLabels = monitoredResourceLabels.keys.toSet()
      ..removeAll(requiredLabels);
    if (forbiddenLabels.isNotEmpty) {
      throw ArgumentError.value(
        monitoredResourceLabels,
        'monitoredResourceLabels',
        'labels "${forbiddenLabels.join('", "')}" are not allowed'
            ' for resourceType: "$monitoredResourceType"',
      );
    }

    final labels = rd.labels;
    if (labels != null) {
      for (final ld in labels) {
        if (!monitoredResourceLabels.containsKey(ld.key!)) {
          throw ArgumentError.value(
            monitoredResourceLabels,
            'monitoredResourceLabels',
            'a label for "${ld.key}" is required'
                ' for resourceType: "$monitoredResourceType"',
          );
        }
        final value = monitoredResourceLabels[ld.key!];
        if (ld.valueType == 'STRING' && value is! String) {
          throw ArgumentError.value(
            monitoredResourceLabels,
            'monitoredResourceLabels',
            'label for key "${ld.key}" must be a String'
                ' for resourceType: "$monitoredResourceType"',
          );
        } else if (ld.valueType == 'BOOL' && value is! bool) {
          throw ArgumentError.value(
            monitoredResourceLabels,
            'monitoredResourceLabels',
            'label for key "${ld.key}" must be a bool'
                ' for resourceType: "$monitoredResourceType"',
          );
        } else if (ld.valueType == 'INT64' && value is! int) {
          throw ArgumentError.value(
            monitoredResourceLabels,
            'monitoredResourceLabels',
            'label for key "${ld.key}" must be a int'
                ' for resourceType: "$monitoredResourceType"',
          );
        }
      }
    }
  } on monitoring.DetailedApiRequestError catch (e) {
    if (e.status == 404) {
      throw ArgumentError.value(
        monitoredResourceType,
        'monitoredResourceType',
        'does not exist',
      );
    }
  }

  final monitoredResource = monitoring.MonitoredResource(
    type: monitoredResourceType,
    labels: monitoredResourceLabels
        .map((key, value) => MapEntry(key, value.toString())),
  );

  return _GoogleCloudMonitoringExporter(
    projectId,
    api,
    monitoredResource,
    interval,
    metricTypePrefix,
  );
}

class _GoogleCloudMonitoringExporter extends MetricsExporter {
  final String _projectId;
  final monitoring.MonitoringApi _api;
  final monitoring.MonitoredResource _monitoredResource;
  final Duration _interval;
  final String _metricTypePrefix;

  final _brokenMetricTypes = <String>{};
  final _createdMetricTypes = <String>{};

  Timer? _exportTimer;
  Completer<void> _done = Completer()..complete();

  _GoogleCloudMonitoringExporter(
    this._projectId,
    this._api,
    this._monitoredResource,
    this._interval,
    this._metricTypePrefix,
  ) {
    _exportTimer = Timer(_interval, _timerCallback);
  }

  void _timerCallback() async {
    _done = Completer();
    try {
      // Send metrics
      await _sendMetrics();
    } finally {
      // Report that we're done sending metrics
      _done.complete();

      // Export in _interval, if not asked to stop.
      if (_exportTimer != null) {
        _exportTimer = Timer(_interval, _timerCallback);
      }
    }
  }

  String _metricTypeFromMetric(Metric metric) =>
      'custom.googleapis.com/$_metricTypePrefix${metric.name}';

  String _valueTypeFromMetric(Metric metric) {
    if (metric.result is DistributionResult) {
      return 'DISTRIBUTION';
    }
    if (metric.result is ValueResult<double>) {
      return 'FLOAT64';
    }
    assert(metric.result is ValueResult<int>);
    return 'INT64';
  }

  monitoring.TypedValue _valueFromMetric(Metric metric) {
    final result = metric.result;
    if (result is DistributionResult) {
      late final monitoring.BucketOptions bucketOptions;

      final aggregation = metric.aggregation;
      if (aggregation is LinearHistogram) {
        bucketOptions = monitoring.BucketOptions(
          linearBuckets: monitoring.Linear(
            numFiniteBuckets: aggregation.bucketCount,
            offset: aggregation.minValue.toDouble(),
            width: (aggregation.maxValue - aggregation.minValue) /
                aggregation.bucketCount,
          ),
        );
      } else if (aggregation is ExponentialHistogram) {
        bucketOptions = monitoring.BucketOptions(
          exponentialBuckets: monitoring.Exponential(
            numFiniteBuckets: aggregation.bucketCount,
            scale: aggregation.scale,
            growthFactor: aggregation.growthFactor,
          ),
        );
      } else {
        throw AssertionError('Unknown aggretation $aggregation');
      }

      return monitoring.TypedValue(
        distributionValue: monitoring.Distribution(
          bucketCounts: result.bucketCounts.map((c) => c.toString()).toList(),
          bucketOptions: bucketOptions,
          count: result.count.toString(),
          mean: result.count > 0 ? result.mean : 0,
          sumOfSquaredDeviation:
              result.count > 0 ? result.sumOfSquaredDeviation : 0,
        ),
      );
    }
    if (result is ValueResult<double>) {
      return monitoring.TypedValue(doubleValue: result.value);
    }
    if (result is ValueResult<int>) {
      return monitoring.TypedValue(int64Value: result.value.toString());
    }
    throw AssertionError('Unknown result type: $result');
  }

  Future<void> _sendMetrics() async {
    final p = Pool(20);
    final allMetrics = MetricsExporter.metrics.slices(200).toList();
    final endTime = clock.now();

    await Future.wait(allMetrics.map((metrics) async {
      // Find metrics to create
      final metricsToCreate = metrics
          .whereNot((m) => _createdMetricTypes.contains(m.name))
          .whereNot((m) => _brokenMetricTypes.contains(m.name));
      await Future.wait(metricsToCreate.map((metric) async {
        // Create metric descriptor
        try {
          await p.withResource(() => _api.projects.metricDescriptors.create(
                monitoring.MetricDescriptor(
                  displayName: metric.displayName,
                  description: metric.description,
                  type: _metricTypeFromMetric(metric),
                  metricKind: 'CUMULATIVE',
                  valueType: _valueTypeFromMetric(metric),
                  unit: metric.unit,
                  // TODO: Support labels
                ),
                'projects/$_projectId',
              ));
          _createdMetricTypes.add(metric.name);
        } on monitoring.DetailedApiRequestError catch (e, st) {
          _brokenMetricTypes.add(metric.name);

          // If the `type` already exists, then the API will return 409, this is
          // undocumented, but can be confirmed using the API explorer.
          if (e.status == 409) {
            _log.shout(
              'Custom metric type: "${_metricTypeFromMetric(metric)}" already'
              ' exists, and has been declared to be a differnet type.'
              ' You must choose a different metric name!',
              e,
              st,
            );
          } else {
            _log.severe(
              'Failed to create MetricDescritor for custom metric type:'
              ' "${_metricTypeFromMetric(metric)}", with statusCode:'
              ' ${e.status}',
              e,
              st,
            );
          }
        } on monitoring.ApiRequestError catch (e, st) {
          _brokenMetricTypes.add(metric.name);
          _log.severe(
            'Failed to create MetricDescritor for custom metric type:'
            ' "${_metricTypeFromMetric(metric)}"',
            e,
            st,
          );
        } on IOException catch (e, st) {
          _log.severe(
            'Failed to create MetricDescritor for custom metric type:'
            ' "${_metricTypeFromMetric(metric)}"',
            e,
            st,
          );
        }
      }));

      try {
        await p.withResource(() => _api.projects.timeSeries.create(
              monitoring.CreateTimeSeriesRequest(
                timeSeries: metrics
                    .where((m) => _createdMetricTypes.contains(m.name))
                    .map((metric) => monitoring.TimeSeries(
                          resource: _monitoredResource,
                          unit: metric.unit,
                          metric: monitoring.Metric(
                            type: _metricTypeFromMetric(metric),
                            // TODO: Add support for labels
                          ),
                          metricKind: 'CUMULATIVE',
                          points: [
                            monitoring.Point(
                              interval: monitoring.TimeInterval(
                                startTime: metric.result.startTime.toJson(),
                                endTime: endTime.toUtc().toJson(),
                              ),
                              value: _valueFromMetric(metric),
                            ),
                          ],
                          valueType: _valueTypeFromMetric(metric),
                        ))
                    .toList(growable: false),
              ),
              'projects/$_projectId',
            ));
      } on monitoring.ApiRequestError catch (e, st) {
        _log.shout('Failed to create time-series', e, st);
      } on IOException catch (e, st) {
        _log.severe('Failed to send time-series', e, st);
      }
    }));
  }

  @override
  Future<void> stopExportingMetrics() async {
    final timer = _exportTimer;
    _exportTimer = null;
    timer?.cancel();

    await _done.future;
  }
}

extension on DateTime {
  /// Return ISO-8601 formatted as Javascript would.
  ///
  /// This is the same as [toIso8601String] with:
  ///  * Timezone set to UTC,
  ///  * Microseconds omitted.
  ///
  /// Many APIs expect ISO-8601 formatted dates in this format.
  String toJson() => DateTime.fromMillisecondsSinceEpoch(millisecondsSinceEpoch)
      .toUtc()
      .toIso8601String();
}
