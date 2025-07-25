import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:insta/resources/auth_method.dart';
import 'package:insta/responsive/mobile_screen_layout.dart';
import 'package:insta/responsive/responsive_layout_screen.dart';
import 'package:insta/responsive/web_screen_layout.dart';
import 'package:insta/screens/login_screen.dart';
import 'package:insta/utils/colors.dart';
import 'package:insta/utils/global_variables.dart';
import 'package:insta/utils/utils.dart';
import 'package:insta/widgets/textfield_input.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  Uint8List? _image;
  bool isLoading = false;

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _usernameController.dispose();
    _bioController.dispose();
  }

  void selectImage() async {
    Uint8List im = await pickImage(ImageSource.gallery);
    setState(() {
      _image = im;
    });
  }

  void signUpUser() async {
    if (_image == null) {
      showSnackbar(context, "Please select Profile Image");
      return;
    }
    setState(() {
      isLoading = true;
    });
    final res = await AuthMethod().signUpUser(
      userName: _usernameController.text,
      email: _emailController.text,
      password: _passwordController.text,
      bio: _bioController.text,
      file: _image!,
    );

    if (res != "Success") {
      showSnackbar(context, res);
      setState(() {
        isLoading = false;
      });
    } else {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => ResponsiveLayoutScreen(
            webScreenLayout: WebScreenLayout(),
            mobileScreenLayout: MobileScreenLayout(),
          ),
        ),
      );
    }
  }

  void navigatorLogIn() {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (context) => LoginScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: MediaQuery.of(context).size.width > webScreenSize
              ? EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width / 3,
                )
              : EdgeInsets.symmetric(horizontal: 32),
          width: double.infinity,

          child: Column(
            spacing: 24,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Flexible(flex: 2, child: Container()),
              //logo
              SvgPicture.asset(
                'assets/ic_instagram.svg',
                color: primaryColor,
                height: 64,
              ),
              //profile
              Stack(
                children: [
                  _image != null
                      ? CircleAvatar(
                          radius: 64,
                          backgroundImage: MemoryImage(_image!),
                        )
                      : CircleAvatar(
                          backgroundColor: Colors.blueGrey,
                          radius: 64,
                          child: Icon(Icons.person, size: 55),
                        ),
                  Positioned(
                    bottom: -10,
                    left: 80,
                    child: IconButton(
                      onPressed: selectImage,
                      icon: Icon(Icons.add_a_photo_outlined),
                    ),
                  ),
                ],
              ),
              //username
              TextfieldInput(
                textEditingController: _usernameController,
                hintText: "Enter username",
                keyboardType: TextInputType.text,
              ),
              //email
              TextfieldInput(
                textEditingController: _emailController,
                hintText: "Enter Your Email",
                keyboardType: TextInputType.emailAddress,
              ),
              //password
              TextfieldInput(
                textEditingController: _passwordController,
                hintText: "Enter Your Password",
                keyboardType: TextInputType.text,
                ispass: true,
              ),
              //bio
              TextfieldInput(
                textEditingController: _bioController,
                hintText: "Bio",
                keyboardType: TextInputType.text,
              ),
              //button
              ElevatedButton(
                onPressed: signUpUser,
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(double.infinity, 50),
                  backgroundColor: blueColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: isLoading
                    ? CircularProgressIndicator()
                    : Text("Sign Up"),
              ),
              Flexible(flex: 2, child: Container()),
              //signup
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Have Account ? "),
                  TextButton(
                    onPressed: navigatorLogIn,
                    child: Text(
                      "Log In",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
