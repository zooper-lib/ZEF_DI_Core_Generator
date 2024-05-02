import 'package:analyzer/dart/element/element.dart';
import 'package:source_gen/source_gen.dart';
import 'package:zef_di_core_generator/src/helpers/annotation_processor.dart';
import 'package:zef_di_core_generator/src/models/parameter.dart';
import 'package:zef_di_core_generator/src/models/parameter_annotation_type.dart';

class AccessorProcessor {
  static List<Parameter> getParams(PropertyAccessorElement propertyAccessor) {
    final parameters = propertyAccessor.parameters;
    final List<Parameter> foundParameters = [];

    for (var param in parameters) {
      // Get the annotation type of the parameter
      final annotationType = _getAnnotationType(param);

      final positionalParameter = param.isPositional
          ? PositionalParameter(
              parameterType: param.type.getDisplayString(withNullability: true),
              annotationType: annotationType,
              name: param.name,
            )
          : NamedParameter(
              parameterType: param.type.getDisplayString(withNullability: true),
              annotationType: annotationType,
              name: param.name,
            );

      foundParameters.add(positionalParameter);
    }

    return foundParameters;
  }

  /* static List<PositionalParameter> getPositionalParams(
      PropertyAccessorElement propertyAccessor) {
    if (propertyAccessor.returnType.element! is ClassElement) {
      throw Exception(
          "$PropertyAccessorElement return type is not a $ClassElement");
    }

    return propertyAccessor.parameters
        .where((param) => !param.isNamed)
        .map((param) => PositionalParameter(
              param.type.getDisplayString(withNullability: true),
            ))
        .toList();
  }

  static List<NamedParameter> getNamedParams(
      PropertyAccessorElement propertyAccessor) {
    if (propertyAccessor.returnType.element! is ClassElement) {
      throw Exception(
          "$PropertyAccessorElement return type is not a $ClassElement");
    }

    return propertyAccessor.parameters
        .where((param) => param.isNamed)
        .map((param) => NamedParameter(
              param.type.getDisplayString(withNullability: true),
              param.name,
            ))
        .toList();
  } */

  static ParameterAnnotationType _getAnnotationType(ParameterElement param) {
    for (var annotation in param.metadata) {
      var reader = ConstantReader(annotation.computeConstantValue());
      return AnnotationProcessor.getParameterAnnotationType(reader);
    }

    return ParameterAnnotationType.injected;
  }
}
