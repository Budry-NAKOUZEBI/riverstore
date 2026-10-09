import 'package:flutter/foundation.dart';

@immutable
class UserProfile {
  const UserProfile({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.city,
    required this.memberSince,
    required this.totalOrders,
  });

  final String id;
  final String name;
  final String email;
  final String phone;
  final String city;
  final DateTime memberSince;
  final int totalOrders;

  String get firstName => name.split(' ').first;

  String get initials => name
      .split(' ')
      .where((part) => part.isNotEmpty)
      .take(2)
      .map((part) => part[0].toUpperCase())
      .join();
}
