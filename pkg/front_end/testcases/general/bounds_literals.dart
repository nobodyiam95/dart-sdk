// Copyright (c) 2022, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

class Class<T> {}

class ConcreteClass implements Class<ConcreteClass> {}

typedef F<X extends Class<X>> = X;

class G<X extends Class<X>> {}

test() {
  <F, F<dynamic>>{}; // Ok
  <F<Class>, F<Class<dynamic>>>{}; // Ok
  <F<ConcreteClass>, F<Class<ConcreteClass>>>{}; // Ok
  <F<Object>, F<int>>{}; // Error
  <G, G<dynamic>>{}; // Ok
  <G<Class>, G<Class<dynamic>>>{}; // Ok
  <G<ConcreteClass>, G<Class<ConcreteClass>>>{}; // Ok
  <G<Object>, G<int>>{}; // Error

  <F>{}; // Ok
  <F<dynamic>>{}; // Ok
  <F<Class>>{}; // Ok
  <F<Class<dynamic>>>{}; // Ok
  <F<Object>>{}; // Error
  <F<int>>{}; // Error
  <F<ConcreteClass>>{}; // Ok
  <F<Class<ConcreteClass>>>{}; // Ok
  <G>{}; // Ok
  <G<dynamic>>{}; // Ok
  <G<Class>>{}; // Ok
  <G<Class<dynamic>>>{}; // Ok
  <G<ConcreteClass>>{}; // Ok
  <G<Class<ConcreteClass>>>{}; // Ok
  <G<Object>>{}; // Error
  <G<int>>{}; // Error

  <F>[]; // Ok
  <F<dynamic>>[]; // Ok
  <F<Class>>[]; // Ok
  <F<Class<dynamic>>>[]; // Ok
  <F<ConcreteClass>>[]; // Ok
  <F<Class<ConcreteClass>>>[]; // Ok
  <F<Object>>[]; // Error
  <F<int>>[]; // Error
  <G>[]; // Ok
  <G<dynamic>>[]; // Ok
  <G<Class>>[]; // Ok
  <G<Class<dynamic>>>[]; // Ok
  <G<ConcreteClass>>[]; // Ok
  <G<Class<ConcreteClass>>>[]; // Ok
  <G<Object>>[]; // Error
  <G<int>>[]; // Error
}

main() {}
