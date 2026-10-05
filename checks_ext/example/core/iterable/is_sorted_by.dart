import 'package:checks_ext/checks_ext.dart';

void main() {
  final people = [
    (name: 'Alice', age: 25),
    (name: 'Bob', age: 30),
    (name: 'Charlie', age: 35),
  ];

  /// This check succeeds.
  check(people).isSortedBy((p) => p.age);

  /// This check fails.
  final unsorted = [
    (name: 'Charlie', age: 35),
    (name: 'Bob', age: 30),
    (name: 'Alice', age: 25),
  ];
  try {
    check(unsorted).isSortedBy((p) => p.age);
  } catch (e) {
    print(e);
    // Expected: a List<({int age, String name})> that:
    //   is sorted by key
    // Actual: [(age: 35, name: Charlie), (age: 30, name: Bob), (age: 25, name: Alice)]
    // Which: is not sorted, because element at index 0 <(age: 35, name: Charlie)>
    // with key <35>
    // compares after element at index 1 <(age: 30, name: Bob)>
    // with key <30>
  }
}
