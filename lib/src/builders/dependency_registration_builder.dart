import 'dart:async';
import 'package:build/build.dart';
import 'package:zef_di_core_generator/src/generators/register_code_generator_factory.dart';
import 'package:zef_di_core_generator/src/helpers/import_path_resolver.dart';

import '../helpers/code_formatter.dart';
import '../helpers/registration_data_processor.dart';
import '../models/import_path.dart';
import '../models/import_type.dart';
import '../models/registrations.dart';

class DependencyRegistrationBuilder implements Builder {
  @override
  Map<String, List<String>> get buildExtensions => {
        r'$lib$': ['zef.di.register.g.dart']
      };

  final Set<ImportPath> _importedPackages = {
    ImportPath(
      'zef_di_core/zef_di_core.dart',
      ImportType.package,
    ),
    ImportPath(
      'zef_helpers_lazy/zef_helpers_lazy.dart',
      ImportType.package,
    ),
  };

  @override
  Future<void> build(BuildStep buildStep) async {
    final codeBuffer = StringBuffer();
    final allRegistrations =
        await RegistrationDataProcessor.readTypeRegistration(buildStep);

    _writeHeader(codeBuffer);
    _writeImports(codeBuffer, allRegistrations);
    _writeRegistrationFunctions(codeBuffer, allRegistrations);

    final formattedContent = CodeFormatter.formatCode(codeBuffer.toString());
    await _writeGeneratedFile(buildStep, formattedContent);
  }

  void _writeHeader(StringBuffer buffer) {
    buffer
      ..writeln("// GENERATED CODE - DO NOT MODIFY BY HAND")
      ..writeln(
          "// ******************************************************************************\n")
      ..writeln()
      ..writeln(
          "// ignore_for_file: implementation_imports, depend_on_referenced_packages, unused_import")
      ..writeln();
  }

  void _writeImports(
      StringBuffer buffer, List<RegistrationData> registrations) {
    final Set<ImportPath> uniqueImports = {};

    for (var registration in registrations) {
      // Collect import paths from registrations
      final importPaths =
          ImportPathResolver.getImportPathsWithInterfaces(registration);
      uniqueImports.addAll(importPaths);
    }

    // Add any default or fixed imports your system requires
    uniqueImports.addAll(_importedPackages);

    // Write the import statements
    for (var importPath in uniqueImports) {
      buffer.writeln(importPath.toString());
    }

    // Add an extra newline for separation
    buffer.writeln();
  }

  void _writeRegistrationFunctions(
    StringBuffer codeBuffer,
    List<RegistrationData> registrations,
  ) {
    // Write the function signature
    codeBuffer.writeln("Future<void> registerDependencies() async {");

    for (var registration in registrations) {
      codeBuffer.writeln(RegisterCodeGeneratorFactory.generate(registration));
      codeBuffer.writeln();
    }

    codeBuffer.writeln("}");
  }

  Future<void> _writeGeneratedFile(BuildStep buildStep, String content) async {
    final formattedContent = CodeFormatter.formatCode(content);
    await buildStep.writeAsString(
      AssetId(buildStep.inputId.package, 'lib/zef.di.register.g.dart'),
      formattedContent,
    );
  }
}
