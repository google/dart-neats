// Copyright 2020 Google LLC
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

import 'dart:math';

import 'package:yaml_edit/yaml_edit.dart';
import 'package:yaml_edit/src/wrap.dart';
import 'package:test/test.dart';
import 'package:yaml/yaml.dart';

import 'problem_strings.dart';
import 'test_utils.dart';

/// Performs naive fuzzing on an initial YAML file based on an initial seed.
///
/// Starting with a template YAML, we randomly generate modifications and their
/// inputs (boolean, null, strings, or numbers) to modify the YAML and assert
/// that the change produced was expected.
void main() {
  const seed = 0;
  final generator = _Generator(seed: seed);

  const roundsOfTesting = 40;
  const modificationsPerRound = 1000;

  for (var i = 0; i < roundsOfTesting; i++) {
    test('fuzz test $i', () {
      final editor = YamlEditor('''
name: yaml_edit
description: A library for YAML manipulation with comment and whitespace preservation.
version: 0.0.1-dev

environment:
  sdk: ">=2.4.0 <3.0.0"

dependencies:
  meta: ^1.1.8
  quiver_hashcode: ^2.0.0

dev_dependencies:
  pedantic: ^1.9.0
  test: ^1.14.4
''');

      for (var j = 0; j < modificationsPerRound; j++) {
        expect(
            () => generator.performNextModification(editor), returnsNormally);
      }
    });
  }
}

/// Generates the random variables we need for fuzzing.
class _Generator {
  final Random r;

  /// 2^32
  static const int maxInt = 4294967296;

  /// Maximum depth of random YAML collection generated.
  final int maxDepth;

  _Generator({int seed, this.maxDepth = 5}) : r = Random(seed ?? 42);

  int nextInt([int max = maxInt]) => r.nextInt(max);

  double nextDouble() => r.nextDouble();

  bool nextBool() => r.nextBool();

  /// Generates a new string by individually generating characters and
  /// appending them to a buffer. Currently only generates strings from
  /// ascii 32 - 127.
  String nextString() {
    if (nextBool()) {
      return problemStrings[nextInt(problemStrings.length)];
    }

    final length = nextInt(100);
    final buffer = StringBuffer();

    for (var i = 0; i < length; i++) {
      final charCode = nextInt(95) + 32;
      buffer.writeCharCode(charCode);
    }

    return buffer.toString();
  }

  /// Generates a new scalar recognizable by YAML.
  Object nextScalar() {
    final typeIndex = nextInt(5);

    switch (typeIndex) {
      case 0:
        return nextBool();
      case 1:
        return nextDouble();
      case 2:
        return nextInt();
      case 3:
        return null;
      default:
        return nextString();
    }
  }

  YamlScalar nextYamlScalar() {
    return wrapAsYamlNode(nextScalar(), scalarStyle: nextScalarStyle());
  }

  /// Generates the next [YamlList], with the current [depth].
  YamlList nextYamlList(int depth) {
    final length = nextInt(9);
    final list = [];

    for (var i = 0; i < length; i++) {
      list.add(nextYamlNode(depth + 1));
    }

    return wrapAsYamlNode(list, collectionStyle: nextCollectionStyle());
  }

  /// Generates the next [YamlList], with the current [depth].
  YamlMap nextYamlMap(int depth) {
    final length = nextInt(9);
    final nodes = {};

    for (var i = 0; i < length; i++) {
      nodes[nextYamlNode(depth + 1)] = nextYamlScalar();
    }

    return wrapAsYamlNode(nodes, collectionStyle: nextCollectionStyle());
  }

  /// Returns a [YamlNode], with it being a [YamlScalar] 80% of the time, a
  /// [YamlList] 10% of the time, and a [YamlMap] 10% of the time.
  ///
  /// If [depth] is greater than [maxDepth], we instantly return a [YamlScalar]
  /// to prevent the parent from growing any further, to improve our speeds.
  YamlNode nextYamlNode([int depth = 0]) {
    if (depth >= maxDepth) {
      return nextYamlScalar();
    }

    final roll = nextInt(10);

    if (roll < 8) {
      return nextYamlScalar();
    } else if (roll == 8) {
      return nextYamlList(depth);
    } else {
      return nextYamlMap(depth);
    }
  }

  /// Performs a random modification
  void performNextModification(YamlEditor editor) {
    final path = findPath(editor);
    final node = editor.parseAt(path);
    final initialString = editor.toString();
    final args = [];
    var method = YamlModificationMethod.remove;

    try {
      if (node is YamlScalar) {
        editor.remove(path);
        return;
      }

      if (node is YamlList) {
        final methodIndex = nextInt(YamlModificationMethod.values.length);
        method = YamlModificationMethod.values[methodIndex];

        switch (method) {
          case YamlModificationMethod.remove:
            editor.remove(path);
            break;
          case YamlModificationMethod.update:
            if (node.isEmpty) break;
            final index = nextInt(node.length);
            args.add(nextYamlNode());
            path.add(index);
            editor.update(path, args[0]);
            break;
          case YamlModificationMethod.appendTo:
            args.add(nextYamlNode());
            editor.appendToList(path, args[0]);
            break;
          case YamlModificationMethod.prependTo:
            args.add(nextYamlNode());
            editor.prependToList(path, args[0]);
            break;
          case YamlModificationMethod.insert:
            args.add(nextInt(node.length + 1));
            args.add(nextYamlNode());
            editor.insertIntoList(path, args[0], args[1]);
            break;
          case YamlModificationMethod.splice:
            args.add(nextInt(node.length + 1));
            args.add(nextInt(node.length + 1 - args[0]));
            args.add(nextYamlList(0));
            editor.spliceList(path, args[0], args[1], args[2]);
            break;
        }
        return;
      }

      if (node is YamlMap) {
        final replace = nextBool();
        method = YamlModificationMethod.update;

        if (replace && node.isNotEmpty) {
          final keyList = node.keys.toList();
          path.add(keyList[nextInt(keyList.length)]);
        } else {
          path.add(nextScalar());
        }
        final value = nextYamlNode();
        args.add(value);
        editor.update(path, value);
        return;
      }
    } catch (error) {
      print('''
Failed to call $method on:
$initialString
with the following arguments:
$args
and path:
$path

Error Details:
${error.message}
''');
      rethrow;
    }

    throw AssertionError('Got invalid node');
  }

  /// Obtains a random path by traversing [editor].
  ///
  /// At every node, we return the path to the node if the node has no children.
  /// Otherwise, we return at a 50% chance, or traverse to one random child.
  List<Object> findPath(YamlEditor editor) {
    final path = [];

    // 50% chance of stopping at the collection
    while (nextBool()) {
      final node = editor.parseAt(path);

      if (node is YamlList && node.isNotEmpty) {
        path.add(nextInt(node.length));
      } else if (node is YamlMap && node.isNotEmpty) {
        final keyList = node.keys.toList();
        path.add(keyList[nextInt(keyList.length)]);
      } else {
        break;
      }
    }

    return path;
  }

  ScalarStyle nextScalarStyle() {
    final seed = nextInt(6);

    switch (seed) {
      case 0:
        return ScalarStyle.DOUBLE_QUOTED;
      case 1:
        return ScalarStyle.FOLDED;
      case 2:
        return ScalarStyle.LITERAL;
      case 3:
        return ScalarStyle.PLAIN;
      case 4:
        return ScalarStyle.SINGLE_QUOTED;
      default:
        return ScalarStyle.ANY;
    }
  }

  CollectionStyle nextCollectionStyle() {
    final seed = nextInt(3);

    switch (seed) {
      case 0:
        return CollectionStyle.BLOCK;
      case 1:
        return CollectionStyle.FLOW;
      default:
        return CollectionStyle.ANY;
    }
  }
}
