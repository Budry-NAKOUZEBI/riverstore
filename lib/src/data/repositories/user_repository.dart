import '../models/user_profile.dart';

abstract class UserRepository {
  Future<UserProfile> fetchCurrentUser();
}

/// Profil utilisateur mocké : aucune authentification réelle n'est mise
/// en place, conformément au périmètre du projet.
class MockUserRepository implements UserRepository {
  const MockUserRepository();

  @override
  Future<UserProfile> fetchCurrentUser() async {
    await Future.delayed(const Duration(milliseconds: 400));
    return UserProfile(
      id: 'u1',
      name: 'Camille Dubois',
      email: 'camille.dubois@example.com',
      avatarUrl: 'https://i.pravatar.cc/150?u=camille.dubois',
      memberSince: DateTime(2023, 3, 12),
      totalOrders: 8,
    );
  }
}
