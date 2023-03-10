import 'dart:ui';

import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'reset_password.dart';

class SignUpWidget extends StatefulWidget {
  // const SignUpWidget({Key? key}) : super(key: key);

  final Function() onClickedSignIn;

  const SignUpWidget({
    Key? key,
    required this.onClickedSignIn,
  }) : super(key: key);

  @override
  State<SignUpWidget> createState() => _SignUpWidgetState();
}

class _SignUpWidgetState extends State<SignUpWidget> {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmpasswordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    confirmpasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: Stack(
        children: [
          SizedBox(
            height: size.height,
            child:
                //Image.network('https://unsplash.com/photos/bOBM8CB4ZC4')
                Image.asset(
              'assets/images/registergif.gif',
              // #Image Url: https://unsplash.com/photos/bOBM8CB4ZC4
              fit: BoxFit.fitHeight,
            ),
            // Image.network('https://source.unsplash.com/random/300×300',fit: BoxFit.fill,),
          ),
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
                          const SizedBox(height: 20),
                          SizedBox(
                              height: 100,
                              width: 100,
                              child: Image.asset('assets/icon/dolphin_01.png')),
                          const SizedBox(height: 20),
                          Text(
                            'S\'enregistrer'.toUpperCase(),
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                                color: Colors.black54,
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                                fontFamily: 'Oswald'),
                          ),
                          const SizedBox(height: 20),
                          const Text(
                            'Hey Toi, Bienvenue',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Oswald'),
                          ),
                          const SizedBox(height: 20),
                          TextFormField(
                            keyboardType: TextInputType.phone, //.emailAddress,
                            controller: emailController,
                            cursorColor: Colors.white,
                            textInputAction: TextInputAction.next,
                            decoration: const InputDecoration(
                                labelText: 'E-mail',
                                labelStyle: TextStyle(
                                    fontFamily: 'Oswald',
                                    color: Colors.black54)),
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            // validator: (email) =>
                            //     email != null && !EmailValidator.validate(email)
                            //         ? 'Entrer a Valide E-Mail'
                            //         : null,
                          ),
                          const SizedBox(height: 4),
                          TextFormField(
                            controller: passwordController,
                            obscureText: true,
                            textInputAction: TextInputAction.next,
                            decoration: const InputDecoration(
                                labelText: 'Mot de Passe',
                                labelStyle: TextStyle(
                                    fontFamily: 'Oswald',
                                    color: Colors.black54)),
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            validator: (value) =>
                                value != null && value.length < 6
                                    ? 'Entrer min 6 characteres.'
                                    : null,
                            // onChanged : _password = value!,
                            //   onEditingComplete :
                          ),
                          const SizedBox(
                            height: 4,
                          ),
                          TextFormField(
                            controller: confirmpasswordController,
                            obscureText: true,
                            textInputAction: TextInputAction.next,
                            decoration: const InputDecoration(
                                labelText: 'Confirmé Mot de Passe',
                                labelStyle: TextStyle(
                                    fontFamily: 'Oswald',
                                    color: Colors.black54)),
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            validator: (value) => value !=
                                    passwordController
                                        .text //(value) => value != null && value.length < 6
                                ? 'Mot de Passe de Confimation n\'est Pas le Même.'
                                : null,
                          ),
                          const SizedBox(height: 20),
                          ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                                primary: Colors.black54,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15)),
                                elevation: 4.0,
                                minimumSize: const Size.fromHeight(50)),
                            icon: const Icon(
                              Icons.lock_open,
                              size: 32,
                              color: Colors.tealAccent,
                            ),
                            label: const Text(
                              'Enregistrer',
                              style: TextStyle(
                                  fontSize: 24, color: Colors.tealAccent),
                            ),
                            onPressed: signUp,
                          ),
                          const SizedBox(
                            height: 24,
                          ),
                          RichText(
                              text: TextSpan(
                                  style: const TextStyle(
                                    fontFamily: 'Oswald',
                                    color: Colors.black54,
                                  ),
                                  text: 'J\'ai Déja Un Compte ? ',
                                  children: [
                                TextSpan(
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = widget.onClickedSignIn,
                                    text: 'Entrer',
                                    style: const TextStyle(
                                        decoration: TextDecoration.underline,
                                        color: Colors.tealAccent,
                                        fontFamily: 'Oswald',
                                        //color: Colors.black54,
                                        fontWeight: FontWeight.bold)),
                              ])),
                          const SizedBox(
                            height: 12,
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
                            onTap: () => Navigator.of(context).push(
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const reset_password())),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Future signUp() async {
  //   final isValid = formKey.currentState!.validate();
  //   if (!isValid) return;
  //
  //   showDialog<void>(
  //       context: context,
  //       barrierDismissible: false,
  //       //false = user must tap button, true = tap outside dialog
  //       builder: (context) => const Center(child: CircularProgressIndicator()));
  //   try {
  //     await FirebaseAuth.instance.createUserWithEmailAndPassword(
  //       email: emailController.text.trim(),
  //       password: passwordController.text.trim(),
  //     );
  //   } on FirebaseException catch (e) {
  //     print(e);
  //   }
  //   //navigatorKey.currentState!.popUntil((route) => route.isFirst);
  //   Navigator.of(context).pop();
  // }
  Future signUp() async {
    final isValid = formKey.currentState!.validate();
    if (!isValid) return;

    showDialog<void>(
        context: context,
        barrierDismissible: true,
        //false = user must tap button, true = tap outside dialog
        builder: (context) => const Center(child: CircularProgressIndicator()));

    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        password: passwordController.text.trim(),
        email: emailController.text.trim(),
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        //navigatorKey.currentState!.popUntil((route) => route.isFirst);
        Navigator.of(context).pop();
        return Fluttertoast.showToast(
            msg: 'E-mail est déjà utilisée',
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.black54,
            textColor: Colors.white,
            fontSize: 14.0);
      } else if (e.code == 'invalid-email') {
        //navigatorKey.currentState!.popUntil((route) => route.isFirst);
        Navigator.of(context).pop();
        return Fluttertoast.showToast(
            msg: 'E-mail Invalide',
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.black54,
            textColor: Colors.white,
            fontSize: 14.0);
      } else if (e.code == 'operation-not-allowed') {
        //navigatorKey.currentState!.popUntil((route) => route.isFirst);
        Navigator.of(context).pop();
        return Fluttertoast.showToast(
            msg: 'Opération non autorisée',
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.black54,
            textColor: Colors.white,
            fontSize: 14.0);
      } else {
        //navigatorKey.currentState!.popUntil((route) => route.isFirst);
        Navigator.of(context).pop();
        return Fluttertoast.showToast(
            msg: 'Mot de passe faible',
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.black54,
            textColor: Colors.white,
            fontSize: 14.0);
      }
    }
    // navigatorKey.currentState!.popUntil((route) => route.isFirst);
    Navigator.of(context).pop();
  }
}
