import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../ik/PublicHomeLIst.dart';
import 'publicProfil.dart';

class publicLogged extends StatefulWidget {
  publicLogged({Key? key, required this.userRole}) : super(key: key);
  final userRole;

  @override
  _publicLoggedState createState() {
    return _publicLoggedState();
  }
}

class _publicLoggedState extends State<publicLogged> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  int currentPageIndex = 0;
  @override
  Widget build(BuildContext context) {
    final currentuser = FirebaseAuth.instance.currentUser;
    // final prov = Provider.of<SuperHero>(context, listen: false);
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
            selectedIcon: ClipRRect(
              clipBehavior: Clip.hardEdge,
              borderRadius: BorderRadius.circular(50),
              child: currentuser == null
                  ? const Icon(Icons.account_circle)
                  : ClipRRect(
                      clipBehavior: Clip.hardEdge,
                      borderRadius: BorderRadius.circular(50),
                      child: CachedNetworkImage(
                        imageUrl: widget.userRole['userAvatar'],
                        fit: BoxFit.cover,
                        height: 30,
                        width: 30,
                      ),
                    ),
            ),
            icon: ClipRRect(
              clipBehavior: Clip.hardEdge,
              borderRadius: BorderRadius.circular(50),
              child: currentuser == null
                  ? const Icon(Icons.account_circle)
                  : ClipRRect(
                      clipBehavior: Clip.hardEdge,
                      borderRadius: BorderRadius.circular(50),
                      child: CachedNetworkImage(
                        imageUrl: widget.userRole['userAvatar'],
                        fit: BoxFit.cover,
                        height: 30,
                        width: 30,
                      ),
                    ),
            ),
            //Icon(Icons.account_circle_rounded),
            label: currentuser == null
                ? 'Account'
                : widget.userRole['userDisplayName'].toUpperCase(),
          ),
        ],
      ),
      body: <Widget>[
        publicHomeList(),
        publicProfil(
          userRole: widget.userRole,
        ),
        //estimateik(),
      ][currentPageIndex],
    );
  }
}
