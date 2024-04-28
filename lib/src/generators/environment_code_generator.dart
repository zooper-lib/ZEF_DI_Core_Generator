import 'package:zef_di_core_generator/src/models/registrations.dart';

class EnvironmentCodeGenerator {
  static String generate(TypeRegistration typeRegistration) {
    return typeRegistration.environment != null
        ? "environment: '${typeRegistration.environment}'"
        : 'environment: null';
  }
}
