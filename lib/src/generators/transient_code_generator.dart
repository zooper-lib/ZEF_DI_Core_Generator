import 'package:zef_di_abstractions_generator/src/generators/environment_code_generator.dart';
import 'package:zef_di_abstractions_generator/src/generators/interfaces_code_generator.dart';
import 'package:zef_di_abstractions_generator/src/generators/key_code_generator.dart';
import 'package:zef_di_abstractions_generator/src/generators/name_code_generator.dart';
import 'package:zef_di_abstractions_generator/src/generators/named_args_code_generator.dart';
import 'package:zef_di_abstractions_generator/src/models/registrations.dart';

class TransientCodeGenerator {
  static String generate(TransientData transient) {
    // Initialize the dependencies resolution string for unnamed parameters
    String dependencies = _generateDependencies(
      transient,
      transient.namedArgs,
    );

    // Prepare the string for named arguments, if any
    String namedArgs = NamedArgsCodeGenerator.generate(transient);

    // Combine dependencies and named arguments, if needed
    String allArgs =
        [dependencies, namedArgs].where((arg) => arg.isNotEmpty).join(', ');

    // Format additional registration parameters
    final interfaces = InterfacesCodeGenerator.generate(transient);
    final name = NameCodeGenerator.generate(transient);
    final key = KeyCodeGenerator.generate(transient);
    final environment = EnvironmentCodeGenerator.generate(transient);

    // Construct the function call to the factory method with resolved dependencies and named arguments
    String functionCall = transient.factoryMethodName == null ||
            transient.factoryMethodName!.isEmpty
        ? '${transient.className}($allArgs)'
        : '${transient.className}.${transient.factoryMethodName}($allArgs)';

    return _generateFactoryRegistration(
      registrationTypeName: 'Transient',
      isAsyncResolution: transient.isAsyncResolution,
      className: transient.className,
      instanceCreation: functionCall,
      interfaces: interfaces,
      name: name,
      key: key,
      environment: environment,
    );
  }

  static String _generateDependencies(
      TypeRegistration typeRegistration, Map<String, String> namedArgs) {
    // TODO: Also pass environment and other parameters
    return typeRegistration.dependencies
        .map((dep) => "await ServiceLocator.I.resolve(namedArgs: namedArgs)")
        .join(', ');
  }

  static String _generateFactoryRegistration({
    required String registrationTypeName,
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
await ServiceLocator.I.register$registrationTypeName<$className>(
    (namedArgs) async => $awaitKeyword $instanceCreation,
    $interfaces,
    $name,
    $key,
    $environment,
);
    '''
        .trim();
  }
}
