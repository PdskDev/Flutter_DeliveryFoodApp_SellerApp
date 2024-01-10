import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sellers_app/global/global.dart';
import 'package:sellers_app/mainScreens/home_screen.dart';
import 'package:sellers_app/models/menus.dart';

import '../widgets/error_dialog.dart';
import '../widgets/progress_bar.dart';
import 'package:firebase_storage/firebase_storage.dart' as storage_ref;

class ItemsUploadScreen extends StatefulWidget {

  final Menus? model;
  const ItemsUploadScreen({super.key, required this.model});


  @override
  State<ItemsUploadScreen> createState() => _ItemsUploadScreenState();
}



class _ItemsUploadScreenState extends State<ItemsUploadScreen> {
  XFile? imageXFile;
  final ImagePicker _picker = ImagePicker();

  TextEditingController shortInfoController = TextEditingController();
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController priceController = TextEditingController();

  bool uploading = false;
  String uniqueIDName = DateTime.now().microsecondsSinceEpoch.toString();

  defaultScreen(){
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
        title: const Text(
            "Add New Item",
            style: TextStyle(
                fontSize: 30,
                color: Colors.white,
                fontFamily: "Lobster"
            )),
        centerTitle: true,
        elevation: 10.0,
        shadowColor: Colors.grey[500],
        automaticallyImplyLeading: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white,),
          onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (c) => const HomeScreen()));
          },
        ),
      ),
      body: Container(
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
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.shop_two, color: Colors.white, size: 180.0,),
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(Colors.cyan),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)
                      )
                  ),
                ),
                onPressed: (){
                  takeImage(context);
                },
                child: const Text(
                  "Add New Items",
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return imageXFile == null ? defaultScreen() : itemUploadFormScreen();
  }

  takeImage(mContext) {
    return showDialog(context: mContext, builder: (context) {
      return SimpleDialog(
        title: const Text("Add Menu Image", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        children: [
          const Divider(
            height: 10,
            color: Colors.grey,
            thickness: 1,
          ),
          SimpleDialogOption(
            onPressed: () => captureImageWithCamera(),
            child: const Text(
              "Capture with camera",
              style: TextStyle(color: Colors.black, fontSize: 18),
            ),
          ),
          SimpleDialogOption(
            onPressed: () => pickImageFromGallery(),
            child: const Text(
              "Select image from gallery",
              style: TextStyle(color: Colors.black, fontSize: 18),
            ),
          ),
          SimpleDialogOption(
            onPressed: (){
              Navigator.pop(context);
            },
            child: const Text(
              "Cancel",
              style: TextStyle(color: Colors.red, fontSize: 18, fontWeight: FontWeight.bold),
            ),
          )
        ],
      );

    });
  }

  Future captureImageWithCamera() async
  {
    Navigator.pop(context);
    imageXFile = await _picker.pickImage(source: ImageSource.camera, maxHeight: 720, maxWidth: 1280);

    setState(() {
      imageXFile;
    });
  }

  Future pickImageFromGallery() async{
    Navigator.pop(context);
    imageXFile = await _picker.pickImage(source: ImageSource.gallery, maxHeight: 720, maxWidth: 1280);

    setState(() {
      imageXFile;
    });
  }

  clearMenusUploadForm(){
    setState(() {
      shortInfoController.clear();
      titleController.clear();
      priceController.clear();
      descriptionController.clear();
      imageXFile = null;
    });
  }

  void validateUploadMenuInput() async {
    if(imageXFile != null){

      if(shortInfoController.text.isNotEmpty && titleController.text.isNotEmpty
          && descriptionController.text.isNotEmpty && priceController.text.isNotEmpty){
        setState(() {
          uploading = true;
        });

        //Upload image
        String downloadUrl = await uploadImage(File(imageXFile!.path));
        saveInfo(downloadUrl);
      }
      else{
        displayErrorMessage("Please enter informations for Item");
      }

    } else {
      displayErrorMessage("Please pick a image for Item");
    }

  }

  displayErrorMessage(message){
    return showDialog(
        context: context,
        builder: (c) {
          return ErrorDialog(message: message,);
        }
    );
  }

  uploadImage(mImageFile) async {
    storage_ref.Reference reference = storage_ref.FirebaseStorage.instance
        .ref().child("items");

    storage_ref.UploadTask uploadTask = reference.child(uniqueIDName + ".jpg").putFile(
        mImageFile,
        storage_ref.SettableMetadata(contentType: 'image/jpg')
    );

    storage_ref.TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() {});

    String downloadUrl = await taskSnapshot.ref.getDownloadURL();

    return downloadUrl;
  }

  saveInfo(String downloadUrl) async {
    String itemMenuID = widget.model!.nemuID.toString();

    final ref = FirebaseFirestore.instance
        .collection("sellers")
        .doc(sharedPreferences!.getString("sellerUID"))
        .collection("menus").doc(widget.model!.nemuID)
        .collection("items");

    ref.doc(uniqueIDName).set({
      "itemID": uniqueIDName,
      "menuID": itemMenuID,
      "sellerUID": sharedPreferences!.getString("sellerUID"),
      "sellerName": sharedPreferences!.getString("sellerName"),
      "itemTitle": titleController.text.trim().toString(),
      "itemShortInfo": shortInfoController.text.trim().toString(),
      "itemDescription": descriptionController.text.trim().toString(),
      "itemPrice": priceController.text.trim().toString(),
      "itemPhotoURL": downloadUrl,
      "publishedDate": DateTime.now(),
      "status": "available"
    }).then((value) {
      final itemRef = FirebaseFirestore.instance
          .collection("items");

      itemRef.doc(uniqueIDName).set({
        "itemID": uniqueIDName,
        "menuID": itemMenuID,
        "sellerUID": sharedPreferences!.getString("sellerUID"),
        "sellerName": sharedPreferences!.getString("sellerName"),
        "itemTitle": titleController.text.trim().toString(),
        "itemShortInfo": shortInfoController.text.trim().toString(),
        "itemDescription": descriptionController.text.trim().toString(),
        "itemPrice": priceController.text.trim().toString(),
        "itemPhotoURL": downloadUrl,
        "publishedDate": DateTime.now(),
        "status": "available"
      });
    }).then((value) {
      itemMenuID = "";
      clearMenusUploadForm();

      setState(() {
        uniqueIDName = DateTime.now().microsecondsSinceEpoch.toString();
        uploading = false;
      });
    });

  }

  itemUploadFormScreen() {
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
        title: const Text(
            "Uploading New Item",
            style: TextStyle(
                fontSize: 20,
                color: Colors.white,
                fontFamily: "Lobster"
            )),
        centerTitle: true,
        elevation: 10.0,
        shadowColor: Colors.grey[500],
        automaticallyImplyLeading: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white,),
          onPressed: (){
            clearMenusUploadForm();
          },
        ),
        actions: [
          TextButton(
            onPressed:  uploading ? null : () => validateUploadMenuInput(),
            child: const Text(
              "Add",
              style: TextStyle(color: Colors.cyan, fontWeight: FontWeight.bold,
                  fontSize: 18, fontFamily: "Lobster", letterSpacing: 2),
            ),
          ),

        ],
      ),
      body: ListView(
        children: [
          uploading == true ? linearProgress(): const Text(""),
          SizedBox(
            height: 250,
            width: MediaQuery.of(context).size.width * 0.8,
            child: Center(
              child: AspectRatio(
                aspectRatio: 16/9,
                child: Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        image: FileImage(File(imageXFile!.path)),
                        fit: BoxFit.cover
                    ),
                  ),
                ),
              ),
            ),
          ),
          const Divider(
            color: Colors.amber,
            height: 4,
            thickness: 1,
          ),
          ListTile(
            leading: const Icon(Icons.title, color: Colors.cyan,),
            title: SizedBox(
                width: 250,
                child: TextField(
                  style: const TextStyle(color: Colors.black),
                  controller: shortInfoController,
                  decoration: const InputDecoration(
                    hintText: 'Info',
                    hintStyle: TextStyle(color: Colors.grey),
                    border: InputBorder.none,
                  ),
                )
            ),
          ),
          const Divider(
            color: Colors.amber,
            height: 4,
            thickness: 1,
          ),
          ListTile(
            leading: const Icon(Icons.comment, color: Colors.cyan,),
            title: SizedBox(
                width: 250,
                child: TextField(
                  style: const TextStyle(color: Colors.black),
                  controller: titleController,
                  decoration: const InputDecoration(
                    hintText: 'Title',
                    hintStyle: TextStyle(color: Colors.grey),
                    border: InputBorder.none,
                  ),
                )
            ),
          ),
          const Divider(
            color: Colors.amber,
            height: 4,
            thickness: 1,
          ),
          ListTile(
            leading: const Icon(Icons.description, color: Colors.cyan,),
            title: SizedBox(
                width: 250,
                child: TextField(
                  keyboardType: TextInputType.multiline,
                  style: const TextStyle(color: Colors.black),
                  controller: descriptionController,
                  decoration: const InputDecoration(
                    hintText: 'Description',
                    hintStyle: TextStyle(color: Colors.grey),
                    border: InputBorder.none,
                  ),
                )
            ),
          ),
          const Divider(
            color: Colors.amber,
            height: 4,
            thickness: 1,
          ),
          ListTile(
            leading: const Icon(Icons.euro, color: Colors.cyan,),
            title: SizedBox(
                width: 250,
                child: TextField(
                  keyboardType: TextInputType.number,
                  style: const TextStyle(color: Colors.black),
                  controller: priceController,
                  decoration: const InputDecoration(
                    hintText: 'Price',
                    hintStyle: TextStyle(color: Colors.grey),
                    border: InputBorder.none,
                  ),
                )
            ),
          ),
        ],
      ),
    );
  }
}

