import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:sellers_app/splashScreen/splash_screen.dart';
import 'dart:io' show Platform;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Platform.isAndroid ?
  await Firebase.initializeApp(options:
  const FirebaseOptions(apiKey: "",
      appId: "",
      messagingSenderId: "",
      projectId: "",
      storageBucket: ""),)
      : await Firebase.initializeApp();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Sellers App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const MySplashScreen(),
    );
  }
}

