// GENERATED CODE - DO NOT MODIFY BY HAND
// ******************************************************************************

// ignore_for_file: implementation_imports, depend_on_referenced_packages, unused_import

import 'package:dio/src/dio.dart';
import 'package:example/test_files/singleton_services.dart';
import 'package:example/test_files/lazy_services.dart';
import 'package:example/test_files/transient_services.dart';
import 'package:zef_di_core/zef_di_core.dart';
import 'package:zef_helpers_lazy/zef_helpers_lazy.dart';

Future<void> registerDependencies() async {
  await ServiceLocator.I.registerSingleton<Dio>(
    Dio(),
    interfaces: null,
    name: null,
    key: null,
    environment: null,
  );

  await ServiceLocator.I.registerSingleton<SingletonNoDependencies>(
    SingletonNoDependencies(),
    interfaces: {SingletonService},
    name: null,
    key: null,
    environment: null,
  );

  await ServiceLocator.I.registerSingletonFactory<SingletonWithFactory>(
    (Map<String, dynamic> args) async => SingletonWithFactory.create(),
    interfaces: {SingletonService},
    name: null,
    key: null,
    environment: null,
  );

  await ServiceLocator.I.registerSingleton<SingletonWithDependencies>(
    SingletonWithDependencies(
      await ServiceLocator.I.resolve(),
    ),
    interfaces: {SingletonService},
    name: null,
    key: null,
    environment: null,
  );

  await ServiceLocator.I
      .registerSingletonFactory<SingletonWithFactoryWithDependencies>(
    (Map<String, dynamic> args) async =>
        SingletonWithFactoryWithDependencies.create(
      await ServiceLocator.I.resolve(
        args: args,
      ),
    ),
    interfaces: {SingletonService},
    name: null,
    key: null,
    environment: null,
  );

  await ServiceLocator.I.registerLazy<LazyNoDependencies>(
    Lazy<LazyNoDependencies>(factory: () async => LazyNoDependencies()),
    interfaces: {LazyServices},
    name: null,
    key: null,
    environment: null,
  );

  await ServiceLocator.I.registerLazy<LazyWithFactoryNoDependencies>(
    Lazy<LazyWithFactoryNoDependencies>(
        factory: () async => LazyWithFactoryNoDependencies.create()),
    interfaces: {LazyServices},
    name: null,
    key: null,
    environment: null,
  );

  await ServiceLocator.I.registerLazy<LazyWithDependencies>(
    Lazy<LazyWithDependencies>(
        factory: () async => LazyWithDependencies(
              await ServiceLocator.I.resolve(),
            )),
    interfaces: {LazyServices},
    name: null,
    key: null,
    environment: null,
  );

  await ServiceLocator.I.registerLazy<LazyWithFactoryWithDependencies>(
    Lazy<LazyWithFactoryWithDependencies>(
        factory: () async => await LazyWithFactoryWithDependencies.create()),
    interfaces: {LazyServices},
    name: null,
    key: null,
    environment: null,
  );

  await ServiceLocator.I.registerTransient<TransientNoDependencies>(
    (args) async => const TransientNoDependencies(),
    interfaces: {TransientService},
    name: null,
    key: null,
    environment: null,
  );

  await ServiceLocator.I.registerTransient<TransientWithFactory>(
    (args) async => TransientWithFactory.create(),
    interfaces: {TransientService},
    name: null,
    key: null,
    environment: null,
  );

  await ServiceLocator.I.registerTransient<TransientWithDependencies>(
    (args) async => TransientWithDependencies(
      await ServiceLocator.I.resolve(
        args: args,
      ),
    ),
    interfaces: {TransientService},
    name: null,
    key: null,
    environment: null,
  );

  await ServiceLocator.I
      .registerTransient<TransientWithFactoryWithDependencies>(
    (args) async => TransientWithFactoryWithDependencies.create(
      await ServiceLocator.I.resolve(
        args: args,
        name: 'TestName',
      ),
    ),
    interfaces: {TransientService},
    name: null,
    key: null,
    environment: null,
  );

  await ServiceLocator.I.registerTransient<TransientWithArgs>(
    (args) async => TransientWithArgs(
      someValue: args['someValue'],
    ),
    interfaces: {TransientService},
    name: null,
    key: null,
    environment: null,
  );

  await ServiceLocator.I.registerTransient<TransientWithFactoryWithArgs>(
    (args) async => TransientWithFactoryWithArgs.create(
      someValue: args['someValue'],
    ),
    interfaces: {TransientService},
    name: null,
    key: null,
    environment: null,
  );

  await ServiceLocator.I.registerTransient<TransientWithDependencyWithArgs>(
    (args) async => TransientWithDependencyWithArgs(
      await ServiceLocator.I.resolve(
        args: args,
      ),
      await ServiceLocator.I.resolve(
        args: args,
      ),
      someValue: args['someValue'],
    ),
    interfaces: {TransientService},
    name: null,
    key: null,
    environment: null,
  );

  await ServiceLocator.I
      .registerTransient<TransientWithFactoryWithDependencyWithArgs>(
    (args) async => TransientWithFactoryWithDependencyWithArgs.create(
      await ServiceLocator.I.resolve(
        args: args,
      ),
      someValue: args['someValue'],
    ),
    interfaces: {TransientService},
    name: null,
    key: null,
    environment: null,
  );

  await ServiceLocator.I
      .registerTransient<TransientWithMultipleDependenciesWithMultipleArgs>(
    (args) async => TransientWithMultipleDependenciesWithMultipleArgs(
      dependencyOne: await ServiceLocator.I.resolve(
        args: args,
      ),
      dependencyTwo: await ServiceLocator.I.resolve(
        args: args,
      ),
      valueOne: args['valueOne'],
      valueTwo: args['valueTwo'],
    ),
    interfaces: {TransientService},
    name: null,
    key: null,
    environment: null,
  );

  await ServiceLocator.I.registerTransient<TransientWithAsyncFactory>(
    (args) async => await TransientWithAsyncFactory.create(),
    interfaces: {TransientService},
    name: null,
    key: null,
    environment: null,
  );

  await ServiceLocator.I.registerTransient<TransientWithMultipleConstructors>(
    (args) async => TransientWithMultipleConstructors(
      await ServiceLocator.I.resolve(
        args: args,
      ),
    ),
    interfaces: {TransientService},
    name: null,
    key: null,
    environment: null,
  );

  await ServiceLocator.I.registerTransient<TransientWithMultipleFactories>(
    (args) async => TransientWithMultipleFactories(
      await ServiceLocator.I.resolve(
        args: args,
      ),
    ),
    interfaces: {TransientService},
    name: null,
    key: null,
    environment: null,
  );
}
