import 'package:zef_di_core_generator/src/models/import_path.dart';
import 'package:zef_di_core_generator/src/models/parameter.dart';
import 'package:zef_di_core_generator/src/models/registrations/super_type_data.dart';
import 'package:zef_di_core_generator/src/models/registrations/type_registration.dart';

class TransientData extends TypeRegistration {
  final String? factoryMethodName;

  TransientData({
    required super.importPath,
    required super.className,
    required super.isConstConstructor,
    required super.isAsyncResolution,
    required super.dependencies,
    required this.factoryMethodName,
    super.interfaces,
    super.name,
    super.key,
    super.environment,
  });

  factory TransientData.fromJson(Map<String, dynamic> json) {
    final importPath = ImportPath.fromJson(json['importPath']);

    List<SuperTypeData> interfaces = (json['interfaces'] as List)
        .map((e) => SuperTypeData.fromJson(e))
        .toList();

    final dependencies = (json['dependencies'] as List)
        .map((e) => Parameter.fromJson(e))
        .toList();

    return TransientData(
      importPath: importPath,
      className: json['className'],
      isConstConstructor: json['isConstConstructor'],
      isAsyncResolution: json['isAsyncResolution'],
      dependencies: dependencies,
      factoryMethodName: json['factoryMethodName'],
      interfaces: interfaces,
      name: json['name'],
      key: json['key'],
      environment: json['environment'],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    final json = super.toJson();
    json.addAll({
      'factoryMethodName': factoryMethodName,
    });
    return json;
  }
}
