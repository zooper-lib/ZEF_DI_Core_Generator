import 'package:zef_di_core_generator/src/models/registrations/registration_data.dart';
import 'package:zef_di_core_generator/src/models/registrations/type_registration.dart';

class ModuleRegistration extends RegistrationData {
  final List<TypeRegistration> registrations;

  ModuleRegistration({
    required this.registrations,
  });

  factory ModuleRegistration.fromJson(Map<String, dynamic> json) =>
      ModuleRegistration(
        registrations: (json['registrations'] as List)
            .map((e) => TypeRegistration.fromJson(e))
            .toList(),
      );

  @override
  Map<String, dynamic> toJson() => {
        'registrations': registrations.map((e) => e.toJson()).toList(),
      };
}
