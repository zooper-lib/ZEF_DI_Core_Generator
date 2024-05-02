import 'package:zef_di_core_generator/src/models/import_path.dart';

class SuperTypeData {
  final ImportPath importPath;
  final String className;

  SuperTypeData({
    required this.importPath,
    required this.className,
  });

  Map<String, dynamic> toJson() {
    return {
      'importPath': importPath.toJson(),
      'className': className,
    };
  }

  factory SuperTypeData.fromJson(Map<String, dynamic> json) {
    return SuperTypeData(
      importPath: ImportPath.fromJson(json['importPath']),
      className: json['className'],
    );
  }
}
