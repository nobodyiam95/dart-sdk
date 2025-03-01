import 'package:dart2js_info/info.dart';
import 'package:dart2js_info/src/util.dart';

class Diff {
  final BasicInfo info;
  final DiffKind kind;
  Diff(this.info, this.kind);
}

enum DiffKind { add, remove, size, deferred }

class RemoveDiff extends Diff {
  RemoveDiff(BasicInfo info) : super(info, DiffKind.remove);
}

class AddDiff extends Diff {
  AddDiff(BasicInfo info) : super(info, DiffKind.add);
}

class SizeDiff extends Diff {
  final int sizeDifference;
  SizeDiff(BasicInfo info, this.sizeDifference) : super(info, DiffKind.size);
}

class DeferredStatusDiff extends Diff {
  final bool wasDeferredBefore;
  DeferredStatusDiff(BasicInfo info, this.wasDeferredBefore)
      : super(info, DiffKind.deferred);
}

List<Diff> diff(AllInfo oldInfo, AllInfo newInfo) {
  var differ = _InfoDiffer(oldInfo, newInfo);
  differ.diff();
  return differ.diffs;
}

class _InfoDiffer extends InfoVisitor<void> {
  final AllInfo _old;
  final AllInfo _new;

  BasicInfo? _other;

  List<Diff> diffs = <Diff>[];

  _InfoDiffer(this._old, this._new);

  void diff() {
    _diffList(_old.libraries, _new.libraries);
  }

  @override
  void visitAll(AllInfo info) {
    throw StateError('should not diff AllInfo');
  }

  @override
  void visitProgram(ProgramInfo info) {
    throw StateError('should not diff ProgramInfo');
  }

  @override
  void visitOutput(OutputUnitInfo info) {
    throw StateError('should not diff OutputUnitInfo');
  }

  // TODO(het): diff constants
  @override
  void visitConstant(ConstantInfo info) {
    throw StateError('should not diff ConstantInfo');
  }

  @override
  void visitLibrary(LibraryInfo info) {
    var other = _other as LibraryInfo;
    _checkSize(info, other);
    _diffList(info.topLevelVariables, other.topLevelVariables);
    _diffList(info.topLevelFunctions, other.topLevelFunctions);
    _diffList(info.classes, other.classes);
  }

  @override
  void visitClass(ClassInfo info) {
    var other = _other as ClassInfo;
    _checkSize(info, other);
    _checkDeferredStatus(info, other);
    _diffList(info.fields, other.fields);
    _diffList(info.functions, other.functions);
  }

  @override
  void visitClassType(ClassTypeInfo info) {
    var other = _other as ClassTypeInfo;
    _checkSize(info, other);
    _checkDeferredStatus(info, other);
  }

  @override
  void visitClosure(ClosureInfo info) {
    var other = _other as ClosureInfo;
    _checkSize(info, other);
    _checkDeferredStatus(info, other);
    _diffList([info.function], [other.function]);
  }

  @override
  void visitField(FieldInfo info) {
    var other = _other as FieldInfo;
    _checkSize(info, other);
    _checkDeferredStatus(info, other);
    _diffList(info.closures, other.closures);
  }

  @override
  void visitFunction(FunctionInfo info) {
    var other = _other as FunctionInfo;
    _checkSize(info, other);
    _checkDeferredStatus(info, other);
    _diffList(info.closures, other.closures);
  }

  @override
  void visitTypedef(TypedefInfo info) {
    var other = _other as TypedefInfo;
    _checkSize(info, other);
    _checkDeferredStatus(info, other);
  }

  void _checkSize(BasicInfo info, BasicInfo other) {
    if (info.size != other.size) {
      diffs.add(SizeDiff(info, other.size - info.size));
    }
  }

  void _checkDeferredStatus(BasicInfo oldInfo, BasicInfo newInfo) {
    var oldIsDeferred = _isDeferred(oldInfo);
    var newIsDeferred = _isDeferred(newInfo);
    if (oldIsDeferred != newIsDeferred) {
      diffs.add(DeferredStatusDiff(oldInfo, oldIsDeferred));
    }
  }

  bool _isDeferred(BasicInfo info) {
    var outputUnit = info.outputUnit!;
    return outputUnit.name.isNotEmpty && outputUnit.name != 'main';
  }

  void _diffList(List<BasicInfo> oldInfos, List<BasicInfo> newInfos) {
    var oldNames = <String, BasicInfo>{};
    var newNames = <String, BasicInfo>{};
    for (var oldInfo in oldInfos) {
      oldNames[longName(oldInfo, useLibraryUri: true)] = oldInfo;
    }
    for (var newInfo in newInfos) {
      newNames[longName(newInfo, useLibraryUri: true)] = newInfo;
    }
    for (var oldName in oldNames.keys) {
      if (newNames[oldName] == null) {
        diffs.add(RemoveDiff(oldNames[oldName]!));
      } else {
        _other = newNames[oldName];
        oldNames[oldName]!.accept(this);
      }
    }
    for (var newName in newNames.keys) {
      if (oldNames[newName] == null) {
        diffs.add(AddDiff(newNames[newName]!));
      }
    }
  }
}
