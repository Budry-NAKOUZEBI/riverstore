import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../data/models/user_profile.dart';
import '../data/repositories/user_repository.dart';

final userRepositoryProvider = Provider<UserRepository>(
  (ref) => const MockUserRepository(),
);

final userProfileProvider = FutureProvider<UserProfile>(
  (ref) => ref.watch(userRepositoryProvider).fetchCurrentUser(),
);
