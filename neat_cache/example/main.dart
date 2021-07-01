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

import 'dart:async' show Future;
import 'dart:convert' show utf8;
import 'package:neat_cache/neat_cache.dart';

Future<void> main() async {
  final u = Uri.parse('redis://localhost:6379');
  final cacheProvider = Cache.redisCacheProvider(u);
  final cache = Cache(cacheProvider);

  /// Create a sub-cache using a prefix, and apply a codec to store utf8
  final userCache = cache.withPrefix('users').withCodec(utf8);

  /// Get data form cache
  final userinfo = await userCache['peter-pan'].get();
  print(userinfo);

  /// Put data into cache
  await userCache['winnie'].set('Like honey');

  await cacheProvider.close();
}
