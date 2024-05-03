import 'package:zef_di_core_generator/src/models/import_path.dart';
import 'package:zef_di_core_generator/src/models/parameter.dart';
import 'package:zef_di_core_generator/src/models/registrations/super_type_data.dart';
import 'package:zef_di_core_generator/src/models/registrations/type_registration.dart';

class LazyData extends TypeRegistration {
  final String returnType;
  final String? factoryMethodName;

  LazyData({
    required super.importPath,
    required super.className,
    required super.isConstConstructor,
    required super.isAsyncResolution,
    required this.returnType,
    required this.factoryMethodName,
    required super.dependencies,
    super.interfaces,
    super.name,
    super.key,
    super.environment,
  });

  factory LazyData.fromJson(Map<String, dynamic> json) {
    final importPath = ImportPath.fromJson(json['importPath']);

    List<SuperTypeData> interfaces = (json['interfaces'] as List)
        .map((e) => SuperTypeData.fromJson(e))
        .toList();

    final dependencies = (json['dependencies'] as List)
        .map((e) => Parameter.fromJson(e))
        .toList();

    return LazyData(
      importPath: importPath,
      className: json['className'],
      isConstConstructor: json['isConstConstructor'],
      isAsyncResolution: json['isAsyncResolution'],
      returnType: json['returnType'],
      factoryMethodName: json['factoryMethodName'],
      dependencies: dependencies,
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
      'returnType': returnType,
      'factoryMethodName': factoryMethodName,
    });
    return json;
  }
}
