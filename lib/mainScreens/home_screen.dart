import 'package:flutter/material.dart';
import 'package:sellers_app/authentication/auth_screen.dart';
import 'package:sellers_app/global/global.dart';

import '../uploadScreens/menus_upload.dart';
import '../widgets/user_drawer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
        title: Text(
            sharedPreferences!.getString("sellerName")!,
            style: const TextStyle(
            fontSize: 30,
            color: Colors.white,
            fontFamily: "Lobster"
        )),
        centerTitle: true,
        automaticallyImplyLeading: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.post_add, color: Colors.cyan,),
            onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (c) => const MenusUploadScreen()));
            },
          )
        ],
      ),
      drawer: const UserDrawer(),
      body: Container(),
    );
  }
}
