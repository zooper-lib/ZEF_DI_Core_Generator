// ignore_for_file: unused_field

import 'package:zef_di_core/zef_di_core.dart';

abstract class SingletonService {
  void doSomething();
}

@RegisterSingleton()
class SingletonNoDependencies implements SingletonService {
  @override
  void doSomething() {
    print('$SingletonNoDependencies.doSomething');
  }
}

@RegisterSingleton()
class SingletonWithFactory implements SingletonService {
  @RegisterFactoryMethod()
  static SingletonWithFactory create() {
    return SingletonWithFactory();
  }

  @override
  void doSomething() {
    print('$SingletonWithFactory.doSomething');
  }
}

@RegisterSingleton()
class SingletonWithDependencies implements SingletonService {
  final SingletonNoDependencies serviceA;

  SingletonWithDependencies(this.serviceA);

  @override
  void doSomething() {
    print('$SingletonWithDependencies.doSomething');
  }
}

@RegisterSingleton()
class SingletonWithFactoryWithDependencies implements SingletonService {
  final SingletonNoDependencies serviceA;

  SingletonWithFactoryWithDependencies(this.serviceA);

  @RegisterFactoryMethod()
  static SingletonWithFactoryWithDependencies create(
      SingletonNoDependencies serviceA) {
    return SingletonWithFactoryWithDependencies(serviceA);
  }

  @override
  void doSomething() {
    print('$SingletonWithFactoryWithDependencies.doSomething');
  }
}
