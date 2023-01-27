import 'dart:core';
import 'dart:math';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutterflow_paginate_firestore/paginate_firestore.dart';
import 'package:flutterflow_paginate_firestore/widgets/bottom_loader.dart';
import 'package:flutterflow_paginate_firestore/widgets/empty_display.dart';
import 'package:flutterflow_paginate_firestore/widgets/empty_separator.dart';
import 'package:flutterflow_paginate_firestore/widgets/initial_loader.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../rmz/Oauth/AuthPage.dart';
import '../rmz/detailItem.dart';
import 'testjason2firestoreGet.dart';

class publicHomeList extends StatefulWidget {
  const publicHomeList({Key? key}) : super(key: key);

  @override
  State<publicHomeList> createState() => _publicHomeListState();
}

class _publicHomeListState extends State<publicHomeList> {
  late TextTheme textTheme;
  final navigatorKey = GlobalKey<NavigatorState>();
  final GlobalKey<FormState> _formKeyQty = GlobalKey<FormState>();

  Color colorRed = Color.fromARGB(255, 213, 2, 2); //Colors.deepPurple;
  Color colorOrange =
      Color.fromARGB(255, 255, 95, 0); //Colors.deepOrangeAccent;
  Color colorGreen = Color.fromARGB(255, 139, 169, 2); //Colors.greenAccent;
  Color colorBlue = Color.fromARGB(255, 66, 58, 41); //Colors.blueAccent;

  Color color1 = const Color.fromARGB(255, 243, 236, 216);
  Color color2 = const Color.fromARGB(255, 127, 136, 106);
  Color color3 = const Color.fromARGB(255, 62, 80, 60);
  final url = 'https://www.youtube.com/watch?v=ZV5HEqyXmUY';
  @override
  void initState() {
    // getdatata();
    super.initState();

    final videoId = YoutubePlayer.convertUrlToId(url);
    ControllerYoutube = YoutubePlayerController(
        initialVideoId: videoId!,
        flags: const YoutubePlayerFlags(
          mute: false,
          loop: true,
          autoPlay: false,
        ));
  }

  User? user = FirebaseAuth.instance.currentUser;

  late YoutubePlayerController ControllerYoutube;
  @override
  void desativate() {
    ControllerYoutube.pause();
    super.deactivate();
  }

  @override
  void dispose() {
    ControllerYoutube.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        centerTitle: true,
        title: Text('Call AdventureGG'),
        actions: [
          IconButton(
              icon: Icon(
                Icons.call,
                color: Colors.green,
              ),
              onPressed: () async {
                final Uri launchUrlR =
                    Uri(scheme: 'Tel', path: ' +971566129156');
                if (await canLaunchUrl(launchUrlR)) {
                  await launchUrl(launchUrlR);
                } else {
                  print('This Call Cant execute');
                }
              }),
          IconButton(
              icon: Icon(
                FontAwesomeIcons.whatsapp,
                color: Colors.green,
              ),
              onPressed: () async {
                // final Uri whatsapp = Uri(scheme: 'Tel', path: ' +971566129156');
                // final Uri whatsappURl_android = Uri(
                //     scheme: 'Tel',
                //     path: 'whatsapp://send?phone=+${whatsapp}+&text=hello');
                //
                // if (await canLaunchUrl(whatsappURl_android)) {
                //   await launchUrl(whatsappURl_android);
                // } else {
                //   ScaffoldMessenger.of(context).showSnackBar(
                //       SnackBar(content: new Text("whatsapp no installed")));
                // }

                var phone = 00971566129156;
                String msg = 'Hello AdventureGG';
                var whatsappUrl = "whatsapp://send?phone=${phone}" +
                    "&text=${Uri.encodeComponent(msg)}";

                final Uri launchUrlRW = Uri(
                    scheme: 'Tel',
                    path: "whatsapp://send?phone=${phone}" +
                        "&text=${Uri.encodeComponent(msg)}");
                try {
                  launch(whatsappUrl);
                } catch (e) {
                  //To handle error and display error message
                  print("Unable to open whatsapp");
                }
              }),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: PaginateFirestore(
            header: SliverToBoxAdapter(
              child: Column(
                children: [
                  user == null
                      ? Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 70.0),
                          child: Card(
                            // margin: const EdgeInsets.all(5),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            clipBehavior: Clip.antiAliasWithSaveLayer,
                            elevation: 5,
                            child: Stack(
                              children: [
                                ShaderMask(
                                  shaderCallback: (rect) {
                                    return const LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomLeft,
                                      colors: [
                                        Colors.transparent,
                                        Colors.black
                                      ],
                                    ).createShader(Rect.fromLTRB(
                                        0, 0, rect.width, rect.height));
                                  },
                                  blendMode: BlendMode.darken,
                                  child: Container(
                                    height: 50,
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        image: CachedNetworkImageProvider(
                                          'https://firebasestorage.googleapis.com/v0/b/adventure-eb4ca.appspot.com/o/wall%2Fwall%20(4).jpg?alt=media&token=c5c01dca-4b32-4b9d-88fe-717e976ac2f5',
                                        ),
                                        fit: BoxFit.cover,
                                        alignment: Alignment.topCenter,
                                      ),
                                    ),
                                  ),
                                ),
                                Center(
                                  child: TextButton(
                                    onPressed: () {
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  AuthPage()));
                                    },
                                    child: Text(
                                      'Google Sign in',
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.white),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      : Container(),
                  ShaderMask(
                    shaderCallback: (rect) {
                      return const LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomLeft,
                        colors: [Colors.transparent, Colors.black],
                      ).createShader(
                          Rect.fromLTRB(0, 0, rect.width, rect.height));
                    },
                    blendMode: BlendMode.darken,
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 8),
                      height: 210,
                      child: YoutubePlayerBuilder(
                          player: YoutubePlayer(
                            controller: ControllerYoutube,
                            showVideoProgressIndicator: true,
                            aspectRatio: 16 / 9,
                            // thumbnail: CachedNetworkImage(
                            //   fit: BoxFit.cover,
                            //   imageUrl:
                            //       'https://images.unsplash.com/photo-1533112050809-b85548ba39c4?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=871&q=80',
                            // ),
                            onReady: () => debugPrint(
                                'Readyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyy'),
                          ),
                          builder: (context, player) => ListView(
                                children: [
                                  player,
                                ],
                              )),
                    ),
                  ),
                  Container(
                    height: 200,
                    child: StreamBuilder(
                        stream: FirebaseFirestore.instance
                            .collection('Users')
                            .snapshots(),
                        builder: (BuildContext context,
                            AsyncSnapshot<QuerySnapshot> snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Text('');
                          } else {
                            return //Text(snapshot.data!.size.toString());
                                Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: CarouselSlider.builder(
                                itemCount: snapshot.data!.docs.length,
                                itemBuilder: (BuildContext context, int index,
                                        int pageViewIndex) =>
                                    Card(
                                  // margin: const EdgeInsets.all(5),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                  clipBehavior: Clip.antiAliasWithSaveLayer,
                                  elevation: 5,
                                  child: Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      ShaderMask(
                                        shaderCallback: (rect) {
                                          return const LinearGradient(
                                            begin: Alignment.topCenter,
                                            end: Alignment.bottomLeft,
                                            colors: [
                                              Colors.transparent,
                                              Colors.black
                                            ],
                                          ).createShader(Rect.fromLTRB(
                                              0, 0, rect.width, rect.height));
                                        },
                                        blendMode: BlendMode.darken,
                                        child: Container(
                                          decoration: BoxDecoration(
                                            image: DecorationImage(
                                              image: CachedNetworkImageProvider(
                                                'https://firebasestorage.googleapis.com/v0/b/adventure-eb4ca.appspot.com/o/wall%2Fwall%20(${index}).jpg?alt=media&token=c5c01dca-4b32-4b9d-88fe-717e976ac2f5',
                                              ),
                                              fit: BoxFit.cover,
                                              alignment: Alignment.topCenter,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        height: 250,
                                        width: 100,
                                        // decoration: BoxDecoration(
                                        //   image: DecorationImage(
                                        //     image: NetworkImage(
                                        //       'https://firebasestorage.googleapis.com/v0/b/adventure-eb4ca.appspot.com/o/carre%2Fcarre%20(${inte}).jpg?alt=media&token=fbcb6223-39c8-4ed7-9b62-13acac60fe94',
                                        //     ),
                                        //     fit: BoxFit.cover,
                                        //   ),
                                        // ),
                                        child: ClipRRect(
                                          // make sure we apply clip it properly
                                          child: BackdropFilter(
                                            filter: ImageFilter.blur(
                                                sigmaX: 3, sigmaY: 3),
                                            child: Container(
                                              padding: EdgeInsets.all(15),
                                              alignment: Alignment.center,
                                              color:
                                                  Colors.grey.withOpacity(0.1),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(top: 15.0),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            UnsplashAvatar(
                                                UnsplashUrl: snapshot.data!
                                                    .docs[index]['userAvatar']),
                                            Container(
                                              width: 90,
                                              child: FittedBox(
                                                child: RatingBar.builder(
                                                  initialRating: double.parse(
                                                      snapshot
                                                          .data!
                                                          .docs[index]
                                                              ['userItemsNbr']
                                                          .toString()),
                                                  ignoreGestures: true,
                                                  minRating: 1,
                                                  direction: Axis.horizontal,
                                                  allowHalfRating: true,
                                                  itemCount: 5,
                                                  itemPadding:
                                                      EdgeInsets.symmetric(
                                                          horizontal: 4.0),
                                                  itemBuilder: (context, _) =>
                                                      Icon(
                                                    Icons.star,
                                                    color: Colors.amber,
                                                  ),
                                                  onRatingUpdate: (rating) {
                                                    print(rating);
                                                  },
                                                ),
                                              ),
                                            ),
                                            Container(
                                              width: 80,
                                              height: 40,
                                              child: FittedBox(
                                                child: Text(
                                                  snapshot
                                                      .data!
                                                      .docs[index]
                                                          ['userDisplayName']
                                                      .toString()
                                                      .toUpperCase(),
                                                  style: TextStyle(
                                                      color: Colors.white70,
                                                      fontSize: 28,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ),
                                            ),
                                            snapshot.data!.docs[index]
                                                        ['userRole'] ==
                                                    'admin'
                                                ? ShaderMask(
                                                    blendMode: BlendMode.srcIn,
                                                    shaderCallback: (Rect
                                                            bounds) =>
                                                        LinearGradient(
                                                          colors: <Color>[
                                                            Colors.red,
                                                            Colors.yellowAccent,
                                                            Color.fromRGBO(246,
                                                                132, 2, 1.0),
                                                          ],
                                                          begin:
                                                              Alignment.topLeft,
                                                          end: Alignment
                                                              .bottomRight,
                                                        ).createShader(bounds),
                                                    child: Text(
                                                      snapshot
                                                          .data!
                                                          .docs[index]
                                                              ['userRole']
                                                          .toString()
                                                          .toUpperCase(),
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 20,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ))
                                                : Text(
                                                    snapshot.data!
                                                        .docs[index]['userRole']
                                                        .toString()
                                                        .toUpperCase(),
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 20,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                options: CarouselOptions(
                                  //height: 400,
                                  aspectRatio: 16 / 9,
                                  viewportFraction: 0.8,
                                  initialPage: 0,
                                  enableInfiniteScroll: true,
                                  reverse: false,
                                  autoPlay: true,
                                  autoPlayInterval: Duration(seconds: 3),
                                  autoPlayAnimationDuration:
                                      Duration(milliseconds: 800),
                                  autoPlayCurve: Curves.fastOutSlowIn,
                                  enlargeCenterPage: true,
                                  enlargeFactor: 0.3,
                                  //onPageChanged: callbackFunction,
                                  scrollDirection: Axis.horizontal,
                                ),
                              ),
                            );
                          }
                        }),
                  ),
                  Container(
                    height: 200.0,
                    child: ListView.builder(
                      shrinkWrap: true,
                      physics: BouncingScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      itemCount: 12,
                      itemBuilder: (BuildContext context, int index) {
                        return UnsplashSlider(
                          UnsplashUrl:
                              'https://firebasestorage.googleapis.com/v0/b/adventure-eb4ca.appspot.com/o/carre%2Fcarre%20(${index + 1}).jpg?alt=media&token=68e384f1-bb64-47cf-a245-9f7f12202443',
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            footer: SliverToBoxAdapter(
              child: Column(
                children: [
                  Container(
                    height: 200.0,
                    child: ListView.builder(
                      shrinkWrap: true,
                      physics: BouncingScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      itemCount: 16,
                      itemBuilder: (BuildContext context, int index) {
                        return UnsplashSlider(
                          UnsplashUrl:
                              'https://firebasestorage.googleapis.com/v0/b/adventure-eb4ca.appspot.com/o/mob%2Fmob%20(${index}).jpg?alt=media&token=e307d1db-a16f-42f9-a472-1f3a2f47ee79',
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            itemsPerPage: 10000,
            onEmpty: const EmptyDisplay(),
            separator: const EmptySeparator(),
            initialLoader: const InitialLoader(),
            bottomLoader: const BottomLoader(),
            shrinkWrap: true,
            isLive: true,
            itemBuilderType: PaginateBuilderType.gridView,
            query: FirebaseFirestore.instance.collection('Adventure'),
            //.orderBy('createdAt', descending: true),
            itemBuilder: (BuildContext, DocumentSnapshot, int) {
              var data = DocumentSnapshot[int].data() as Map?;
              String dataid = DocumentSnapshot[int].id;
              Random random = new Random();
              var randomNumber = random.nextInt(37);
              String randomPhoto =
                  'https://firebasestorage.googleapis.com/v0/b/adventure-eb4ca.appspot.com/o/carre%2Fcarre%20(${int}).jpg?alt=media&token=7347a738-f3f1-431b-a0f2-707238f4f1dc';

              return GestureDetector(
                onDoubleTap: () => Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => SilverdetailItem(
                    intex: int,
                    data: data,
                    UnsplashUrl: randomPhoto,
                  ),
                )),
                onTap: () async {
                  await showDetailPublic(data, int);
                },
                child: Card(
                  margin: const EdgeInsets.all(5),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  elevation: 5,
                  child: Stack(
                    children: [
                      ShaderMask(
                        shaderCallback: (rect) {
                          return const LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomLeft,
                            colors: [Colors.transparent, Colors.black],
                          ).createShader(
                              Rect.fromLTRB(0, 0, rect.width, rect.height));
                        },
                        blendMode: BlendMode.darken,
                        child: Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: CachedNetworkImageProvider(
                                'https://firebasestorage.googleapis.com/v0/b/adventure-eb4ca.appspot.com/o/tyres%2Ftyres%20(${randomNumber}).jpg?alt=media&token=291ec2fb-6013-45a0-8513-5611136125cb',
                              ),
                              fit: BoxFit.cover,
                              alignment: Alignment.topCenter,
                            ),
                          ),
                        ),
                      ),
                      GridTile(
                        header: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Center(
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.black54,
                                  borderRadius: BorderRadius.circular(8)),
                              padding: const EdgeInsets.all(5.0),
                              child: FittedBox(
                                child: Text(
                                  data!['category'],
                                  overflow: TextOverflow.fade,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                            ),
                          ),
                        ),
                        footer: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Center(
                            child: Text(
                              NumberFormat.currency(
                                      symbol: 'AED ', decimalDigits: 2)
                                  .format(data!['prixVente']),
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  //backgroundColor: Colors.black45,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.amberAccent,
                                  fontFamily: 'oswald'),
                            ),
                          ),
                        ),
                        child: Text(
                          '',
                          // data['code'],
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                      Positioned(
                        left: 8,
                        top: 40,
                        child: Center(
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.black54,
                                borderRadius: BorderRadius.circular(8)),
                            padding: const EdgeInsets.all(5.0),
                            child: Text(
                              data['code'],
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
      ),
    );
  }

  openwhatsapp() async {
    var whatsapp = "+919144040888";
    var whatsappURl_android =
        "whatsapp://send?phone=" + whatsapp + "&text=hello";

    // android , web
    if (await canLaunch(whatsappURl_android)) {
      await launch(whatsappURl_android);
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: new Text("whatsapp no installed")));
    }
  }

  Future showDetailPublic(data, int) => showDialog(
        context: context,
        builder: (context) => AlertDialog(
          //  backgroundColor: Colors.transparent,

          insetPadding: EdgeInsets.all(10),
          title: Center(
            child: Text(
              'Item : ${data['model'].toString()}'.toUpperCase(),
              style: TextStyle(
                fontSize: 15,
                color: colorBlue, // Colors.orange,
              ),
            ),
          ),

          content: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'codebar : ${data['codebar'].toString()}'.toUpperCase(),
              ),
              CachedNetworkImage(
                imageUrl:
                    'https://firebasestorage.googleapis.com/v0/b/adventure-eb4ca.appspot.com/o/tyres%2Ftyres%20(${int + 1}).jpg?alt=media&token=b3c6a2c0-c5ad-4433-95f2-60c42ebbc092',
                fit: BoxFit.cover,
                errorWidget: (context, url, error) => Image.network(
                    'https://img1.wsimg.com/isteam/ip/d48b4882-6d43-4aed-ac22-2834c9891797/4.jpg/:/rs=w:1300,h:800'),
              ),
              Text(
                'size : ${data['size'].toString()}'.toUpperCase(),
              ),
              Text(
                'origine : ${data['origine'].toString()}'.toUpperCase(),
              ),
              Text(
                NumberFormat.currency(symbol: 'AED ', decimalDigits: 2)
                    .format(data!['prixVente']),
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    //backgroundColor: Colors.black45,
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: Colors.green,
                    fontFamily: 'oswald'),
              ),
              Text(
                'Description : ${data['description'].toString()}'.toUpperCase(),
              ),
            ],
          ),
          actions: [
            Center(
              child: TextButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(colorRed),
                    foregroundColor: MaterialStateProperty.all(colorGreen),
                    minimumSize: MaterialStateProperty.all(const Size(200, 50)),
                    shape: MaterialStateProperty.all(
                      const RoundedRectangleBorder(
                        borderRadius: BorderRadius.zero, //.circular(30),
                      ),
                    ),
                  ),
                  onPressed: () {
                    Navigator.pop(context, false);
                  },
                  child: Text(
                    'Leave'.toUpperCase(),
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.red.shade100,
                    ),
                  )),
            )
          ],
        ),
      );
}

class UnsplashSlider extends StatelessWidget {
  const UnsplashSlider({
    Key? key,
    required this.UnsplashUrl,
  }) : super(key: key);

  final String UnsplashUrl;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => UnsplashSlider(
          UnsplashUrl: UnsplashUrl,
        ),
      )),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        elevation: 5,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        semanticContainer: true,
        child: ShaderMask(
          shaderCallback: (rect) {
            return const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomLeft,
              colors: [Colors.transparent, Colors.black],
            ).createShader(Rect.fromLTRB(0, 0, rect.width, rect.height));
          },
          blendMode: BlendMode.darken,
          child: CachedNetworkImage(
            fit: BoxFit.cover,
            imageUrl: UnsplashUrl,
            errorWidget: (context, url, error) => const Icon(
              Icons.error,
              color: Colors.red,
            ),
          ),
        ),
      ),
    );
  }
}
