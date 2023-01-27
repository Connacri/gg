import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class googleSignInProvider extends ChangeNotifier {
  final googleSignIn = GoogleSignIn();

  GoogleSignInAccount? _user;

  GoogleSignInAccount get user => _user!;

  @override
  void dispose() {
    googleLogin();
    super.dispose();
  }

  Future googleLogin() async {
    try {
      final googleUser = await googleSignIn.signIn();
      if (googleUser == null) return;
      _user = googleUser;
      final googleAuth = await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await FirebaseAuth.instance.signInWithCredential(credential);
      final userGoo = FirebaseAuth.instance.currentUser;

      checkIfDocExists(userGoo!.uid);
      notifyListeners();
    } catch (e) {
      print(e.toString());
    }
  }

  Future logouta() async {
    await googleSignIn.disconnect();
    await FirebaseAuth.instance.signOut();
  }

////////////////////// a verifi
//   late Map<String, dynamic> _userx;
//
//   Map<String, dynamic> get userXX => _userx;

  // Stream<SuperHero> streamHero() {
  //   final userGoo = FirebaseAuth.instance.currentUser;
  //   final _fireStoreDataBase = FirebaseFirestore.instance;
  //   return _fireStoreDataBase
  //       .collection('Users')
  //       .doc(userGoo!.uid)
  //       .snapshots()
  //       .map((documen) {
  //     final dataQ = SuperHero.fromJson(documen.data());
  //     // _userx = dataQ as Map<String, dynamic>;
  //     // print(_userx);
  //     return dataQ;
  //   });
  // }
}

Future<bool> checkIfDocExists(String uid) async {
  try {
    final userGoo = FirebaseAuth.instance.currentUser;
    var collectionRef = FirebaseFirestore.instance.collection('Users');
    var doc = await collectionRef.doc(uid).get();
    print(doc.exists);
    doc.exists ? null : setUserDoc(userGoo!);
    return doc.exists;
  } catch (e) {
    throw e;
  }
}

Future setUserDoc(User userGoo) async {
  CollectionReference userRef = FirebaseFirestore.instance.collection('Users');

  int i = 1;
  String userID = userGoo.uid;
  String? userEmail = userGoo.email;
  String? userAvatar = userGoo.photoURL;
  String? userDisplayName = userGoo.displayName;
  List usersLike = ['sans'];
  int userAge = 20;
  int userItemsNbr = 0;
  String userRole = 'dealer';
  int userPhone = 65498321000; //int.parse(userGoo.phoneNumber.toString());
  String userSex = 'mal';
  bool userState = true;

  var now = DateTime.now().millisecondsSinceEpoch;

  userRef.doc(userGoo.uid).set({
    'userID': userID,
    'userEmail': userEmail,
    'userAvatar': userAvatar,
    'UcreatedAt': Timestamp.now(), //now.toString(),
    'userDisplayName': userDisplayName,
    'userAge': userAge,
    'userItemsNbr': FieldValue.increment(1),
    'userRole': userRole,
    'userPhone': userPhone,
    'userSex': userSex,
    'userState': userState,
  }, SetOptions(merge: true));
}

//   Future<DocumentSnapshot?> getUserDocx() async {
//     final userGoo = FirebaseAuth.instance.currentUser;
//     final docRef = FirebaseFirestore.instance.collection('Users');
//     var docc = await docRef.doc(userGoo!.uid);
//     docc.get().then(
//       (DocumentSnapshot doc) {
//         final data = doc.data();
//         print('dataUser');
//         print(data);
//         _userx = data as Map<String, dynamic>?;
//         return data;
//       },
//       onError: (e) => print("Error getting document: $e"),
//     );
//   }
//
//   // Future<Map<String, dynamic>?> getUserDoc() async {
//   //   try {
//   //     final userGoo = await FirebaseAuth.instance.currentUser;
//   //     var collectionRef = await FirebaseFirestore.instance.collection('Users');
//   //     var doc = await collectionRef.doc(userGoo!.uid).get();
//   //     var userDD = doc.data();
//   //
//   //     _userx = userDD;
//   //     print(_userx);
//   //
//   //     return _userx;
//   //   } catch (e) {
//   //     throw e;
//   //   }
//   // }
//
//   Future<String?> getUser(String uid) async {
//     try {
//       CollectionReference users =
//           FirebaseFirestore.instance.collection('Users');
//       final snapshot = await users.doc(uid).get();
//       final data = snapshot.data() as Map<String, dynamic>;
//       return data['userAge'];
//     } catch (e) {
//       return 'Error fetching user';
//     }
//   }
// ////////////////////// fin a verifi
