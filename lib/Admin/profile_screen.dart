import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:katalog_motor/sign_in_screen.dart';
import 'package:katalog_motor/service/user_services.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late Future<DocumentSnapshot> userFuture;

  @override
  void initState() {
    super.initState();
    userFuture = _fetchUserData();
  }

  Future<DocumentSnapshot> _fetchUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return await UserServices().getUserData(user.uid);
    } else {
      throw Exception('User not logged in');
    }
  }

  Future<void> signOut(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => SignInScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: userFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Error fetching user data'));
          } else if (snapshot.hasData && !snapshot.data!.exists) {
            return const Center(child: Text('User data not found'));
          } else if (snapshot.hasData) {
            final userData = snapshot.data!.data() as Map<String, dynamic>;
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 20),
                  Card(
                    elevation: 4.0,
                    margin: const EdgeInsets.symmetric(
                        horizontal: 20.0, vertical: 10.0),
                    child: ListTile(
                      leading: const Icon(Icons.person, color: Colors.blue),
                      title: Text(
                        userData['username'] ?? 'Nama Pengguna',
                        style: const TextStyle(fontSize: 20),
                      ),
                    ),
                  ),
                  Card(
                    elevation: 4.0,
                    margin: const EdgeInsets.symmetric(
                        horizontal: 20.0, vertical: 10.0),
                    child: ListTile(
                      leading: const Icon(Icons.phone, color: Colors.blue),
                      title: Text(
                        userData['phone'] ?? 'No Handphone',
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                  Card(
                    elevation: 4.0,
                    margin: const EdgeInsets.symmetric(
                        horizontal: 20.0, vertical: 10.0),
                    child: ListTile(
                      leading: const Icon(Icons.email, color: Colors.blue),
                      title: Text(
                        userData['email'] ?? 'Email',
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () => signOut(context),
                    child: const Text('Sign Out'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30, vertical: 15),
                      textStyle: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            );
          } else {
            return const Center(child: Text('Unknown error occurred'));
          }
        },
      ),
    );
  }
}