import 'package:dart2js_info/info.dart';
import 'package:dart2js_info/src/util.dart';

class CommonElement {
  final BasicInfo oldInfo;
  final BasicInfo newInfo;

  CommonElement(this.oldInfo, this.newInfo);

  String get name => longName(oldInfo, useLibraryUri: true);
}

List<CommonElement> findCommonalities(AllInfo oldInfo, AllInfo newInfo) {
  var finder = _InfoCommonElementFinder(oldInfo, newInfo);
  finder.run();
  return finder.commonElements;
}

class _InfoCommonElementFinder extends InfoVisitor<void> {
  final AllInfo _old;
  final AllInfo _new;

  late BasicInfo _other;

  List<CommonElement> commonElements = <CommonElement>[];

  _InfoCommonElementFinder(this._old, this._new);

  void run() {
    _commonList(_old.libraries, _new.libraries);
  }

  @override
  void visitAll(AllInfo info) {
    throw StateError('should not run common on AllInfo');
  }

  @override
  void visitProgram(ProgramInfo info) {
    throw StateError('should not run common on ProgramInfo');
  }

  @override
  void visitOutput(OutputUnitInfo info) {
    throw StateError('should not run common on OutputUnitInfo');
  }

  @override
  void visitConstant(ConstantInfo info) {
    throw StateError('should not run common on ConstantInfo');
  }

  @override
  void visitLibrary(LibraryInfo info) {
    var other = _other as LibraryInfo;
    commonElements.add(CommonElement(info, other));
    _commonList(info.topLevelVariables, other.topLevelVariables);
    _commonList(info.topLevelFunctions, other.topLevelFunctions);
    _commonList(info.classes, other.classes);
  }

  @override
  void visitClass(ClassInfo info) {
    var other = _other as ClassInfo;
    commonElements.add(CommonElement(info, other));
    _commonList(info.fields, other.fields);
    _commonList(info.functions, other.functions);
  }

  @override
  void visitClassType(ClassTypeInfo info) {
    var other = _other as ClassInfo;
    commonElements.add(CommonElement(info, other));
  }

  @override
  void visitClosure(ClosureInfo info) {
    var other = _other as ClosureInfo;
    commonElements.add(CommonElement(info, other));
    _commonList([info.function], [other.function]);
  }

  @override
  void visitField(FieldInfo info) {
    var other = _other as FieldInfo;
    commonElements.add(CommonElement(info, other));
    _commonList(info.closures, other.closures);
  }

  @override
  void visitFunction(FunctionInfo info) {
    var other = _other as FunctionInfo;
    commonElements.add(CommonElement(info, other));
    _commonList(info.closures, other.closures);
  }

  @override
  void visitTypedef(TypedefInfo info) {
    var other = _other as ClassInfo;
    commonElements.add(CommonElement(info, other));
  }

  void _commonList(List<BasicInfo> oldInfos, List<BasicInfo> newInfos) {
    var newNames = <String, BasicInfo>{};
    for (var newInfo in newInfos) {
      newNames[longName(newInfo, useLibraryUri: true)] = newInfo;
    }
    for (var oldInfo in oldInfos) {
      var oldName = longName(oldInfo, useLibraryUri: true);
      if (newNames.containsKey(oldName)) {
        _other = newNames[oldName]!;
        oldInfo.accept(this);
      }
    }
  }
}
