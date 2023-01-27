// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
//
// import '../../main_in.dart';
// import '../../main_out.dart';
//
// class verifi_auth extends StatefulWidget {
//   const verifi_auth({
//     Key? key,
//   }) : super(key: key);
//
//   @override
//   State<verifi_auth> createState() => _verifi_authState();
// }
//
// class _verifi_authState extends State<verifi_auth> {
//   final FirebaseServices firebaseServices = FirebaseServices();
//   @override
//   Widget build(BuildContext context) => Scaffold(
//           body: StreamBuilder<User?>(
//         stream: FirebaseAuth.instance.authStateChanges(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(
//               child: CircularProgressIndicator(),
//             );
//           } else if (snapshot.hasError) {
//             return const Center(child: Text('Probleme de Connexion'));
//           }
//           if (snapshot.hasData) {
//             return MultiProviderWidget(
//               firebaseServices: firebaseServices,
//             );
//           } else {
//             return const main_out();
//           }
//         },
//       ));
// }
