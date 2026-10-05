# checks_ext

Extensions for `package:checks` to make testing easier.

## Usage

Add a dev-dependency on `checks_ext` using `dart pub add dev:checks_ext` and
import it in your test files:

```dart
import 'package:checks_ext/checks_ext.dart';
```

## Highlights

### 📅 DateTime & Duration

Test dates and durations with ease.

```dart
check(DateTime.now()).isAfter(DateTime(2020));
check(DateTime.now()).isBetween(DateTime(2020), DateTime(2030));
check(DateTime.now()).isCloseTo(DateTime.now(), within: Duration(seconds: 1));

check(Duration(seconds: 5)).isGreaterThan(Duration(seconds: 2));
check(Duration(seconds: 5)).isCloseTo(Duration(seconds: 6), within: Duration(seconds: 2));
```

### 🔤 RegExp & Match

Powerful assertions for regular expressions.

```dart
final regex = RegExp(r'(\d+)');
check(regex).hasMatch('123');
check(regex).hasNoMatch('abc');

// Check specific matches
check(regex).firstMatch('123').isNotNull()[1].equals('123');
```

### 📜 Iterable Extensions

Check sorting and handle nulls.

```dart
check([1, 2, 3]).isSorted();
check([{'age': 20}, {'age': 30}]).isSortedBy((m) => m['age'] as int);
check([1, 2, 3]).containsAll([1, 2]);

// Skip nulls in an iterable
check([1, null, 2]).nonNulls.deepEquals([1, 2]);
```

### 🔤 String Checks

Additional checks for strings.

```dart
check('  ').isBlank();
check('abc').isLowerCase();
check('Hello World').containsIgnoringCase('world');
check('a\nb\nc').lines.deepEquals(['a', 'b', 'c']);
```

### 🔢 Numeric Checks

Checks for `num`, `int`, and `double`.

```dart
check(5).isBetween(1, 10);
check(2).isEven();
check(4).isMultipleOf(2);
check(1.0).isFinite();
```

### 🔢 List<int> (Bytes)

Specialized checks for byte arrays, featuring beautiful hex/ASCII diffs on failure.

```dart
check([72, 101, 108, 108, 111]).equalsBytes([72, 101, 108, 108, 111]);
check([72, 101, 108, 108, 111]).isValidUtf8();
```

If `equalsBytes` fails, it provides a helpful diff:
```
Expected: a List<int> that:
  equals [72, 101, 108, 108, 111]
Actual: [72, 101, 108, 108, 112]
Which: differs at offset 4:
Actual:   H e l l [p]
Expected: H e l l [o]
```

