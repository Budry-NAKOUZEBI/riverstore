class UserProfile {
  const UserProfile({
    required this.id,
    required this.name,
    required this.email,
    required this.avatarUrl,
    required this.memberSince,
    required this.totalOrders,
  });

  final String id;
  final String name;
  final String email;
  final String avatarUrl;
  final DateTime memberSince;
  final int totalOrders;
}
