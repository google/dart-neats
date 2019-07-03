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
import 'dart:io' show SocketException;
import 'package:dartis/dartis.dart';
import 'package:logging/logging.dart';
import '../../cache_provider.dart';

final _logger = Logger('neat_cache');

class _RedisContext {
  final Connection connection;
  final Client client;
  final Commands<String, List<int>> commands;
  _RedisContext({this.connection, this.client, this.commands});
}

typedef _Op<T> = Future<T> Function(Commands<String, List<int>>);

class RedisCacheProvider extends CacheProvider<List<int>> {
  final String _connectionString;
  final Duration _connectTimeLimit;
  final Duration _commandTimeLimit;
  final Duration _reconnectDelay;

  Future<_RedisContext> _context;
  bool _isClosed = false;

  RedisCacheProvider(
    this._connectionString, {
    Duration connectTimeLimit = const Duration(seconds: 30),
    Duration commandTimeLimit = const Duration(milliseconds: 200),
    Duration reconnectDelay = const Duration(seconds: 30),
  })  : _connectTimeLimit = connectTimeLimit,
        _commandTimeLimit = commandTimeLimit,
        _reconnectDelay = reconnectDelay {
    assert(_connectionString.isNotEmpty, 'connectionString must be given');
    assert(!_connectTimeLimit.isNegative, 'connectTimeLimit is negative');
    assert(!_commandTimeLimit.isNegative, 'commandTimeLimit is negative');
    assert(!_reconnectDelay.isNegative, 'reconnectDelay is negative');
  }

  Future<_RedisContext> _createContext() async {
    try {
      _logger.info('Connecting to redis');
      final connection = await Connection.connect(_connectionString)
          .timeout(_connectTimeLimit);
      // Create context
      final client = Client(connection);
      return _RedisContext(
        connection: connection,
        client: client,
        commands: client.asCommands(),
      );
    } on TimeoutException {
      throw IntermittentCacheException('connect failed with timeout');
    } on SocketException {
      throw IntermittentCacheException('connect failed with socket exception');
    } on Exception {
      throw IntermittentCacheException('connect failed with exception');
    }
  }

  Future<_RedisContext> _getContext() {
    if (_context != null) {
      return _context;
    }
    _context = _createContext();
    scheduleMicrotask(() async {
      _RedisContext ctx;
      try {
        ctx = await _context;
      } on IntermittentCacheException {
        // If connecting fails, then we sleep and try again
        await Future.delayed(_reconnectDelay);
        _context = null; // reset _context, so next operation creates a new
        return;
      } catch (e) {
        _logger.shout('unknown error/exception connecting to redis', e);
        _context = null; // reset _context, so next operation creates a new
        rethrow; // propagate the error to crash to application.
      }
      // If connecting was successful, then we await the connection being
      // closed or error, and we reset _context.
      // Any errors have already been returned if any commands were affect
      // otherwise the error is just a broken TCP connection and we ignore it.
      try {
        await ctx.connection.done;
      } catch (e) {
        // ignore error
      }
      _context = null;
    });
    return _context;
  }

  Future<T> _withRedis<T>(_Op<T> fn) async {
    if (_isClosed) {
      throw StateError('CacheProvider.closed() has been called');
    }
    final ctx = await _getContext();
    try {
      return await fn(ctx.commands).timeout(_commandTimeLimit);
    } on TimeoutException {
      // If we had a timeout, doing the command we forcibly disconnect
      // from the server, such that next retry will use a new connection.
      await ctx.connection.disconnect().catchError((e) {/* ignore */});

      throw IntermittentCacheException(
        'operation timed-out, we have closed the connection',
      );
    } on RedisConnectionClosedException {
      await ctx.connection.disconnect().catchError((e) {/* ignore */});
      throw IntermittentCacheException('connection already closed');
    } on SocketException {
      await ctx.connection.disconnect().catchError((e) {/* ignore */});
      throw IntermittentCacheException('socket broken');
    }
  }

  @override
  Future<void> close() async {
    _isClosed = true;
    if (_context != null) {
      final ctx = await _context.catchError((e) {/* ignore */});
      if (ctx != null) {
        await ctx.connection.disconnect().catchError((e) {/* ignore */});
      }
    }
  }

  @override
  Future<List<int>> get(String key) => _withRedis((redis) => redis.get(key));

  @override
  Future<void> set(String key, List<int> value, [Duration ttl]) =>
      _withRedis((redis) => redis.set(key, value, seconds: ttl?.inSeconds));

  @override
  Future<void> purge(String key) => _withRedis((redis) => redis.del(key: key));
}
