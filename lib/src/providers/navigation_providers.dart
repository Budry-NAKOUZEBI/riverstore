import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Onglet actif de la navigation principale (Catalogue / Favoris / Panier /
/// Profil).
final selectedTabProvider = StateProvider<int>((ref) => 0);
