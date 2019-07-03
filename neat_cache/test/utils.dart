import 'dart:async';
import 'dart:convert';
import 'package:neat_cache/cache_provider.dart';
import 'package:logging/logging.dart';
import 'package:convert/convert.dart' show IdentityCodec;

void setupLogging() {
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((LogRecord rec) {
    print('${rec.level.name}: ${rec.message}');
  });
}

/// Simple class to wrap a `CacheProvider<T>` + `Codec<String, T>` to get a
/// `CacheProvider<String>`.
///
/// This is just meant to be useful for testing.
class StringCacheProvider<T> implements CacheProvider<String> {
  final CacheProvider<T> cache;
  final Codec<String, T> codec;
  StringCacheProvider({this.cache, this.codec = const IdentityCodec()});

  @override
  Future<String> get(String key) async {
    final val = await cache.get(key);
    if (val == null) {
      return null;
    }
    return codec.decode(val);
  }

  @override
  Future set(String key, String value, [Duration ttl]) =>
      cache.set(key, codec.encode(value), ttl);

  @override
  Future purge(String key) => cache.purge(key);

  @override
  Future close() => cache.close();
}
