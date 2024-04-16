import 'package:build/build.dart';
import 'builders/code_generator_builder.dart';
import 'builders/information_collector_builder.dart';

Builder informationCollectorBuilder(BuilderOptions options) =>
    InformationCollectorBuilder();

Builder codeGeneratorBuilder(BuilderOptions options) => CodeGeneratorBuilder();
