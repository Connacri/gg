import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'ik/Dealer.dart';
import 'ik/classes.dart';
import 'ik/testjason2firestoreGet.dart';
import 'rmz/publicProfil.dart';

class MultiProviderWidget extends StatelessWidget {
  MultiProviderWidget({Key? key, required this.userRole}) : super(key: key);

  var userRole;

  @override
  Widget build(BuildContext context) {
    final FirebaseServices firebaseServices = FirebaseServices();

    return MultiProvider(
      providers: [
        StreamProvider<List<Charges>>(
          create: (_) => firebaseServices.getCostsTaxesList(),
          initialData: [],
        ),
        StreamProvider<List<ItemsA>>(
          create: (_) => firebaseServices.getItemsList(),
          initialData: [],
        ),
        StreamProvider<List<Invoice>>(
          create: (_) => firebaseServices.getInvoiceList(),
          initialData: [],
        ),
        // StreamProvider<SuperHero>.value(
        //   // All children will have access to SuperHero data
        //   value: firebaseServices.streamHero(GoogleUser2!.uid),
        //   initialData: SuperHero(
        //     userDisplayName: GoogleUser2.displayName.toString(),
        //     userAvatar: GoogleUser2.photoURL.toString(),
        //   ),
        // ),
      ],
      // child: logIn(),
      child:
          // Center(
          //   child: Text(userRole['userDisplayName']),
          // ),
          NavigationExample(
        userRole: userRole,
      ),
      //**************************************
      //child: mainPageFirestoreGetik(),
    );
  }
}

class FirebaseServices {
  FirebaseFirestore _fireStoreDataBase = FirebaseFirestore.instance;

  Stream<List<Charges>> getCostsTaxesList() {
    return _fireStoreDataBase.collection('Charges').snapshots().map(
        (snapShot) => snapShot.docs
            .map((document) => Charges.fromJson(document.data()))
            .toList());
  }

  Stream<List<ItemsA>> getItemsList() {
    return _fireStoreDataBase.collection('Adventure').snapshots().map(
        (snapShot) => snapShot.docs
            .map((document) => ItemsA.fromJson(document.data()))
            .toList());
  }

  Stream<List<Invoice>> getInvoiceList() {
    return _fireStoreDataBase.collection('Invoice').snapshots().map(
        (snapShot) => snapShot.docs
            .map((document) => Invoice.fromJson(document.data()))
            .toList());
  }

  /// Get a stream of a single document
  // Stream<SuperHero> streamHero(String? id) {
  //   return _fireStoreDataBase
  //       .collection('Users')
  //       .doc(id)
  //       .snapshots()
  //       .map((documen) => SuperHero.fromJson(documen.data()));
  // }
}

class NavigationExample extends StatefulWidget {
  NavigationExample({Key? key, required this.userRole}) : super(key: key);
  final userRole;

  @override
  State<NavigationExample> createState() => _NavigationExampleState();
}

class _NavigationExampleState extends State<NavigationExample> {
  int currentPageIndex = 0;

  // @override
  // void initState() {
  //
  //   final prov = Provider.of<SuperHero>(context, listen: false);
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: NavigationBar(
        height: 80,
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        selectedIndex: currentPageIndex,
        destinations: <Widget>[
          NavigationDestination(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
              icon: Icon(Icons.accessibility), label: 'Customers'),
          NavigationDestination(
            icon: ClipRRect(
                clipBehavior: Clip.hardEdge,
                borderRadius: BorderRadius.circular(50),
                child: CachedNetworkImage(
                  imageUrl: widget.userRole['userAvatar'],
                  fit: BoxFit.cover,
                  height: 30,
                  width: 30,
                )

                // prov.userAvatar == null
                //     ? const Icon(Icons.account_circle)
                //     : CachedNetworkImage(
                //         imageUrl: '${prov.userAvatar}',
                //         width: 30,
                //         height: 30,
                //         fit: BoxFit.cover,
                //         imageBuilder: (context, imageProvider) => Container(
                //               decoration: BoxDecoration(
                //                 shape: BoxShape.circle,
                //                 image: DecorationImage(
                //                     image: imageProvider, fit: BoxFit.cover),
                //               ),
                //             ),
                //         errorWidget: (context, url, error) => Icon(Icons.error),
                //         placeholderFadeInDuration: Duration(seconds: 1)),
                ),
            label: widget.userRole['userDisplayName'],
          ),
          // FutureBuilder(
          //   future: readUser(),
          //   builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          //     if (snapshot.hasData) {
          //       final user1 = snapshot.data;
          //       return NavigationDestination(
          //         selectedIcon: Icon(Icons.account_circle_rounded),
          //         icon: ClipRRect(
          //           clipBehavior: Clip.hardEdge,
          //           borderRadius: BorderRadius.circular(50),
          //           child: ClipRRect(
          //             clipBehavior: Clip.hardEdge,
          //             borderRadius: BorderRadius.circular(50),
          //             child: user!.photoURL == null
          //                 ? const Icon(Icons.account_circle)
          //                 : CachedNetworkImage(
          //                     imageUrl: user1['userAvatar'],
          //                     width: 30,
          //                     height: 30,
          //                     fit: BoxFit.cover,
          //                   ),
          //           ),
          //         ),
          //
          //         //Icon(Icons.account_circle_rounded),
          //         label: user1['userDisplayName'],
          //       );
          //     } else {
          //       return Center(
          //         child: CircularProgressIndicator(),
          //       );
          //     }
          //   },
          // ),
        ],
      ),
      body: <Widget>[
        mainPageFirestoreGetik(),
        dealer(),
        publicProfil(
          userRole: widget.userRole,
        ),
      ][currentPageIndex],
    );
  }
}
