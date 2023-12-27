import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:comrade_app/models/roundbutton.dart';
import 'package:comrade_app/models/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AddPost extends StatefulWidget {
  const AddPost({super.key});

  @override
  State<AddPost> createState() => _AddPostState();
}

class _AddPostState extends State<AddPost> {
  final postController = TextEditingController();
  final fireStore = FirebaseFirestore.instance.collection("data");
  final auth = FirebaseAuth.instance;

  late User? user = auth.currentUser;

  bool buttonPressed = false;
  File? selectedImage;
  String? url;

  Future picImageFromGallery() async {
    var pickedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedImage == null) return;
    setState(() {
      selectedImage = File(pickedImage.path);
    });
  }

  Future uploadImage() async {
    final Reference postImageRef =
        FirebaseStorage.instance.ref().child("Post Images");
    var timeKey = DateTime.now();

    final UploadTask uploadTask =
        postImageRef.child("$timeKey.jpg").putFile(selectedImage!);

    var ImageUrl =
        await (await uploadTask.whenComplete(() {})).ref.getDownloadURL();

    url = ImageUrl.toString();
    savetoDatabase(url);
  }

  void savetoDatabase(url) {
    DateTime dbTimekey = DateTime.now();

    String postDate = ("${dbTimekey.day}-${dbTimekey.month}-${dbTimekey.year}");
    String postTime = ("${dbTimekey.hour}:${dbTimekey.minute}");

    String id = DateTime.now().millisecondsSinceEpoch.toString();

    CollectionReference ref = FirebaseFirestore.instance.collection("data");
    ref.doc(id).set({
      'id': id,
      'image': url,
      'message': postController.text.toString(),
      'uid': user!.uid,
      'email': user!.email,
      'postDate': postDate,
      'postTime': postTime
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // extendBodyBehindAppBar: true,
      extendBody: true,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
        title: const Text('Add Post'),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            children: [
              const SizedBox(
                height: 30,
              ),
              selectedImage != null
                  ? Image.file(selectedImage!)
                  : TextButton(
                      style: const ButtonStyle(
                          backgroundColor:
                              MaterialStatePropertyAll(Colors.transparent)),
                      child: const Text(
                        "Pick an Image",
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                      onPressed: () async {
                        picImageFromGallery();
                        buttonPressed = true;
                      },
                    ),
              const SizedBox(
                height: 20,
              ),
              TextField(
                controller: postController,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(), hintText: "Description"),
              ),
              const SizedBox(
                height: 20,
              ),
              RoundButton(
                text: 'Add',
                onTap: () {
                  buttonPressed == true
                      ? uploadImage().then((value) {
                          Utils().toastMesssage("Post added");
                          Navigator.pop(context);
                        }).onError((error, stackTrace) {
                          Utils().toastMesssage(error.toString());
                        })
                      : Utils().toastMesssage("Pick an Image First");
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
