# zef_di_core_generator

A code generator for the library [zef_di_core](https://pub.dev/packages/zef_di_core). It is used to automatically generate the service registrations based on annotations.

## Features

- **Automatic Service Registration**: Generates service registration code automatically, based on custom annotations within your project.
- **Seamless Integration**: Designed to work hand-in-hand with `zef_di_core` for a smooth development experience.
- **Improved Development Efficiency**: Reduces manual coding and potential human errors, speeding up the development process.

## Getting Started

To begin using this package in your project, follow these steps:

### Installation

1. Add `zef_di_core` to you `pubspec.yaml` under `dependencies`

```yaml
dependencies:
  zef_di_core: latest_version
```

2. Add `zef_di_core_generator` to your `pubspec.yaml` under `dev_dependencies`:

```yaml
dev_dependencies:
  zef_di_core_generator: latest_version
```

3. Run `pub get` or `flutter pub get` to install the package.

## Usage

1. Annotate your services with annotations from `zef_di_core`.
2. Run the build runner to generate the necessary code:

   ```shell
   dart run build_runner build
   ```

This will generate the service registration code in your project, adhering to the configurations defined by your annotations.

You should call the `registerDependencies` function from inside the starting point of your application:

```dart
void main(List<String> arguments) {
  // Create an instance of the ServiceLocator
  ServiceLocatorBuilder().build();

  // Call the function to register the generated dependencies
  registerDependencies();

  ... other code
```

## Example

### Singleton

Here is a simple usage example, which registers an instance if `SingletonService`

```dart
import 'package:zef_di_core/zef_di_core.dart';

@RegisterSingleton()
class SingletonService {
  void doSomething() {
    print("Doing something...");
  }
}
```

After running the generator, the code to register `SingletonService` is being generated inside the file `zef.di.g.dart`:

```dart
void registerDependencies() {
  ServiceLocator.I.registerInstance<SingletonService>(
    SingletonService(),
    interfaces: null,
    name: null,
    key: null,
    environment: null,
  );
}
```

### Transient

You can also register as a Transient. This means that the class will be instantiated when you resolve it.

```dart
import 'package:zef_di_core/zef_di_core.dart';

@RegisterTransient()
class TransientService {
  void doSomething() {
    print("Doing something...");
  }
}
```

Which will generate this code:

```dart
ServiceLocator.I.registerTransient<TransientService>(
    (args) => TransientService(),
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
The strategy is, that non-annotated parameters are tried to be resolved with the `ServiceLocator`. If you want tell the generator
that a parameter is passed via the `args`, you can annotate it with `@Passed()`.

```dart
import 'package:zef_di_core/zef_di_core.dart';

@RegisterTransient()
class TransientService {

  final AnyOtherService _anyOtherService;
  final double _anyValue;

  TransientService(
    // This parameter will be tried to automatically resolved
    this._anyOtherService, {

    // This parameter will be passed from `args`
    @Passed() required double anyValue,
  }) : _anyValue : anyValue;
}
```

This will generate a factory registration for the `TransientService` class with parameters. This also applies if you use the `RegisterFactoryMethod` annotation.

---

**NOTE**

Right now you can pass parameters via the `args` from the `resolve` function. If one service depends on another service, the `args` will be passed to the next service also. If the next service does not get the required args provided, there will be an Error thrown.
We don't like this approach, but we will create a better solution for this in future.

---

### Lazy Registration

Lazy registration allows you to defer the instantiation of a service until it's actually needed. This can improve the startup time of your application by loading services on-demand. To register a service as lazy, use the `@RegisterLazy()` annotation:

```dart
import 'package:zef_di_core/zef_di_core.dart';

@RegisterLazy()
class LazyService {
  void doSomething() {
    print("Doing something lazily...");
  }
}
```

After running the generator, `LazyService` will be registered for lazy instantiation in the generated `zef.di.g.dart` file:

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
  ServiceLocatorBuilder().build();

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
  // Singletons need to be registered with a getter
  @RegisterSingleton()
  ExternalClassA get externalClassA;

  // Transient registrations are no getters, instead they are methods
  @RegisterTransient()
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

The code will be generated into the same class as if you would have annotated the classes directly. See `zef.di.g.dart`

## Contributing

Contributions are welcome! Please feel free to submit issues, pull requests, or suggestions to improve the tool.
