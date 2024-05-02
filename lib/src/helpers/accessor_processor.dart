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

      // Get the annotation attributes
      final attributes = AnnotationProcessor.getAnnotationAttributes(param);

      final positionalParameter = param.isPositional
          ? PositionalParameter(
              parameterType: param.type.getDisplayString(withNullability: true),
              annotationType: annotationType,
              parameterName: param.name,
              name: attributes.name,
              key: attributes.key,
              environment: attributes.environment,
            )
          : NamedParameter(
              parameterType: param.type.getDisplayString(withNullability: true),
              annotationType: annotationType,
              parameterName: param.name,
              name: attributes.name,
              key: attributes.key,
              environment: attributes.environment,
            );

      foundParameters.add(positionalParameter);
    }

    return foundParameters;
  }

  static ParameterAnnotationType _getAnnotationType(ParameterElement param) {
    for (var annotation in param.metadata) {
      var reader = ConstantReader(annotation.computeConstantValue());
      return AnnotationProcessor.getParameterAnnotationType(reader);
    }

    return ParameterAnnotationType.injected;
  }
}
