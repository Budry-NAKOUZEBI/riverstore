/// Comportement partagé par les implémentations de démonstration : elles
/// simulent le délai d'un appel réseau. La latence est injectable
/// (`Duration.zero` dans les tests, qui restent instantanés et
/// déterministes).
mixin SimulatedLatency {
  Duration get latency;

  Future<void> simulateLatency() async {
    if (latency > Duration.zero) await Future<void>.delayed(latency);
  }
}
