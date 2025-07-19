import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:insta/models/user.dart';
import 'package:insta/providers/user_provider.dart';
import 'package:insta/utils/utils.dart';
import 'dart:typed_data';
import 'package:insta/resources/firestore_method.dart';
import 'package:provider/provider.dart';

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({super.key});

  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  bool isLoading = false;
  Uint8List? _file;
  final TextEditingController _captionController = TextEditingController();
  void postImage(String uid, String username, String profImage) async {
    setState(() {
      isLoading = true;
    });
    try {
      String res = await FirestoreMethod().uploadPost(
        caption: _captionController.text,
        file: _file!,
        uid: uid,
        userName: username,
        photoImage: profImage,
      );

      if (res == "Success") {
        setState(() {
          isLoading = false;
        });

        showSnackbar(context, "Posted");
        clearImage();
      } else {
        setState(() {
          isLoading = false;
        });

        showSnackbar(context, res);
      }
    } catch (err) {
      setState(() {
        isLoading = false;
      });
      showSnackbar(context, err.toString());
    }
  }

  _selectImage(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (context) {
        return SimpleDialog(
          title: const Text("Create a post"),
          children: [
            SimpleDialogOption(
              padding: EdgeInsets.all(20),
              onPressed: () async {
                Navigator.of(context).pop();
                Uint8List file = await pickImage(ImageSource.camera);
                setState(() {
                  _file = file;
                });
              },
              child: const Text("Take a Photo"),
            ),
            SimpleDialogOption(
              padding: EdgeInsets.all(20),
              onPressed: () async {
                Navigator.of(context).pop();
                Uint8List file = await pickImage(ImageSource.gallery);
                setState(() {
                  _file = file;
                });
              },
              child: const Text("Choose Photo From Gallery"),
            ),
            SimpleDialogOption(
              padding: EdgeInsets.all(20),
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Cancel"),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    _captionController.dispose();
  }

  void clearImage() {
    setState(() {
      _file = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final User user = Provider.of<UserProvider>(context).getUser;
    return _file == null
        ? Center(
            child: IconButton(
              onPressed: () => _selectImage(context),
              icon: Icon(Icons.upload_outlined),
            ),
          )
        : Scaffold(
            appBar: AppBar(
              leading: IconButton(
                onPressed: clearImage,
                icon: Icon(Icons.arrow_back),
              ),
              title: const Text("Post"),
              actions: [
                TextButton(
                  onPressed: () =>
                      postImage(user.uid, user.userName, user.photoUrl),
                  child: Text(
                    "Post",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueAccent,
                    ),
                  ),
                ),
              ],
            ),
            body: Column(
              spacing: 5,
              children: [
                isLoading ? LinearProgressIndicator() : SizedBox(),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(backgroundImage: NetworkImage(user.photoUrl)),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.4,
                      child: TextField(
                        controller: _captionController,
                        decoration: InputDecoration(
                          hintText: "Write Caption",
                          border: InputBorder.none,
                        ),
                        maxLines: 8,
                      ),
                    ),
                    SizedBox(
                      height: 45,
                      width: 45,
                      child: AspectRatio(
                        aspectRatio: 487 / 451,
                        child: Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: MemoryImage(_file!),
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
  }
}
