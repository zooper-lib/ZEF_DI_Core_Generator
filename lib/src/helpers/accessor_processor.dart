import 'package:analyzer/dart/element/element.dart';

class AccessorProcessor {
  static List<String> getUnnamedParams(
      PropertyAccessorElement propertyAccessor) {
    if (propertyAccessor.returnType.element! is ClassElement) {
      throw Exception(
          "$PropertyAccessorElement return type is not a $ClassElement");
    }

    final unnamedParams = propertyAccessor.parameters
        .where((param) => !param.isNamed)
        .map((param) => param.type.getDisplayString(withNullability: false))
        .toList();

    return unnamedParams;
  }

  static Map<String, String> getNamedParams(
      PropertyAccessorElement propertyAccessor) {
    if (propertyAccessor.returnType.element! is ClassElement) {
      throw Exception(
          "$PropertyAccessorElement return type is not a $ClassElement");
    }

    return Map.fromEntries(propertyAccessor.parameters
        .where((param) => param.isNamed)
        .map((param) => MapEntry(
            param.name, param.type.getDisplayString(withNullability: false))));
  }
}
