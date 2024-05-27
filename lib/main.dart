import 'package:flutter/material.dart';
import 'package:katalog_motor/screens/home_screen.dart';
import 'package:katalog_motor/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:katalog_motor/screens/profile_screen.dart';
import 'package:katalog_motor/screens/sign_in_screen.dart';
import 'package:katalog_motor/screens/sign_up_screen.dart';
import 'package:katalog_motor/screens/add_post_screen.dart';
import 'package:katalog_motor/screens/search_screen.dart';
import 'package:katalog_motor/screens/chat_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

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
            return const HomeScreen();
          } else {
            return const SignInScreen();
          }
        },
      ),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;
  final List<Widget> _children = [
    HomeScreen(),
    SearchScreen(),
    AddPostScreen(),
    ChatScreen(), //
    ProfileScreen(),
  ];
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _children[_currentIndex],
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
            canvasColor: Colors.blue[50]
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index){
            setState(() {
              _currentIndex = index;
            });
          },
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home, color: Colors.blue,),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.search, color: Colors.blue,),
              label: 'Search',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.upload, color: Colors.blue,),
              label: 'Upload',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.chat, color: Colors.blue,),
              label: 'Chat',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person, color: Colors.blue,),
              label: 'Profile',
            ),
          ],
          selectedItemColor: Colors.grey,
          unselectedItemColor: Colors.blueAccent,
          showUnselectedLabels: true,
        ),
      ),
    );
  }
}
