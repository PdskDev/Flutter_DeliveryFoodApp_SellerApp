import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:sellers_app/authentication/auth_screen.dart';
import 'package:sellers_app/global/global.dart';
import 'package:sellers_app/widgets/text_widget_header.dart';

import '../models/menus.dart';
import '../uploadScreens/menus_upload.dart';
import '../widgets/info_design.dart';
import '../widgets/progress_bar.dart';
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
      body: CustomScrollView(
        slivers: [
          SliverPersistentHeader(
              pinned: true,
              delegate: TextWidgetHeader(textTitle: "My Menus")),
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection("sellers").doc(sharedPreferences?.getString("sellerUID"))
                .collection("menus").snapshots(),
            builder: (context, snapshot) {
              return !snapshot.hasData ?
              SliverToBoxAdapter(child: Center(child: circularProgress()),)
                  : SliverStaggeredGrid.countBuilder(
                crossAxisCount: 1,
                staggeredTileBuilder: (c) => const StaggeredTile.fit(1),
                itemBuilder: (context, index) {
                  Menus menusModel = Menus.fromJson(
                      snapshot.data!.docs[index].data()! as Map<String, dynamic>
                  );
                  //Design info display
                  return InfoDesignWidget(
                    model: menusModel,
                    context: context,
                  );
                },
                itemCount: snapshot.data!.docs.length,
              );
            },
          ),

        ],
      ),
    );
  }
}
