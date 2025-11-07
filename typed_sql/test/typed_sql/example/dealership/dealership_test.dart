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

// ignore_for_file: omit_local_variable_types

import 'package:meta/meta.dart' show immutable;
import 'package:typed_sql/typed_sql.dart';

import '../../testrunner.dart';

part 'dealership_test.g.dart';

// #region custom-color
@immutable
final class Color implements CustomDataType<int> {
  final int red;
  final int green;
  final int blue;

  Color(this.red, this.green, this.blue);
  Color.red() : this(255, 0, 0);
  Color.green() : this(0, 255, 0);
  Color.blue() : this(0, 0, 255);

  /// Factory constructor `fromDatabase(T value)` is required by code-generator!
  factory Color.fromDatabase(int value) => Color(
        (value >> 16) & 0xFF,
        (value >> 8) & 0xFF,
        value & 0xFF,
      );

  /// `toDatabase` serialization method is also required!
  @override
  int toDatabase() => (red << 16) | (green << 8) | blue;
}
// #endregion

// #region custom-expr
extension ColorExprExt on Expr<Color> {
  // We know black is encoded as zero
  Expr<bool> get isBlack => asEncoded().equalsValue(0);

  // We can make `.equals` and `.equalsValue` for `Color` if we want
  Expr<bool> equals(Expr<Color> other) => asEncoded().equals(other.asEncoded());
  Expr<bool> equalsValue(Color other) => equals(other.asExpr);

  // We can make our own utility methods too
  Expr<bool> get isRed => equalsValue(Color.red());
  Expr<bool> get isGreen => equalsValue(Color.green());
  Expr<bool> get isBlue => equalsValue(Color.blue());
}
// #endregion

// #region schema
abstract final class Dealership extends Schema {
  Table<Car> get cars;
}

@PrimaryKey(['id'])
abstract final class Car extends Row {
  @AutoIncrement()
  int get id;

  String get model;

  @Unique()
  @SqlOverride(dialect: 'mysql', columnType: 'VARCHAR(255)') // #hide
  String get licensePlate;

  // We can use our custom type as column type
  Color get color;
}
// #endregion

// #region initial-data
final initialCars = [
  (model: 'Beetle', licensePlate: 'ABC-123', color: Color.red()),
  (model: 'Cooper', licensePlate: 'DEF-456', color: Color.blue()),
  (model: 'Beetle', licensePlate: 'GHI-789', color: Color.blue()),
];
// #endregion

void main() {
  final r = TestRunner<Dealership>(
    setup: (db) async {
      await db.createTables();

      for (final v in initialCars) {
        await db.cars
            .insert(
              model: toExpr(v.model),
              licensePlate: toExpr(v.licensePlate),
              color: v.color.asExpr,
            )
            .execute();
      }
    },
  );

  r.addTest('db.cars.insert()', (db) async {
    // #region insert-car
    await db.cars
        .insert(
          model: toExpr('Beetle'),
          licensePlate: toExpr('ABC-001'),
          color: Color.red().asExpr,
        )
        .execute();
    // #endregion
  });

  r.addTest('db.cars.fetch()', (db) async {
    // #region fetch-cars
    final List<Car> cars = await db.cars.fetch();
    // #endregion
    check(cars).length.equals(3);
  });

  r.addTest('db.cars.select()', (db) async {
    // #region available-colors
    final List<(String, Color)> modelAndColor = await db.cars
        .select((car) => (
              car.model,
              car.color,
            ))
        .distinct()
        .fetch();
    // #endregion
    check(modelAndColor).length.equals(3);
  });

  r.addTest('db.cars.where()', (db) async {
    // #region where-blue-cars
    final modelsAndLicense = await db.cars
        .where((car) => car.color.isBlue)
        .select((car) => (
              car.model,
              car.licensePlate,
            ))
        .fetch();

    check(modelsAndLicense).unorderedEquals([
      ('Beetle', 'GHI-789'),
      ('Cooper', 'DEF-456'),
    ]);
    // #endregion
  });

  r.run();
}
