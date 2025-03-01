// Copyright (c) 2021, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

/*library: 
 compilationSequence=[main.dart|package:_fe_analyzer_shared/src/macros/api.dart],
 declaredMacros=[MyMacro],
 macrosAreAvailable
*/

import 'package:_fe_analyzer_shared/src/macros/api.dart';

macro class MyMacro implements Macro {}

void main() {}
