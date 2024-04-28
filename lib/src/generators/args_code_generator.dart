import 'package:zef_di_core_generator/src/models/registrations.dart';

class ArgsCodeGenerator {
  static String generate(TypeRegistration typeRegistration) {
    if (typeRegistration is SingletonData) {
      throw Exception('SingletonData does not support named arguments');
    } else if (typeRegistration is TransientData) {
      return typeRegistration.args.entries
          .map((e) => "${e.key}: args['${e.key}'],")
          .join();
    } else if (typeRegistration is LazyData) {
      throw Exception('LazyData does not support named arguments');
    } else {
      throw Exception('Unknown type registration');
    }
  }
}
