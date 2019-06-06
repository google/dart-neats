Neat Periodic Task Scheduling 
=============================

When writing long-running processes such as a web-server in Dart it is often
useful to run maintenance operations in a periodic background task. This package
provides an auxiliary framework for reliably running such tasks.

**Disclaimer:** This is not an officially supported Google product.

Backup tasks, database maintenance operations, garbage collection of cloud
storage, pre-computed data aggregations are often tasks that can't be done
on-line every time a request arrives at a web-server. While doing the task more
than once isn't a problem, it is wasteful to run it too often and could lead to
performance degradation or an expensive cloud bill.

One solution is off-load such tasks to a clouding scheduling system similar to
cron, but such services typically require out-of-band configuration.
Further more, a scheduling service needs a way to trigger your task, requiring
that the web server exposes a public web API for triggering the task.

However, if the web-server is a set of long-processes serving traffic, the
web-server could simply run the task on a loop with a long delay. That is
effectively what this package facilitates. Obviously, this package has few more
tricks such as.

  * Run a periodic task on a loop.
  * Limit maximum run-time to prevent a hanging loop.
  * Retry failed task executions after a timeout.
  * Catch and log all exceptions/errors from the task.
  * (Optionally) prevent concurrent tasks using status in a storage service that
    supports optimistic concurrency (eg. Cloud Datastore, Google Cloud Storage).
  * Print log messages liveness monitoring of the periodic tasks.

## Example

```dart
import 'dart:io';
import 'package:neat_periodic_task/neat_periodic_task.dart';

void main() async {
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
```

## Monitoring

When a `NeatPeriodicTaskScheduler` is created it is given a task `name`. When
the scheduler is running the following log messages is written to package
[logging](https://pub.dartlang.org/packages/logging).

* `'### [ALIVE] neat-periodic-task: "<name>"'`, when task status is verified to be idle,
* `'### [START] neat-periodic-task: "<name>"'`, when task is started,
* `'### [FAILED] neat-periodic-task: "<name>"'`, when task has failed, and,
* `'### [FINISHED] neat-periodic-task: "<name>"'`, when task is finished.

To be alerted when a task consistently fails to run, it is sufficient to alert
if the log message `'### [ALIVE] neat-periodic-task: "<name>"'` is absent from
logs for more than 24 hours. This message is printed when the status is checked
and the scheduler decided not to run the task because it was completely
successfully less than `interval` time ago.

A simple robust monitoring strategy is to alert if the message
`'### [ALIVE] neat-periodic-task: "<name>"'` have **not** occurred in 24 hours.
This works regardless of the `interval` length, and will fire alerts even if the
server fails to boot.

If the task is intended to run frequently it is also possible to monitor for
`'### [FINISHED] neat-periodic-task: "<name>"'`. Simply alert if this message
does not appear at-least once every `3 * interval`.

