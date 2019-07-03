Neat Cache
==========

Abstractions around in-memory caches stores such as redis, with timeouts and
automatic reconnects.

**Disclaimer:** This is not an officially supported Google product.

## Example

```dart
import 'dart:async' show Future;
import 'dart:convert' show utf8;
import 'package:neat_cache/neat_cache.dart';

Future<void> main() async {
  final cacheProvider = Cache.redisCacheProvider('redis://localhost:6379');
  final cache = Cache(cacheProvider);

  /// Create a sub-cache using a prefix, and apply a codec to store utf8
  final userCache = cache.withPrefix('users').withCodec(utf8);

  /// Get data form cache
  String userinfo = await userCache['peter-pan'].get();
  print(userinfo);

  /// Put data into cache
  await userCache['winnie'].set('Like honey');

  await cacheProvider.close();
}
```


## Development
To test the redis `CacheProvider` a redis instance must be running on
`localhost:6379`, this can be setup with:

 * `docker run --rm -p 127.0.0.1:6379:6379 redis`
