import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:percent_indicator/percent_indicator.dart';

class MainPageik extends StatefulWidget {
  const MainPageik({Key? key}) : super(key: key);

  @override
  State<MainPageik> createState() => MainPageikState();
}

class MainPageikState extends State<MainPageik> {
  late Future<List<Item2>> itemsFuture;

  @override
  void initState() {
    super.initState();
    itemsFuture = getItems(context);
  }

  static Future<List<Item2>> getItems(BuildContext context) async {
    final assetBundle = DefaultAssetBundle.of(context);
    final data = await assetBundle.loadString('assets/GG.json');
    final body = json.decode(data);
    return body.map<Item2>(Item2.fromJson).toList();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('List With JSON'),
          centerTitle: true,
          actions: [
            // IconButton(
            //     onPressed: () async {
            //       Navigator.of(context).push(MaterialPageRoute(
            //           builder: (context) => mainPageFirestoreGetik()));
            //     },
            //     icon: Icon(Icons.adb)),
            FutureBuilder<List<Item2>>(
              future: itemsFuture,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final users = snapshot.data!;
                  return IconButton(
                      onPressed: () async {
                        await uploadItems(users);
                      },
                      icon: Icon(Icons.noise_control_off));
                } else {
                  return const Center(
                    child: Text('no'),
                  );
                }
              },
            ),
          ],
        ),
        body: Center(
            child: FutureBuilder<List<Item2>>(
          future: itemsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            if (snapshot.hasData) {
              final users = snapshot.data!;
              return Lottie.asset(
                  'assets/lotties/130621-mobile-social-share-links.json');
              // Text(users.length.toString(),
              //   style: TextStyle(fontSize: 40));
              //buildUsers(users);
            } else {
              return const Center(
                child: Text('no data fetchekkkd'),
              );
            }
          },
        )),
      );

  Widget buildUsers(List<Item2> users) => ListView.builder(
      itemCount: users.length,
      itemBuilder: (context, index) {
        final user = users[index];

        return Card(
          child: ListTile(
            leading: CircleAvatar(
              child: Text(user.stock.toString()),
            ),
            title: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Text(
                //   user.model,
                //   overflow: TextOverflow.ellipsis,
                // ),
                Text(
                  user.createdAt.toString(),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
            subtitle: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user.size.toString(),
                  overflow: TextOverflow.ellipsis,
                ),
                LinearPercentIndicator(
                  width: MediaQuery.of(context).size.width * 0.4,
                  animation: true,
                  lineHeight: 20.0,
                  animationDuration: 1000,
                  percent: user.stock > user.oldStock
                      ? 1
                      : user.stock / user.oldStock,
                  center: Text(
                    (user.stock * 100 / user.oldStock).toString() + '%',
                    style: TextStyle(),
                  ),
                  barRadius: Radius.circular(20.0),
                  progressColor: Colors.greenAccent,
                  backgroundColor: Colors.red,
                  restartAnimation: false,
                ),
              ],
            ),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  user.prixVente.toString() + '0 ',
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                Text(
                  'D : ' + user.code.toString() + '0 ',
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Colors.black45),
                ),
              ],
            ),
          ),
        );
      });

  uploadItems(List<Item2> users) async {
    final numbers = List.generate(users.length, (index) => index);

    for (final number in numbers) {
      final item = users[number];
      print('**************users[number]*****user.category*************');
      print(item.description);
      final postCollectionItemsSuperette = FirebaseFirestore.instance
          .collection('Adventure')
          .doc(item.codebar.toString())
          .withConverter<Item2>(
            fromFirestore: (snapshot, _) => Item2.fromJson(snapshot.data()!),
            toFirestore: (Item2, _) => Item2.toJson(),
          );
      print('withConverter');

      final postItem2 = Item2(
        createdAt: item.createdAt as DateTime,
        code: item.code as String,
        //Timestamp.now().toDate(),
        category: item.category as String,
        model: item.model as String,
        description: users[number].description as String,
        size: users[number].size as String,
        prixAchat: double.parse(users[number].prixAchat.toString()) * 3.68,
        prixVente: double.parse(users[number].prixVente.toString()),
        //prixDealer: double.parse(users[number].prixDealer.toString()),
        stock: users[number].stock as int,
        codebar: users[number].codebar.toString() as String,
        oldStock: users[number].oldStock as int,
        origine: users[number].origine as String,
        user: users[number].user as String,
      );
      print('model');

      postCollectionItemsSuperette
          .set(postItem2) //, SetOptions(merge: true))
          .then((value) => print("Item Added"))
          .catchError((error) => print("Failed to Add: $error"));
    }
  }
}

class Item2 {
  final String category;
  final String code;
  final String codebar;
  final DateTime createdAt;
  final String description;
  final String model;
  final int oldStock;
  final String origine;
  final double prixAchat;
  final double prixVente;
  final String size;
  final int stock;
  final String user;

  const Item2(
      {required this.category,
      required this.code,
      required this.codebar,
      required this.createdAt,
      required this.description,
      required this.model,
      required this.oldStock,
      required this.origine,
      required this.prixAchat,
      required this.prixVente,
      required this.size,
      required this.stock,
      required this.user});

  static Item2 fromJson(json) => Item2(
        createdAt: DateTime.parse(json['createdAt']!) as DateTime,
        code: json['code']! as String,
        category: json['category']! as String,
        model: json['model']! as String,
        description: json['description']! as String,
        size: json['size']! as String,
        prixAchat: double.parse(json['prixAchat']!.toString()),
        prixVente: double.parse(json['prixVente']!.toString()),
        stock: json['stock']! as int,
        oldStock: json['oldStock']! as int,
        codebar: json['codebar']!.toString() as String,
        origine: json['origine']! as String,
        user: json['user']! as String,
      );

  Map<String, Object?> toJson() => {
        'createdAt': createdAt, //*****

        ///***************** verifier sa !!!!!!!!!!!!!!!!!!!!!!
        'code': code,
        'category': category,
        'model': model,
        'description': description,
        'size': size,
        'prixAchat': prixAchat,
        'prixVente': prixVente,
        'stock': stock,
        'oldStock': oldStock,
        'codebar': codebar,
        'origine': origine,
        'user': user,
      };
}
