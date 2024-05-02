import 'package:zef_di_core_generator/src/models/parameter.dart';

import '../models/registrations.dart';

class SortHelper {
  /// Sorts the type registrations topologically by their dependencies
  /// to ensure that dependencies are registered before the types that depend on them.
  static List<TypeRegistration> topologicallySortTypeRegistrations(
    List<TypeRegistration> registrations,
  ) {
    final Map<String, Set<Parameter>> graph = {};
    final Map<String, TypeRegistration> dataLookup = {};

    // Initialize graph and lookup table
    for (var registration in registrations) {
      if (registration is SingletonData) {
        graph[registration.className] = registration.dependencies.toSet();
      }
      dataLookup[registration.className] = registration;
    }

    // Perform topological sort
    final List<String> sortedClassNames = _performTopologicalSort(graph);

    // Map sorted class names back to their corresponding RegistrationData objects
    final List<TypeRegistration> sortedRegistrations = [];
    for (var className in sortedClassNames) {
      final registrationData = dataLookup[className];

      if (registrationData != null) {
        sortedRegistrations.add(registrationData);
      } else {
        print("Warning: No registrered type found for '$className'");
      }
    }

    // Add FactoryData objects at the end, assuming they don't have dependencies affecting the order
    for (var registration in registrations) {
      if ((registration is TransientData || registration is LazyData) &&
          !sortedClassNames.contains(registration.className)) {
        sortedRegistrations.add(registration);
      }
    }

    return sortedRegistrations;
  }

  static List<String> _performTopologicalSort(
      Map<String, Set<Parameter>> graph) {
    final List<String> sorted = [];
    final Set<String> visited = {};
    final Set<String> visiting = {};

    void visit(String node) {
      if (visited.contains(node)) return;
      if (visiting.contains(node)) {
        throw Exception('Cyclic dependency detected in $node');
      }

      visiting.add(node);
      final dependencies = graph[node];
      if (dependencies != null) {
        for (var dep in dependencies) {
          visit(dep.parameterType);
        }
      }
      visiting.remove(node);
      visited.add(node);
      sorted.add(node);
    }

    graph.keys.forEach(visit);
    return sorted;
  }
}
