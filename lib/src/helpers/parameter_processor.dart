import 'package:analyzer/dart/element/element.dart';
import 'package:zef_di_abstractions_generator/src/helpers/accessor_processor.dart';
import 'package:zef_di_abstractions_generator/src/helpers/constructor_processor.dart';
import 'package:zef_di_abstractions_generator/src/helpers/method_processor.dart';

class ParameterProcessor {
  static List<String> getUnnamedParameters({
    ConstructorElement? constructor,
    MethodElement? method,
    PropertyAccessorElement? propertyAccessor,
  }) {
    if (method != null) {
      return MethodProcessor.getUnnamedParams(method);
    } else if (propertyAccessor != null) {
      return AccessorProcessor.getUnnamedParams(propertyAccessor);
    } else if (constructor != null) {
      return ConstructorProcessor.getUnnamedParams(constructor);
    } else {
      throw ArgumentError(
          'No constructor, factory method or property accessor provided');
    }
  }

  static Map<String, String> getNamedParameters({
    ConstructorElement? constructor,
    MethodElement? method,
    PropertyAccessorElement? propertyAccessor,
  }) {
    if (method != null) {
      return MethodProcessor.getNamedParams(method);
    } else if (propertyAccessor != null) {
      return AccessorProcessor.getNamedParams(propertyAccessor);
    } else if (constructor != null) {
      return ConstructorProcessor.getNamedParams(constructor);
    } else {
      throw ArgumentError(
          'No constructor, factory method or property accessor provided');
    }
  }
}
