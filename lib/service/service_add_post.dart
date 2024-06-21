import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class AddPostServices {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<void> tambahPost(String title, String description, Timestamp date,
      String urlImage, double harga) async {
    try {
      await _firestore.collection('posts').add({
        'title': title,
        'descr': description,
        'urlimage': urlImage,
        'time': date,
        'harga': harga,
      });
    } catch (e) {
      throw Exception('Gagal Melakukan Postings: $e');
    }
  }

  Future<String?> uploadImage(XFile image) async {
    try {
      final storageRef = _storage
          .ref()
          .child('images/post_images/${DateTime.now().toIso8601String()}');

      if (kIsWeb) {
        // For web, use putData
        final bytes = await image.readAsBytes();
        final uploadTask = storageRef.putData(bytes);
        final snapshot = await uploadTask;
        return await snapshot.ref.getDownloadURL();
      } else {
        // For mobile, use putFile
        final uploadTask = storageRef.putFile(File(image.path));
        final snapshot = await uploadTask;
        return await snapshot.ref.getDownloadURL();
      }
    } catch (e) {
      print('Error uploading image: $e');
      return null;
    }
  }

  Future<List<Map<String, dynamic>>> getPosts() async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('posts')
          .orderBy('time', descending: true)
          .get();
      List<Map<String, dynamic>> posts = [];
      querySnapshot.docs.forEach((doc) {
        Map<String, dynamic> post = doc.data() as Map<String, dynamic>;
        posts.add(post);
      });
      return posts;
    } catch (e) {
      print('Error fetching posts: $e');
      return [];
    }
  }
}