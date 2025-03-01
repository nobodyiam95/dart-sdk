// Copyright (c) 2022, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

// Tests that when the feature is enabled, inferred types can flow
// "horizontally" from a non-closure argument of an invocation to a closure
// argument.

testLaterUnnamedParameter(void Function<T>(T, void Function(T)) f) {
  f(0, (x) {
    x;
  });
}

/// This special case verifies that the implementations correctly associate the
/// zeroth positional parameter with the corresponding argument (even if that
/// argument isn't in the zeroth position at the call site).
testLaterUnnamedParameterDependsOnNamedParameter(
    void Function<T>(void Function(T), {required T a}) f) {
  f(a: 0, (x) {
    x;
  });
}

testEarlierUnnamedParameter(void Function<T>(void Function(T), T) f) {
  f((x) {
    x;
  }, 0);
}

testLaterNamedParameter(
    void Function<T>({required T a, required void Function(T) b}) f) {
  f(
      a: 0,
      b: (x) {
        x;
      });
}

testEarlierNamedParameter(
    void Function<T>({required void Function(T) a, required T b}) f) {
  f(
      a: (x) {
        x;
      },
      b: 0);
}

/// This special case verifies that the implementations correctly associate the
/// zeroth positional parameter with the corresponding argument (even if that
/// argument isn't in the zeroth position at the call site).
testEarlierNamedParameterDependsOnUnnamedParameter(
    void Function<T>(T b, {required void Function(T) a}) f) {
  f(a: (x) {
    x;
  }, 0);
}

testPropagateToReturnType(U Function<T, U>(T, U Function(T)) f) {
  f(0, (x) => [x]);
}

testFold(List<int> list) {
  var a = list.fold(0, (x, y) => (x) + (y));
  a;
}

// The test cases below exercise situations where there are multiple closures in
// the invocation, and they need to be inferred in the right order.

testClosureAsParameterType(U Function<T, U>(T, U Function(T)) f) {
  f(() => 0, (h) => [h()]);
}

testPropagateToEarlierClosure(U Function<T, U>(U Function(T), T Function()) f) {
  f((x) => [x], () => 0);
}

testPropagateToLaterClosure(U Function<T, U>(T Function(), U Function(T)) f) {
  f(() => 0, (x) => [x]);
}

testLongDependencyChain(
    V Function<T, U, V>(T Function(), U Function(T), V Function(U)) f) {
  f(() => [0], (x) => x.single, (y) => {y});
}

testDependencyCycle(Map<T, U> Function<T, U>(T Function(U), U Function(T)) f) {
  f((x) => [x], (y) => {y});
}

testNecessaryDueToWrongExplicitParameterType(List<int> list) {
  var a = list.fold(0, (x, int y) => (x) + (y));
  a;
}

testPropagateFromContravariantReturnType(
    U Function<T, U>(void Function(T) Function(), U Function(T)) f) {
  f(() => (int i) {}, (x) => [x]);
}

testPropagateToContravariantParameterType(
    U Function<T, U>(T Function(), U Function(void Function(T))) f) {
  f(() => 0, (x) => [x]);
}

testReturnTypeRefersToMultipleTypeVars(
    void Function<T, U>(
            Map<T, U> Function(), void Function(T), void Function(U))
        f) {
  f(() => {0: ''}, (k) {
    k;
  }, (v) {
    v;
  });
}

testUnnecessaryDueToNoDependency(T Function<T>(T Function(), T) f) {
  f(() => 0, null);
}

testUnnecessaryDueToExplicitParameterType(List<int> list) {
  var a = list.fold(null, (int? x, y) => (x ?? 0) + y);
  a;
}

testUnnecessaryDueToExplicitParameterTypeNamed(
    T Function<T>(T, T Function({required T x, required int y})) f) {
  var a = f(null, ({int? x, required y}) => (x ?? 0) + y);
  a;
}

testParenthesized(void Function<T>(T, void Function(T)) f) {
  f(0, ((x) {
    x;
  }));
}

testParenthesizedNamed(
    void Function<T>({required T a, required void Function(T) b}) f) {
  f(
      a: 0,
      b: ((x) {
        x;
      }));
}

testParenthesizedTwice(void Function<T>(T, void Function(T)) f) {
  f(0, (((x) {
    x;
  })));
}

testParenthesizedTwiceNamed(
    void Function<T>({required T a, required void Function(T) b}) f) {
  f(
      a: 0,
      b: (((x) {
        x;
      })));
}

main() {}
