import 'package:analyzer/dart/element/element.dart';
import 'package:zef_di_core_generator/src/helpers/accessor_processor.dart';
import 'package:zef_di_core_generator/src/helpers/constructor_processor.dart';
import 'package:zef_di_core_generator/src/helpers/method_processor.dart';
import 'package:zef_di_core_generator/src/models/parameter.dart';

class ParameterProcessor {
  /// Get the parameters of a constructor, factory method or property accessor
  static List<Parameter> getParameters({
    ConstructorElement? constructor,
    MethodElement? method,
    PropertyAccessorElement? propertyAccessor,
  }) {
    if (method != null) {
      return MethodProcessor.getParams(method);
    } else if (propertyAccessor != null) {
      return AccessorProcessor.getParams(propertyAccessor);
    } else if (constructor != null) {
      return ConstructorProcessor.getParams(constructor);
    } else {
      throw ArgumentError(
          'No constructor, factory method or property accessor provided');
    }
  }
}
