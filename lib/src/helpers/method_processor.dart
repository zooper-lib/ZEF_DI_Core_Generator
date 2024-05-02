import 'package:analyzer/dart/element/element.dart';
import 'package:source_gen/source_gen.dart';
import 'package:zef_di_core/zef_di_core.dart';
import 'package:zef_di_core_generator/src/helpers/annotation_processor.dart';
import 'package:zef_di_core_generator/src/models/parameter.dart';
import 'package:zef_di_core_generator/src/models/parameter_annotation_type.dart';

class MethodProcessor {
  static MethodElement? getAnnotatedFactoryMethod(ClassElement element) {
    for (var method in element.methods) {
      // Check if the method is annotated with @RegisterFactoryMethod
      var annotation = TypeChecker.fromRuntime(RegisterFactoryMethod)
          .firstAnnotationOfExact(method);
      if (annotation != null) {
        return method;
      }
    }
    // Return null if no annotated factory method is found
    return null;
  }

  static String getFactoryMethodName(MethodElement factoryMethod) {
    return factoryMethod.name;
  }

  static String? getFactoryMethodNameOrNull(MethodElement? factoryMethod) {
    return factoryMethod?.name;
  }

  static List<Parameter> getParams(MethodElement method) {
    final parameters = method.parameters;
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

  /*  static List<PositionalParameter> getPositionalParams(MethodElement method) {
    return method.parameters.where((param) => !param.isNamed).map((param) {
      return PositionalParameter(
        type: param.type.getDisplayString(withNullability: true),
      );
    }).toList();
  }

  static List<NamedParameter> getNamedParams(MethodElement method) {
    return method.parameters.where((param) => param.isNamed).map((param) {
      return NamedParameter(
        type: param.type.getDisplayString(withNullability: true),
        name: param.name,
      );
    }).toList();
  } */

  static bool isAsync(MethodElement? method) {
    return method == null ? false : method.returnType.isDartAsyncFuture;
  }

  static ParameterAnnotationType _getAnnotationType(ParameterElement param) {
    for (var annotation in param.metadata) {
      var reader = ConstantReader(annotation.computeConstantValue());
      return AnnotationProcessor.getParameterAnnotationType(reader);
    }

    return ParameterAnnotationType.injected;
  }
}
