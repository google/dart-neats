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
import 'neat_cache.dart' show Cache;

/// Low-level interface for a cache.
///
/// This can be an in-memory cache, something that writes to disk or to an
/// cache service such as memcached or redis.
///
/// The [Cache] provided by `package:neat_cache`, is intended to wrap
/// a [CacheProvider] and provide a more convinient high-level interface.
///
/// Implementers of [CacheProvider] can implement something that stores a value
/// of any type `T`, but usually implementers should aim to implement
/// `CacheProvider<List<int>>` which stores binary data.
///
/// Implementations of the [CacheProvider] interface using a remote backing
/// store should throw [IntermittentCacheException] when an intermittent network
/// issue occurs. The [CacheProvider] should obviously attempt to reconnect to
/// the remote backing store, but it should not retry operations.
///
/// Operations will be retried by [Cache], if necessary. Many use-cases of
/// caching are resilient to intermittent failures.
abstract class CacheProvider<T> {
  /// Fetch data stored under [key].
  ///
  /// If nothing is cached for [key], this **must** return `null`.
  Future<T?> get(String key);

  /// Set [value] stored at [key] with optional [ttl].
  ///
  /// If a value is already stored at [key], that value should be overwritten
  /// with the new [value] given here.
  ///
  /// When given [ttl] is advisory, however, implementers should avoid returning
  /// entries that are far past their [ttl].
  Future<void> set(String key, T value, [Duration? ttl]);

  /// Clear value stored at [key].
  ///
  /// After this has returned future calls to [get] for the given [key] should
  /// not return any value, unless a new value have been set.
  Future<void> purge(String key);

  /// Close all connections, causing all future operations to throw.
  ///
  /// This method frees resources used by this [CacheProvider], if backed by
  /// a remote service like redis, this should close the connection.
  ///
  /// Calling [close] multiple times does not throw. But after this has returned
  /// all future operations should throw [StateError].
  Future<void> close();
}

/// Exception thrown when there is an intermittent exception.
///
/// This is typically thrown if there is an intermittent connection error.
class IntermittentCacheException implements Exception {
  final String _message;
  IntermittentCacheException(this._message);

  @override
  String toString() => _message;
}
