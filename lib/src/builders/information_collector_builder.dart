import 'dart:convert';

import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
import 'package:zef_di_abstractions_generator/src/helpers/annotation_processor.dart';
import 'package:zef_di_abstractions_generator/src/helpers/registration_data_collector.dart';
import '../helpers/module_data_collector.dart';
import '../models/registrations.dart';

class InformationCollectorBuilder implements Builder {
  @override
  Map<String, List<String>> get buildExtensions => {
        '.dart': ['.info.json']
      };

  @override
  Future<void> build(BuildStep buildStep) async {
    // Only process library elements
    if (await buildStep.resolver.isLibrary(buildStep.inputId) == false) {
      return;
    }

    final LibraryElement library = await buildStep.inputLibrary;
    final registrations = <RegistrationData>[];

    for (var element in library.topLevelElements.whereType<ClassElement>()) {
      if (AnnotationProcessor.isTypeRegistration(element)) {
        final classRegistration = RegistrationDataCollector.collect(
          element,
          buildStep,
        );

        if (classRegistration != null) {
          registrations.add(classRegistration);
        }
      } else if (AnnotationProcessor.isDependencyModule(element)) {
        final moduleRegistration = ModuleDataCollector.collect(
          element,
          buildStep,
        );

        if (moduleRegistration != null) {
          registrations.add(moduleRegistration);
        }
      }
    }

    // Serialize and write the collected registration data
    await _writeCollectedData(buildStep, registrations);
  }

  Future<void> _writeCollectedData(
      BuildStep buildStep, List<RegistrationData> registrations) async {
    if (registrations.isNotEmpty) {
      final jsonList =
          registrations.map((registration) => registration.toJson()).toList();

      final jsonString = json.encode(jsonList);

      await buildStep.writeAsString(
        buildStep.inputId.changeExtension('.info.json'),
        jsonString,
      );
    }
  }
}
