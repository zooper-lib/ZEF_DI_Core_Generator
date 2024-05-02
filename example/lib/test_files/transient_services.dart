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
      @Injected(name: 'TestName') TransientNoDependencies serviceA) {
    return TransientWithFactoryWithDependencies(serviceA);
  }

  @override
  void doSomething() {
    print('$TransientWithFactoryWithDependencies.doSomething');
  }
}

@RegisterTransient()
class TransientWithArgs implements TransientService {
  final double someValue;

  TransientWithArgs({@Passed() required this.someValue});

  @override
  void doSomething() {
    print('$TransientWithArgs.doSomething');
  }
}

@RegisterTransient()
class TransientWithFactoryWithArgs implements TransientService {
  final double someValue;

  TransientWithFactoryWithArgs({required this.someValue});

  @RegisterFactoryMethod()
  static TransientWithFactoryWithArgs create(
      {@Passed() required double someValue}) {
    return TransientWithFactoryWithArgs(someValue: someValue);
  }

  @override
  void doSomething() {
    print('$TransientWithFactoryWithArgs.doSomething');
  }
}

@RegisterTransient()
class TransientWithDependencyWithArgs implements TransientService {
  final TransientNoDependencies _dependency;
  final TransientWithFactory _dependency2;
  final double? someValue;

  TransientWithDependencyWithArgs(
    this._dependency,
    this._dependency2, {
    @Passed() required this.someValue,
  });

  @override
  void doSomething() {
    print('$TransientWithArgs.doSomething');
  }
}

@RegisterTransient()
class TransientWithFactoryWithDependencyWithArgs implements TransientService {
  final TransientNoDependencies _dependency;
  final double? someValue;

  TransientWithFactoryWithDependencyWithArgs(
    this._dependency,
    this.someValue,
  );

  @RegisterFactoryMethod()
  static TransientWithFactoryWithDependencyWithArgs create(
    TransientNoDependencies dependency, {
    @Passed() required double? someValue,
  }) {
    return TransientWithFactoryWithDependencyWithArgs(
      dependency,
      someValue,
    );
  }

  @override
  void doSomething() {
    print('$TransientWithFactoryWithDependencyWithArgs.doSomething');
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

  TransientWithMultipleConstructors.named(@Passed() this.someValue);

  @override
  void doSomething() {
    print('$TransientWithMultipleConstructors.doSomething');
  }
}

@RegisterTransient()
class TransientWithMultipleFactories implements TransientService {
  final double someValue;

  TransientWithMultipleFactories(this.someValue);

  static TransientWithMultipleFactories factory1(@Passed() double someValue) {
    return TransientWithMultipleFactories(someValue);
  }

  static Future<TransientWithMultipleFactories> factory2(
    @Passed() double someValue,
  ) async {
    return TransientWithMultipleFactories(someValue);
  }

  @override
  void doSomething() {
    print('$TransientWithMultipleFactories.doSomething');
  }
}
