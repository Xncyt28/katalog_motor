// user_model.dart
import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String id;
  final String email;
  final String username;
  final String phone;
  final String address;
  final String role;
  final Timestamp createdAt;

  User({
    required this.id,
    required this.email,
    required this.username,
    required this.phone,
    required this.address,
    required this.role,
    required this.createdAt,
  });
}
