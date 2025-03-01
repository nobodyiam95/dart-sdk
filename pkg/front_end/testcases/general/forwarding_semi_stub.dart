// Copyright (c) 2021, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

class Super<T> {
  void method1(int a) {}
  void method2({int? a}) {}
  void method3(int a) {}
  void method4(num a) {}
  void method5({int? a}) {}
  void method6({num? a}) {}
  void method7(List<T> a) {}
  void method8({List<T>? a}) {}
  void method9(List<T> a) {}
  void method10(Iterable<T> a) {}
  void method11({List<T>? a}) {}
  void method12({Iterable<T>? a}) {}

  void set setter1(int a) {}
  void set setter2(num a) {}
  void set setter3(List<T> a) {}
  void set setter4(Iterable<T> a) {}
}

class Interface<T> {
  void method1(covariant num a) {}
  void method2({covariant num? a}) {}
  void method7(covariant Iterable<T> a) {}
  void method8({covariant Iterable<T>? a}) {}

  void set setter1(covariant num a) {}
  void set setter3(covariant Iterable<T> a) {}
}

abstract class Class<T> extends Super<T> implements Interface<T> {
  void method3(covariant num a);
  void method4(covariant int a);
  void method5({covariant num? a});
  void method6({covariant int? a});

  void method9(covariant Iterable<T> a);
  void method10(covariant List<T> a);
  void method11({covariant Iterable<T>? a});
  void method12({covariant List<T>? a});

  void set setter2(covariant int a);
  void set setter4(covariant List<T> a);
}

class Subclass<T> extends Class<T> {
  void method1(num a) {}
  void method2({num? a}) {}
  void method3(num a) {}
  void method4(num a) {}
  void method5({num? a}) {}
  void method6({num? a}) {}
  void method7(Iterable<T> a) {}
  void method8({Iterable<T>? a}) {}
  void method9(Iterable<T> a) {}
  void method10(Iterable<T> a) {}
  void method11({Iterable<T>? a}) {}
  void method12({Iterable<T>? a}) {}

  void set setter1(num a) {}
  void set setter2(num a) {}
  void set setter3(Iterable<T> a) {}
  void set setter4(Iterable<T> a) {}
}

main() {}
