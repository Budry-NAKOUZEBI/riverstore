import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:riverstore/src/bootstrap.dart';
import 'package:riverstore/src/data/repositories/settings_storage.dart';
import 'package:riverstore/src/ui/widgets/catalog_filters.dart';
import 'package:riverstore/src/ui/widgets/product_card.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Parcours d'achat complet sur l'application réelle (vrais repositories,
/// vrais assets, vraies latences simulées).
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('search, add to cart, checkout and see the order in profile', (
    tester,
  ) async {
    SharedPreferences.setMockInitialValues({SettingsStorage.languageKey: 'fr'});
    final preferences = await SharedPreferences.getInstance();

    await tester.pumpWidget(buildApp(preferences: preferences));
    await tester.pumpAndSettle();
    expect(find.byType(ProductCard), findsWidgets);

    // 1. Recherche (insensible à la casse) puis ouverture du détail.
    await tester.enterText(find.byType(TextField), 'SANDALES');
    await tester.pump(searchDebounce);
    await tester.pumpAndSettle();
    expect(find.byType(ProductCard), findsOneWidget);

    await tester.tap(find.text('Sandales en cuir artisanales'));
    await tester.pumpAndSettle();
    expect(find.text('Description'), findsOneWidget);

    // 2. Ajout au panier et raccourci « Voir le panier » de la snackbar.
    await tester.tap(find.widgetWithText(FilledButton, 'Ajouter au panier'));
    await tester.pumpAndSettle();
    expect(find.text('1 déjà dans le panier'), findsOneWidget);
    await tester.tap(find.text('Voir le panier'));
    await tester.pumpAndSettle();
    expect(find.text('Mon panier'), findsOneWidget);

    // 3. Quantité 2 : 2 × 12 500 + 2 000 FCFA de livraison = 27 000 FCFA.
    await tester.tap(
      find.byTooltip('Augmenter la quantité de Sandales en cuir artisanales'),
    );
    await tester.pumpAndSettle();
    expect(find.text('2\u00a0000\u00a0FCFA'), findsOneWidget);

    // 4. Checkout : nom, téléphone et ville pré-remplis depuis le profil.
    await tester.tap(find.text('Commander'));
    await tester.pumpAndSettle();
    expect(find.text('Grâce Mabiala'), findsOneWidget);
    expect(find.text('06 612 34 56'), findsOneWidget);
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Quartier / arrondissement'),
      'Bacongo',
    );
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Adresse et point de repère'),
      'Rue Mbochis, n° 12, près du marché Total',
    );
    await tester.ensureVisible(find.text('Airtel Money'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Airtel Money'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Payer 27\u00a0000\u00a0FCFA'));
    await tester.pumpAndSettle();

    // 5. Confirmation puis retour au catalogue.
    expect(find.text('Commande confirmée'), findsOneWidget);
    expect(find.textContaining('Commande n° RS-'), findsOneWidget);
    expect(find.text('Paiement : Airtel Money'), findsOneWidget);
    await tester.ensureVisible(find.text('Continuer mes achats'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Continuer mes achats'));
    await tester.pumpAndSettle();

    // 6. Le panier est vide et la commande apparaît dans le profil.
    await tester.tap(find.text('Panier'));
    await tester.pumpAndSettle();
    expect(find.text('Votre panier est vide.'), findsOneWidget);

    await tester.tap(find.text('Profil'));
    await tester.pumpAndSettle();
    expect(find.textContaining('Commande n° RS-'), findsOneWidget);
    expect(find.text('9'), findsOneWidget); // 8 commandes passées + 1
  });
}
