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

class ModuleWithNamedArgs {
  final double someValue;

  ModuleWithNamedArgs({required this.someValue});

  void doSomething() {
    print('$ModuleWithNamedArgs.doSomething');
  }
}

class ModuleWithFactoryWithNamedArgs {
  final double someValue;

  ModuleWithFactoryWithNamedArgs.create({required this.someValue});

  void doSomething() {
    print('$ModuleWithFactoryWithNamedArgs.doSomething');
  }
}

class ModuleWithDependencyWithNamedArgs {
  final ModuleNoDependencies _dependency;
  final double someValue;

  ModuleWithDependencyWithNamedArgs(
    this._dependency, {
    required this.someValue,
  });

  void doSomething() {
    print('$ModuleWithDependencyWithNamedArgs.doSomething');
  }
}

class ModuleWithFactoryWithDependencyWithNamedArgs {
  final ModuleNoDependencies _dependency;
  final double someValue;

  ModuleWithFactoryWithDependencyWithNamedArgs.create(
    this._dependency, {
    required this.someValue,
  });

  void doSomething() {
    print('$ModuleWithFactoryWithDependencyWithNamedArgs.doSomething');
  }
}
