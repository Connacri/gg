import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:provider/provider.dart';

import 'main_in.dart';
import 'main_out.dart';
import 'rmz/Oauth/Ogoogle/googleSignInProvider.dart';
import 'rmz/publicLogged.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    //options: DefaultFirebaseOptions.currentPlatform,
  );
  FlutterNativeSplash.removeAfter(initialization);
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky,
      overlays: [SystemUiOverlay.top, SystemUiOverlay.bottom]);
  runApp(Materialclass());
}

Future initialization(BuildContext? context) async {
  Future.delayed(Duration(seconds: 5));
}

final navigatorKey = GlobalKey<NavigatorState>();

/// This is the main application widget.
class Materialclass extends StatelessWidget {
  Materialclass({Key? key}) : super(key: key);

  static const String _title = 'Oran ';
  final GoogleUser2 = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    // final GoogleSignInProvider googleSignInProviderStream =
    //     GoogleSignInProvider();

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => googleSignInProvider(),
        ),
        // StreamProvider<SuperHero>(
        //   create: (_) =>
        //       googleSignInProviderStream.streamHero(GoogleUser2!.uid),
        //   initialData: SuperHero(userDisplayName: 'df', userAvatar: 'fd'),
        //   lazy: true,
        // ),
      ],
      child: MaterialApp(
        locale: const Locale('fr', ''),
        //scaffoldMessengerKey: Utils.messengerKey,
        navigatorKey: navigatorKey,
        debugShowCheckedModeBanner: false,
        title: _title,
        themeMode: ThemeMode.dark,
        theme: ThemeData(
          useMaterial3: true,
          fontFamily: "Oswald",
          //fontFamily: lang.languageCode == "ar" ? 'ArbFONTS-khalaad-al-arabeh' : "Oswald",
          //   fontFamily:
          //   Localizations.localeOf(context).languageCode == 'ar'?
          //   'ArbFONTS-khalaad-al-arabeh' : 'Oswald'
        ),
//          darkTheme: _darkTheme,

        home: const verifi_auth(),
      ),
    );
  }
}


class verifi_auth extends StatefulWidget {
  const verifi_auth({Key? key}) : super(key: key);

  @override
  State<verifi_auth> createState() => _verifi_authState();
}

class _verifi_authState extends State<verifi_auth> {
  @override
  Widget build(BuildContext context) => Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return const Center(child: Text('Probleme de Connexion'));
          }
          if (snapshot.hasData) {
            final userD = snapshot.data!.uid;
            return CheckRole(userD); //MultiProviderWidget();
          } else {
            return main_out();
          }
        },
      ));
}

class CheckRole extends StatelessWidget {
  final String documentId;

  CheckRole(this.documentId);

  @override
  Widget build(BuildContext context) {
    CollectionReference users = FirebaseFirestore.instance.collection('Users');

    return FutureBuilder<DocumentSnapshot>(
      future: users.doc(documentId).get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text("Something went wrong");
        }

        if (snapshot.hasData && !snapshot.data!.exists) {
          return Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              title: Text("${users.id} Document does not exist"),
              centerTitle: true,
            ),
            body: Center(
              child: Padding(
                padding:
                const EdgeInsets.symmetric(vertical: 8, horizontal: 38),
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                      primary: Colors.black54,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)),
                      elevation: 4.0,
                      minimumSize: const Size.fromHeight(50)),
                  icon: Icon(
                    Icons.cancel,
                    color: Colors.red,
                  ),
                  label: const Text(
                    'Deconnexion',
                    style: TextStyle(fontSize: 24, color: Colors.white),
                  ),
                  onPressed: () async {
                    FirebaseAuth.instance.signOut();
                    final provider = Provider.of<googleSignInProvider>(context,
                        listen: false);
                    await provider.logouta();
                    // Navigator.of(context).pop();
                    Navigator.pop(context, true);
                  },
                ),
              ),
            ),
          );
        }

        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> userRole =
          snapshot.data!.data() as Map<String, dynamic>;
          if (userRole['userRole'] == 'admin') {
            return MultiProviderWidget(
              userRole: userRole,
            );
          } else {
            return publicLogged(
              userRole: userRole,
            );
          }
        }

        return Center(child: CircularProgressIndicator());
      },
    );
  }
}
