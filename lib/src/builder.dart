import 'package:build/build.dart';
import 'package:zef_di_core_generator/src/builders/dependency_registration_builder.dart';
import 'builders/information_collector_builder.dart';

Builder informationCollectorBuilder(BuilderOptions options) =>
    InformationCollectorBuilder();

Builder dependencyRegistrationBuilder(BuilderOptions options) =>
    DependencyRegistrationBuilder();
