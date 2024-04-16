import 'import_type.dart';

class ImportPath {
  final String path;
  final ImportType type;

  ImportPath(this.path, this.type);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ImportPath &&
          runtimeType == other.runtimeType &&
          path == other.path &&
          type == other.type;

  @override
  int get hashCode => path.hashCode ^ type.hashCode;

  @override
  String toString() {
    switch (type) {
      case ImportType.package:
        return "import 'package:$path';";
      case ImportType.internal:
        return "import 'package:$path';";
      case ImportType.relative:
        return "import '$path';";
      default:
        return '';
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'path': path,
      'type': type.toString(),
    };
  }

  factory ImportPath.fromJson(Map<String, dynamic> json) {
    return ImportPath(
      json['path'],
      ImportType.values.firstWhere(
        (e) => e.toString() == json['type'],
      ),
    );
  }
}
