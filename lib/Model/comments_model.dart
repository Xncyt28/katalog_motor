import 'package:cloud_firestore/cloud_firestore.dart';

class Comment {
  final String username;
  final String text;
  final Timestamp timestamp;

  Comment(
      {required this.username, required this.text, required this.timestamp});

  factory Comment.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return Comment(
      username: data['username'] ?? 'Anonymous',
      text: data['text'] ?? '',
      timestamp: data['timestamp'] ?? Timestamp.now(),
    );
  }
}