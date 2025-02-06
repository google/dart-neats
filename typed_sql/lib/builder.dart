import 'package:build/build.dart' show Builder, BuilderOptions;
import 'package:source_gen/source_gen.dart' as g;
import 'package:typed_sql/src/codegen/generator.dart';

/// A [Builder] that generates extension methods and classes for typed_sql.
Builder typedSqlBuilder(BuilderOptions options) => g.SharedPartBuilder(
      [typedSqlGenerator(options)],
      'typed_sql',
    );
