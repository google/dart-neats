// Copyright 2025 Google LLC
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

import 'package:analyzer/dart/analysis/results.dart' show ResolvedLibraryResult;
import 'package:analyzer/dart/ast/ast.dart' show Annotation, AstNode;
import 'package:analyzer/dart/ast/visitor.dart' show GeneralizingAstVisitor;
import 'package:analyzer/dart/constant/value.dart' show DartObject;
import 'package:analyzer/dart/element/element.dart'
    show Element, ElementAnnotation;
import 'package:source_gen/source_gen.dart'
    show InvalidGenerationSource, TypeChecker;

extension TypeCheckerExt on TypeChecker {
  /// Get [ElementAnnotation] and [DartObject] (value) for each annotation of
  /// [element].
  ///
  ///
  List<(ElementAnnotation, DartObject)> annotationAndValuesOfExact(
    Element element,
  ) {
    return element.metadata.annotations
        .map((a) {
          final value = a.computeConstantValue();
          if (value != null && isExactlyType(value.type!)) {
            return (a, value);
          }
          return null;
        })
        .nonNulls
        .toList();
  }
}

/// Throw [InvalidGenerationSource] for [annotation] on [annotatedElement].
///
/// This will look for the [AstNode] defining the [annotation], and if it cannot
/// be found, it'll use [annotatedElement] as source for the exception.
Future<Never> throwInvalidAnnotationInSource(
  String message, {
  required Element annotatedElement,
  required ElementAnnotation annotation,
}) async {
  final session = annotatedElement.session;
  final libraryElement = annotatedElement.library;

  // Find AstNode for the annotation!
  AstNode? node;
  if (session != null && libraryElement != null) {
    final result = await session.getResolvedLibraryByElement(libraryElement);

    if (result case ResolvedLibraryResult r) {
      for (final u in r.units) {
        u.unit.accept(_ForEachAnnotationVisitor((a) {
          if (a.elementAnnotation == annotation) {
            node = a;
          }
        }));
      }
    }
  }

  if (node != null) {
    throw InvalidGenerationSource(message, node: node);
  }
  throw InvalidGenerationSource(message, element: annotatedElement);
}

final class _ForEachAnnotationVisitor extends GeneralizingAstVisitor<void> {
  final void Function(Annotation node) _forEach;
  _ForEachAnnotationVisitor(this._forEach);

  @override
  void visitAnnotation(Annotation node) {
    _forEach(node);
    super.visitAnnotation(node);
  }
}
