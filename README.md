# zef_di_abstractions_generator

A code generator for the library [zef_di_abstractions](https://pub.dev/packages/zef_di_abstractions). It is used to automatically generate the service registrations based on annotations.

## Features

- **Automatic Service Registration**: Generates service registration code automatically, based on custom annotations within your project.
- **Seamless Integration**: Designed to work hand-in-hand with `zef_di_abstractions` for a smooth development experience.
- **Improved Development Efficiency**: Reduces manual coding and potential human errors, speeding up the development process.

## Getting Started

To begin using `zef_di_abstractions_generator` in your project, follow these steps:

### Installation

1. Add `zef_di_abstractions_generator` to your `pubspec.yaml` under `dev_dependencies`:

```yaml
dev_dependencies:
  zef_di_abstractions_generator: latest_version
```

2. Run `pub get` or `flutter pub get` to install the package.

### Usage

1. Annotate your services with annotations from `zef_di_abstractions`.
2. Run the build runner to generate the necessary code:

   ```shell
   flutter pub run build_runner build
   ```

This will generate the service registration code in your project, adhering to the configurations defined by your annotations.

## Example

### Instance

Here is a simple usage example, which registers an Instance if `InstanceService`

```dart
import 'package:zef_di_abstractions/zef_di_abstractions.dart';

@RegisterInstance()
class InstanceService {
  void doSomething() {
    print("Doing something...");
  }
}
```

After running the generator, `InstanceService` a new file will be generated under `lib/` named `dependency_registration.g.dart` with a function `registerDependencies()`:

```dart
void registerDependencies() {
  ServiceLocator.I.registerInstance<InstanceService>(
    InstanceService(),
    interfaces: null,
    name: null,
    key: null,
    environment: null,
  );
}
```

You should now call this function from inside the starting point of your application:

```dart
void main(List<String> arguments) {
  // Create an instance of the ServiceLocator
  ServiceLocatorBuilder()...build();

  // Call the function to register the generated dependencies
  registerDependencies();

  ... other code
```

### Factory

You can also register as a factory. This means that the class will be instantiated when you resolve it.

```dart
import 'package:zef_di_abstractions/zef_di_abstractions.dart';

@RegisterFactory()
class FactoryService {
  void doSomething() {
    print("Doing something...");
  }
}
```

Which will generate this code:

```dart
ServiceLocator.I.registerFactory<FactoryService>(
    (serviceLocator, namedArgs) => FactoryService(),
    interfaces: null,
    name: null,
    key: null,
    environment: null,
  );
```

### Factory method

If you want to manually set how the class will be constructed, you can annotate a function with `RegisterFactoryMethod`:

```dart
  @RegisterFactoryMethod()
  static FactoryMethodService create() {
    return FactoryMethodService();
  }
```

### Passing parameters

The code generator will also generate the needed code to pass parameters while resolving a dependency.

```dart
import 'package:zef_di_abstractions/zef_di_abstractions.dart';

@RegisterFactory()
class FactoryService {

  final AnyOtherService _anyOtherService;
  final double _anyValue;

  FactoryService(
    // Positional parameters will automatically be resolved via the ServiceLocator
    this._anyOtherService, {

    // Named arguments are considered to be passed as parameters
    required double anyValue,
  }) : _anyValue : anyValue;
}
```

This will generate a factory registration for the `FactoryService` class with parameters. This also applies if you use the `RegisterFactoryMethod` annotation.

---

**NOTE**

Right now you can pass parameters via the `namedArgs` from the `resolve` function. If one service depends on another service, the `namedArgs` will be passed to the next service also. If the next service does not get the required args provided, there will be an Error thrown.
We don't like this approach, but we will create a better solution for this in future.

---

### Lazy Registration

Lazy registration allows you to defer the instantiation of a service until it's actually needed. This can improve the startup time of your application by loading services on-demand. To register a service as lazy, use the `@RegisterLazy()` annotation:

```dart
import 'package:zef_di_abstractions/zef_di_abstractions.dart';

@RegisterLazy()
class LazyService {
  void doSomething() {
    print("Doing something lazily...");
  }
}
```

After running the generator, `LazyService` will be registered for lazy instantiation in the generated `dependency_registration.g.dart` file:

```dart
void registerDependencies() {
  ServiceLocator.I.registerLazy<LazyService>(
    Lazy<LazyService>(factory: () => LazyService()),
    interfaces: null,
    name: null,
    key: null,
    environment: null,
  );
}
```

When you resolve `LazyService` from the `ServiceLocator`, it will only be instantiated at that moment, not before:

```dart
void main(List<String> arguments) {
  // Create an instance of the ServiceLocator
  ServiceLocatorBuilder()...build();

  // Call the function to register the generated dependencies
  registerDependencies();

  // LazyService is not instantiated yet
  final lazyService = ServiceLocator.I.resolve<LazyService>(); // Instantiates LazyService now
  lazyService.doSomething();

  ... other code
}
```

This lazy registration feature is especially useful for services that are resource-intensive to create or are used infrequently, allowing your application to start faster and consume less memory during initialization.

## Registering external dependencies

You can also register classes which come from other packages. As you cannot annotate them directly, you need to define a `Module`:

```dart
@DependencyModule()
abstract class ExternalClassesModule {
  // Instances need to be registered with a getter
  @RegisterInstance()
  ExternalClassA get externalClassA;

  // Factory registrations are no getters, instead they are methods
  @RegisterFactory()
  ExternalClassB externalClassB(ExternalClassA externalClassA) =>
      ExternalClassB(externalClassA);

  // Lazies are also methods
  @RegisterLazy()
  ExternalClassC externalClassC(
    ExternalClassA externalClassA,
    ExternalClassB externalClassB,
  ) =>
      ExternalClassC(
        externalClassA,
        externalClassB,
      );
}
```

The code will be generated into the same class as if you would have annotated the classes directly. See `dependency_registration.g.dart`

## Contributing

Contributions are welcome! Please feel free to submit issues, pull requests, or suggestions to improve the tool.
