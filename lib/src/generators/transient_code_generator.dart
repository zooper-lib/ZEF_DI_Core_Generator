import 'package:zef_di_core_generator/src/generators/args_code_generator.dart';
import 'package:zef_di_core_generator/src/generators/environment_code_generator.dart';
import 'package:zef_di_core_generator/src/generators/interfaces_code_generator.dart';
import 'package:zef_di_core_generator/src/generators/key_code_generator.dart';
import 'package:zef_di_core_generator/src/generators/name_code_generator.dart';
import 'package:zef_di_core_generator/src/models/registrations.dart';

class TransientCodeGenerator {
  static String generate(TransientData transient) {
    // Initialize the dependencies resolution string for unnamed parameters
    String dependencies = _generateDependencies(
      transient,
      transient.args,
    );

    // Prepare the string for named arguments, if any
    String args = ArgsCodeGenerator.generate(transient);

    // Format additional registration parameters
    final interfaces = InterfacesCodeGenerator.generate(transient);
    final name = NameCodeGenerator.generate(transient);
    final key = KeyCodeGenerator.generate(transient);
    final environment = EnvironmentCodeGenerator.generate(transient);

    return _generateFactoryRegistration(
      registrationTypeName: 'Transient',
      dependencies: dependencies,
      args: args,
      isConstConstructor: transient.isConstConstructor,
      isAsyncResolution: transient.isAsyncResolution,
      className: transient.className,
      factoryMethodName: transient.factoryMethodName,
      interfaces: interfaces,
      name: name,
      key: key,
      environment: environment,
    );
  }

  static String _generateDependencies(
      TypeRegistration typeRegistration, Map<String, String> args) {
    // TODO: Also pass environment and other parameters
    return typeRegistration.dependencies
        .map((dep) => "await ServiceLocator.I.resolve(args: args)")
        .join(', ');
  }

  static String _generateFactoryRegistration({
    required String registrationTypeName,
    required bool isAsyncResolution,
    required String className,
    required bool isConstConstructor,
    required String? factoryMethodName,
    required String dependencies,
    required String args,
    required String interfaces,
    required String name,
    required String key,
    required String environment,
  }) {
    // Combine dependencies and named arguments, if needed
    String allArgs =
        [dependencies, args].where((arg) => arg.isNotEmpty).join(', ');

    final bool includeConst =
        (factoryMethodName == null || factoryMethodName.isEmpty) &&
            isConstConstructor;

    String functionCall =
        '${includeConst ? 'const ' : ''} $className${factoryMethodName == null || factoryMethodName.isEmpty ? '' : '.$factoryMethodName'}($allArgs)';

    final String awaitKeyword = isAsyncResolution ? 'await' : '';

    return '''
await ServiceLocator.I.register$registrationTypeName<$className>(
    (args) async => $awaitKeyword $functionCall,
    $interfaces,
    $name,
    $key,
    $environment,
);
    '''
        .trim();
  }
}
