import 'package:zef_di_core_generator/src/models/registrations/module_registration.dart';
import 'package:zef_di_core_generator/src/models/registrations/type_registration.dart';

abstract class RegistrationData {
  const RegistrationData();

  Map<String, dynamic> toJson();

  factory RegistrationData.fromJson(Map<String, dynamic> json) {
    if (json.containsKey('registrations')) {
      return ModuleRegistration.fromJson(json);
    } else {
      return TypeRegistration.fromJson(json);
    }
  }
}
