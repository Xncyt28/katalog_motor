import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:katalog_motor/Admin/home_screen.dart';
import 'package:katalog_motor/Admin/navbar.dart';
import 'package:katalog_motor/User/navbar.dart';
import 'package:katalog_motor/service/user_services.dart';
import 'package:katalog_motor/sign_up_screen.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  SignInScreenState createState() => SignInScreenState();
}

class SignInScreenState extends State<SignInScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  String _errorMessage = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign In'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 32.0),
              _buildTextField(_emailController, 'Email', false),
              const SizedBox(height: 16.0),
              _buildTextField(_passwordController, 'Password', true),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: _signIn,
                child: const Text('Sign In'),
              ),
              const SizedBox(height: 32.0),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const SignUpScreen()),
                  );
                },
                child: const Text('Don\'t have an account? Sign up'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
      TextEditingController controller, String labelText, bool obscureText) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        border: const OutlineInputBorder(),
      ),
      obscureText: obscureText,
    );
  }

  Future<void> _signIn() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    if (email.isEmpty || !isValidEmail(email)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid email')),
      );
      return;
    }

    if (password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter your password')),
      );
      return;
    }

    try {
      UserCredential userCredential =
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Fetch user role
      DocumentSnapshot userData =
      await UserServices().getUserData(userCredential.user!.uid);
      String role = userData.get('role');

      // Navigate based on role
      if (role == 'admin') {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
              builder: (context) =>
                  MainScreenAdmin()), // Change to your admin screen
        );
      } else {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
              builder: (context) =>
                  MainScreenUser()), // Change to your user screen
        );
      }
    } on FirebaseAuthException catch (error) {
      _handleFirebaseAuthError(error);
    } catch (error) {
      setState(() {
        _errorMessage = error.toString();
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(_errorMessage)),
      );
    }
  }

  void _handleFirebaseAuthError(FirebaseAuthException error) {
    print('Error code: ${error.code}');
    String errorMessage;

    switch (error.code) {
      case 'user-not-found':
        errorMessage = 'No user found with that email';
        break;
      case 'wrong-password':
        errorMessage = 'Wrong password. Please try again.';
        break;
      default:
        errorMessage = error.message ?? 'An error occurred';
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(errorMessage)),
    );
  }

  bool isValidEmail(String email) {
    String emailRegex =
        r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$";
    RegExp regex = RegExp(emailRegex);
    return regex.hasMatch(email);
  }
}
