import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

import '../../main.dart';
import 'Ogoogle/googleSignInProvider.dart';

class LoginWidget extends StatefulWidget {
  // const login({Key? key}) : super(key: key);
  final VoidCallback onClickedSignUp;

  const LoginWidget({
    Key? key,
    required this.onClickedSignUp,
  }) : super(key: key);

  @override
  State<LoginWidget> createState() => _LoginWidgetState();
}

class _LoginWidgetState extends State<LoginWidget> {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  bool visible = true;

  loadProgress() {
    if (visible == true) {
      setState(() {
        visible = false;
      });
    } else {
      setState(() {
        visible = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          Padding(
            padding: EdgeInsets.only(
                // change 1
                top: 100,
                bottom: MediaQuery.of(context).viewInsets.bottom + 20,

                // change 2
                left: 20,
                right: 20),
            child: Form(
                key: formKey,
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(30),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaY: 25, sigmaX: 25),
                      child: SizedBox(
                        width: size.width * .9,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Stack(
                                children: [
                                  Container(
                                    height: 300,
                                    width: 200,
                                  ),
                                  Lottie.asset(
                                    'assets/lotties/127878-avatar-creation (2).json',
                                    repeat: true,
                                    // reverse: true,
                                    animate: true,
                                    height: 300,
                                    width: 200,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20),
                              Text(
                                'S\'Identifier'.toUpperCase(),
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                    color: Colors.black45,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w500,
                                    fontFamily: 'Oswald'),
                              ),
                              const SizedBox(height: 20),
                              ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                    primary: Colors.black54,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(15)),
                                    elevation: 4.0,
                                    minimumSize: const Size.fromHeight(50)),
                                icon: Icon(
                                  FontAwesomeIcons.google,
                                  color: Colors.red,
                                ),
                                label: const Text(
                                  'Google',
                                  style: TextStyle(
                                      fontSize: 24, color: Colors.white),
                                ),
                                onPressed: () async {
                                  final provider =
                                      await Provider.of<googleSignInProvider>(
                                          context,
                                          listen: false);
                                  provider.googleLogin().whenComplete(() =>
                                      Navigator.of(context).pushAndRemoveUntil(
                                          MaterialPageRoute(builder: (context) {
                                        return verifi_auth(); //CheckRole();
                                      }), ModalRoute.withName('/')));
                                  // (route) => true
                                },
                              ), // Google
                              const SizedBox(
                                height: 24,
                              ),
                              GestureDetector(
                                child: const Text(
                                  'Mot de Passe Oublié',
                                  style: TextStyle(
                                    decoration: TextDecoration.underline,
                                    color: Colors.red,
                                    fontSize: 16,
                                    fontFamily: 'Oswald',
                                  ),
                                ),
                                // onTap: () => Navigator.of(context).push(
                                //     MaterialPageRoute(
                                //         builder: (context) =>
                                //             const reset_password())),
                              ), //Forgot Password
                              const SizedBox(
                                height: 16,
                              ),
                              RichText(
                                  text: TextSpan(
                                      style: const TextStyle(
                                        fontFamily: 'Oswald',
                                        color: Colors.black54,
                                      ),
                                      text: 'J\'ai pas Encore de Compte? ',
                                      children: [
                                    TextSpan(
                                        // recognizer: TapGestureRecognizer()
                                        //   ..onTap = widget.onClickedSignUp,
                                        text: 'S\'Enregistrer',
                                        style: const TextStyle(
                                            decoration:
                                                TextDecoration.underline,
                                            fontFamily: 'Oswald',
                                            color: Colors.deepPurple,
                                            fontWeight: FontWeight.bold))
                                  ])), // J'ai pas Encore de Compte? / S'Enregistrer
                            ],
                          ),
                        ),
                      ),
                    ))),
          ),
        ],
      ),
    );
  }

  Future signIn() async {
    showDialog<void>(
        context: context,
        barrierDismissible: true,
        //false = user must tap button, true = tap outside dialog
        builder: (context) => const Center(child: CircularProgressIndicator()));

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim());
    } on FirebaseException catch (e) {
      if (e.code == 'invalid-email') {
        Navigator.of(context).pop();
        //navigatorKey.currentState!.popUntil((route) => route.isFirst);

        return Fluttertoast.showToast(
          msg: 'E-mail Invalide',
        );
      } else if (e.code == 'user-disabled') {
        Navigator.of(context).pop();
        //navigatorKey.currentState!.popUntil((route) => route.isFirst);
        return Fluttertoast.showToast(
            msg: 'Utlisateur Désactivé',
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 14.0);
      } else if (e.code == 'user-not-found') {
        Navigator.of(context).pop();
        //navigatorKey.currentState!.popUntil((route) => route.isFirst);
        return Fluttertoast.showToast(
            msg: 'Utilisateur Non Trouvé',
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 14.0);
      } else {
        Navigator.of(context).pop();
        //navigatorKey.currentState!.popUntil((route) => route.isFirst);
        return Fluttertoast.showToast(
            msg: 'Mot de passe incorrect',
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 14.0);
      }
    }
    //navigatorKey.currentState!.popUntil((route) => route.isFirst);
    Navigator.of(context, rootNavigator: true).pop((route) => route.isFirst);
    //Navigator.of(context).pop();
  }
}
