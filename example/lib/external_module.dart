import 'package:dio/dio.dart';
import 'package:zef_di_core/zef_di_core.dart';

@DependencyModule()
abstract class ExternalModule {
  @RegisterSingleton()
  Dio dio() => Dio(BaseOptions(baseUrl: 'https://zooper.dev'));
}
