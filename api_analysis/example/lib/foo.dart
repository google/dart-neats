// Copyright 2023 Google LLC
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

import 'src/impl.dart';
export 'dart:io' show File;
export 'src/impl.dart' show getterForHello;
export 'src/impl.dart'
    show setterForHello
    hide setterForHello
    show setterForHello;

void sayHello({required String a, String? b}) {
  print(finalHelloMessage);
  _privateMethod();
}

void _privateMethod() {}
