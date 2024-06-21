import 'package:flutter/material.dart';
import 'package:katalog_motor/User/navbar.dart';
import 'package:katalog_motor/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:katalog_motor/Admin/navbar.dart';
import 'package:katalog_motor/sign_in_screen.dart';
import 'package:katalog_motor/sign_up_screen.dart';
import 'package:katalog_motor/Admin/add_post_screen.dart';
import 'package:katalog_motor/User/search_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

//flutter run -d edge --web-renderer html
class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // initialRoute: '/',
      // routes: {
      //   '/' : (context) => MainScreen(),
      //   // '/signin' : (context) => SignInScreen(),
      //   // '/signup' : (context) => SignUpScreen(),
      //   // '/profil': (context) => ProfileScreen(),
      // },
      debugShowCheckedModeBanner: false,
      title: 'Katalog Motor',
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          iconTheme: IconThemeData(color: Colors.blueAccent),
          titleTextStyle: TextStyle(
            color: Colors.blueAccent,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.blue)
            .copyWith(secondary: Colors.deepPurple[50]),
        useMaterial3: true, // Remove this line if not required
      ),
      home: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return MainScreenUser();
          } else {
            return const SignInScreen();
          }
        },
      ),
    );
  }
}
