import 'package:flutter/material.dart';

import 'ik/PublicHomeLIst.dart';
import 'rmz/Oauth/AuthPage.dart';

class main_out extends StatelessWidget {
  const main_out({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //return const AuthPage();
    // return MyHomePage();
    //return publicNavigation();
    return Home();
  }
}

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const publicHomeList();
  }
}

class publicNavigation extends StatefulWidget {
  const publicNavigation({super.key});

  @override
  State<publicNavigation> createState() => _publicNavigationState();
}

class _publicNavigationState extends State<publicNavigation> {
  int currentPageIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: NavigationBar(
        backgroundColor: Colors.transparent,
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
            selectedIcon: Icon(Icons.account_circle_rounded),
            icon: ClipRRect(
                clipBehavior: Clip.hardEdge,
                borderRadius: BorderRadius.circular(50),
                child: const Icon(Icons.account_circle)),
            //Icon(Icons.account_circle_rounded),
            label: 'Account',
          ),
        ],
      ),
      body: <Widget>[
        publicHomeList(),
        //estimateik(),
        AuthPage(),
      ][currentPageIndex],
    );
  }
}
