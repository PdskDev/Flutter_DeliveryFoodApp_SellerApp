import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../widgets/error_dialog.dart';

SharedPreferences? sharedPreferences;
FirebaseAuth firebaseAuth = FirebaseAuth.instance;