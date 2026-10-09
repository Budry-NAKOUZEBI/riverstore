import '../models/user_profile.dart';

abstract interface class UserRepository {
  Future<UserProfile> fetchCurrentUser();
}

/// Profil de démonstration : l'authentification est hors périmètre.
class MockUserRepository implements UserRepository {
  const MockUserRepository({this.latency = const Duration(milliseconds: 300)});

  final Duration latency;

  @override
  Future<UserProfile> fetchCurrentUser() async {
    if (latency > Duration.zero) await Future<void>.delayed(latency);
    return UserProfile(
      id: 'u1',
      name: 'Grâce Mabiala',
      email: 'grace.mabiala@example.cg',
      phone: '06 612 34 56',
      city: 'Brazzaville',
      memberSince: DateTime(2023, 3, 12),
      totalOrders: 8,
    );
  }
}
