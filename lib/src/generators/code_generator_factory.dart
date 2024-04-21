import 'package:zef_di_abstractions_generator/src/generators/lazy_code_generator.dart';
import 'package:zef_di_abstractions_generator/src/generators/singleton_code_generator.dart';
import 'package:zef_di_abstractions_generator/src/generators/transient_code_generator.dart';
import 'package:zef_di_abstractions_generator/src/models/registrations.dart';

class CodeGeneratorFactory {
  static String generate(RegistrationData typeRegistration) {
    if (typeRegistration is SingletonData) {
      return SingletonCodeGenerator.generate(typeRegistration);
    } else if (typeRegistration is TransientData) {
      return TransientCodeGenerator.generate(typeRegistration);
    } else if (typeRegistration is LazyData) {
      return LazyCodeGenerator.generate(typeRegistration);
    } else {
      throw Exception('Unknown type registration');
    }
  }
}
