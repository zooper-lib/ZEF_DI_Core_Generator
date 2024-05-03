import 'package:zef_di_core_generator/src/models/parameter_annotation_type.dart';

abstract class Parameter {
  final String parameterType;
  final ParameterAnnotationType annotationType;
  final String parameterName;
  final String? name;
  final dynamic key;
  final String? environment;

  Parameter({
    required this.parameterType,
    required this.annotationType,
    required this.parameterName,
    required this.name,
    required this.key,
    required this.environment,
  });

  factory Parameter.positional(
    String parameterType,
    ParameterAnnotationType annotationType,
    String parameterName,
    String? name,
    dynamic key,
    String? environment,
  ) =>
      PositionalParameter(
        parameterType: parameterType,
        annotationType: annotationType,
        parameterName: parameterName,
        name: name,
        key: key,
        environment: environment,
      );

  factory Parameter.named(
    String parameterType,
    ParameterAnnotationType annotationType,
    String parameterName,
    String? name,
    dynamic key,
    String? environment,
  ) =>
      NamedParameter(
        parameterType: parameterType,
        annotationType: annotationType,
        parameterName: parameterName,
        name: name,
        key: key,
        environment: environment,
      );

  factory Parameter.fromJson(Map<String, dynamic> json) {
    if (json.containsKey('\$type') == false) {
      throw ArgumentError('Invalid JSON object');
    }

    if (json['\$type'] == 'PositionalParameter') {
      return PositionalParameter.fromJson(json);
    } else if (json['\$type'] == 'NamedParameter') {
      return NamedParameter.fromJson(json);
    }

    throw ArgumentError('Invalid JSON object');
  }

  Map<String, dynamic> toJson();
}

class PositionalParameter extends Parameter {
  PositionalParameter({
    required super.parameterType,
    required super.annotationType,
    required super.parameterName,
    required super.key,
    required super.environment,
    required super.name,
  });

  factory PositionalParameter.fromJson(Map<String, dynamic> json) {
    return PositionalParameter(
      parameterType: json['parameterType'],
      annotationType: ParameterAnnotationType.values[json['annotationType']],
      parameterName: json['parameterName'],
      name: json['name'],
      key: json['key'],
      environment: json['environment'],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      '\$type': 'PositionalParameter',
      'parameterType': parameterType,
      'annotationType': annotationType.index,
      'parameterName': parameterName,
      'name': name,
      'key': key,
      'environment': environment,
    };
  }
}

class NamedParameter extends Parameter {
  NamedParameter({
    required super.parameterType,
    required super.annotationType,
    required super.parameterName,
    required super.name,
    required super.key,
    required super.environment,
  });

  factory NamedParameter.fromJson(Map<String, dynamic> json) {
    return NamedParameter(
      parameterType: json['parameterType'],
      annotationType: ParameterAnnotationType.values[json['annotationType']],
      parameterName: json['parameterName'],
      name: json['name'],
      key: json['key'],
      environment: json['environment'],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      '\$type': 'NamedParameter',
      'parameterType': parameterType,
      'parameterName': parameterName,
      'annotationType': annotationType.index,
      'name': name,
      'key': key,
      'environment': environment,
    };
  }
}
