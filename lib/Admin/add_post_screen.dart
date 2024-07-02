import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:katalog_motor/service/services_add_post.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddPostScreen extends StatefulWidget {
  @override
  _AddPostScreenState createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  final TextEditingController _postTitleController = TextEditingController();
  final TextEditingController _postDescriptionController =
  TextEditingController();
  final TextEditingController _postHargaController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  XFile? _image;
  String? _imageUrl;
  final AddPostServices _services = AddPostServices();

  Future<void> _getImageFromCamera() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);
    setState(() {
      if (pickedFile != null) {
        _image = pickedFile;
        if (kIsWeb) {
          _imageUrl = pickedFile.path;
        }
      }
    });
  }

  Future<void> _postContent() async {
    if (_postTitleController.text.isNotEmpty &&
        _postDescriptionController.text.isNotEmpty &&
        _postHargaController.text.isNotEmpty &&
        _image != null) {
      try {
        final harga = double.parse(_postHargaController.text);
        final imageUrl = await _services.uploadImage(_image!);
        if (imageUrl != null) {
          await _services.tambahPost(
            _postTitleController.text,
            _postDescriptionController.text,
            Timestamp.now(),
            imageUrl,
            harga,
          );
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Posting berhasil!')),
          );
          setState(() {
            _postTitleController.clear();
            _postDescriptionController.clear();
            _postHargaController.clear();
            _image = null;
            _imageUrl = null;
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Gagal mengunggah gambar')),
          );
        }
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal memposting: $error')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lengkapi semua field terlebih dahulu!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tambah Postingan Disini'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            GestureDetector(
              onTap: _getImageFromCamera,
              child: Container(
                height: 200,
                color: Colors.grey[200],
                child: _image != null
                    ? kIsWeb
                    ? (_imageUrl != null
                    ? Image.network(
                  _imageUrl!,
                  fit: BoxFit.cover,
                )
                    : Icon(
                  Icons.error,
                  size: 100,
                  color: Colors.red,
                ))
                    : Image.file(
                  File(_image!.path),
                  fit: BoxFit.cover,
                )
                    : Icon(
                  Icons.camera_alt,
                  size: 100,
                  color: Colors.grey[400],
                ),
                alignment: Alignment.center,
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _postTitleController,
              decoration: const InputDecoration(
                hintText: 'Judul postingan',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _postDescriptionController,
              maxLines: null,
              decoration: const InputDecoration(
                hintText: 'Silahkan tulis deskripsi postingan Anda di sini...',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _postHargaController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                hintText: 'Harga',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _postContent,
              child: const Text('Posting'),
            ),
          ],
        ),
      ),
    );
  }
}