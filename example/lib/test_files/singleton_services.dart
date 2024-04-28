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
  static SingletonWithFactoryWithDependencies create(SingletonNoDependencies serviceA) {
    return SingletonWithFactoryWithDependencies(serviceA);
  }

  @override
  void doSomething() {
    print('$SingletonWithFactoryWithDependencies.doSomething');
  }
}

// This will throw an Exception
/* 
@RegisterSingleton()
class SingletonWithNamedArgs implements AbstractService {
  final double someValue;

  SingletonWithNamedArgs({required this.someValue});

  @override
  void doSomething() {
    print('$SingletonWithNamedArgs.doSomething with someValue: $someValue');
  }
} */

// This will throw an Exception
/*
@RegisterSingleton()
class SingletonWithNamedArgsWithFactory implements AbstractService {
  final double someValue;

  SingletonWithNamedArgsWithFactory({required this.someValue});

  @RegisterFactoryMethod()
  static SingletonWithNamedArgsWithFactory create({required double someValue}) {
    return SingletonWithNamedArgsWithFactory(someValue: someValue);
  }

  @override
  void doSomething() {
    print(
        '$SingletonWithNamedArgsWithFactory.doSomething with someValue: $someValue');
  }
} */
