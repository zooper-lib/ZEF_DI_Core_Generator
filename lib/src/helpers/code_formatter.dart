import 'package:dart_style/dart_style.dart';

class CodeFormatter {
  static String formatCode(String code) {
    final formatter = DartFormatter();
    return formatter.format(code);
  }
}
