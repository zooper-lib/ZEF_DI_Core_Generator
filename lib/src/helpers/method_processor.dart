import 'package:analyzer/dart/element/element.dart';
import 'package:source_gen/source_gen.dart';
import 'package:zef_di_core/zef_di_core.dart';

class MethodProcessor {
  static MethodElement? getAnnotatedFactoryMethod(ClassElement element) {
    for (var method in element.methods) {
      // Check if the method is annotated with @RegisterFactoryMethod
      var annotation = TypeChecker.fromRuntime(RegisterFactoryMethod).firstAnnotationOfExact(method);
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

  static List<String> getUnnamedParams(MethodElement method) {
    final unnamedParams = method.parameters.where((param) => !param.isNamed).map((param) => param.type.getDisplayString(withNullability: false)).toList();

    return unnamedParams;
  }

  static Map<String, String> getNamedParams(MethodElement method) {
    return Map.fromEntries(method.parameters.where((param) => param.isNamed).map((param) => MapEntry(param.name, param.type.getDisplayString(withNullability: false))));
  }

  static bool isAsync(MethodElement? method) {
    return method == null ? false : method.returnType.isDartAsyncFuture;
  }
}
