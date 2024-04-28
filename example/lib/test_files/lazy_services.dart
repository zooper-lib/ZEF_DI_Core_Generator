import 'package:zef_di_core/zef_di_core.dart';

abstract class LazyServices {
  void doSomething();
}

@RegisterLazy()
class LazyNoDependencies implements LazyServices {
  @override
  void doSomething() {
    print('$LazyNoDependencies.doSomething');
  }
}

@RegisterLazy()
class LazyWithFactoryNoDependencies implements LazyServices {
  @RegisterFactoryMethod()
  static LazyWithFactoryNoDependencies create() {
    return LazyWithFactoryNoDependencies();
  }

  @override
  void doSomething() {
    print('$LazyWithFactoryNoDependencies.doSomething');
  }
}

@RegisterLazy()
class LazyWithDependencies implements LazyServices {
  LazyWithDependencies(this.lazyNoDependencies);

  final LazyNoDependencies lazyNoDependencies;

  @override
  void doSomething() {
    print('$LazyWithDependencies.doSomething');
  }
}

@RegisterLazy()
class LazyWithFactoryWithDependencies implements LazyServices {
  LazyWithFactoryWithDependencies(this.lazyNoDependencies);

  @RegisterFactoryMethod()
  static Future<LazyWithFactoryWithDependencies> create() async {
    return LazyWithFactoryWithDependencies(
      await ServiceLocator.I.resolve<LazyNoDependencies>(),
    );
  }

  final LazyNoDependencies lazyNoDependencies;

  @override
  void doSomething() {
    print('$LazyWithFactoryWithDependencies.doSomething');
  }
}
