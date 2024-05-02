import 'package:analyzer/dart/element/element.dart';
import 'package:source_gen/source_gen.dart';
import 'package:zef_di_core_generator/src/helpers/annotation_processor.dart';
import 'package:zef_di_core_generator/src/models/parameter.dart';
import 'package:zef_di_core_generator/src/models/parameter_annotation_type.dart';

class ConstructorProcessor {
  static ConstructorElement getConstructor(ClassElement element) {
    // Attempt to find the default constructor; if not found, use the first constructor as a fallback
    return element.unnamedConstructor ?? element.constructors.first;
  }

  static String getConstructorName(ConstructorElement constructor) {
    return constructor.name;
  }

  static String? getConstructorNameOrNull(ConstructorElement? constructor) {
    return constructor?.name;
  }

  static List<Parameter> getParams(ConstructorElement constructor) {
    final parameters = constructor.parameters;
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

  static bool isConst(ConstructorElement constructor) {
    return constructor.isConst;
  }

  static ParameterAnnotationType _getAnnotationType(ParameterElement param) {
    for (var annotation in param.metadata) {
      var reader = ConstantReader(annotation.computeConstantValue());
      return AnnotationProcessor.getParameterAnnotationType(reader);
    }

    return ParameterAnnotationType.injected;
  }
}
