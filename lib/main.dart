import 'package:firebase_flutter_crud/screens/authentication/login.dart';
import 'package:firebase_flutter_crud/screens/authentication/register.dart';
import 'package:firebase_flutter_crud/screens/homepage/home.dart';
import 'package:firebase_flutter_crud/screens/homepage/home_page.dart';
import 'package:firebase_flutter_crud/screens/homepage/second_screen.dart';
import 'package:firebase_flutter_crud/screens/notification/notification_service.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await NotificationService.initializeNotification();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(navigatorKey: navigatorKey, initialRoute: 'login', routes: {
      // home: HomePage(),
      'home': (context) => const HomePage(),
      'login': (context) => const LoginScreen(),
      'register': (context) => const RegisterScreen(),
      'second': (context) => const SecondScreen(),
    });
  }
}
