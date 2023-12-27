import 'package:flutter/material.dart';
import 'package:sellers_app/authentication/login_form.dart';
import 'package:sellers_app/authentication/register_form.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
        centerTitle: true,
        leading: const BackButton(color: Colors.white),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.cyan,
                Colors.amber
              ],
              begin: FractionalOffset(0.0, 0.0),
              end: FractionalOffset(1.0, 0.0),
              stops: [0.0, 1.0],
              tileMode: TileMode.clamp
            )
          ),
        ),
        title: const Text(
            "Food Online",
            style: TextStyle(
                fontSize: 45,
                color: Colors.white,
              fontFamily: "Lobster"
            )
        ),
        bottom: const TabBar(
          tabs: [
            Tab(
              icon: Icon(Icons.lock, color: Colors.white,),
              text: "Login",
            ),
            Tab(
              icon: Icon(Icons.person, color: Colors.white,),
              text: "Register",
            )
          ],
          indicatorColor: Colors.white54 ,
          indicatorWeight: 6,
          indicatorSize: TabBarIndicatorSize.tab,
          automaticIndicatorColorAdjustment: true,
        ),
      ),
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [
                Colors.amber,
                Colors.cyan
              ]
            )
          ),
          child: const TabBarView(
            children: [
              LoginScreen(),
              RegisterScreen(),
            ],
          ) ,
        ),
      ),
    );
  }
}
