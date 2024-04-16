import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:build/build.dart';

import '../models/import_path.dart';
import '../models/registrations.dart';
import 'import_path_resolver.dart';

class ClassHierarchyExplorer {
  static Set<SuperTypeData> explore(
      ClassElement classElement, BuildStep buildStep) {
    return _exploreClassHierarchy(classElement, buildStep, {}, true);
  }

  static Set<SuperTypeData> _exploreClassHierarchy(
    ClassElement classElement,
    BuildStep buildStep,
    Set<SuperTypeData> visitedClasses,
    bool isInitialCall,
  ) {
    if (_isFromDartSdk(classElement.librarySource.uri)) {
      return visitedClasses;
    }

    _exploreSuperclassAndInterfaces(classElement, buildStep, visitedClasses);

    if (!isInitialCall &&
        !_alreadyVisited(classElement, visitedClasses, buildStep)) {
      visitedClasses.add(SuperTypeData(
        importPath: ImportPathResolver.determineImportPathForClass(
            classElement, buildStep),
        className: classElement.name,
      ));
    }

    return visitedClasses;
  }

  static bool _isFromDartSdk(Uri uri) => uri.scheme == 'dart';

  static void _exploreSuperclassAndInterfaces(ClassElement classElement,
      BuildStep buildStep, Set<SuperTypeData> visitedClasses) {
    // Explore the superclass
    _exploreElement(classElement.supertype?.element, buildStep, visitedClasses);

    // Explore the implemented interfaces
    for (InterfaceType interfaceType in classElement.interfaces) {
      _exploreElement(interfaceType.element, buildStep, visitedClasses);
    }
  }

  static void _exploreElement(Element? element, BuildStep buildStep,
      Set<SuperTypeData> visitedClasses) {
    if (element is ClassElement &&
        !_isFromDartSdk(element.librarySource.uri) &&
        !_alreadyVisited(element, visitedClasses, buildStep) &&
        !element.isPrivate) {
      _exploreClassHierarchy(element, buildStep, visitedClasses, false);
    }
  }

  static bool _alreadyVisited(
    ClassElement classElement,
    Set<SuperTypeData> visitedClasses,
    BuildStep buildStep,
  ) {
    final ImportPath importPath =
        ImportPathResolver.determineImportPathForClass(classElement, buildStep);
    return visitedClasses.any((element) =>
        element.className == classElement.name &&
        element.importPath.toString() == importPath.toString());
  }
}
