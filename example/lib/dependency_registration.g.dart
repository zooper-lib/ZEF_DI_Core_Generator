// GENERATED CODE - DO NOT MODIFY BY HAND
// ******************************************************************************

// ignore_for_file: implementation_imports, depend_on_referenced_packages, unused_import

import 'package:example/test_files/singleton_services.dart';
import 'package:example/test_files/module_services.dart';
import 'package:example/test_files/lazy_services.dart';
import 'package:example/test_files/transient_services.dart';
import 'package:zef_di_core/zef_di_core.dart';
import 'package:zef_helpers_lazy/zef_helpers_lazy.dart';

Future<void> registerDependencies() async {
  ServiceLocator.I.registerSingletonSync<SingletonNoDependencies>(
    SingletonNoDependencies(),
    interfaces: {SingletonService},
    name: null,
    key: null,
    environment: null,
  );

  ServiceLocator.I.registerSingletonFactorySync<SingletonWithFactory>(
    (serviceLocator) => SingletonWithFactory.create(),
    interfaces: {SingletonService},
    name: null,
    key: null,
    environment: null,
  );

  ServiceLocator.I.registerSingletonSync<SingletonWithDependencies>(
    SingletonWithDependencies(
      ServiceLocator.I.resolveSync(),
    ),
    interfaces: {SingletonService},
    name: null,
    key: null,
    environment: null,
  );

  ServiceLocator.I
      .registerSingletonFactorySync<SingletonWithFactoryWithDependencies>(
    (serviceLocator) => SingletonWithFactoryWithDependencies.create(
      ServiceLocator.I.resolveSync(),
    ),
    interfaces: {SingletonService},
    name: null,
    key: null,
    environment: null,
  );

  ServiceLocator.I.registerSingletonSync<ModuleNoDependencies>(
    ModuleNoDependencies(),
    interfaces: {SingletonService},
    name: null,
    key: null,
    environment: null,
  );

  ServiceLocator.I.registerSingletonFactorySync<ModuleWithFactory>(
    (serviceLocator) => ModuleWithFactory.create(),
    interfaces: null,
    name: null,
    key: null,
    environment: null,
  );

  ServiceLocator.I.registerLazySync<LazyNoDependencies>(
    Lazy<LazyNoDependencies>(factory: () => LazyNoDependencies()),
    interfaces: {LazyServices},
    name: null,
    key: null,
    environment: null,
  );

  ServiceLocator.I.registerLazySync<LazyWithFactoryNoDependencies>(
    Lazy<LazyWithFactoryNoDependencies>(
        factory: () => LazyWithFactoryNoDependencies.create()),
    interfaces: {LazyServices},
    name: null,
    key: null,
    environment: null,
  );

  ServiceLocator.I.registerLazySync<LazyWithDependencies>(
    Lazy<LazyWithDependencies>(
        factory: () => LazyWithDependencies(
              ServiceLocator.I.resolveSync(),
            )),
    interfaces: {LazyServices},
    name: null,
    key: null,
    environment: null,
  );

  ServiceLocator.I.registerLazySync<LazyWithFactoryWithDependencies>(
    Lazy<LazyWithFactoryWithDependencies>(
        factory: () => LazyWithFactoryWithDependencies.create()),
    interfaces: {LazyServices},
    name: null,
    key: null,
    environment: null,
  );

  ServiceLocator.I.registerTransientSync<TransientNoDependencies>(
    (serviceLocator, namedArgs) => TransientNoDependencies(),
    interfaces: {TransientService},
    name: null,
    key: null,
    environment: null,
  );

  ServiceLocator.I.registerTransientSync<TransientWithFactory>(
    (serviceLocator, namedArgs) => TransientWithFactory.create(),
    interfaces: {TransientService},
    name: null,
    key: null,
    environment: null,
  );

  ServiceLocator.I.registerTransientSync<TransientWithDependencies>(
    (serviceLocator, namedArgs) => TransientWithDependencies(
        serviceLocator.resolveSync(namedArgs: namedArgs)),
    interfaces: {TransientService},
    name: null,
    key: null,
    environment: null,
  );

  ServiceLocator.I.registerTransientSync<TransientWithFactoryWithDependencies>(
    (serviceLocator, namedArgs) => TransientWithFactoryWithDependencies.create(
        serviceLocator.resolveSync(namedArgs: namedArgs)),
    interfaces: {TransientService},
    name: null,
    key: null,
    environment: null,
  );

  ServiceLocator.I.registerTransientSync<TransientWithNamedArgs>(
    (serviceLocator, namedArgs) => TransientWithNamedArgs(
      someValue: namedArgs['someValue'] as double,
    ),
    interfaces: {TransientService},
    name: null,
    key: null,
    environment: null,
  );

  ServiceLocator.I.registerTransientSync<TransientWithFactoryWithNamedArgs>(
    (serviceLocator, namedArgs) => TransientWithFactoryWithNamedArgs.create(
      someValue: namedArgs['someValue'] as double,
    ),
    interfaces: {TransientService},
    name: null,
    key: null,
    environment: null,
  );

  ServiceLocator.I.registerTransientSync<TransientWithDependencyWithNamedArgs>(
    (serviceLocator, namedArgs) => TransientWithDependencyWithNamedArgs(
      serviceLocator.resolveSync(namedArgs: namedArgs),
      someValue: namedArgs['someValue'] as double,
    ),
    interfaces: {TransientService},
    name: null,
    key: null,
    environment: null,
  );

  ServiceLocator.I
      .registerTransientSync<TransientWithFactoryWithDependencyWithNamedArgs>(
    (serviceLocator, namedArgs) =>
        TransientWithFactoryWithDependencyWithNamedArgs.create(
      serviceLocator.resolveSync(namedArgs: namedArgs),
      someValue: namedArgs['someValue'] as double,
    ),
    interfaces: {TransientService},
    name: null,
    key: null,
    environment: null,
  );

  ServiceLocator.I.registerTransientSync<ModuleWithNamedArgs>(
    (serviceLocator, namedArgs) => ModuleWithNamedArgs(
      someValue: namedArgs['someValue'] as double,
    ),
    interfaces: null,
    name: null,
    key: null,
    environment: null,
  );

  ServiceLocator.I.registerTransientSync<ModuleWithDependency>(
    (serviceLocator, namedArgs) =>
        ModuleWithDependency(serviceLocator.resolveSync(namedArgs: namedArgs)),
    interfaces: null,
    name: null,
    key: null,
    environment: null,
  );

  ServiceLocator.I.registerLazySync<ModuleWithFactoryWithDependencies>(
    Lazy<ModuleWithFactoryWithDependencies>(
        factory: () => ModuleWithFactoryWithDependencies.create(
              ServiceLocator.I.resolveSync(),
              ServiceLocator.I.resolveSync(),
            )),
    interfaces: null,
    name: null,
    key: null,
    environment: null,
  );
}
