# tar

A library for reading [.tar](<https://en.wikipedia.org/wiki/Tar_(computing)>) archives.

**Disclaimer:** This is not an officially supported Google product.

## Usage

A simple usage example:

```dart
import 'dart:io';

import 'package:tar/tar.dart';

void main() async {
  final fileName = 'retry.tar';

  final tarStream = File(fileName).openRead();
  final tarFileStream = TarReader(tarStream);

  while (await tarFileStream.next()) {
    print(tarFileStream.header.name);
  }
}

```
