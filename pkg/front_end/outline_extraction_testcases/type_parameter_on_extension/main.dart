class Foo<E> {}

extension HiExtension<T extends Foo> on T {
  void sayHi() {}
}
