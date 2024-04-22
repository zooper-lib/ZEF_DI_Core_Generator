import 'package:zef_di_abstractions_generator/src/models/import_path.dart';

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

class ModuleRegistration extends RegistrationData {
  final List<TypeRegistration> registrations;

  ModuleRegistration({
    required this.registrations,
  });

  @override
  Map<String, dynamic> toJson() {
    return {
      'registrations': registrations.map((e) => e.toJson()).toList(),
    };
  }

  factory ModuleRegistration.fromJson(Map<String, dynamic> json) {
    List<TypeRegistration> registrations =
        (json['registrations'] as List<dynamic>? ?? [])
            .map((e) => TypeRegistration.fromJson(e as Map<String, dynamic>))
            .toList();

    return ModuleRegistration(
      registrations: registrations,
    );
  }

  @override
  String toString() {
    return 'ModuleRegistration{registrations: $registrations}';
  }
}

abstract class TypeRegistration extends RegistrationData {
  final ImportPath importPath;
  final String className;
  final bool isConstConstructor;
  final bool isAsyncResolution;
  final List<String> dependencies;
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

  @override
  Map<String, dynamic> toJson() {
    return {
      'importPath': importPath.toJson(),
      'className': className,
      'isConstConstructor': isConstConstructor,
      'isAsyncResolution': isAsyncResolution,
      'dependencies': dependencies,
      'interfaces': interfaces,
      'name': name,
      'key': key,
      'environment': environment,
    };
  }

  factory TypeRegistration.fromJson(Map<String, dynamic> json) {
    final String type = json['type'];

    switch (type) {
      case 'singleton':
        return SingletonData.fromJson(json);
      case 'transient':
        return TransientData.fromJson(json);
      case 'lazy':
        return LazyData.fromJson(json);
      default:
        throw ArgumentError('Unknown TypeRegistration type: $type');
    }
  }

  bool isInstance() => this is SingletonData;
}

class SuperTypeData {
  final ImportPath importPath;
  final String className;

  SuperTypeData({
    required this.importPath,
    required this.className,
  });

  Map<String, dynamic> toJson() {
    return {
      'importPath': importPath.toJson(),
      'className': className,
    };
  }

  factory SuperTypeData.fromJson(Map<String, dynamic> json) {
    return SuperTypeData(
      importPath: ImportPath.fromJson(json['importPath']),
      className: json['className'],
    );
  }

  @override
  String toString() {
    return 'SuperTypeData{importPath: $importPath, className: $className}';
  }
}

class SingletonData extends TypeRegistration {
  final String? factoryMethodName;
  final Map<String, String> namedArgs;

  SingletonData({
    required super.importPath,
    required super.className,
    required super.isConstConstructor,
    required super.isAsyncResolution,
    required super.dependencies,
    required this.factoryMethodName,
    required this.namedArgs,
    required super.interfaces,
    required super.name,
    required super.key,
    required super.environment,
  });

  factory SingletonData.fromJson(Map<String, dynamic> json) {
    List<SuperTypeData> interfaces =
        (json['interfaces'] as List<dynamic>? ?? [])
            .map((e) => SuperTypeData.fromJson(e as Map<String, dynamic>))
            .toList();

    return SingletonData(
      importPath: ImportPath.fromJson(json['importPath']),
      className: json['className'],
      isConstConstructor: json['isConstConstructor'],
      isAsyncResolution: json['isAsyncResolution'],
      interfaces: interfaces,
      name: json['name'],
      key: json['key'],
      environment: json['environment'],
      dependencies: List<String>.from(json['dependencies'] ?? []),
      factoryMethodName: json['factoryMethodName'],
      namedArgs: Map<String, String>.from(json['namedArgs'] ?? {}),
    );
  }

  @override
  Map<String, dynamic> toJson() {
    final json = super.toJson();
    json.addAll({
      'type': 'singleton',
      'factoryMethodName': factoryMethodName,
      'namedArgs': namedArgs,
    });
    return json;
  }

  @override
  String toString() {
    return '$SingletonData{importPath: $importPath, className: $className, interfaces: $interfaces, name: $name, key: $key, environment: $environment}';
  }
}

class TransientData extends TypeRegistration {
  final String? factoryMethodName;
  final Map<String, String> namedArgs;

  TransientData({
    required super.importPath,
    required super.className,
    required super.isConstConstructor,
    required super.isAsyncResolution,
    required super.dependencies,
    required this.factoryMethodName,
    required this.namedArgs,
    super.interfaces,
    super.name,
    super.key,
    super.environment,
  });

  @override
  Map<String, dynamic> toJson() {
    final json = super.toJson();
    json.addAll({
      'type': 'transient',
      'factoryMethod': factoryMethodName,
      'namedArgs': namedArgs,
    });
    return json;
  }

  factory TransientData.fromJson(Map<String, dynamic> json) {
    List<SuperTypeData> interfaces =
        (json['interfaces'] as List<dynamic>? ?? [])
            .map((e) => SuperTypeData.fromJson(e as Map<String, dynamic>))
            .toList();

    return TransientData(
      importPath: ImportPath.fromJson(json['importPath']),
      className: json['className'],
      isConstConstructor: json['isConstConstructor'],
      isAsyncResolution: json['isAsyncResolution'],
      dependencies: List<String>.from(json['dependencies'] ?? []),
      factoryMethodName: json['factoryMethod'],
      namedArgs: Map<String, String>.from(json['namedArgs'] ?? {}),
      interfaces: interfaces,
      name: json['name'],
      key: json['key'],
      environment: json['environment'],
    );
  }

  @override
  String toString() {
    return '$TransientData{importPath: $importPath, className: $className, dependencies: $dependencies, factoryMethod: $factoryMethodName, namedArgs: $namedArgs, interfaces: $interfaces, name: $name, key: $key, environment: $environment}';
  }
}

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
    required super.interfaces,
    required super.name,
    required super.key,
    required super.environment,
  });

  @override
  Map<String, dynamic> toJson() {
    final json = super.toJson();
    json.addAll({
      'type': 'lazy',
      'returnType': returnType,
      'factoryMethod': factoryMethodName,
    });
    return json;
  }

  factory LazyData.fromJson(Map<String, dynamic> json) {
    List<SuperTypeData> interfaces =
        (json['interfaces'] as List<dynamic>? ?? [])
            .map((e) => SuperTypeData.fromJson(e as Map<String, dynamic>))
            .toList();

    return LazyData(
      importPath: ImportPath.fromJson(json['importPath']),
      className: json['className'],
      isConstConstructor: json['isConstConstructor'],
      isAsyncResolution: json['isAsyncResolution'],
      returnType: json['returnType'] as String,
      factoryMethodName: json['factoryMethod'],
      dependencies: List<String>.from(json['dependencies']),
      interfaces: interfaces,
      name: json['name'],
      key: json['key'],
      environment: json['environment'],
    );
  }

  @override
  String toString() {
    return 'LazyData{importPath: $importPath, className: $className, returnType: $returnType, factoryMethodName: $factoryMethodName, dependencies: $dependencies, interfaces: $interfaces, name: $name, key: $key, environment: $environment}';
  }
}
