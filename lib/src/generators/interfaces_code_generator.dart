import 'package:zef_di_core_generator/src/models/registrations.dart';

class InterfacesCodeGenerator {
  static String generate(TypeRegistration typeRegistration) {
    return typeRegistration.interfaces.isNotEmpty
        ? "interfaces: {${typeRegistration.interfaces.map((i) => i.className).join(', ')}}"
        : "interfaces: null";
  }
}
