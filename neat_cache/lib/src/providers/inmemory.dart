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
import '../../cache_provider.dart';

class _InMemoryEntry<T> {
  final T value;
  final DateTime? _expires;
  _InMemoryEntry(this.value, [this._expires]);
  bool get isExpired => _expires != null && _expires!.isBefore(DateTime.now());
}

/// Simple two-generational LRU cache inspired by:
/// https://github.com/sindresorhus/quick-lru
class InMemoryCacheProvider<T> extends CacheProvider<T> {
  /// New generation of cache entries.
  Map<String, _InMemoryEntry<T>> _new = <String, _InMemoryEntry<T>>{};

  /// Old generation of cache entries.
  Map<String, _InMemoryEntry<T>> _old = <String, _InMemoryEntry<T>>{};

  /// Maximum size before clearing old generation.
  final int _maxSize;

  /// Have this been closed.
  bool _isClosed = false;

  InMemoryCacheProvider(this._maxSize);

  /// Clear old generation, if _maxSize have been reached.
  void _maintainGenerations() {
    if (_new.length >= _maxSize) {
      _old = _new;
      _new = {};
    }
  }

  @override
  Future<T?> get(String key) async {
    if (_isClosed) {
      throw StateError('CacheProvider.close() have been called');
    }
    // Lookup in the new generation
    var entry = _new[key];
    if (entry != null) {
      if (!entry.isExpired) {
        return entry.value;
      }
      // Remove, if expired
      _new.remove(key);
    }
    // Lookup in the old generation
    entry = _old[key];
    if (entry != null) {
      if (!entry.isExpired) {
        // If not expired, we insert the entry into the new generation
        _new[key] = entry;
        _maintainGenerations();
        return entry.value;
      }
      // Remove, if expired
      _old.remove(key);
    }
    return null;
  }

  @override
  Future<void> set(String key, T value, [Duration? ttl]) async {
    if (_isClosed) {
      throw StateError('CacheProvider.close() have been called');
    }
    if (ttl == null) {
      _new[key] = _InMemoryEntry(value);
    } else {
      _new[key] = _InMemoryEntry(value, DateTime.now().add(ttl));
    }
    // Always remove key from old generation to avoid risks of looking up there
    // if it's overwritten by an entry with a shorter ttl
    _old.remove(key);
    _maintainGenerations();
  }

  @override
  Future<void> purge(String key) async {
    if (_isClosed) {
      throw StateError('CacheProvider.close() have been called');
    }
    _new.remove(key);
    _old.remove(key);
  }

  @override
  Future<void> close() async {
    _isClosed = true;
    _old = {};
    _new = {};
  }
}
