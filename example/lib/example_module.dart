import 'package:example/test_files/module_services.dart';
import 'package:zef_di_core/zef_di_core.dart';

//@DependencyModule()
abstract class ExampleModule {
  @RegisterSingleton()
  ModuleNoDependencies get moduleNoDependencies;

  @RegisterTransient()
  ModuleWithDependency moduleWithDependency(
          ModuleNoDependencies moduleServiceA) =>
      ModuleWithDependency(moduleServiceA);

  @RegisterSingleton()
  ModuleWithFactory get moduleServiceC;

  @RegisterLazy()
  ModuleWithFactoryWithDependencies moduleWithFactoryWithDependencies(
    ModuleNoDependencies moduleServiceA,
    ModuleWithDependency moduleServiceB, {
    required String testString,
  }) =>
      ModuleWithFactoryWithDependencies.create(
        moduleServiceA,
        moduleServiceB,
      );

  @RegisterTransient()
  ModuleWithArgs get moduleServiceD;
}
