import 'package:comrade_app/models/roundbutton.dart';
import 'package:comrade_app/models/utils.dart';
import 'package:comrade_app/screens/homescreen.dart';
import 'package:comrade_app/screens/signin_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final emailController = TextEditingController();

  final passController = TextEditingController();

  final confpassController = TextEditingController();

  final auth = FirebaseAuth.instance;

  bool isLoading = false;

  void signup(String email, String password) async {
    UserCredential userCredential = await auth.createUserWithEmailAndPassword(
        email: email, password: password);
    Utils().toastMesssage("$email signed in Successfully");
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const HomeScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("Signup Screen"),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 22.0),
              child: TextField(
                controller: emailController,
                decoration: const InputDecoration(
                  hintText: "Email",
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 22.0),
              child: TextField(
                controller: passController,
                decoration: const InputDecoration(hintText: "Password"),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 22.0),
              child: TextField(
                controller: confpassController,
                decoration: const InputDecoration(hintText: "Confirm Password"),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            RoundButton(
                onTap: () {
                  if (emailController.text == "" ||
                      passController.text == "" ||
                      confpassController.text == "") {
                    Utils().toastMesssage("Fields required");
                  } else {
                    passController.text == confpassController.text
                        ? signup(emailController.text.toString(),
                            passController.text.toString())
                        : Utils().toastMesssage("Password doesn't match");
                  }
                },
                text: "Sign Up"),
            const SizedBox(
              height: 30,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Already have an account "),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const SignInScreen()));
                  },
                  child: Text(
                    "Login now",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColor),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
