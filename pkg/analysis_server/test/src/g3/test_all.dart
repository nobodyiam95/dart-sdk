// Copyright (c) 2021, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:test_reflective_loader/test_reflective_loader.dart';

import 'fixes_test.dart' as fixes;
import 'utilities_test.dart' as utilities;

void main() {
  defineReflectiveSuite(() {
    fixes.main();
    utilities.main();
  });
}
