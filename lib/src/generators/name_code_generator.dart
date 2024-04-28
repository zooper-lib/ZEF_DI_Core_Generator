import 'package:zef_di_core_generator/src/models/registrations.dart';

class NameCodeGenerator {
  static String generate(TypeRegistration typeRegistration) {
    return typeRegistration.name != null
        ? "name: '${typeRegistration.name}'"
        : 'name: null';
  }
}
