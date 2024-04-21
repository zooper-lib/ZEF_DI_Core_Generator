import 'package:zef_di_abstractions_generator/src/generators/environment_code_generator.dart';
import 'package:zef_di_abstractions_generator/src/generators/interfaces_code_generator.dart';
import 'package:zef_di_abstractions_generator/src/generators/key_code_generator.dart';
import 'package:zef_di_abstractions_generator/src/generators/name_code_generator.dart';
import 'package:zef_di_abstractions_generator/src/models/registrations.dart';

class LazyCodeGenerator {
  static String generate(LazyData lazy) {
    // Resolve dependencies for the constructor parameters
    final dependencies = _generateDependencies(
      lazy,
    );

    // Format additional registration parameters
    final interfaces = InterfacesCodeGenerator.generate(lazy);
    final name = NameCodeGenerator.generate(lazy);
    final key = KeyCodeGenerator.generate(lazy);
    final environment = EnvironmentCodeGenerator.generate(lazy);

    return _generateLazyWithFactoryRegistration(
      lazy.className,
      lazy.isAsyncResolution,
      lazy.factoryMethodName,
      dependencies,
      interfaces,
      name,
      key,
      environment,
    );
  }

  static String _generateDependencies(TypeRegistration typeRegistration) {
    // TODO: Also pass environment and other parameters
    return typeRegistration.dependencies
        .map((dep) => "await ServiceLocator.I.resolve()")
        .join(', ');
  }

  static String _generateLazyWithFactoryRegistration(
    String className,
    bool isAsyncResolution,
    String? factoryMethodName,
    String dependencies,
    String interfaces,
    String name,
    String key,
    String environment,
  ) {
    final String awaitKeyword = isAsyncResolution ? 'await' : '';
    final String factoryMethodCall =
        factoryMethodName == null ? '' : '.$factoryMethodName';

    return '''
await ServiceLocator.I.registerLazy<$className>(
    Lazy<$className>(factory: () async => $awaitKeyword $className$factoryMethodCall($dependencies)),
    $interfaces,
    $name,
    $key,
    $environment,
);
    '''
        .trim();
  }
}
