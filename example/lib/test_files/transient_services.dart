// ignore_for_file: unused_field

import 'package:zef_di_core/zef_di_core.dart';

abstract class TransientService {
  void doSomething();
}

@RegisterTransient()
class TransientNoDependencies implements TransientService {
  const TransientNoDependencies();

  @override
  void doSomething() {
    print('$TransientNoDependencies.doSomething');
  }
}

@RegisterTransient()
class TransientWithFactory implements TransientService {
  const TransientWithFactory();

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
  static TransientWithFactoryWithDependencies create(
      TransientNoDependencies serviceA) {
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
  final TransientWithFactory _dependency2;
  final double? someValue;

  TransientWithDependencyWithNamedArgs(
    this._dependency,
    this._dependency2, {
    required this.someValue,
  });

  @override
  void doSomething() {
    print('$TransientWithNamedArgs.doSomething');
  }
}

@RegisterTransient()
class TransientWithFactoryWithDependencyWithNamedArgs
    implements TransientService {
  final TransientNoDependencies _dependency;
  final double? someValue;

  TransientWithFactoryWithDependencyWithNamedArgs(
    this._dependency,
    this.someValue,
  );

  @RegisterFactoryMethod()
  static TransientWithFactoryWithDependencyWithNamedArgs create(
    TransientNoDependencies dependency, {
    required double? someValue,
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

@RegisterTransient()
class TransientWithAsyncFactory implements TransientService {
  @RegisterFactoryMethod()
  static Future<TransientWithAsyncFactory> create() async {
    return TransientWithAsyncFactory();
  }

  @override
  void doSomething() {
    print('$TransientWithAsyncFactory.doSomething');
  }
}

@RegisterTransient()
class TransientWithMultipleConstructors implements TransientService {
  final double someValue;

  TransientWithMultipleConstructors(this.someValue);

  TransientWithMultipleConstructors.named(this.someValue);

  @override
  void doSomething() {
    print('$TransientWithMultipleConstructors.doSomething');
  }
}

@RegisterTransient()
class TransientWithMultipleFactories implements TransientService {
  final double someValue;

  TransientWithMultipleFactories(this.someValue);

  static TransientWithMultipleFactories factory1(double someValue) {
    return TransientWithMultipleFactories(someValue);
  }

  static Future<TransientWithMultipleFactories> factory2(
      double someValue) async {
    return TransientWithMultipleFactories(someValue);
  }

  @override
  void doSomething() {
    print('$TransientWithMultipleFactories.doSomething');
  }
}
