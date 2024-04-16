// ignore_for_file: unused_field

import 'package:zef_di_core/zef_di_core.dart';

abstract class TransientService {
  void doSomething();
}

@RegisterTransient()
class TransientNoDependencies implements TransientService {
  @override
  void doSomething() {
    print('$TransientNoDependencies.doSomething');
  }
}

@RegisterTransient()
class TransientWithFactory implements TransientService {
  @RegisterFactoryMethod()
  static TransientWithFactory create() {
    return TransientWithFactory();
  }

  @override
  void doSomething() {
    print('$TransientWithFactory.doSomething');
  }
}

@RegisterTransient()
class TransientWithDependencies implements TransientService {
  final TransientNoDependencies serviceA;

  TransientWithDependencies(this.serviceA);

  @override
  void doSomething() {
    print('$TransientWithDependencies.doSomething');
  }
}

@RegisterTransient()
class TransientWithFactoryWithDependencies implements TransientService {
  final TransientNoDependencies serviceA;

  TransientWithFactoryWithDependencies(this.serviceA);

  @RegisterFactoryMethod()
  static TransientWithFactoryWithDependencies create(TransientNoDependencies serviceA) {
    return TransientWithFactoryWithDependencies(serviceA);
  }

  @override
  void doSomething() {
    print('$TransientWithFactoryWithDependencies.doSomething');
  }
}

@RegisterTransient()
class TransientWithNamedArgs implements TransientService {
  final double someValue;

  TransientWithNamedArgs({required this.someValue});

  @override
  void doSomething() {
    print('$TransientWithNamedArgs.doSomething');
  }
}

@RegisterTransient()
class TransientWithFactoryWithNamedArgs implements TransientService {
  final double someValue;

  TransientWithFactoryWithNamedArgs({required this.someValue});

  @RegisterFactoryMethod()
  static TransientWithFactoryWithNamedArgs create({required double someValue}) {
    return TransientWithFactoryWithNamedArgs(someValue: someValue);
  }

  @override
  void doSomething() {
    print('$TransientWithFactoryWithNamedArgs.doSomething');
  }
}

@RegisterTransient()
class TransientWithDependencyWithNamedArgs implements TransientService {
  final TransientNoDependencies _dependency;
  final double someValue;

  TransientWithDependencyWithNamedArgs(
    this._dependency, {
    required this.someValue,
  });

  @override
  void doSomething() {
    print('$TransientWithNamedArgs.doSomething');
  }
}

@RegisterTransient()
class TransientWithFactoryWithDependencyWithNamedArgs implements TransientService {
  final TransientNoDependencies _dependency;
  final double someValue;

  TransientWithFactoryWithDependencyWithNamedArgs(
    this._dependency,
    this.someValue,
  );

  @RegisterFactoryMethod()
  static TransientWithFactoryWithDependencyWithNamedArgs create(
    TransientNoDependencies dependency, {
    required double someValue,
  }) {
    return TransientWithFactoryWithDependencyWithNamedArgs(
      dependency,
      someValue,
    );
  }

  @override
  void doSomething() {
    print('$TransientWithFactoryWithDependencyWithNamedArgs.doSomething');
  }
}
