import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sellers_app/global/global.dart';
import 'package:sellers_app/mainScreens/home_screen.dart';

import '../widgets/error_dialog.dart';
import '../widgets/progress_bar.dart';
import 'package:firebase_storage/firebase_storage.dart' as storage_ref;

class MenusUploadScreen extends StatefulWidget {
  const MenusUploadScreen({super.key});

  @override
  State<MenusUploadScreen> createState() => _MenusUploadScreenState();
}

class _MenusUploadScreenState extends State<MenusUploadScreen> {
  XFile? imageXFile;
  final ImagePicker _picker = ImagePicker();

  TextEditingController shortInfoController = TextEditingController();
  TextEditingController titleController = TextEditingController();
  TextEditingController priceController = TextEditingController();

  bool uploading = false;
  String uniqueMenuName = DateTime.now().microsecondsSinceEpoch.toString();

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
            "Add New Menu",
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
                  "Add New Menu",
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
    return imageXFile == null ? defaultScreen() : menusUploadFormScreen();
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
      imageXFile = null;
    });
  }

  void validateUploadMenuInput() async {
    if(imageXFile != null){

      if(shortInfoController.text.isNotEmpty && titleController.text.isNotEmpty){
        setState(() {
          uploading = true;
        });

        //Upload image
        String downloadUrl = await uploadImage(File(imageXFile!.path));
        saveInfo(downloadUrl);
      }
      else{
        displayErrorMessage("Please enter both info and title for Menu");
      }

    } else {
      displayErrorMessage("Please pick a image for Menu");
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
        .ref().child("menus");

    storage_ref.UploadTask uploadTask = reference.child(uniqueMenuName + ".jpg").putFile(
        mImageFile,
        storage_ref.SettableMetadata(contentType: 'image/jpg')
    );

    storage_ref.TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() {});

    String downloadUrl = await taskSnapshot.ref.getDownloadURL();

     return downloadUrl;
  }

  saveInfo(String downloadUrl) async {
    final ref = FirebaseFirestore.instance.collection("sellers").doc(
      sharedPreferences!.getString("sellerUID")
    ).collection("menus");

    ref.doc(uniqueMenuName).set({
      "sellerUID": sharedPreferences!.getString("sellerUID"),
      "nemuID": uniqueMenuName,
      "nemuTitle": titleController.text.trim().toString(),
      "nemuShortInfo": shortInfoController.text.trim().toString(),
      "menuImageURL": downloadUrl,
      "publishedDate": DateTime.now(),
      "status": "available"
    });

    clearMenusUploadForm();

    setState(() {
      uniqueMenuName = DateTime.now().microsecondsSinceEpoch.toString();
      uploading = false;
    });
  }

  menusUploadFormScreen() {
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
            "Uploading New Menu",
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
            leading: const Icon(Icons.perm_device_information, color: Colors.cyan,),
            title: SizedBox(
              width: 250,
              child: TextField(
                style: const TextStyle(color: Colors.black),
                controller: shortInfoController,
                decoration: const InputDecoration(
                  hintText: 'Menu Short Info',
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
            leading: const Icon(Icons.title, color: Colors.cyan,),
            title: SizedBox(
                width: 250,
                child: TextField(
                  style: const TextStyle(color: Colors.black),
                  controller: titleController,
                  decoration: const InputDecoration(
                    hintText: 'Menu Title',
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
        ],
      ),
    );
  }
}

