import 'package:analyzer/dart/element/element.dart';
import 'package:source_gen/source_gen.dart';
import 'package:zef_di_core/zef_di_core.dart';

import '../models/annotation_attributes.dart';

class AnnotationProcessor {
  static bool isRegisterSingleton(ConstantReader annotation) => TypeChecker.fromRuntime(RegisterSingleton).isExactlyType(annotation.objectValue.type!);

  static bool isRegisterTransient(ConstantReader annotation) => TypeChecker.fromRuntime(RegisterTransient).isExactlyType(annotation.objectValue.type!);

  static bool isRegisterLazy(ConstantReader annotation) => TypeChecker.fromRuntime(RegisterLazy).isExactlyType(annotation.objectValue.type!);

  static bool isTypeRegistration(Element element) => element.metadata.any((annotation) =>
      TypeChecker.fromRuntime(RegisterSingleton).isAssignableFromType(annotation.computeConstantValue()!.type!) ||
      TypeChecker.fromRuntime(RegisterTransient).isAssignableFromType(annotation.computeConstantValue()!.type!) ||
      TypeChecker.fromRuntime(RegisterLazy).isAssignableFromType(annotation.computeConstantValue()!.type!));

  static bool isDependencyModule(Element element) => element.metadata.any((annotation) => TypeChecker.fromRuntime(DependencyModule).isAssignableFromType(annotation.computeConstantValue()!.type!));

  static AnnotationAttributes getAnnotationAttributes(Element element) {
    for (var annotation in element.metadata) {
      var annotationReader = ConstantReader(annotation.computeConstantValue());
      if (AnnotationProcessor.isRegisterSingleton(annotationReader) || AnnotationProcessor.isRegisterTransient(annotationReader) || AnnotationProcessor.isRegisterLazy(annotationReader)) {
        final String? name = annotationReader.read('_name').isNull ? null : annotationReader.read('_name').stringValue;
        final dynamic key = annotationReader.read('_key').isNull ? null : annotationReader.read('_key').literalValue;
        final String? environment = annotationReader.read('_environment').isNull ? null : annotationReader.read('_environment').stringValue;

        return AnnotationAttributes(name: name, key: key, environment: environment);
      }
    }
    return AnnotationAttributes();
  }
}
