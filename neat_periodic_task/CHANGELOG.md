## v2.1.0
 * Added heartbeat support to `NeatPeriodicTaskScheduler`:
   * `heartbeatInterval` and `heartbeatTimeout` parameters allow tasks to
     periodically refresh a heartbeat timestamp in the status while running.
   * If a running worker process crashes or is terminated abruptly, other
     schedulers can detect the expired heartbeat after `heartbeatTimeout`
     and reclaim the task without waiting for the full `timeout`.
 * Added `heartbeat` property to `NeatTaskStatus`.

## v2.0.1
 * Added `topics` to `pubspec.yaml`.

## v2.0.0
 * Migrated to null-safety!

## v1.0.1
 * Changed failure to write finished status into a warning. It's only a problem
   if it consistently occurs. It could happen if something else went wrong,
   hence, we classify it as a warning.

## v1.0.0+2
 * Relaxed dependency constraint on `json_annotation` to allow both version
   `2.0.0` and `3.0.0`.

## v1.0.0+1
 * Relaxed dependency constraints on `retry` to allow both `2.x` and `3.x`.

## v1.0.0
 * Initial release.
