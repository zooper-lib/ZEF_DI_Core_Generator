import 'package:dio/dio.dart';
import 'package:zef_di_core/zef_di_core.dart';

// Mock interceptors for the example
@RegisterTransient()
class UserIdInterceptor extends Interceptor {}

@RegisterTransient()
class UnauthorizedInterceptor extends Interceptor {}

@DependencyModule()
class ExternalModule {
  @RegisterTransient()
  static Dio dio(
    UserIdInterceptor userIdInterceptor,
    UnauthorizedInterceptor unauthorizedInterceptor,
  ) =>
      Dio(
        BaseOptions(
          baseUrl: 'https://api.speakeasy.com',
          followRedirects: true,
        ),
      )..interceptors.addAll([
          userIdInterceptor,
          unauthorizedInterceptor,
        ]);
}
