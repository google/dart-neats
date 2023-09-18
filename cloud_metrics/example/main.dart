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

import 'package:clock/clock.dart';
import 'package:cloud_metrics/cloud_metrics.dart';
import 'package:cloud_metrics/google_cloud_monitoring.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:logging/logging.dart';

void main() async {
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((LogRecord rec) {
    final time = clock.now(); // rec.time

    for (final line in rec.message.split('\n')) {
      print('$time [${rec.loggerName}] ${rec.level.name}: $line');
    }
    if (rec.error != null) {
      print('ERROR: ${rec.error}, ${rec.stackTrace}');
    }
  });

  final client = await clientViaApplicationDefaultCredentials(scopes: [
    'https://www.googleapis.com/auth/monitoring.write',
  ]);

  var now = clock.now().subtract(Duration(minutes: 60));
  await withClock(Clock(() => now), () async {
    final _requestLatency = Measure.duration(views: [
      View(
        name: 'request-latency-test-2',
        displayName: 'Request Latency Test',
        description:
            'Test data points... trying to create metrics.. this is just a test',
        aggregation: Aggregation.linearHistogram(
          bucketCount: 10,
          minValue: 0,
          maxValue: 100,
        ),
      ),
    ]);

    final exporter = await googleCloudMonitoringExporter(
      client: client,
      projectId: 'jonasfj-dart-testing',
      monitoredResourceType: 'gae_instance',
      monitoredResourceLabels: {
        'project_id': 'jonasfj-dart-testing',
        'module_id': 'default',
        'version_id': 'jonasfj',
        'instance_id': 'test-demo-1234-isolate-1',
        'location': 'us-central1-a',
      },
      interval: Duration(hours: 1), // Never send data in this test
    ) as dynamic;

    Future<void> sendMetrics() async {
      now = now.add(Duration(minutes: 1));
      await exporter._sendMetrics();
    }

    for (var j = 0; j < 5; j++) {
      for (var i = 0; i < 5; i++) {
        _requestLatency.record(Duration(milliseconds: 5));
      }
      await sendMetrics();
    }

    for (var j = 0; j < 5; j++) {
      for (var i = 0; i < 5; i++) {
        _requestLatency.record(Duration(milliseconds: 50));
      }
      await sendMetrics();
    }

    for (var j = 0; j < 5; j++) {
      for (var i = 0; i < 5; i++) {
        _requestLatency.record(Duration(milliseconds: 95));
      }
      await sendMetrics();
    }

    for (var j = 0; j < 5; j++) {
      for (var i = 0; i < 5; i++) {
        _requestLatency.record(Duration(milliseconds: 5));
        _requestLatency.record(Duration(milliseconds: 95));
      }
      await sendMetrics();
    }

    await exporter.stopExportingMetrics();
  });
  client.close();
}
