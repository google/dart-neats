import 'package:yaml/yaml.dart';
import 'package:yaml_edit/yaml_edit.dart';

void main() {
  final doc = YamlEditor('''
- 0 # comment 0
-
- 2 # comment 2
''');
  doc.remove([1]);

  print(doc);
}
