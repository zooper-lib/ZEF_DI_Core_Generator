import 'package:zef_di_core_generator/src/models/parameter_annotation_type.dart';

abstract class Parameter {
  final String parameterType;
  final ParameterAnnotationType annotationType;

  Parameter({
    required this.parameterType,
    required this.annotationType,
  });

  factory Parameter.positional(
    String parameterType,
    ParameterAnnotationType annotationType,
    String name,
  ) =>
      PositionalParameter(
        parameterType: parameterType,
        annotationType: annotationType,
        name: name,
      );

  factory Parameter.named(
    String parameterType,
    ParameterAnnotationType annotationType,
    String name,
  ) =>
      NamedParameter(
        parameterType: parameterType,
        annotationType: annotationType,
        name: name,
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
  final String name;

  PositionalParameter({
    required super.parameterType,
    required super.annotationType,
    required this.name,
  });

  factory PositionalParameter.fromJson(Map<String, dynamic> json) {
    return PositionalParameter(
      parameterType: json['parameterType'],
      annotationType: ParameterAnnotationType.values[json['annotationType']],
      name: json['name'],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      '\$type': 'PositionalParameter',
      'parameterType': parameterType,
      'annotationType': annotationType.index,
      'name': name,
    };
  }
}

class NamedParameter extends Parameter {
  final String name;

  NamedParameter({
    required super.parameterType,
    required super.annotationType,
    required this.name,
  });

  factory NamedParameter.fromJson(Map<String, dynamic> json) {
    return NamedParameter(
      parameterType: json['parameterType'],
      annotationType: ParameterAnnotationType.values[json['annotationType']],
      name: json['name'],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      '\$type': 'NamedParameter',
      'parameterType': parameterType,
      'name': name,
      'annotationType': annotationType.index,
    };
  }
}
