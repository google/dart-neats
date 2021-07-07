// Copyright 2021 Google LLC
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
  StringCacheProvider({
    required this.cache,
    this.codec = const IdentityCodec(),
  });

  @override
  Future<String?> get(String key) async {
    final val = await cache.get(key);
    if (val == null) {
      return null;
    }
    return codec.decode(val);
  }

  @override
  Future set(String key, String value, [Duration? ttl]) {
    if (ttl != null) {
      return cache.set(key, codec.encode(value), ttl);
    }
    return cache.set(key, codec.encode(value));
  }

  @override
  Future purge(String key) => cache.purge(key);

  @override
  Future close() => cache.close();
}
