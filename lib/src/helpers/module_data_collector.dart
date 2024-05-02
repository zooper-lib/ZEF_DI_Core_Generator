import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
import 'package:collection/collection.dart';
import 'package:source_gen/source_gen.dart';
import 'package:zef_di_core_generator/src/helpers/constructor_processor.dart';
import 'package:zef_di_core_generator/src/helpers/parameter_processor.dart';

import '../models/annotation_attributes.dart';
import '../models/import_path.dart';
import '../models/registrations.dart';
import 'annotation_processor.dart';
import 'class_hierarchy_explorer.dart';
import 'import_path_resolver.dart';

class ModuleDataCollector {
  static ModuleRegistration? collect(
      ClassElement element, BuildStep buildStep) {
    final List<TypeRegistration> registrations = [];

    if (AnnotationProcessor.isDependencyModule(element) == false) {
      return null;
    }

    for (var accessor
        in element.accessors.where((accessor) => accessor.isGetter)) {
      // Get the reader
      var reader = _getReader(accessor, buildStep);

      // If there is no reader, continue with the next accessor
      if (reader == null) {
        continue;
      }

      // Get the registration by the getter
      var registration = _collectFromAccessor(accessor, buildStep, reader);

      // If there is no registration, continue with the next accessor
      if (registration == null) {
        continue;
      }

      // Add the registration to the list
      registrations.add(registration);
    }

    for (var method in element.methods.where((method) => !method.isAbstract)) {
      // Get the reader
      var reader = _getReader(method, buildStep);

      // If there is no reader, continue with the next method
      if (reader == null) {
        continue;
      }

      // Get the registration by the method
      var registration = _collectFromMethod(method, buildStep, reader);

      // If there is no registration, continue with the next method
      if (registration == null) {
        continue;
      }

      // Add the registration to the list
      registrations.add(registration);
    }

    return ModuleRegistration(
      registrations: registrations,
    );
  }

  static ConstantReader? _getReader(Element element, BuildStep buildStep) {
    return element.metadata
        .map((m) => ConstantReader(m.computeConstantValue()))
        .firstWhereOrNull(
          (reader) =>
              AnnotationProcessor.isRegisterSingleton(reader) ||
              AnnotationProcessor.isRegisterTransient(reader) ||
              AnnotationProcessor.isRegisterLazy(reader),
        );
  }

  static TypeRegistration? _collectFromAccessor(
    PropertyAccessorElement element,
    BuildStep buildStep,
    ConstantReader reader,
  ) {
    var returnTypeElement = element.returnType.element;

    if (returnTypeElement is! ClassElement) {
      throw Exception("The return type of the element is not a class.");
    }

    final isSingleton = AnnotationProcessor.isRegisterSingleton(reader);
    final isTransient = AnnotationProcessor.isRegisterTransient(reader);
    final isLazy = AnnotationProcessor.isRegisterLazy(reader);

    // Get the super classes of the class
    final Set<SuperTypeData> superTypes =
        ClassHierarchyExplorer.explore(returnTypeElement, buildStep);

    // Get the import path of the class
    final ImportPath importPath =
        ImportPathResolver.determineImportPathForClass(
            returnTypeElement, buildStep);

    // Get the annotation attributes
    final AnnotationAttributes attributes =
        AnnotationProcessor.getAnnotationAttributes(element);

    // Get the constructor
    final ConstructorElement constructor =
        ConstructorProcessor.getConstructor(returnTypeElement);

    // Determine if the constructor is a const constructor
    final isConstConstructor = ConstructorProcessor.isConst(constructor);

    //* Since there cannot be a factory method in a getter, we can safely ignore the factory method
    //* and just use the constructor name
    final String? constructorName =
        ConstructorProcessor.getConstructorNameOrNull(constructor);

    // Get the dependencies
    final dependencies = ParameterProcessor.getParameters(
      constructor: constructor,
    );

    if (isSingleton) {
      return SingletonData(
        importPath: importPath,
        className: returnTypeElement.name,
        isConstConstructor: isConstConstructor,
        factoryMethodName: constructorName,
        isAsyncResolution: false,
        dependencies: dependencies,
        interfaces: superTypes.toList(),
        name: attributes.name,
        key: attributes.key,
        environment: attributes.environment,
      );
    } else if (isTransient) {
      return TransientData(
        importPath: importPath,
        className: returnTypeElement.name,
        isConstConstructor: isConstConstructor,
        isAsyncResolution: false,
        factoryMethodName: constructorName,
        dependencies: dependencies,
        interfaces: superTypes.toList(),
        name: attributes.name,
        key: attributes.key,
        environment: attributes.environment,
      );
    } else if (isLazy) {
      return LazyData(
        importPath: importPath,
        className: returnTypeElement.name,
        isConstConstructor: isConstConstructor,
        isAsyncResolution: false,
        returnType: returnTypeElement.name,
        factoryMethodName: constructorName,
        dependencies: dependencies,
        interfaces: superTypes.toList(),
        name: attributes.name,
        key: attributes.key,
        environment: attributes.environment,
      );
    } else {
      throw Exception("Unknown registration type.");
    }
  }

  static TypeRegistration? _collectFromMethod(
    MethodElement element,
    BuildStep buildStep,
    ConstantReader reader,
  ) {
    var returnTypeElement = element.returnType.element;
    if (returnTypeElement is! ClassElement) {
      throw Exception("The return type of the element is not a class.");
    }

    final isSingleton = AnnotationProcessor.isRegisterSingleton(reader);
    final isTransient = AnnotationProcessor.isRegisterTransient(reader);
    final isLazy = AnnotationProcessor.isRegisterLazy(reader);

    // Get the super classes of the class
    final Set<SuperTypeData> superTypes =
        ClassHierarchyExplorer.explore(returnTypeElement, buildStep);

    // Get the import path of the class
    final ImportPath importPath =
        ImportPathResolver.determineImportPathForClass(
            returnTypeElement, buildStep);

    // Get the annotation attributes
    final AnnotationAttributes attributes =
        AnnotationProcessor.getAnnotationAttributes(element);

    // Get the constructor
    final ConstructorElement constructor =
        ConstructorProcessor.getConstructor(returnTypeElement);

    //* Since there cannot be a factory method in a getter, we can safely ignore the factory method
    //* and just use the constructor name
    final String? constructorName =
        ConstructorProcessor.getConstructorNameOrNull(constructor);

    // Determine if the constructor is a const constructor
    final isConstConstructor = ConstructorProcessor.isConst(constructor);

    // Get the dependencies
    final dependencies = ParameterProcessor.getParameters(method: element);

    if (isSingleton) {
      return SingletonData(
        importPath: importPath,
        className: returnTypeElement.name,
        isConstConstructor: isConstConstructor,
        // TODO: Check this
        isAsyncResolution: false,
        factoryMethodName: constructorName,
        dependencies: dependencies,
        interfaces: superTypes.toList(),
        name: attributes.name,
        key: attributes.key,
        environment: attributes.environment,
      );
    } else if (isTransient) {
      return TransientData(
        importPath: importPath,
        className: returnTypeElement.name,
        isConstConstructor: isConstConstructor,
        // TODO: Check this
        isAsyncResolution: false,
        factoryMethodName: constructorName,
        dependencies: dependencies,
        interfaces: superTypes.toList(),
        name: attributes.name,
        key: attributes.key,
        environment: attributes.environment,
      );
    } else if (isLazy) {
      return LazyData(
        importPath: importPath,
        className: returnTypeElement.name,
        isConstConstructor: isConstConstructor,
        // TODO: Check this
        isAsyncResolution: false,
        returnType: returnTypeElement.name,
        factoryMethodName: constructorName,
        dependencies: dependencies,
        interfaces: superTypes.toList(),
        name: attributes.name,
        key: attributes.key,
        environment: attributes.environment,
      );
    } else {
      throw Exception("Unknown registration type.");
    }
  }
}
