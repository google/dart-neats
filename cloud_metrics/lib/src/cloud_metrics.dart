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

import 'dart:core';
import 'dart:math' as math;

import 'package:clock/clock.dart' show clock;
import 'package:collection/collection.dart';
import 'package:meta/meta.dart' show protected, sealed;

final _measures = <_Measure<num>>[];

/// A [Measure] is a kind of data-point that can be recorded.
///
/// When a [Measure] is defined a list of [View]s on the [Measure] are also
/// created. The [View]s are in effect aggregations of the data-points recorded
/// for the [Measure].
///
/// **Example**
/// ```dart
/// import 'package:cloud_metrics/cloud_metrics.dart';
///
/// final requestPayloadSize = Measure.bytes(views: [
///   // Aggregate payload sizes in a histogram.
///   View(
///     name: 'request-payload-sizes',
///     displayName: 'Request Size Distribution',
///     description: 'Distribution of various request sizes',
///     aggregation: Aggregation.linearHistogram(
///       bucketCount: 100,
///       maxValue: 10 * 1024, // 10 kiB
///     ),
///   ),
///   // Count the number of requests.
///   View(
///     name: 'request-count',
///     displayName: 'Request Count',
///     description: 'Number of requests recorded',
///     aggregation: Aggregation.count(),
///   ),
///   // Sum total number of bytes received
///   View(
///     name: 'request-size-sum',
///     displayName: 'Request Size',
///     description: 'Total number of request payload bytes received',
///     aggregation: Aggregation.sum(),
///   ),
/// ]);
///
/// Response handleRequest(Request request) {
///   // Record the size of a request body
///   requestPayloadSize.record(request.bodyBytes.length);
///   // ...
/// }
/// ```
@sealed
abstract class Measure<T> {
  /// Record [value] as a data-point for this measure.
  void record(T value);

  /// Create custom [Measure] accepting [double] as data-points.
  ///
  /// For supported [unit] values, see:
  /// https://cloud.google.com/monitoring/api/ref_v3/rpc/google.api#metricdescriptor
  static Measure<double> float64({
    String? unit,
    required Iterable<View> views,
  }) {
    return _Measure(unit ?? '1', views.toList(growable: false));
  }

  /// Create custom [Measure] accepting [int] as data-points.
  ///
  /// For supported [unit] values, see:
  /// https://cloud.google.com/monitoring/api/ref_v3/rpc/google.api#metricdescriptor
  static Measure<int> int64({
    String? unit,
    required Iterable<View> views,
  }) {
    return _Measure(unit ?? '1', views.toList(growable: false));
  }

  /// Measure [Duration] in ms.
  static Measure<Duration> duration({
    required Iterable<View> views,
  }) =>
      convert(
        float64(unit: 'ms', views: views),
        (d) => d.inMilliseconds.toDouble(),
      );

  /// Measure [int] as bytes.
  static Measure<int> bytes({
    required Iterable<View> views,
  }) =>
      int64(unit: 'By', views: views);

  /// Convert the type of [Measure].
  ///
  /// Beware that this does not change the unit.
  static Measure<T> convert<S, T>(
    Measure<S> measure,
    S Function(T) convert,
  ) =>
      _ConvertedMeasure(measure, convert);
}

class _Measure<T extends num> implements Measure<T> {
  final String _unit;
  final List<View> _views;
  final List<_Aggregator<T>> _aggregators;

  _Measure(
    this._unit,
    this._views,
  ) : _aggregators = _views
            .map((view) => view.aggregation._aggregator<T>())
            .toList(growable: false) {
    final allViewNames = _measures.expand((m) => m._views.map((v) => v.name));
    final conflictingViewNames =
        allViewNames.where(_views.map((v) => v.name).toSet().contains).toList();

    if (conflictingViewNames.isNotEmpty) {
      throw ArgumentError.value(
        conflictingViewNames.first,
        'name',
        'view names must be unique within an application',
      );
    }
    _measures.add(this);
  }

  @override
  void record(T value) {
    for (final aggregator in _aggregators) {
      aggregator.aggregate(value);
    }
  }
}

class _ConvertedMeasure<S, T> implements Measure<T> {
  final Measure<S> _measure;
  final S Function(T) _convert;

  _ConvertedMeasure(this._measure, this._convert);

  @override
  void record(T value) => _measure.record(_convert(value));
}

/// A [View] defines how a [Measure] should be aggregated and reported.
///
/// Each [View] results in a time-series of data-points in the system to which
/// metrics are reported.
@sealed
class View {
  final String name;
  final String displayName;
  final String description;
  final Aggregation aggregation;

  View._(this.name, this.displayName, this.description, this.aggregation);

  /// Create a [View] with a application unique [name], that is the [name] and
  /// the _monitored resource_ configured when exporting metrics should be
  /// globally unique.
  ///
  /// The [displayName] and [description] should show up in the monitoring.
  ///
  /// The [aggregation] determines how data-points from the [Measure] are
  /// aggregated before being exported to the monitoring backend.
  factory View({
    required String name,
    required String displayName,
    required String description,
    required Aggregation aggregation,
  }) {
    return View._(
      name,
      displayName,
      description,
      aggregation,
    );
  }
}

/// Aggregation strategy for a [View].
///
/// Custom implementations of [Aggregation] is not supported.
@sealed
abstract class Aggregation {
  /// Create an [Aggregation] that counts data-
  factory Aggregation.linearHistogram({
    required int bucketCount,
    double minValue = 0,
    required double maxValue,
  }) =>
      LinearHistogram._(
        bucketCount: bucketCount,
        minValue: minValue,
        maxValue: maxValue,
      );

  factory Aggregation.exponentialHistogram({
    required int bucketCount,
    required double growthFactor,
    required double scale,
  }) =>
      ExponentialHistogram._(
        bucketCount: bucketCount,
        growthFactor: growthFactor,
        scale: scale,
      );

  /// Create an [Aggregation] given [bucketCount], [scale] and
  /// [maxValue].
  ///
  /// This derives a [growthFactor] from [maxValue]. The first bucket will hold
  /// all values less than [scale], so if you pick a [scale] no larger than the
  /// smallest value you care about you should be reasonably fine.
  ///
  /// Picking a low [scale] like `0.01` will create large buckets at end of the
  /// scale. Whereas a larger [scale] will create more even buckets. However,
  /// as the first bucket will count all values less than [scale], it follows
  /// that [scale] cannot be larger than the smallest value you care to
  /// distinguish from other values.
  ///
  /// This constructor is here as rule-of-thumb milage may vary.
  factory Aggregation.exponentialHistogramFromRange({
    required int bucketCount,
    required double scale,
    required double maxValue,
  }) =>
      ExponentialHistogram._fromRange(
        bucketCount: bucketCount,
        scale: scale,
        maxValue: maxValue,
      );

  /// An [Aggregation] that counts the number of data-points from a [Measure].
  ///
  /// This will never look at the actual values, just count how many values are
  /// reported.
  ///
  /// For a [Measure] that measures the response latency in a web server, this
  /// aggregation could be used to create a [View] that reports the number of
  /// requests/responses.
  factory Aggregation.count() => CountAggregation._();

  /// An [Aggregation] that summarizes all the data-points from a [Measure].
  ///
  /// This will ignore the number of value, but report the sum of all the
  /// values.
  ///
  /// For a [Measure] that measures the request size in a web server, this
  /// aggregation could be used to create a [View] that reports the number of
  /// bytes recevied.
  factory Aggregation.sum() => SumAggregation._();

  _Aggregator<T> _aggregator<T extends num>();
}

/// An [Aggregation] that summarizes data-points from a [Measure] into a
/// _linear histogram_.
///
/// The histogram will have [bucketCount] finite buckets, and 2 unbounded
/// buckets at the start / end of the range. So in total there will be
/// `N = bucketCount + 2` number of buckets.
///
/// Example:
/// TODO: Write a table of a linear bucket
///
/// This [Aggregation] produces a [DistributionResult] for each reporting
/// interval.
@sealed
class LinearHistogram implements Aggregation {
  /// Number of finite buckets.
  ///
  /// There is `N = bucketCount + 2` buckets. The two extra buckets are
  /// infinite buckets, because the first bucket lacks a lower-bound, and the
  /// last bucket lacks an upper-bound.
  final int bucketCount;

  /// Lower-bound for the first finite bucket.
  final double minValue;

  /// Upper-bound for the last finite bucket.
  final double maxValue;

  LinearHistogram._({
    required this.bucketCount,
    required this.minValue,
    required this.maxValue,
  }) {
    if (bucketCount < 1) {
      throw ArgumentError.value(bucketCount, 'bucketCount', 'must be >= 1');
    }
    if (minValue < maxValue) {
      throw ArgumentError.value(maxValue, 'maxValue', 'must > minValue');
    }
  }

  @override
  _Aggregator<T> _aggregator<T extends num>() =>
      _LinearHistogramAggregator._(this);
}

@sealed
class ExponentialHistogram implements Aggregation {
  final int bucketCount;
  final double growthFactor;
  final double scale;

  ExponentialHistogram._({
    required this.bucketCount,
    required this.growthFactor,
    required this.scale,
  }) {
    if (bucketCount < 1) {
      throw ArgumentError.value(bucketCount, 'bucketCount', 'must be >= 1');
    }
    if (growthFactor <= 1) {
      throw ArgumentError.value(growthFactor, 'growthFactor', 'must > 1');
    }
    if (scale < 0) {
      throw ArgumentError.value(scale, 'scale', 'must > 0');
    }
  }

  ExponentialHistogram._fromRange({
    required this.bucketCount,
    required this.scale,
    required double maxValue,
  }) : growthFactor = math.pow(maxValue / scale, 1.0 / bucketCount).toDouble() {
    if (bucketCount < 1) {
      throw ArgumentError.value(bucketCount, 'bucketCount', 'must be >= 1');
    }
    if (scale <= 0) {
      throw ArgumentError.value(scale, 'scale', 'must > 0');
    }
    if (maxValue <= 0) {
      throw ArgumentError.value(maxValue, 'maxValue', 'must > 0');
    }
  }

  @override
  _Aggregator<T> _aggregator<T extends num>() =>
      _ExponentialHistogramAggregator._(this);
}

/// An [Aggregation] that counts the number of data-points from a [Measure],
/// and produces a [ValueResult] for each reporting interval.
@sealed
class CountAggregation implements Aggregation {
  CountAggregation._();

  @override
  _Aggregator<T> _aggregator<T extends num>() => _CountAggregator();
}

/// An [Aggregation] that summarizes data-points from a [Measure],
/// and produces a [ValueResult] for each reporting interval.
@sealed
class SumAggregation implements Aggregation {
  SumAggregation._();

  @override
  _Aggregator<T> _aggregator<T extends num>() => _SumAggregator();
}

abstract class _Aggregator<T extends num> {
  void aggregate(T value);

  AggregationResult result();
}

class _LinearHistogramAggregator<T extends num> implements _Aggregator<T> {
  final LinearHistogram aggregation;

  final DateTime _startTime;

  final List<int> _bucketCounts;
  double _sum = 0;
  int _count = 0;
  double _mean = 0;
  double _sumOfSquaredDeviation = 0;

  _LinearHistogramAggregator._(this.aggregation)
      : _startTime = clock.now(),
        _bucketCounts = List.generate(
          aggregation.bucketCount + 2,
          (_) => 0,
          growable: false,
        );

  @override
  void aggregate(num value) {
    _sum += value;

    // Example: Suppose we have:
    //   _minValue = 10
    //   _maxValue = 50
    //   _bucketCount = 4  // results in 6 buckets
    //
    // Then we get:
    final width =
        (aggregation.maxValue - aggregation.minValue) / aggregation.bucketCount;
    // and we get buckets like:
    //   0: [-infinity;10]
    //   1: [10;20]
    //   2: [20;30]
    //   3: [30;40]
    //   4: [40;50]
    //   5: [50;infinity]
    // , where top and bottom buckets are unbounded, see:
    // https://cloud.google.com/monitoring/api/ref_v3/rest/v3/TypedValue#linear
    //
    // Now, if we get:
    //  * value = 5,  then: bucket = floor((5 - _minValue)  / width) + 1 = 0
    //  * value = 35, then: bucket = floor((35 - _minValue)  / width) + 1 = 3
    //
    // Hence:
    var bucket = ((value - aggregation.minValue) / width).floor() + 1;
    // Handle cases where bucket < 0 or bucket > _maxValue -1
    if (bucket < 0) {
      bucket = 0;
    }
    if (bucket > aggregation.bucketCount + 1) {
      bucket = aggregation.bucketCount + 1;
    }
    // Increment bucket count
    _bucketCounts[bucket]++;

    // Maintain [_mean] and [_sumOfSquaredDeviation] using
    // Method of Provisional Means, see:
    // https://pages.stat.wisc.edu/~larget/math496/mean-var.html
    _count += 1;
    final dev = value - _mean;
    _mean = _mean + (dev / _count);
    _sumOfSquaredDeviation += dev * (value - _mean);
  }

  @override
  AggregationResult result() => DistributionResult._(
        startTime: _startTime,
        bucketCounts: UnmodifiableListView(_bucketCounts),
        sum: _sum,
        count: _count,
        mean: _mean,
        sumOfSquaredDeviation: _sumOfSquaredDeviation,
      );
}

class _ExponentialHistogramAggregator<T extends num> implements _Aggregator<T> {
  final ExponentialHistogram aggregation;
  final DateTime _startTime;

  final double _logGrowth;
  final List<int> _bucketCounts;
  double _sum = 0;
  int _count = 0;
  double _mean = 0;
  double _sumOfSquaredDeviation = 0;

  _ExponentialHistogramAggregator._(this.aggregation)
      : _startTime = clock.now(),
        _logGrowth = math.log(aggregation.growthFactor),
        _bucketCounts = List.generate(
          aggregation.bucketCount + 2,
          (_) => 0,
          growable: false,
        );

  @override
  void aggregate(num value) {
    _sum += value;
    // Example: Suppose we have:
    //   growthFactor = 4
    //   scale = 0.5
    //   bucketCount = 4     // results in 6 buckets
    //
    // Then we get buckets like:
    //   0: [-infinity;0.5]
    //   1: [0.5;2]
    //   2: [2;8]
    //   3: [8;32]
    //   4: [32;128]
    //   5: [128;infinity]
    // , where top and bottom buckets are unbounded, see:
    // https://cloud.google.com/monitoring/api/ref_v3/rest/v3/TypedValue#Exponential
    //
    // Now, if we get:
    //  * value = 5,  then: bucket = floor(log(5 / 0.5) / log(4) + 1) = 2
    //  * value = 45, then: bucket = floor(log(45 / 0.5) / log(4) + 1) = 4
    //
    // Hence:
    var bucket = (math.log(value / aggregation.scale) / _logGrowth + 1).floor();
    // Handle cases where bucket < 0 or bucket > _maxValue -1
    if (bucket < 0) {
      bucket = 0;
    }
    if (bucket > aggregation.bucketCount + 1) {
      bucket = aggregation.bucketCount + 1;
    }
    // Increment bucket count
    _bucketCounts[bucket]++;

    // Maintain [_mean] and [_sumOfSquaredDeviation] using
    // Method of Provisional Means, see:
    // https://pages.stat.wisc.edu/~larget/math496/mean-var.html
    _count += 1;
    final dev = value - _mean;
    _mean = _mean + (dev / _count);
    _sumOfSquaredDeviation += dev * (value - _mean);
  }

  @override
  AggregationResult result() => DistributionResult._(
        startTime: _startTime,
        bucketCounts: UnmodifiableListView(_bucketCounts),
        sum: _sum,
        count: _count,
        mean: _mean,
        sumOfSquaredDeviation: _sumOfSquaredDeviation,
      );
}

class _CountAggregator<T extends num> implements _Aggregator<T> {
  final DateTime _startTime;

  var _count = 0;

  _CountAggregator() : _startTime = clock.now();

  @override
  void aggregate(T value) => _count += 1;

  @override
  AggregationResult result() => ValueResult._(
        startTime: _startTime,
        value: _count,
      );
}

class _SumAggregator<T extends num> implements _Aggregator<T> {
  final DateTime _startTime;

  T _sum = 0 as T;

  _SumAggregator() : _startTime = clock.now();

  @override
  void aggregate(T value) => _sum = (_sum + value) as T;

  @override
  AggregationResult result() => ValueResult._(
        startTime: _startTime,
        value: _sum,
      );
}

@sealed
abstract class AggregationResult {
  AggregationResult._({required this.startTime});

  final DateTime startTime;
}

@sealed
class DistributionResult extends AggregationResult {
  final List<int> bucketCounts;
  final double sum;
  final int count;
  final double mean;
  final double sumOfSquaredDeviation;

  DistributionResult._({
    required DateTime startTime,
    required this.bucketCounts,
    required this.sum,
    required this.count,
    required this.mean,
    required this.sumOfSquaredDeviation,
  }) : super._(startTime: startTime);
}

@sealed
class ValueResult<T extends num> extends AggregationResult {
  final T value;

  ValueResult._({
    required DateTime startTime,
    required this.value,
  }) : super._(startTime: startTime);
}

@sealed
class Metric {
  final String name;
  final String displayName;
  final String description;
  final String unit;
  final Aggregation aggregation;
  final AggregationResult result;

  Metric._({
    required this.name,
    required this.displayName,
    required this.description,
    required this.unit,
    required this.aggregation,
    required this.result,
  });
}

/// Abstraction for a class that periodically exports metrics.
abstract class MetricsExporter {
  /// Stop exporting metrics from this [MetricsExporter].
  Future<void> stopExportingMetrics();

  /// Get a metrics from all views.
  ///
  /// This is intended to be used by [MetricsExporter] implementations.
  @protected
  static Iterable<Metric> get metrics sync* {
    for (final measure in _measures) {
      for (var i = 0; i < measure._views.length; i++) {
        final view = measure._views[i];
        final aggregator = measure._aggregators[i];
        yield Metric._(
          name: view.name,
          displayName: view.displayName,
          description: view.description,
          unit: measure._unit,
          aggregation: view.aggregation,
          result: aggregator.result(),
        );
      }
    }
  }
}
