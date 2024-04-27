import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';
import 'package:zef_di_abstractions_generator/src/helpers/constructor_processor.dart';
import 'package:zef_di_abstractions_generator/src/helpers/parameter_processor.dart';

import '../models/annotation_attributes.dart';
import '../models/import_path.dart';
import '../models/registrations.dart';
import 'annotation_processor.dart';
import 'class_hierarchy_explorer.dart';
import 'import_path_resolver.dart';
import 'method_processor.dart';

class RegistrationDataCollector {
  static RegistrationData? collect(ClassElement element, BuildStep buildStep) {
    for (var annotation in element.metadata) {
      var annotationReader = ConstantReader(annotation.computeConstantValue());

      if (AnnotationProcessor.isRegisterSingleton(annotationReader)) {
        return _collectSingletonData(element, buildStep);
      } else if (AnnotationProcessor.isRegisterTransient(annotationReader)) {
        return _collectTransientData(element, buildStep);
      } else if (AnnotationProcessor.isRegisterLazy(annotationReader)) {
        return _collectLazyData(element, buildStep);
      }
    }

    // As the class can be annotated with any other annotation, which is not a ZEF annotation, we return null and dont throw an error
    return null;
  }

  static SingletonData _collectSingletonData(
    ClassElement classElement,
    BuildStep buildStep,
  ) {
    // Get the import path of the class
    final ImportPath importPath =
        ImportPathResolver.determineImportPathForClass(classElement, buildStep);

    // Get the super classes of the class
    final Set<SuperTypeData> superClasses =
        ClassHierarchyExplorer.explore(classElement, buildStep);

    // Get the Constructor
    final ConstructorElement constructor =
        ConstructorProcessor.getConstructor(classElement);

    // Determine if the constructor is a const constructor
    final isConstConstructor = ConstructorProcessor.isConst(constructor);

    // Get the factory method
    final MethodElement? factoryMethod =
        MethodProcessor.getAnnotatedFactoryMethod(classElement);
    final String? factoryMethodName =
        MethodProcessor.getFactoryMethodNameOrNull(factoryMethod);

    // Determine if the factory method is async
    final bool isAsyncResolution = MethodProcessor.isAsync(factoryMethod);

    // Get the injectable dependencies
    List<String> dependencies = ParameterProcessor.getUnnamedParameters(
      constructor: constructor,
      method: factoryMethod,
    );

    // Get the named arguments
    Map<String, String> args = ParameterProcessor.getNamedParameters(
      constructor: constructor,
      method: factoryMethod,
    );

    // Check if the class has named arguments. If so, throw an error
    if (args.isNotEmpty) {
      throw InvalidGenerationSourceError(
        'Named arguments are not supported in Singleton classes',
        element: classElement,
      );
    }

    // Get the annotation attributes
    final AnnotationAttributes attributes =
        AnnotationProcessor.getAnnotationAttributes(classElement);

    return SingletonData(
      importPath: importPath,
      interfaces: superClasses.toList(),
      className: classElement.name,
      isConstConstructor: isConstConstructor,
      isAsyncResolution: isAsyncResolution,
      factoryMethodName: factoryMethodName,
      dependencies: dependencies,
      args: args,
      name: attributes.name,
      key: attributes.key,
      environment: attributes.environment,
    );
  }

  static TransientData _collectTransientData(
    ClassElement classElement,
    BuildStep buildStep,
  ) {
    // Get the import path of the class
    final ImportPath importPath =
        ImportPathResolver.determineImportPathForClass(classElement, buildStep);

    // Get the super classes of the class
    final Set<SuperTypeData> superClasses =
        ClassHierarchyExplorer.explore(classElement, buildStep);

    // Get the annotation attributes
    final AnnotationAttributes attributes =
        AnnotationProcessor.getAnnotationAttributes(classElement);

    // Get the Constructor
    final ConstructorElement constructor =
        ConstructorProcessor.getConstructor(classElement);

    // Determine if the constructor is a const constructor
    final isConstConstructor = ConstructorProcessor.isConst(constructor);

    // Get the factory method
    final MethodElement? factoryMethod =
        MethodProcessor.getAnnotatedFactoryMethod(classElement);
    final String? factoryMethodName =
        MethodProcessor.getFactoryMethodNameOrNull(factoryMethod);

    // Determine if the factory method is async
    final bool isAsyncResolution = MethodProcessor.isAsync(factoryMethod);

    List<String> dependencies = ParameterProcessor.getUnnamedParameters(
      constructor: constructor,
      method: factoryMethod,
    );
    Map<String, String> args = ParameterProcessor.getNamedParameters(
      constructor: constructor,
      method: factoryMethod,
    );

    return TransientData(
      importPath: importPath,
      interfaces: superClasses.toList(),
      className: classElement.name,
      isConstConstructor: isConstConstructor,
      isAsyncResolution: isAsyncResolution,
      dependencies: dependencies,
      factoryMethodName: factoryMethodName,
      args: args,
      name: attributes.name,
      key: attributes.key,
      environment: attributes.environment,
    );
  }

  static LazyData _collectLazyData(
      ClassElement classElement, BuildStep buildStep) {
    // Get the import path of the class
    final ImportPath importPath =
        ImportPathResolver.determineImportPathForClass(classElement, buildStep);

    // Get the super classes of the class
    final Set<SuperTypeData> superClasses =
        ClassHierarchyExplorer.explore(classElement, buildStep);

    // Get the return type of the class
    final returnType = classElement.name;

    // Get the Constructor
    final ConstructorElement constructor =
        ConstructorProcessor.getConstructor(classElement);

    // Determine if the constructor is a const constructor
    final isConstConstructor = ConstructorProcessor.isConst(constructor);

    // Get the factory method
    final MethodElement? factoryMethod =
        MethodProcessor.getAnnotatedFactoryMethod(classElement);
    final String? factoryMethodName =
        MethodProcessor.getFactoryMethodNameOrNull(factoryMethod);

    // Determine if the factory method is async
    final bool isAsyncResolution = MethodProcessor.isAsync(factoryMethod);

    // Get the injectable dependencies
    final List<String> dependencies = ParameterProcessor.getUnnamedParameters(
      constructor: constructor,
      method: factoryMethod,
    );

    // Get the annotation attributes
    final AnnotationAttributes attributes =
        AnnotationProcessor.getAnnotationAttributes(classElement);

    return LazyData(
      importPath: importPath,
      className: classElement.name,
      isConstConstructor: isConstConstructor,
      isAsyncResolution: isAsyncResolution,
      returnType: returnType,
      factoryMethodName: factoryMethodName,
      dependencies: dependencies,
      interfaces: superClasses.toList(),
      name: attributes.name,
      key: attributes.key,
      environment: attributes.environment,
    );
  }
}
