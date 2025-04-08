While `package:typed_sql` has a limited number of data-types that can be used
in columns when defining tables in a database schema, it is possible to create
_custom types_ that serialize to a database column. This is done by creating a
class that implements `CustomDataType<T>`, where `T` is one of:
 * `bool`,
 * `int`,
 * `double`,
 * `String`,
 * `DateTime`, or,
 * `Uint8List`.

> [!NOTE]
> A _custom types_ does not give rise to a _User Defined Type (UDT)_ in SQL.
> Implementations of `CustomDataType` serves exclusively to facilitate
> convenient serialization and deserialization of custom types.

## Implementing a `CustomDataType`
Implemeting a `CustomDataType<T>` is straight forward, you pick a `T` which must
be one of the existing columns types supported by `package:typed_sql`. Then you
write a class that implements `CustomDataType<T>` and can be deserialized from
`T` using a `fromDatabase` _factory constructor_.

Below we have an example of how to implement a `Color` as a custom type that
can be stored in a table with `package:typed_sql`.

```dart dealership_test.dart#custom-color
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
```

The `Color` class above implements `CustomDataType<int>`, which means it is
stored as an `int` in the database. Thus, the `toDatabase` method **must**
return an `int`, and the `fromDatabase` constructor **must** take an `int`.

> [!NOTE]
> The `fromDatabase` constructor **must** be defined, and it **must** be a
> factory constructor taking a single parameter of type `T`.

You may implement additional methods on your custom type. For example, it's
often useful to implement `==` and `hashCode` for immutable data types, for
details see [Effective Dart](https://dart.dev/effective-dart/design#equality).

> [!TIP]
> You custom type is not required to be _immutable_, but using an immutable type
> is strongly recommended. The analyzer can help with you this if you use the
> `@immutable` annotation from [`package:meta`](https://pub.dev/packages/meta).

Finally, it's important to note that if your custom type implements
`Comparable<T>` from `dart:core`, then the serialized value **should** satisfy
this ordering! As `Expr<Comparable>` can be used for `.min` and `.max`
_aggregate functions_ in `.groupBy`.


## Database schema using a `CustomDataType`
With `Color` implementing `CustomDataType<int>` as in the example above we can
use `Color` as column type in a database schema. The following example
shows how to use `Color` in a database schema:

```dart dealership_test.dart#schema
abstract final class Dealership extends Schema {
  Table<Car> get cars;
}

@PrimaryKey(['id'])
abstract final class Car extends Model {
  @AutoIncrement()
  int get id;

  String get model;

  @Unique()
  String get licensePlate;

  // We can use our custom type as column type
  Color get color;
}
```

The _custom type_ `Color` does not need be define in the same library as the
database schema.


## Inserting a row with a `CustomDataType`
We can insert a row into the `cars` table with a `Color` as follows:

```dart dealership_test.dart#insert-car
await db.cars
    .insert(
      model: literal('Beetle'),
      licensePlate: literal('ABC-001'),
      color: Color.red().asExpr,
    )
    .execute();
```

To insert a `Color` we must constructor an `Expr<Color>` object wrapping the
value we want to insert. We can obtain such an object using the `.asExpr`
_extension method_. This _extension method_ will be created by the
code-generator when it sees a field with the type `Color`.


## Fetching a rows with a `CustomDataType`
We can fetch rows from the `cars` table with a `Color` as follows:

```dart dealership_test.dart#fetch-cars
final List<Car> cars = await db.cars.fetch();
```

This gives us a list of `Car` objects, where the `color` field is deserialized
using `Color.fromDatabase`. We can also use `.select` to fetch only a subset
of fields from the database. The following example shows how to fetch distinct
`model` and `color` combinations:

```dart dealership_test.dart#available-colors
final List<(String, Color)> modelAndColor = await db.cars
    .select((car) => (
          car.model,
          car.color,
        ))
    .distinct()
    .fetch();
```


## Expressions with a `Expr<CustomDataType>`
In the previous section we saw that we can use `Car.color` as any other field.
When using _extension methods_ like `.select` or `.where` we can access
`Expr<Color>` using the `.color` property on `Expr<Car>`. However, since
the `Color` type is purely a Dart concept, `package:typed_sql` doesn't have many
_extension methods_.

The only _extension method_ on `Expr<Color>` is `asEncoded()`, which casts to
the underlying serialized expression type. Thus, `asEncoded()` on `Expr<Color>`
will return an `Expr<int>`. We can use this to make our own extension methods
for `Expr<Color>` as follows:

```dart dealership_test.dart#custom-expr
extension ColorExprExt on Expr<Color> {
  // We know black is encoded as zero
  Expr<bool> get isBlack => asEncoded().equalsLiteral(0);

  // We can make `.equals` and `.equalsLiteral` for `Color` if we want
  Expr<bool> equals(Expr<Color> other) => asEncoded().equals(other.asEncoded());
  Expr<bool> equalsLiteral(Color other) => equals(other.asExpr);

  // We can make our own utility methods too
  Expr<bool> get isRed => equalsLiteral(Color.red());
  Expr<bool> get isGreen => equalsLiteral(Color.green());
  Expr<bool> get isBlue => equalsLiteral(Color.blue());
}
```

These _extension methods_ operate on the serialized `Color`, as serialized by
`Color.toDatabase`. Implementing a `.equals` might not make sense, if your
custom type doesn't have a canonical encoding.

When writing queries we can use these extension methods, suppose we have loaded
the following rows into the database:
```dart dealership_test.dart#initial
```

Then we could query for blue cars as follows:

```dart dealership_test.dart#where-blue-cars
```

