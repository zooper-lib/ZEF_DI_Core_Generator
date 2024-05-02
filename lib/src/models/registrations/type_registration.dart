import 'package:zef_di_core_generator/src/models/import_path.dart';
import 'package:zef_di_core_generator/src/models/parameter.dart';
import 'package:zef_di_core_generator/src/models/registrations/lazy_data.dart';
import 'package:zef_di_core_generator/src/models/registrations/registration_data.dart';
import 'package:zef_di_core_generator/src/models/registrations/singleton_data.dart';
import 'package:zef_di_core_generator/src/models/registrations/super_type_data.dart';
import 'package:zef_di_core_generator/src/models/registrations/transient_data.dart';

abstract class TypeRegistration extends RegistrationData {
  final ImportPath importPath;
  final String className;
  final bool isConstConstructor;
  final bool isAsyncResolution;
  final List<Parameter> dependencies;
  final List<SuperTypeData> interfaces;
  final String? name;
  final dynamic key;
  final String? environment;

  TypeRegistration({
    required this.importPath,
    required this.className,
    required this.isConstConstructor,
    required this.isAsyncResolution,
    required this.dependencies,
    this.interfaces = const [],
    this.name,
    this.key,
    this.environment,
  });

  factory TypeRegistration.fromJson(Map<String, dynamic> json) {
    final String type = json['type'];

    switch (type) {
      case 'SingletonData':
        return SingletonData.fromJson(json);
      case 'TransientData':
        return TransientData.fromJson(json);
      case 'LazyData':
        return LazyData.fromJson(json);
      default:
        throw ArgumentError('Unknown TypeRegistration type: $type');
    }
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'type': runtimeType.toString(),
      'importPath': importPath.toJson(),
      'className': className,
      'isConstConstructor': isConstConstructor,
      'isAsyncResolution': isAsyncResolution,
      'dependencies': dependencies.map((e) => e.toJson()).toList(),
      'interfaces': interfaces.map((e) => e.toJson()).toList(),
      'name': name,
      'key': key,
      'environment': environment,
    };
  }
}
