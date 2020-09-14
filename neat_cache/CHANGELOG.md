## v1.0.2
 * Upgrade `package:dartis`.
 * `RedisCacheProvider` accepts redis `Connection` or a callback that returns
   `Connection` alongside a connection `String`.

## v1.0.1
 * Avoid unnecessary purging when calling `set` with a `create` function that
   returns `null`.

## v1.0.0
 * Initial release.
