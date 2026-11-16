import 'package:test/test.dart';

void main() {
  test('greets the world', () {
    // #region greeting
    final message = 'Hello, world!';
    print(message);
    // #endregion greeting
    expect(message, isNotEmpty);
  });
}
