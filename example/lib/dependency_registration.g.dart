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
    () async => SingletonWithFactory.create(),
    interfaces: {SingletonService},
    name: null,
    key: null,
    environment: null,
  );

  await ServiceLocator.I.registerSingleton<SingletonWithDependencies>(
    SingletonWithDependencies(await ServiceLocator.I.resolve()),
    interfaces: {SingletonService},
    name: null,
    key: null,
    environment: null,
  );

  await ServiceLocator.I
      .registerSingletonFactory<SingletonWithFactoryWithDependencies>(
    () async => SingletonWithFactoryWithDependencies.create(
        await ServiceLocator.I.resolve()),
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
        factory: () async =>
            LazyWithDependencies(await ServiceLocator.I.resolve())),
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
    (namedArgs) async => TransientNoDependencies(),
    interfaces: {TransientService},
    name: null,
    key: null,
    environment: null,
  );

  await ServiceLocator.I.registerTransient<TransientWithFactory>(
    (namedArgs) async => TransientWithFactory.create(),
    interfaces: {TransientService},
    name: null,
    key: null,
    environment: null,
  );

  await ServiceLocator.I.registerTransient<TransientWithDependencies>(
    (namedArgs) async => TransientWithDependencies(
        await ServiceLocator.I.resolve(namedArgs: namedArgs)),
    interfaces: {TransientService},
    name: null,
    key: null,
    environment: null,
  );

  await ServiceLocator.I
      .registerTransient<TransientWithFactoryWithDependencies>(
    (namedArgs) async => TransientWithFactoryWithDependencies.create(
        await ServiceLocator.I.resolve(namedArgs: namedArgs)),
    interfaces: {TransientService},
    name: null,
    key: null,
    environment: null,
  );

  await ServiceLocator.I.registerTransient<TransientWithNamedArgs>(
    (namedArgs) async => TransientWithNamedArgs(
      someValue: namedArgs['someValue'],
    ),
    interfaces: {TransientService},
    name: null,
    key: null,
    environment: null,
  );

  await ServiceLocator.I.registerTransient<TransientWithFactoryWithNamedArgs>(
    (namedArgs) async => TransientWithFactoryWithNamedArgs.create(
      someValue: namedArgs['someValue'],
    ),
    interfaces: {TransientService},
    name: null,
    key: null,
    environment: null,
  );

  await ServiceLocator.I
      .registerTransient<TransientWithDependencyWithNamedArgs>(
    (namedArgs) async => TransientWithDependencyWithNamedArgs(
      await ServiceLocator.I.resolve(namedArgs: namedArgs),
      someValue: namedArgs['someValue'],
    ),
    interfaces: {TransientService},
    name: null,
    key: null,
    environment: null,
  );

  await ServiceLocator.I
      .registerTransient<TransientWithFactoryWithDependencyWithNamedArgs>(
    (namedArgs) async => TransientWithFactoryWithDependencyWithNamedArgs.create(
      await ServiceLocator.I.resolve(namedArgs: namedArgs),
      someValue: namedArgs['someValue'],
    ),
    interfaces: {TransientService},
    name: null,
    key: null,
    environment: null,
  );

  await ServiceLocator.I.registerTransient<TransientWithAsyncFactory>(
    (namedArgs) async => await TransientWithAsyncFactory.create(),
    interfaces: {TransientService},
    name: null,
    key: null,
    environment: null,
  );

  await ServiceLocator.I.registerTransient<TransientWithMultipleConstructors>(
    (namedArgs) async => TransientWithMultipleConstructors(
        await ServiceLocator.I.resolve(namedArgs: namedArgs)),
    interfaces: {TransientService},
    name: null,
    key: null,
    environment: null,
  );

  await ServiceLocator.I.registerTransient<TransientWithMultipleFactories>(
    (namedArgs) async => TransientWithMultipleFactories(
        await ServiceLocator.I.resolve(namedArgs: namedArgs)),
    interfaces: {TransientService},
    name: null,
    key: null,
    environment: null,
  );
}
