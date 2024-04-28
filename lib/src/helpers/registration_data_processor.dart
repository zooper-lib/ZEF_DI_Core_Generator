import 'dart:convert';

import 'package:build/build.dart';
import 'package:glob/glob.dart';

import '../models/registrations.dart';
import 'sort_helper.dart';

class RegistrationDataProcessor {
  static Future<List<TypeRegistration>> readTypeRegistration(
      BuildStep buildStep) async {
    final registrationDataList = <RegistrationData>[];
    await for (final inputId in buildStep.findAssets(Glob('**/*.info.json'))) {
      final content = await buildStep.readAsString(inputId);
      final jsonData = json.decode(content) as List<dynamic>;

      for (var jsonItem in jsonData) {
        final data = Map<String, dynamic>.from(jsonItem);
        final registration = RegistrationData.fromJson(data);
        registrationDataList.add(registration);
      }
    }

    final registrations = getAllTypeRegistrations(registrationDataList);

    return SortHelper.topologicallySortTypeRegistrations(registrations);
  }

  static List<TypeRegistration> getAllTypeRegistrations(
      List<RegistrationData> registrationDataList) {
    final registrations = <TypeRegistration>[];
    for (var registrationData in registrationDataList) {
      // If the registration data is a TypeRegistration, add it to the list
      if (registrationData is TypeRegistration) {
        registrations.add(registrationData);
      }

      // If the registration data is a ModuleRegistration, add all its registrations to the list
      if (registrationData is ModuleRegistration) {
        registrations.addAll(registrationData.registrations);
      }
    }
    return registrations;
  }
}
