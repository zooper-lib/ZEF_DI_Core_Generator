import 'package:zef_di_core_generator/src/models/parameter.dart';
import 'package:zef_di_core_generator/src/models/parameter_annotation_type.dart';
import 'package:zef_di_core_generator/src/models/registrations.dart';

class ArgsCodeGenerator {
  /// Generates the code for the arguments
  static String generate(TypeRegistration typeRegistration, bool hasArgs) {
    final positional = _generatePositional(typeRegistration, hasArgs);
    final named = _generateNamed(typeRegistration, hasArgs);

    if (positional.isNotEmpty && named.isNotEmpty) {
      return "$positional $named";
    }

    if (positional.isNotEmpty) {
      return positional;
    }

    if (named.isNotEmpty) {
      return named;
    }

    return '';
  }

  static String _generatePositional(
    TypeRegistration typeRegistration,
    bool hasArgs,
  ) {
    final positionalParameters =
        typeRegistration.dependencies.whereType<PositionalParameter>();

    if (positionalParameters.isEmpty) {
      return '';
    }

    return positionalParameters
        .map((dep) => dep.annotationType == ParameterAnnotationType.injected
            ? _generateInjectedArg(
                dep, hasArgs, dep.name, dep.key, dep.environment)
            : _generatePassedArg(dep))
        .join();
  }

  static String _generateNamed(
    TypeRegistration typeRegistration,
    bool hasArgs,
  ) {
    final namedParameters =
        typeRegistration.dependencies.whereType<NamedParameter>();

    if (namedParameters.isEmpty) {
      return '';
    }

    return typeRegistration.dependencies
        .whereType<NamedParameter>()
        .map((dep) => dep.annotationType == ParameterAnnotationType.injected
            ? _generateInjectedArg(
                dep, hasArgs, dep.name, dep.key, dep.environment)
            : _generatePassedArg(dep))
        .join();
  }

  static String _generateInjectedArg(
    Parameter parameter,
    bool hasArgs,
    String? name,
    dynamic key,
    String? environment,
  ) {
    final argsString = hasArgs ? 'args: args,' : '';
    final nameString = name != null ? 'name: \'$name\',' : '';
    final keyString = key != null ? 'key: $key,' : '';
    final environmentString =
        environment != null ? 'environment: \'$environment\',' : '';

    if (parameter is PositionalParameter) {
      return 'await ServiceLocator.I.resolve($argsString $nameString $keyString $environmentString),';
    } else if (parameter is NamedParameter) {
      return '${parameter.parameterName}: await ServiceLocator.I.resolve($argsString $nameString $keyString $environmentString),';
    } else {
      throw Exception('Unknown parameter type');
    }
  }

  static String _generatePassedArg(Parameter parameter) {
    if (parameter is PositionalParameter) {
      return 'args[\'${parameter.parameterName}\']';
    } else if (parameter is NamedParameter) {
      return '${parameter.parameterName}: args[\'${parameter.parameterName}\']';
    } else {
      throw Exception('Unknown parameter type');
    }
  }
}
