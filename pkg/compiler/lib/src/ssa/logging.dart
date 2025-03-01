// Copyright (c) 2018, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import '../elements/entities.dart';
import '../elements/types.dart';
import 'package:_fe_analyzer_shared/src/testing/features.dart';
import 'nodes.dart';

/// Log used for unit testing optimizations.
class OptimizationTestLog {
  final DartTypes _dartTypes;

  OptimizationTestLog(this._dartTypes);

  List<OptimizationLogEntry> entries = [];

  late final Map<String, Set<HInstruction>> _unconverted = {};

  Features? _register(String tag, HInstruction original,
      HInstruction? converted, void f(Features features)) {
    if (converted == null) {
      Set<HInstruction> set = _unconverted[tag] ??= {};
      if (!set.add(original)) {
        return null;
      }
    }
    Features features = Features();
    f(features);
    entries.add(OptimizationLogEntry(tag, features));
    return features;
  }

  void registerNullCheck(HInstruction original, HNullCheck check) {
    Features features = Features();
    if (check.selector != null) {
      features['selector'] = check.selector!.name;
    }
    if (check.field != null) {
      features['field'] =
          '${check.field!.enclosingClass!.name}.${check.field!.name}';
    }
    entries.add(OptimizationLogEntry('NullCheck', features));
  }

  void registerConditionValue(
      HInstruction original, bool value, String where, int count) {
    Features features = Features();
    features['value'] = '$value';
    features['where'] = where;
    features['count'] = '$count';
    entries.add(OptimizationLogEntry('ConditionValue', features));
  }

  void registerFieldGet(HInvokeDynamicGetter original, HFieldGet converted) {
    Features features = Features();
    final element = converted.element;
    features['name'] = '${element.enclosingClass!.name}.${element.name}';
    entries.add(OptimizationLogEntry('FieldGet', features));
  }

  void registerFieldSet(HInvokeDynamicSetter original, [HFieldSet? converted]) {
    Features features = Features();
    if (converted != null) {
      features['name'] =
          '${converted.element.enclosingClass!.name}.${converted.element.name}';
    } else {
      features['removed'] = original.selector.name;
    }
    entries.add(OptimizationLogEntry('FieldSet', features));
  }

  void registerFieldCall(HInvokeDynamicMethod original, HFieldGet converted) {
    Features features = Features();
    final element = converted.element;
    features['name'] = '${element.enclosingClass!.name}.${element.name}';
    entries.add(OptimizationLogEntry('FieldCall', features));
  }

  void registerConstantFieldGet(
      HInvokeDynamicGetter original, FieldEntity field, HConstant converted) {
    Features features = Features();
    features['name'] = '${field.enclosingClass!.name}.${field.name}';
    features['value'] = converted.constant.toStructuredText(_dartTypes);
    entries.add(OptimizationLogEntry('ConstantFieldGet', features));
  }

  void registerConstantFieldCall(
      HInvokeDynamicMethod original, FieldEntity field, HConstant converted) {
    Features features = Features();
    features['name'] = '${field.enclosingClass!.name}.${field.name}';
    features['value'] = converted.constant.toStructuredText(_dartTypes);
    entries.add(OptimizationLogEntry('ConstantFieldCall', features));
  }

  Features? _registerSpecializer(
      HInvokeDynamic original, HInstruction? converted, String? name,
      [String? unconvertedName]) {
    assert(!(converted == null && unconvertedName == null));
    return _register('Specializer', original, converted, (Features features) {
      if (converted != null) {
        features.add(name!);
      } else {
        features.add(unconvertedName!);
      }
    });
  }

  void registerIndexAssign(HInvokeDynamic original, HIndexAssign converted) {
    _registerSpecializer(original, converted, 'IndexAssign');
  }

  void registerIndex(HInvokeDynamic original, HIndex converted) {
    _registerSpecializer(original, converted, 'Index');
  }

  void registerRemoveLast(HInvokeDynamic original, HInvokeDynamic converted) {
    _registerSpecializer(original, converted, 'RemoveLast');
  }

  void registerBitNot(HInvokeDynamic original, HBitNot converted) {
    _registerSpecializer(original, converted, 'BitNot');
  }

  void registerUnaryNegate(HInvokeDynamic original, HNegate converted) {
    _registerSpecializer(original, converted, 'Negate');
  }

  void registerAbs(HInvokeDynamic original, HAbs converted) {
    _registerSpecializer(original, converted, 'Abs');
  }

  void registerAdd(HInvokeDynamic original, HInstruction? converted) {
    _registerSpecializer(original, converted, 'Add');
  }

  void registerDivide(HInvokeDynamic original, HInstruction? converted) {
    _registerSpecializer(original, converted, 'Divide');
  }

  void registerModulo(HInvokeDynamic original, HInstruction? converted) {
    _registerSpecializer(original, converted, 'Modulo', 'DynamicModulo');
  }

  void registerRemainder(HInvokeDynamic original, HInstruction? converted) {
    _registerSpecializer(original, converted, 'Remainder');
  }

  void registerMultiply(HInvokeDynamic original, HInstruction? converted) {
    _registerSpecializer(original, converted, 'Multiply');
  }

  void registerSubtract(HInvokeDynamic original, HInstruction? converted) {
    _registerSpecializer(original, converted, 'Subtract');
  }

  void registerTruncatingDivide(
      HInvokeDynamic original, HInstruction? converted) {
    _registerSpecializer(original, converted, 'TruncatingDivide',
        'TruncatingDivide.${original.selector.name}');
  }

  void registerShiftLeft(HInvokeDynamic original, HInstruction? converted) {
    _registerSpecializer(original, converted, 'ShiftLeft',
        'ShiftLeft.${original.selector.name}');
  }

  void registerShiftRight(HInvokeDynamic original, HInstruction? converted) {
    _registerSpecializer(original, converted, 'ShiftRight',
        'ShiftRight.${original.selector.name}');
  }

  void registerShiftRightUnsigned(
      HInvokeDynamic original, HInstruction? converted) {
    _registerSpecializer(original, converted, 'ShiftRightUnsigned',
        'ShiftRightUnsigned.${original.selector.name}');
  }

  void registerBitOr(HInvokeDynamic original, HInstruction? converted) {
    _registerSpecializer(original, converted, 'BitOr');
  }

  void registerBitAnd(HInvokeDynamic original, HInstruction? converted) {
    _registerSpecializer(original, converted, 'BitAnd');
  }

  void registerBitXor(HInvokeDynamic original, HInstruction? converted) {
    _registerSpecializer(original, converted, 'BitXor');
  }

  void registerEquals(HInvokeDynamic original, HInstruction converted) {
    _registerSpecializer(original, converted, 'Equals');
  }

  void registerLess(HInvokeDynamic original, HInstruction converted) {
    _registerSpecializer(original, converted, 'Less');
  }

  void registerGreater(HInvokeDynamic original, HInstruction converted) {
    _registerSpecializer(original, converted, 'Greater');
  }

  void registerLessEqual(HInvokeDynamic original, HInstruction converted) {
    _registerSpecializer(original, converted, 'LessEquals');
  }

  void registerGreaterEqual(HInvokeDynamic original, HInstruction converted) {
    _registerSpecializer(original, converted, 'GreaterEquals');
  }

  void registerCodeUnitAt(HInvokeDynamic original) {
    Features features = Features();
    features['name'] = original.selector.name;
    entries.add(OptimizationLogEntry('CodeUnitAt', features));
  }

  void registerCompareTo(HInvokeDynamic original, [HConstant? converted]) {
    Features features = Features();
    if (converted != null) {
      features['constant'] = converted.constant.toDartText(_dartTypes);
    }
    entries.add(OptimizationLogEntry('CompareTo', features));
  }

  void registerSubstring(HInvokeDynamic original) {
    _registerSpecializer(original, null, null, 'substring');
  }

  void registerTrim(HInvokeDynamic original) {
    _registerSpecializer(original, null, null, 'trim');
  }

  void registerPatternMatch(HInvokeDynamic original) {
    _registerSpecializer(original, null, null, original.selector.name);
  }

  void registerRound(HInvokeDynamic original) {
    _registerSpecializer(original, null, null, 'Round');
  }

  void registerToInt(HInvokeDynamic original) {
    _registerSpecializer(original, null, null, 'ToInt');
  }

  void registerPrimitiveCheck(HInstruction original, HPrimitiveCheck check) {
    Features features = Features();

    if (check.isReceiverTypeCheck) {
      features['kind'] = 'receiver';
    } else if (check.isArgumentTypeCheck) {
      features['kind'] = 'argument';
    }
    features['type'] = '${check.typeExpression}';
    entries.add(OptimizationLogEntry('PrimitiveCheck', features));
  }

  /// Generates optimization log entries that form a histogram. [summarize]
  /// projects the instruction to a string that is used as a key for counting
  /// instructions. [summarize] returns `null` to omit the instruction.
  void instructionHistogram(
      String tag, HGraph graph, String? Function(HInstruction) summarize) {
    Map<String, int> histogram = {};
    for (final block in graph.blocks) {
      for (HInstruction? node = block.first; node != null; node = node.next) {
        String? description = summarize(node);
        if (description != null) {
          int count = histogram[description] ?? 0;
          histogram[description] = count + 1;
        }
      }
    }

    for (final entry in histogram.entries) {
      Features features = Features();
      features[entry.key] = '${entry.value}';
      entries.add(OptimizationLogEntry(tag, features));
    }
  }

  String getText() {
    return entries.join(',\n');
  }

  @override
  String toString() => 'OptimizationLog(${getText()})';
}

/// A registered optimization.
class OptimizationLogEntry {
  /// String that uniquely identifies the optimization kind.
  final String tag;

  /// Additional data for this optimization.
  final Features features;

  OptimizationLogEntry(this.tag, this.features);

  @override
  String toString() => '$tag(${features.getText()})';
}
