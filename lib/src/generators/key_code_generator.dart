import 'package:zef_di_abstractions_generator/src/models/registrations.dart';

class KeyCodeGenerator {
  static String generate(TypeRegistration typeRegistration) {
    return typeRegistration.key != null
        ? "key: ${typeRegistration.key}"
        : 'key: null';
  }
}
