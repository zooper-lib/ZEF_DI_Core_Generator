import 'package:zef_di_core_generator/src/generators/args_code_generator.dart';
import 'package:zef_di_core_generator/src/generators/environment_code_generator.dart';
import 'package:zef_di_core_generator/src/generators/interfaces_code_generator.dart';
import 'package:zef_di_core_generator/src/generators/key_code_generator.dart';
import 'package:zef_di_core_generator/src/generators/name_code_generator.dart';
import 'package:zef_di_core_generator/src/models/registrations.dart';

class SingletonCodeGenerator {
  static String generateRegisterFunction(SingletonData instance) {
    // Check if a factory method is provided for singleton creation
    if (instance.factoryMethodName != null &&
        instance.factoryMethodName!.isNotEmpty) {
      return _generateWithFactory(instance);
    } else {
      return _generateWithInstance(instance);
    }
  }

  static String _generateWithInstance(SingletonData instance) {
    // Instantiate the class directly, potentially with resolved dependencies
    String parameters = ArgsCodeGenerator.generate(
      instance,
    );

    final instanceCreation =
        '${instance.isConstConstructor ? 'const ' : ''} ${instance.className}($parameters)';

    // Format additional registration parameters
    final interfaces = InterfacesCodeGenerator.generate(instance);
    final name = NameCodeGenerator.generate(instance);
    final key = KeyCodeGenerator.generate(instance);
    final environment = EnvironmentCodeGenerator.generate(instance);

    return _generateInstanceRegistration(
        registrationTypeName: 'Singleton',
        className: instance.className,
        instanceCreation: instanceCreation,
        interfaces: interfaces,
        name: name,
        key: key,
        environment: environment);
  }

  static String _generateWithFactory(SingletonData instance) {
    // Ensure a factory method name is provided
    if (instance.factoryMethodName == null ||
        instance.factoryMethodName!.isEmpty) {
      throw Exception(
          'Factory method name must be provided for singleton function registration.');
    }

    // Resolve dependencies for the factory method
    final dependencies = ArgsCodeGenerator.generate(
      instance,
    );

    // Construct the function call to the factory method with resolved dependencies and named arguments
    String functionCall =
        '${instance.className}.${instance.factoryMethodName!}($dependencies)';

    // Format additional registration parameters
    final interfaces = InterfacesCodeGenerator.generate(instance);
    final name = NameCodeGenerator.generate(instance);
    final key = KeyCodeGenerator.generate(instance);
    final environment = EnvironmentCodeGenerator.generate(instance);

    return _generateFactoryRegistration(
      isAsyncResolution: instance.isAsyncResolution,
      className: instance.className,
      instanceCreation: functionCall,
      interfaces: interfaces,
      name: name,
      key: key,
      environment: environment,
    );
  }

  static String _generateInstanceRegistration({
    required String registrationTypeName,
    required String className,
    required String instanceCreation,
    required String interfaces,
    required String name,
    required String key,
    required String environment,
  }) {
    return '''
await ServiceLocator.I.register$registrationTypeName<$className>(
    $instanceCreation,
    $interfaces,
    $name,
    $key,
    $environment,
);
    '''
        .trim();
  }

  static String _generateFactoryRegistration({
    required bool isAsyncResolution,
    required String className,
    required String instanceCreation,
    required String interfaces,
    required String name,
    required String key,
    required String environment,
  }) {
    final String awaitKeyword = isAsyncResolution ? 'await' : '';

    return '''
await ServiceLocator.I.registerSingletonFactory<$className>(
    (Map<String, dynamic> args) async => $awaitKeyword $instanceCreation,
    $interfaces,
    $name,
    $key,
    $environment,
);
    '''
        .trim();
  }
}
