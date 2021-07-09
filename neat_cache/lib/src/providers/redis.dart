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
import 'dart:io' show IOException, Socket, SocketOption;
import 'dart:typed_data';
import 'resp.dart';
import 'package:logging/logging.dart';
import '../../cache_provider.dart';

final _log = Logger('neat_cache');

class _RedisContext {
  final RespClient client;
  _RedisContext({
    required this.client,
  });
}

class RedisCacheProvider extends CacheProvider<List<int>> {
  final Uri _connectionString;
  final Duration _connectTimeLimit;
  final Duration _commandTimeLimit;
  final Duration _reconnectDelay;

  Future<_RedisContext>? _context;
  bool _isClosed = false;

  RedisCacheProvider(
    Uri connectionString, {
    Duration connectTimeLimit = const Duration(seconds: 30),
    Duration commandTimeLimit = const Duration(milliseconds: 200),
    Duration reconnectDelay = const Duration(seconds: 30),
  })  : _connectionString = connectionString,
        _connectTimeLimit = connectTimeLimit,
        _commandTimeLimit = commandTimeLimit,
        _reconnectDelay = reconnectDelay {
    if (!connectionString.isScheme('redis')) {
      throw ArgumentError.value(
          connectionString, 'connectionString', 'must have scheme redis://');
    }
    if (!connectionString.hasEmptyPath) {
      throw ArgumentError.value(
          connectionString, 'connectionString', 'cannot have a path');
    }
    if (connectTimeLimit.isNegative) {
      throw ArgumentError.value(
          connectTimeLimit, 'connectTimeLimit', 'must be positive');
    }
    if (commandTimeLimit.isNegative) {
      throw ArgumentError.value(
          commandTimeLimit, 'commandTimeLimit', 'must be positive');
    }
    if (reconnectDelay.isNegative) {
      throw ArgumentError.value(
          reconnectDelay, 'reconnectDelay', 'must be positive');
    }
  }

  Future<_RedisContext> _createContext() async {
    try {
      _log.info('Connecting to redis');
      final socket = await Socket.connect(
        _connectionString.host,
        _connectionString.port,
      ).timeout(_connectTimeLimit);
      socket.setOption(SocketOption.tcpNoDelay, true);

      // Create context
      return _RedisContext(
        client: RespClient(socket, socket),
      );
    } on RedisConnectionException {
      throw IntermittentCacheException('connection failed');
    } on TimeoutException {
      throw IntermittentCacheException('connect failed with timeout');
    } on IOException catch (e) {
      throw IntermittentCacheException('connect failed with IOException: $e');
    } on Exception {
      throw IntermittentCacheException('connect failed with exception');
    }
  }

  Future<_RedisContext> _getContext() {
    if (_context != null) {
      return _context!;
    }
    _context = _createContext();
    scheduleMicrotask(() async {
      _RedisContext ctx;
      try {
        ctx = await _context!;
      } on IntermittentCacheException {
        // If connecting fails, then we sleep and try again
        await Future.delayed(_reconnectDelay);
        _context = null; // reset _context, so next operation creates a new
        return;
      } catch (e) {
        _log.shout('unknown error/exception connecting to redis', e);
        _context = null; // reset _context, so next operation creates a new
        rethrow; // propagate the error to crash to application.
      }
      // If connecting was successful, then we await the connection being
      // closed or error, and we reset _context.
      try {
        await ctx.client.closed;
      } catch (e) {
        // ignore error
      }
      _context = null;
    });
    return _context!;
  }

  Future<T> _withResp<T>(Future<T> Function(RespClient) fn) async {
    if (_isClosed) {
      throw StateError('CacheProvider.closed() has been called');
    }
    final ctx = await _getContext();
    try {
      return await fn(ctx.client).timeout(_commandTimeLimit);
    } on RedisCommandException catch (e) {
      throw AssertionError('error from redis command: $e');
    } on TimeoutException {
      // If we had a timeout, doing the command we forcibly disconnect
      // from the server, such that next retry will use a new connection.
      await ctx.client.close(force: true);
      throw IntermittentCacheException('redis command timeout');
    } on RedisConnectionException catch (e) {
      throw IntermittentCacheException('redis error: $e');
    } on IOException catch (e) {
      throw IntermittentCacheException('socket broken: $e');
    }
  }

  @override
  Future<void> close() async {
    _isClosed = true;
    if (_context != null) {
      try {
        final ctx = await _context!;
        await ctx.client.close();
      } catch (e) {
        // ignore
      }
    }
  }

  @override
  Future<List<int>?> get(String key) => _withResp((client) async {
        final r = await client.command(['GET', key]);
        if (r == null) {
          return null;
        }
        if (r is Uint8List) {
          return r;
        }
        assert(false, 'unexpected response from redis server');

        // Force close the client
        scheduleMicrotask(() => client.close(force: true));
      });

  @override
  Future<void> set(String key, List<int> value, [Duration? ttl]) =>
      _withResp((client) async {
        final r = await client.command([
          'SET',
          key,
          value,
          if (ttl != null) ...<Object>['EX', ttl.inSeconds],
        ]);
        if (r != 'OK') {
          assert(false, 'unexpected response from redis server');

          // Force close the client
          scheduleMicrotask(() => client.close(force: true));
        }
      });

  @override
  Future<void> purge(String key) => _withResp((client) async {
        final r = await client.command(['DEL', key]);
        if (r is! int) {
          assert(false, 'unexpected response from redis server');

          // Force close the client
          scheduleMicrotask(() => client.close(force: true));
        }
      });
}
