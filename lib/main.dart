import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:sellers_app/global/global.dart';
import 'package:sellers_app/splashScreen/splash_screen.dart';
import 'dart:io' show Platform;

import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  sharedPreferences = await SharedPreferences.getInstance();

  Platform.isAndroid ?
  await Firebase.initializeApp(options:
  const FirebaseOptions(apiKey: "AIzaSyCKHdN_pPizCbRLkypOzosGg6c_xdwZV7Y",
      appId: "1:514243578539:android:5ac92e3fede3407a0ec5ee",
      messagingSenderId: "514243578539",
      projectId: "onlinefooddelivery-ac42b",
      storageBucket: "gs://onlinefooddelivery-ac42b.appspot.com"),)
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

