class AnnotationAttributes {
  final String? name;
  final dynamic key;
  final String? environment;

  AnnotationAttributes({this.name, this.key, this.environment});

  @override
  String toString() {
    return 'AnnotationAttributes{name: $name, key: $key, environment: $environment}';
  }
}
