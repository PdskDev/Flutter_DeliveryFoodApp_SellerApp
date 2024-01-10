import 'package:flutter/material.dart';
import 'package:sellers_app/uploadScreens/items_upload_screen.dart';
import 'package:sellers_app/widgets/text_widget_header.dart';

import '../global/global.dart';
import '../models/menus.dart';
import '../uploadScreens/menus_upload.dart';
import '../widgets/user_drawer.dart';
class ItemsScreen extends StatefulWidget {

  final Menus? model;

  const ItemsScreen({super.key, required this.model});

  @override
  State<ItemsScreen> createState() => _ItemsScreenState();
}

class _ItemsScreenState extends State<ItemsScreen> {

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
            icon: const Icon(Icons.library_add, color: Colors.cyan,),
            onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (c) => ItemsUploadScreen(model: widget.model)));
            },
          )
        ],
      ),
      drawer: const UserDrawer(),
      body: CustomScrollView(
        slivers: [
          SliverPersistentHeader(pinned: true, delegate: TextWidgetHeader(textTitle: "My ${widget.model!.nemuTitle}'s menu"))
        ],
      ),
    );
  }
}
