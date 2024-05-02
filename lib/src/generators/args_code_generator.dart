import 'package:zef_di_core_generator/src/models/parameter.dart';
import 'package:zef_di_core_generator/src/models/parameter_annotation_type.dart';
import 'package:zef_di_core_generator/src/models/registrations.dart';

class ArgsCodeGenerator {
  static String generate(TypeRegistration typeRegistration) {
    final positional = typeRegistration is TransientData
        ? _generatePositional(typeRegistration, true)
        : _generatePositional(typeRegistration, false);
    final named = typeRegistration is TransientData
        ? _generateNamed(typeRegistration, true)
        : _generateNamed(typeRegistration, false);

    if (positional.isNotEmpty && named.isNotEmpty) {
      return "$positional, $named,";
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
            ? _generateInjectedArg(dep, hasArgs)
            : _generatePassedArg(dep))
        .join(', ');
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
            ? _generateInjectedArg(dep, hasArgs)
            : _generatePassedArg(dep))
        .join(', ');
  }

  static String _generateInjectedArg(Parameter parameter, bool hasArgs) {
    if (parameter is PositionalParameter) {
      return (hasArgs)
          ? 'await ServiceLocator.I.resolve(args: args)'
          : 'await ServiceLocator.I.resolve()';
    } else if (parameter is NamedParameter) {
      return (hasArgs)
          ? '${parameter.name}: await ServiceLocator.I.resolve(args: args)'
          : '${parameter.name}: await ServiceLocator.I.resolve()';
    } else {
      throw Exception('Unknown parameter type');
    }
  }

  static String _generatePassedArg(Parameter parameter) {
    if (parameter is PositionalParameter) {
      return 'args[\'${parameter.name}\']';
    } else if (parameter is NamedParameter) {
      return '${parameter.name}: args[\'${parameter.name}\']';
    } else {
      throw Exception('Unknown parameter type');
    }
  }

  /* static String generate(TypeRegistration typeRegistration) {
    if (typeRegistration is SingletonData) {
      throw Exception('SingletonData does not support named arguments');
    } else if (typeRegistration is TransientData) {
      return typeRegistration.args
          .map((e) => "${e.name}: args['${e.name}'],")
          .join();
    } else if (typeRegistration is LazyData) {
      throw Exception('LazyData does not support named arguments');
    } else {
      throw Exception('Unknown type registration');
    }
  } */
}
