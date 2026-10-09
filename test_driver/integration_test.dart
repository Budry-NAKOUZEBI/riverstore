import 'package:integration_test/integration_test_driver.dart';

/// Driver pour `flutter drive` : écrit les données de rapport (dont les
/// métriques de performance) dans `build/integration_response_data.json`.
Future<void> main() => integrationDriver();
