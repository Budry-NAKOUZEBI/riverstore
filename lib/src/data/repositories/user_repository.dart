import '../models/user_profile.dart';
import 'simulated_latency.dart';

abstract class UserRepository {
  const UserRepository();

  Future<UserProfile> fetchCurrentUser();
}

/// Profil de démonstration : l'authentification est hors périmètre.
class MockUserRepository extends UserRepository with SimulatedLatency {
  const MockUserRepository({this.latency = const Duration(milliseconds: 300)});

  @override
  final Duration latency;

  @override
  Future<UserProfile> fetchCurrentUser() async {
    await simulateLatency();
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
