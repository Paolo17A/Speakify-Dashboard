import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:speechlab_dashboard/firebase_options.dart';
import 'package:speechlab_dashboard/screens/home_screen.dart';

import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/welcome_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(App());
}

class App extends StatelessWidget {
  App({super.key});

  final Map<String, WidgetBuilder> _routes = {
    '/': (context) => const Welcome(),
    '/register': (context) => const RegisterScreen(),
    '/login': (context) => const LoginScreen(),
    '/home': (context) => const HomeScreen()
  };

  final ThemeData _themeData = ThemeData(
      scaffoldBackgroundColor: const Color.fromARGB(255, 245, 245, 245),
      appBarTheme:
          const AppBarTheme(backgroundColor: Color.fromARGB(255, 60, 118, 141)),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Color.fromARGB(255, 49, 102, 123),
          selectedItemColor: Color.fromARGB(255, 141, 201, 225)),
      listTileTheme: const ListTileThemeData(
          iconColor: Color.fromARGB(255, 141, 201, 225),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)))),
      elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
              shape: MaterialStateProperty.all<OutlinedBorder>(
                  const RoundedRectangleBorder(
                      borderRadius:
                          BorderRadiusDirectional.all(Radius.circular(10)))),
              backgroundColor: MaterialStateProperty.all<Color>(
                  const Color.fromARGB(255, 60, 118, 141)))));

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SpeechLab Dashboard',
      initialRoute: '/',
      routes: _routes,
      theme: _themeData,
    );
  }
}
