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
import 'dart:io';

import 'package:test/test.dart';

import 'package:neat_cache/src/providers/redis.dart';
import 'package:neat_cache/cache_provider.dart';

import 'utils.dart';

void _doAndForget(Function fn) {
  scheduleMicrotask(() async {
    try {
      await fn();
    } catch (_) {
      // ignore
    }
  });
}

class SocketProxyServer {
  ServerSocket _server;
  final List<Socket> _sockets = [];
  final String _targetHost;
  final int _targetPort;

  /// Number of accepted connections (including those closed).
  int acceptedConnections = 0;

  /// Delay before forwarding to the target.
  Duration proxyDelay = Duration(milliseconds: 0);

  SocketProxyServer._(this._server, this._targetHost, this._targetPort);

  static Future<SocketProxyServer> create(
    String targetHost,
    int targetPort,
  ) async {
    final server = await ServerSocket.bind('localhost', 0);
    final sp = SocketProxyServer._(server, targetHost, targetPort);
    scheduleMicrotask(() async {
      await server.forEach(sp._process);
    });
    return sp;
  }

  Future<void> restart() async {
    _server = await ServerSocket.bind('localhost', port);
    scheduleMicrotask(() async {
      await _server.forEach(_process);
    });
  }

  Future<void> stop() async {
    await _server.close();
  }

  Future<void> _process(Socket client) async {
    acceptedConnections++;
    _sockets.add(client);
    await Future.delayed(proxyDelay);
    final target = await Socket.connect(_targetHost, _targetPort);

    _doAndForget(() async {
      await client.forEach((data) async {
        await Future.delayed(proxyDelay);
        target.add(data);
      });
      await client.close();
    });
    _doAndForget(() async {
      await target.forEach((data) => client.add(data));
    });

    await client.done.catchError((e) {/* ignore */});
    _sockets.remove(client);
    target.destroy();
  }

  String get host => 'localhost';
  int get port => _server.port;

  Future<void> breakAll() async {
    for (final client in _sockets) {
      client.destroy();
    }
    await Future.wait(_sockets.map((s) => s.done));
  }

  Future<void> close() => _server.close();
}

void main() {
  setupLogging();

  group('redis', () {
    late SocketProxyServer proxy;
    late CacheProvider<String> cache;
    setUp(() async {
      proxy = await SocketProxyServer.create('localhost', 6379);
      final connectionString = 'redis://${proxy.host}:${proxy.port}';
      cache = StringCacheProvider(
        cache: RedisCacheProvider(
          Uri.parse(connectionString),
          connectTimeLimit: Duration(milliseconds: 200),
          commandTimeLimit: Duration(milliseconds: 100),
          reconnectDelay: Duration(microseconds: 1000),
        ),
        codec: utf8,
      );
    });
    tearDown(() async {
      await cache.close();
      await proxy.close();
    });

    test('proxy works', () async {
      await cache.set('msg', 'hello-world');
    });

    test('broken connection throws IntermittentCacheException', () async {
      await cache.set('msg', 'hello-world');

      await proxy.breakAll();

      await expectLater(
        cache.set('msg', 'hello-world'),
        throwsA(TypeMatcher<IntermittentCacheException>()),
      );

      await Future.delayed(Duration(milliseconds: 300));
      await cache.set('msg', 'hello-world');

      expect(proxy.acceptedConnections, equals(2));
    });

    test('timeout commands throws IntermittentCacheException', () async {
      print(' - set(), creating a connection to redis');
      await cache.set('msg', 'hello-world');

      print(' - set(), with with a proxy so slow command will timeout');
      proxy.proxyDelay = Duration(milliseconds: 300);
      await expectLater(
        cache.set('msg', 'hello-world'),
        throwsA(TypeMatcher<IntermittentCacheException>()),
      );
      proxy.proxyDelay = Duration(milliseconds: 0);

      print(' - Sleep, to not starve the event queue');
      await Future.delayed(Duration(milliseconds: 5));

      print(' - set(), with fast proxy again, this reconnect');
      await cache.set('msg', 'hello-world');

      expect(proxy.acceptedConnections, equals(2));
    });

    test('connection failure throws IntermittentCacheException', () async {
      print(' - stop the proxy from accepting new connections');
      await proxy.stop();
      print(' - set(), should fail');
      await expectLater(
        cache.set('msg', 'hello-world'),
        throwsA(TypeMatcher<IntermittentCacheException>()),
      );
      print(' - restart the proxy');
      await proxy.restart();

      print(
        ' - set(), should still fail, as the reconnect timeout have passed',
      );
      await expectLater(
        cache.set('msg', 'hello-world'),
        throwsA(TypeMatcher<IntermittentCacheException>()),
      );

      print(' - sleep 1500ms, to get past the reconnect timeout');
      await Future.delayed(Duration(milliseconds: 1500));

      print(' - set(), should reconnect');
      await cache.set('msg', 'hello-world');

      // Note: we only connected once, we failed to connect initially
      expect(proxy.acceptedConnections, equals(1));
    });
  }, tags: 'redis');
}
