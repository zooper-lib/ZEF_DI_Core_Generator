import 'package:analyzer/dart/element/element.dart';

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

  static List<String> getUnnamedParams(ConstructorElement constructor) {
    return constructor.parameters
        .where((param) => !param.isNamed)
        .map((param) => param.type.getDisplayString(withNullability: false))
        .toList();
  }

  static Map<String, String> getNamedParams(ConstructorElement constructor) {
    return Map.fromEntries(constructor.parameters
        .where((param) => param.isNamed)
        .map((param) => MapEntry(
            param.name, param.type.getDisplayString(withNullability: false))));
  }
}
