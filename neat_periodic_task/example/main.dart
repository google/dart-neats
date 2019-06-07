// Copyright 2019 Google LLC
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
import 'dart:io';
import 'package:neat_periodic_task/neat_periodic_task.dart';

Future<void> main() async {
  // Create a periodic task that prints 'Hello World' every 30s
  final scheduler = NeatPeriodicTaskScheduler(
    interval: Duration(seconds: 30),
    name: 'hello-world',
    timeout: Duration(seconds: 5),
    task: () async => print('Hello World'),
    minCycle: Duration(seconds: 5),
  );

  scheduler.start();
  await ProcessSignal.sigterm.watch().first;
  await scheduler.stop();
}
