import 'dart:io';

import 'package:tar/tar.dart';

void main() async {
  final fileName = 'retry.tar';

  final tarStream = File(fileName).openRead();
  final tarFileStream = TarReader(tarStream);

  while (await tarFileStream.next()) {
    print((await tarFileStream.header).name);
  }
}
