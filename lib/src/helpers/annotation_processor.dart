import 'package:analyzer/dart/element/element.dart';
import 'package:source_gen/source_gen.dart';
import 'package:zef_di_core/zef_di_core.dart';
import 'package:zef_di_core_generator/src/models/parameter_annotation_type.dart';

import '../models/annotation_attributes.dart';

class AnnotationProcessor {
  /// Check if the annotation is of type RegisterSingleton
  static bool isRegisterSingleton(ConstantReader annotation) =>
      TypeChecker.fromRuntime(RegisterSingleton)
          .isExactlyType(annotation.objectValue.type!);

  /// Check if the annotation is of type RegisterTransient
  static bool isRegisterTransient(ConstantReader annotation) =>
      TypeChecker.fromRuntime(RegisterTransient)
          .isExactlyType(annotation.objectValue.type!);

  /// Check if the annotation is of type RegisterLazy
  static bool isRegisterLazy(ConstantReader annotation) =>
      TypeChecker.fromRuntime(RegisterLazy)
          .isExactlyType(annotation.objectValue.type!);

  /// Get the ParameterAnnotationType of the annotation
  static ParameterAnnotationType getParameterAnnotationType(
      ConstantReader annotation) {
    if (isPassed(annotation)) {
      return ParameterAnnotationType.passed;
    } else if (isInjected(annotation)) {
      return ParameterAnnotationType.injected;
    } else {
      return ParameterAnnotationType.injected;
    }
  }

  /// Check if the annotation is marked with @Passed
  static bool isPassed(ConstantReader annotation) =>
      TypeChecker.fromRuntime(Passed)
          .isExactlyType(annotation.objectValue.type!);

  /// Check if the annotation is marked with @Injected
  static bool isInjected(ConstantReader annotation) =>
      TypeChecker.fromRuntime(Injected)
          .isExactlyType(annotation.objectValue.type!);

  /// Check if the Element is annotated with any of the Type Registrations
  static bool isTypeRegistration(Element element) =>
      element.metadata.any((annotation) =>
          TypeChecker.fromRuntime(RegisterSingleton)
              .isAssignableFromType(annotation.computeConstantValue()!.type!) ||
          TypeChecker.fromRuntime(RegisterTransient)
              .isAssignableFromType(annotation.computeConstantValue()!.type!) ||
          TypeChecker.fromRuntime(RegisterLazy)
              .isAssignableFromType(annotation.computeConstantValue()!.type!));

  static bool isDependencyModule(Element element) => element.metadata.any(
      (annotation) => TypeChecker.fromRuntime(DependencyModule)
          .isAssignableFromType(annotation.computeConstantValue()!.type!));

  static AnnotationAttributes getAnnotationAttributes(Element element) {
    for (var annotation in element.metadata) {
      var annotationReader = ConstantReader(annotation.computeConstantValue());
      if (AnnotationProcessor.isRegisterSingleton(annotationReader) ||
          AnnotationProcessor.isRegisterTransient(annotationReader) ||
          AnnotationProcessor.isRegisterLazy(annotationReader)) {
        final String? name = annotationReader.read('_name').isNull
            ? null
            : annotationReader.read('_name').stringValue;
        final dynamic key = annotationReader.read('_key').isNull
            ? null
            : annotationReader.read('_key').literalValue;
        final String? environment = annotationReader.read('_environment').isNull
            ? null
            : annotationReader.read('_environment').stringValue;

        return AnnotationAttributes(
            name: name, key: key, environment: environment);
      }
    }
    return AnnotationAttributes();
  }
}
