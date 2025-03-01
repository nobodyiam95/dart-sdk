// Copyright (c) 2019, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:analysis_server/src/protocol_server.dart';
import 'package:test/test.dart';
import 'package:test_reflective_loader/test_reflective_loader.dart';

import 'base.dart';

void main() {
  defineReflectiveSuite(() {
    defineReflectiveTests(GetWidgetDescriptionTest);
  });
}

@reflectiveTest
class GetWidgetDescriptionTest extends FlutterBase {
  Future<void> test_kind_required() async {
    addTestFile(r'''
import 'package:flutter/material.dart';

void f() {
  Text('aaa');
}
''');

    var result = await getWidgetDescription('Text(');

    var property = getProperty(result, 'data');
    expect(property.documentation, isNotNull);
    expect(property.expression, "'aaa'");
    expect(property.isRequired, isTrue);
    expect(property.editor, isNotNull);
    expect(property.value!.stringValue, 'aaa');
  }

  Future<void> test_notInstanceCreation() async {
    addTestFile(r'''
void f() {
  42;
}
''');

    var response = await getWidgetDescriptionResponse('42');
    assertResponseFailure(
      response,
      requestId: '0',
      errorCode: RequestErrorCode.FLUTTER_GET_WIDGET_DESCRIPTION_NO_WIDGET,
    );
  }

  Future<void> test_unresolvedInstanceCreation() async {
    addTestFile(r'''
void f() {
  new Foo();
}
''');

    var response = await getWidgetDescriptionResponse('new Foo');
    assertResponseFailure(
      response,
      requestId: '0',
      errorCode: RequestErrorCode.FLUTTER_GET_WIDGET_DESCRIPTION_NO_WIDGET,
    );
  }
}
