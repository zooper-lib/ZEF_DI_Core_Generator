import 'package:build/build.dart';
import 'package:zef_di_core_generator/src/builders/dependency_registration_builder.dart';
import 'package:zef_di_core_generator/src/builders/resolve_function_builder.dart';
import 'builders/information_collector_builder.dart';

Builder informationCollectorBuilder(BuilderOptions options) =>
    InformationCollectorBuilder();

Builder resolveFunctionBuilder(BuilderOptions options) =>
    ResolveFunctionBuilder();

Builder dependencyRegistrationBuilder(BuilderOptions options) =>
    DependencyRegistrationBuilder();
