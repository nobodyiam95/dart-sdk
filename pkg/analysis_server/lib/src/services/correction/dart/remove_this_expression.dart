// Copyright (c) 2020, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:analysis_server/src/services/correction/dart/abstract_producer.dart';
import 'package:analysis_server/src/services/correction/fix.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer_plugin/utilities/change_builder/change_builder_core.dart';
import 'package:analyzer_plugin/utilities/fixes/fixes.dart';
import 'package:analyzer_plugin/utilities/range_factory.dart';

class RemoveThisExpression extends ResolvedCorrectionProducer {
  @override
  bool get canBeAppliedInBulk => true;

  @override
  bool get canBeAppliedToFile => true;

  @override
  FixKind get fixKind => DartFixKind.REMOVE_THIS_EXPRESSION;

  @override
  FixKind get multiFixKind => DartFixKind.REMOVE_THIS_EXPRESSION_MULTI;

  @override
  Future<void> compute(ChangeBuilder builder) async {
    final node = this.node;
    if (node is ConstructorFieldInitializer) {
      var thisKeyword = node.thisKeyword;
      if (thisKeyword != null) {
        await builder.addDartFileEdit(file, (builder) {
          var fieldName = node.fieldName;
          builder.addDeletion(range.startStart(thisKeyword, fieldName));
        });
      }
      return;
    } else if (node is PropertyAccess && node.target is ThisExpression) {
      await builder.addDartFileEdit(file, (builder) {
        builder.addDeletion(range.startEnd(node, node.operator));
      });
    } else if (node is MethodInvocation) {
      var operator = node.operator;
      if (node.target is ThisExpression && operator != null) {
        await builder.addDartFileEdit(file, (builder) {
          builder.addDeletion(range.startEnd(node, operator));
        });
      }
    }
  }
}
