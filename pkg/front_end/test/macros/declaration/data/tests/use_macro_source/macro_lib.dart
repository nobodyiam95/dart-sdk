// Copyright (c) 2021, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

/*library: 
 declaredMacros=[
  Macro1,
  Macro2],
 macrosAreAvailable
*/

import 'package:_fe_analyzer_shared/src/macros/api.dart';

macro class Macro1 implements Macro {
  const Macro1();
}

macro class Macro2 implements Macro {
  const Macro2();
}

class NonMacro {
  const NonMacro();
}
