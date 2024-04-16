import '../models/registrations.dart';

class CodeGenerationHelper {
  static String generateSingletonRegistration(SingletonData instance) {
    // Check if a factory method is provided for singleton creation
    if (instance.factoryMethodName != null &&
        instance.factoryMethodName!.isNotEmpty) {
      return generateSingletonRegistrationWithFunction(instance);
    } else {
      return generateSingletonRegistrationWithInstance(instance);
    }
  }

  static String generateSingletonRegistrationWithInstance(
      SingletonData instance) {
    String instanceCreation;

    // Instantiate the class directly, potentially with resolved dependencies
    String dependenciesResolution = _generateStaticDependencies(
      instance,
      instance.isAsyncResolution,
    );

    instanceCreation = '${instance.className}($dependenciesResolution)';

    // Format additional registration parameters
    final interfaces = _getInterfaces(instance);
    final name = _getName(instance);
    final key = _getKey(instance);
    final environment = _getEnvironment(instance);

    // Construct the registration code for the singleton
    return _generateSingletonRegistration(
      instance.isAsyncResolution,
      instance.className,
      instanceCreation,
      interfaces,
      name,
      key,
      environment,
    );
  }

  static String generateSingletonRegistrationWithFunction(
      SingletonData instance) {
    // Ensure a factory method name is provided
    if (instance.factoryMethodName == null ||
        instance.factoryMethodName!.isEmpty) {
      throw Exception(
          'Factory method name must be provided for singleton function registration.');
    }

    // Resolve dependencies for the factory method
    final dependencies = _generateStaticDependencies(
      instance,
      instance.isAsyncResolution,
    );

    // Resolve named arguments for the factory method
    final namedArgs = _getNamedArgs(instance);

    // Construct the function call to the factory method with resolved dependencies and named arguments
    String functionCall =
        '${instance.className}.${instance.factoryMethodName!}($dependencies${namedArgs.isNotEmpty ? ', ' : ''}$namedArgs)';

    // Format additional registration parameters
    final interfaces = _getInterfaces(instance);
    final name = _getName(instance);
    final key = _getKey(instance);
    final environment = _getEnvironment(instance);

    // Construct the registration code using a factory function
    return _generateSingletonFunctionRegistration(
      instance.isAsyncResolution,
      instance.className,
      functionCall,
      interfaces,
      name,
      key,
      environment,
    );
  }

  static String generateTransientRegistration(TransientData factory) {
    final interfaces = factory.interfaces.isNotEmpty
        ? "interfaces: {${factory.interfaces.map((i) => i.className).join(', ')}}"
        : "interfaces: null";

    final name =
        factory.name != null ? "name: '${factory.name}'" : 'name: null';

    final key = factory.key != null ? "key: ${factory.key}" : 'key: null';

    final environment = factory.environment != null
        ? "environment: '${factory.environment}'"
        : 'environment: null';

    // Initialize the dependencies resolution string for unnamed parameters
    /* String dependencies = factory.dependencies
        .map((dep) => "serviceLocator.resolve(namedArgs: namedArgs)")
        .join(', '); */
    String dependencies = factory.dependencies
        .map((dep) => _generateMethodDependencies(
            factory, factory.isAsyncResolution, true))
        .join(', ');

    // Prepare the string for named arguments, if any
    String namedArgs = factory.namedArgs.entries
        .map((e) => "${e.key}: namedArgs['${e.key}'] as ${e.value},")
        .join();

    // Combine dependencies and named arguments, if needed
    String allArgs =
        [dependencies, namedArgs].where((arg) => arg.isNotEmpty).join(', ');

    return _generateTransientRegistration(
      factory.isAsyncResolution,
      factory.className,
      factory.factoryMethodName,
      allArgs,
      interfaces,
      name,
      key,
      environment,
    );
  }

  static String generateLazyRegistration(LazyData lazyData) {
    // Resolve dependencies for the constructor parameters
    final dependencies = _generateStaticDependencies(
      lazyData,
      lazyData.isAsyncResolution,
    );

    final interfaces = _getInterfaces(lazyData);
    final name = _getName(lazyData);
    final key = _getKey(lazyData);
    final environment = _getEnvironment(lazyData);

    return _generateLazyRegistration(
      lazyData.className,
      lazyData.isAsyncResolution,
      lazyData.factoryMethodName,
      dependencies,
      interfaces,
      name,
      key,
      environment,
    );
  }

  static String _generateStaticDependencies(
      TypeRegistration typeRegistration, bool resolveAsync) {
    return resolveAsync
        ? typeRegistration.dependencies
            .map((dep) => "await ServiceLocator.I.resolve(),")
            .join()
        : typeRegistration.dependencies
            .map((dep) => "ServiceLocator.I.resolveSync(),")
            .join();
  }

  static String _generateMethodDependencies(TypeRegistration typeRegistration,
      bool resolveAsync, bool includeNamedArgs) {
    String namedArgsPart = includeNamedArgs ? 'namedArgs: namedArgs' : '';

    return resolveAsync
        ? typeRegistration.dependencies
            .map((dep) => "await serviceLocator.resolve($namedArgsPart)")
            .join()
        : typeRegistration.dependencies
            .map((dep) => "serviceLocator.resolveSync($namedArgsPart)")
            .join();
  }

  static String _getNamedArgs(TypeRegistration typeRegistration) {
    if (typeRegistration is SingletonData) {
      return typeRegistration.namedArgs.entries
          .map((e) => "${e.key}: namedArgs['${e.key}'],")
          .join();
    } else if (typeRegistration is TransientData) {
      return typeRegistration.namedArgs.entries
          .map((e) => "${e.key}: namedArgs['${e.key}'] as ${e.value},")
          .join();
    } else {
      throw Exception('Unknown type registration');
    }
  }

  static String _getInterfaces(TypeRegistration typeRegistration) {
    return typeRegistration.interfaces.isNotEmpty
        ? "interfaces: {${typeRegistration.interfaces.map((i) => i.className).join(', ')}}"
        : "interfaces: null";
  }

  static String _getName(TypeRegistration typeRegistration) {
    return typeRegistration.name != null
        ? "name: '${typeRegistration.name}'"
        : 'name: null';
  }

  static String _getKey(TypeRegistration typeRegistration) {
    return typeRegistration.key != null
        ? "key: ${typeRegistration.key}"
        : 'key: null';
  }

  static String _getEnvironment(TypeRegistration typeRegistration) {
    return typeRegistration.environment != null
        ? "environment: '${typeRegistration.environment}'"
        : 'environment: null';
  }

  static String _generateSingletonRegistration(
    bool isAsyncResolution,
    String className,
    String instanceCreation,
    String interfaces,
    String name,
    String key,
    String environment,
  ) {
    if (isAsyncResolution) {
      return '''
      await ServiceLocator.I.registerSingleton<$className>(
          (serviceLocator) async => await $instanceCreation,
          $interfaces,
          $name,
          $key,
          $environment,
      );
      '''
          .trim();
    }

    return '''
    ServiceLocator.I.registerSingletonSync<$className>(
        $instanceCreation,
        $interfaces,
        $name,
        $key,
        $environment,
    );
    '''
        .trim();
  }

  static String _generateSingletonFunctionRegistration(
    bool isAsyncResolution,
    String className,
    String functionCall,
    String interfaces,
    String name,
    String key,
    String environment,
  ) {
    if (isAsyncResolution) {
      return '''
      await ServiceLocator.I.registerSingletonFactory<$className>(
          (serviceLocator) async => await $functionCall,
          $interfaces,
          $name,
          $key,
          $environment,
      );
      '''
          .trim();
    }

    return '''
    ServiceLocator.I.registerSingletonFactorySync<$className>(
        (serviceLocator) => $functionCall,
        $interfaces,
        $name,
        $key,
        $environment,
    );
    '''
        .trim();
  }

  static String _generateTransientRegistration(
    bool isAsyncResolution,
    String className,
    String? factoryMethod,
    String allArgs,
    String interfaces,
    String name,
    String key,
    String environment,
  ) {
    bool hasFactoryMethod = factoryMethod != null && factoryMethod.isNotEmpty;

    if (isAsyncResolution) {
      if (hasFactoryMethod) {
        return _generateAsyncFactoryTransientRegistration(className,
            factoryMethod, allArgs, interfaces, name, key, environment);
      } else {
        return _generateAsyncTransientRegistration(
            className, allArgs, interfaces, name, key, environment);
      }
    } else {
      if (hasFactoryMethod) {
        return _generateSyncFactoryTransientRegistration(className,
            factoryMethod, allArgs, interfaces, name, key, environment);
      } else {
        return _generateSyncTransientRegistration(
            className, allArgs, interfaces, name, key, environment);
      }
    }
  }

  static String _generateAsyncFactoryTransientRegistration(
    String className,
    String factoryMethod,
    String allArgs,
    String interfaces,
    String name,
    String key,
    String environment,
  ) {
    return '''
         await ServiceLocator.I.registerTransient<$className>(
            (serviceLocator, namedArgs) async => await $className.$factoryMethod(
              $allArgs),
              $interfaces,
              $name,
              $key,
              $environment,
          );
        '''
        .trim();
  }

  static String _generateSyncFactoryTransientRegistration(
    String className,
    String factoryMethod,
    String allArgs,
    String interfaces,
    String name,
    String key,
    String environment,
  ) {
    return '''
         ServiceLocator.I.registerTransientSync<$className>(
            (serviceLocator, namedArgs) => $className.$factoryMethod(
              $allArgs),
              $interfaces,
              $name,
              $key,
              $environment,
          );
        '''
        .trim();
  }

  static String _generateAsyncTransientRegistration(
    String className,
    String allArgs,
    String interfaces,
    String name,
    String key,
    String environment,
  ) {
    return '''
         await ServiceLocator.I.registerTransient<$className>(
            (serviceLocator, namedArgs) async => await $className(
              $allArgs),
              $interfaces,
              $name,
              $key,
              $environment,
          );
        '''
        .trim();
  }

  static String _generateSyncTransientRegistration(
    String className,
    String allArgs,
    String interfaces,
    String name,
    String key,
    String environment,
  ) {
    return '''
         ServiceLocator.I.registerTransientSync<$className>(
            (serviceLocator, namedArgs) => $className(
              $allArgs),
              $interfaces,
              $name,
              $key,
              $environment,
          );
        '''
        .trim();
  }

  static String _generateLazyRegistration(
    String className,
    bool isAsyncResolution,
    String? factoryMethod,
    String dependencies,
    String interfaces,
    String name,
    String key,
    String environment,
  ) {
    bool hasFactoryMethod = factoryMethod != null && factoryMethod.isNotEmpty;

    if (isAsyncResolution) {
      if (hasFactoryMethod) {
        return _generateAsyncLazyFunctionRegistration(
            className,
            isAsyncResolution,
            factoryMethod,
            dependencies,
            interfaces,
            name,
            key,
            environment);
      } else {
        return _generateAsyncLazyRegistration(className, isAsyncResolution,
            dependencies, interfaces, name, key, environment);
      }
    } else {
      if (hasFactoryMethod) {
        return _generateSyncLazyFunctionRegistration(
            className,
            isAsyncResolution,
            factoryMethod,
            dependencies,
            interfaces,
            name,
            key,
            environment);
      } else {
        return _generateSyncLazyRegistration(className, isAsyncResolution,
            dependencies, interfaces, name, key, environment);
      }
    }
  }

  static String _generateAsyncLazyRegistration(
    String className,
    bool isAsyncResolution,
    String dependencies,
    String interfaces,
    String name,
    String key,
    String environment,
  ) {
    return '''
    await ServiceLocator.I.registerLazy<$className>(
        Lazy<$className>(factory: () async => await $className($dependencies)),
        $interfaces,
        $name,
        $key,
        $environment,
    );
    ''';
  }

  static String _generateSyncLazyRegistration(
    String className,
    bool isAsyncResolution,
    String dependencies,
    String interfaces,
    String name,
    String key,
    String environment,
  ) {
    return '''
    ServiceLocator.I.registerLazySync<$className>(
        Lazy<$className>(factory: () => $className($dependencies)),
        $interfaces,
        $name,
        $key,
        $environment,
    );
    ''';
  }

  static String _generateAsyncLazyFunctionRegistration(
    String className,
    bool isAsyncResolution,
    String factoryMethod,
    String dependencies,
    String interfaces,
    String name,
    String key,
    String environment,
  ) {
    return '''
    await ServiceLocator.I.registerLazy<$className>(
        Lazy<$className>(factory: () async => await $className.$factoryMethod($dependencies)),
        $interfaces,
        $name,
        $key,
        $environment,
    );
    ''';
  }

  static String _generateSyncLazyFunctionRegistration(
    String className,
    bool isAsyncResolution,
    String factoryMethod,
    String dependencies,
    String interfaces,
    String name,
    String key,
    String environment,
  ) {
    return '''
    ServiceLocator.I.registerLazySync<$className>(
        Lazy<$className>(factory: () => $className.$factoryMethod($dependencies)),
        $interfaces,
        $name,
        $key,
        $environment,
    );
    ''';
  }
}
