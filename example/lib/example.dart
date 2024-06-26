import 'package:example/test_files/lazy_services.dart';
import 'package:example/test_files/transient_services.dart';
import 'package:example/zef.di.register.g.dart';
import 'package:zef_di_core/zef_di_core.dart';

import 'test_files/singleton_services.dart';

void main(List<String> arguments) async {
  ServiceLocatorBuilder().build();

  await registerDependencies();

  await resolveSingletons();
  await resolveTransients();
  await resolveLazies();
}

Future<void> resolveSingletons() async {
  final singletonNoDependencies =
      await ServiceLocator.instance.resolve<SingletonNoDependencies>();
  singletonNoDependencies.doSomething();

  final singletonWithFactory =
      await ServiceLocator.instance.resolve<SingletonWithFactory>();
  singletonWithFactory.doSomething();

  final singletonWithDependencies =
      await ServiceLocator.instance.resolve<SingletonWithDependencies>();
  singletonWithDependencies.doSomething();

  final singletonWithFactoryWithDependencies = await ServiceLocator.instance
      .resolve<SingletonWithFactoryWithDependencies>();
  singletonWithFactoryWithDependencies.doSomething();
}

Future<void> resolveTransients() async {
  final transientNoDependencies =
      await ServiceLocator.instance.resolve<TransientNoDependencies>();
  transientNoDependencies.doSomething();

  final transientWithFactory =
      await ServiceLocator.instance.resolve<TransientWithFactory>();
  transientWithFactory.doSomething();

  final transientWithDependencies =
      await ServiceLocator.instance.resolve<TransientWithDependencies>();
  transientWithDependencies.doSomething();

  final transientWithFactoryWithDependencies = await ServiceLocator.instance
      .resolve<TransientWithFactoryWithDependencies>();
  transientWithFactoryWithDependencies.doSomething();

  final transientWithArgs =
      await ServiceLocator.instance.resolve<TransientWithArgs>(args: {
    'someValue': 5.0,
  });
  transientWithArgs.doSomething();

  final transientWithFactoryWithArgs = await ServiceLocator.instance
      .resolve<TransientWithFactoryWithArgs>(args: {
    'someValue': 5.0,
  });
  transientWithFactoryWithArgs.doSomething();

  final transientWithFactoryWithDependencyWithArgs = await ServiceLocator
      .instance
      .resolve<TransientWithFactoryWithDependencyWithArgs>(args: {
    'someValue': 5.0,
  });
  transientWithFactoryWithDependencyWithArgs.doSomething();

  final transientWithAsyncFactory =
      await ServiceLocator.instance.resolve<TransientWithAsyncFactory>();
  transientWithAsyncFactory.doSomething();
}

Future<void> resolveLazies() async {
  final lazyNoDependencies =
      await ServiceLocator.instance.resolve<LazyNoDependencies>();
  lazyNoDependencies.doSomething();

  final lazyWithFactoryNoDependencies =
      await ServiceLocator.instance.resolve<LazyWithFactoryNoDependencies>();
  lazyWithFactoryNoDependencies.doSomething();

  final lazyWithDependencies =
      await ServiceLocator.instance.resolve<LazyWithDependencies>();
  lazyWithDependencies.doSomething();

  final lazyWithFactoryWithDependencies =
      await ServiceLocator.instance.resolve<LazyWithFactoryWithDependencies>();
  lazyWithFactoryWithDependencies.doSomething();
}
