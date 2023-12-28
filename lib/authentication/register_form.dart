import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sellers_app/widgets/custom_text_field.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController locationController = TextEditingController();

  XFile? imageXFile;
  final ImagePicker _picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          const SizedBox(height: 20,),
          InkWell(
            child: CircleAvatar(
              radius: MediaQuery.of(context).size.width * 0.20,
              backgroundColor: Colors.white,
              backgroundImage: imageXFile == null ? null : FileImage(File(imageXFile!.path)),
              child: imageXFile == null ?
              Icon(
                Icons.add_photo_alternate,
                size: MediaQuery.of(context).size.width * 0.20,
                color: Colors.grey,) : null
              ,
            ),
          ),
          const SizedBox(height: 10,),
          Form(
            key: _formKey,
            child: Column(
              children: [
                CustomTextField(
                  data: Icons.person,
                  isObscure: false,
                  enabled: true,
                  hintText: "Name",
                  controller: nameController,
                ),
                CustomTextField(
                  data: Icons.email,
                  isObscure: false,
                  enabled: true,
                  hintText: "E-mail",
                  controller: emailController,
                ),
                CustomTextField(
                  data: Icons.phone,
                  isObscure: false,
                  enabled: true,
                  hintText: "Phone",
                  controller: phoneController,
                ),
                CustomTextField(
                  data: Icons.lock,
                  isObscure: true,
                  enabled: true,
                  hintText: "Password",
                  controller: passwordController,
                ),
                CustomTextField(
                  data: Icons.lock,
                  isObscure: true,
                  enabled: true,
                  hintText: "Confirm password",
                  controller: confirmPasswordController,
                ),
                CustomTextField(
                  data: Icons.my_location,
                  isObscure: false,
                  enabled: false,
                  hintText: "Cafe/Restaurant address",
                  controller: locationController,
                ),
                Container(
                  width: 400,
                  height: 40,
                  alignment: Alignment.center,
                  child: ElevatedButton.icon(
                    icon: const Icon(
                      Icons.location_on,
                      color: Colors.white,
                    ),
                    label: const Text(
                      "Get My Current Location",
                      style: TextStyle(
                        color: Colors.white
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.amber,
                      padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    onPressed: ()=> print("clicked"),
                  ),
                )
              ],

            ),
          ),
          const SizedBox(height:10,),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding: const EdgeInsets.symmetric(horizontal: 100, vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
            ),
            child: const Text(
              "Sign Up",
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold,),
            ),
            onPressed: () => print("Clicked"),
          ),
          const SizedBox(height:20,),
        ],
      ),
    );
  }
}
