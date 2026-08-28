import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/models/user_profile.dart';
import '../data/repositories/user_repository.dart';

final userRepositoryProvider = Provider<UserRepository>((ref) {
  return const MockUserRepository();
});

final userProfileProvider = FutureProvider<UserProfile>((ref) {
  return ref.watch(userRepositoryProvider).fetchCurrentUser();
});
