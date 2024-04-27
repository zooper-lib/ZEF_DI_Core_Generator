// ignore_for_file: unused_field

import 'singleton_services.dart';

class ModuleNoDependencies implements SingletonService {
  @override
  void doSomething() {
    print('$ModuleNoDependencies.doSomething');
  }
}

class ModuleWithDependency {
  final ModuleNoDependencies dependency;

  ModuleWithDependency(this.dependency);

  void doSomething() {
    print('$ModuleNoDependencies.doSomething');
  }
}

class ModuleWithFactory {
  ModuleWithFactory.create();

  void doSomething() {
    print('$ModuleWithFactory.doSomething');
  }
}

class ModuleWithFactoryWithDependencies {
  final ModuleNoDependencies serviceA;
  final ModuleWithDependency serviceB;

  ModuleWithFactoryWithDependencies.create(
    this.serviceA,
    this.serviceB,
  );

  void doSomething() {
    print('$ModuleWithFactoryWithDependencies.doSomething');
  }
}

class ModuleWithArgs {
  final double someValue;

  ModuleWithArgs({required this.someValue});

  void doSomething() {
    print('$ModuleWithArgs.doSomething');
  }
}

class ModuleWithFactoryWithArgs {
  final double someValue;

  ModuleWithFactoryWithArgs.create({required this.someValue});

  void doSomething() {
    print('$ModuleWithFactoryWithArgs.doSomething');
  }
}

class ModuleWithDependencyWithArgs {
  final ModuleNoDependencies _dependency;
  final double someValue;

  ModuleWithDependencyWithArgs(
    this._dependency, {
    required this.someValue,
  });

  void doSomething() {
    print('$ModuleWithDependencyWithArgs.doSomething');
  }
}

class ModuleWithFactoryWithDependencyWithArgs {
  final ModuleNoDependencies _dependency;
  final double someValue;

  ModuleWithFactoryWithDependencyWithArgs.create(
    this._dependency, {
    required this.someValue,
  });

  void doSomething() {
    print('$ModuleWithFactoryWithDependencyWithArgs.doSomething');
  }
}
