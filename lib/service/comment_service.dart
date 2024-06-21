import 'package:cloud_firestore/cloud_firestore.dart';

class CommentServices {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addComment(String postId, String userId, String text) async {
    try {
      await _firestore
          .collection('posts')
          .doc(postId)
          .collection('comments')
          .add({
        'userId': userId,
        'text': text,
        'timestamp': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Error adding comment: $e');
    }
  }

  Stream<List<Map<String, dynamic>>> getCommentsStream(String postId) {
    return _firestore
        .collection('posts')
        .doc(postId)
        .collection('comments')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .asyncMap((querySnapshot) async {
      List<Map<String, dynamic>> comments = [];
      for (var doc in querySnapshot.docs) {
        var data = doc.data();
        // Fetch user details
        var userSnapshot =
        await _firestore.collection('users').doc(data['userId']).get();
        var userData = userSnapshot.data() as Map<String, dynamic>;

        data['username'] = userData['username'];
        comments.add(data);
      }
      return comments;
    });
  }
}