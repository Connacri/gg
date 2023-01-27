import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'Estimate.dart';

class dealer extends StatefulWidget {
  const dealer({Key? key}) : super(key: key);

  @override
  State<dealer> createState() => _dealerState();
}

class _dealerState extends State<dealer> {
  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
            stream: FirebaseFirestore.instance
                .collection('users')
                .doc('Ramzy')
                .collection('Coins')
                .doc('RamziGuedouar')
                //  .get(),
                .snapshots(),
            builder: (BuildContext,
                AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snap) {
              if (snap.hasError) {
                return Center(child: Text("Something went wrong"));
              }

              if (snap.hasData && !snap.data!.exists) {
                return Center(child: Text("Document does not exist"));
              }

              if (snap.connectionState == ConnectionState.done) {
                Map<String, dynamic> data =
                    snap.data!.data() as Map<String, dynamic>;
                print(data);
                return Center(child: Text("Amount: ${data['Amount']}"));
              }

              return Center(child: Text("loading..."));
            }),
        IconButton(
          onPressed: () {
            addCoin('RamziGuedouar', 33.22);
          },
          icon: const Icon(Icons.ac_unit_rounded),
        ),
      ],
    ));
    //   Column(
    //   children: [
    //     Expanded(
    //       child: StreamBuilder(
    //           stream:
    //               FirebaseFirestore.instance.collection('Dealer').snapshots(),
    //           builder: (BuildContext context,
    //               AsyncSnapshot<QuerySnapshot> snapshot) {
    //             if (snapshot.hasError) {
    //               return Center(
    //                 child: Text("Something is wrong"),
    //               );
    //             }
    //             try {
    //               if (snapshot.data!.docs.length == 0) {
    //                 return Scaffold(
    //                     backgroundColor: Colors.white,
    //                     body: Padding(
    //                       padding: const EdgeInsets.all(58.0),
    //                       child: Center(
    //                         child: Lottie.asset(
    //                             'assets/lotties/103142-motorcycle-skeleton.json',
    //                             fit: BoxFit.contain),
    //                       ),
    //                     ));
    //               }
    //             } catch (exception) {}
    //
    //             return Scaffold(
    //               appBar: AppBar(
    //                 toolbarHeight: 90.0,
    //                 title: Text('Estimate'),
    //                 actions: [
    //                   IconButton(
    //                     icon: const Icon(Icons.account_balance_sharp),
    //                     onPressed: () {
    //                       List LLIst = snapshot.data!.docs
    //                           .map((DocumentSnapshot document) {
    //                         Map<String, dynamic> data =
    //                             document.data()! as Map<String, dynamic>;
    //                         return data;
    //                       }).toList();
    //
    //                       double summ = 0;
    //                       var ds = snapshot.data!.docs;
    //
    //                       for (int i = 0; i < ds.length; i++) {
    //                         summ +=
    //                             (ds[i]['prixVente']).toInt() * (ds[i]['qty']);
    //                       }
    //
    //                       double cout = 0;
    //                       for (int i = 0; i < ds.length; i++) {
    //                         cout += ds[i]['prixAchat'] * (ds[i]['qty']);
    //                       }
    //                       double countEarn = 0;
    //                       for (int i = 0; i < ds.length; i++) {
    //                         countEarn += ds[i]['earn'] * (ds[i]['qty']);
    //                       }
    //                     },
    //                   ),
    //                 ],
    //               ),
    //               body: ListView(
    //                 children: [
    //                   ListView.builder(
    //                       shrinkWrap: true,
    //                       itemCount: snapshot.data == null
    //                           ? 0
    //                           : snapshot.data!.docs.length,
    //                       itemBuilder: (_, index) {
    //                         DocumentSnapshot _documentSnapshot =
    //                             snapshot.data!.docs[index];
    //                         double sum = 0.0;
    //                         var ds = snapshot.data!.docs;
    //
    //                         return Slidable(
    //                           key: const Key('keyslidable'),
    //                           closeOnScroll: true,
    //                           endActionPane: ActionPane(
    //                             extentRatio: 0.25,
    //                             motion: const StretchMotion(),
    //                             children: [
    //                               SlidableAction(
    //                                 onPressed: (Context) async {
    //                                   print(_documentSnapshot.id);
    //                                 },
    //                                 backgroundColor: Colors.red,
    //                                 foregroundColor: Colors.white,
    //                                 icon: Icons.delete,
    //                                 label: 'Delete',
    //                               ),
    //                             ],
    //                           ),
    //                           startActionPane: ActionPane(
    //                             extentRatio: 0.25,
    //                             motion: const StretchMotion(),
    //                             children: [
    //                               SlidableAction(
    //                                 onPressed: (Context) async {},
    //                                 backgroundColor: Colors.green,
    //                                 foregroundColor: Colors.white,
    //                                 icon: Icons.edit,
    //                                 label: 'Edit',
    //                               ),
    //                             ],
    //                           ),
    //                           child: ListTile(
    //                             trailing: Column(
    //                               crossAxisAlignment: CrossAxisAlignment.end,
    //                               children: [
    //                                 Text(
    //                                   NumberFormat.currency(
    //                                           //locale: 'aed',
    //                                           symbol: '')
    //                                       .format(
    //                                           (_documentSnapshot['prixVente'] *
    //                                               _documentSnapshot['qty'])),
    //                                   // .toString() +  '0',
    //                                   style: TextStyle(fontSize: 20),
    //                                 ),
    //                                 Text(
    //                                   NumberFormat.currency(symbol: '').format(
    //                                       _documentSnapshot[
    //                                           'prixVente']), //.toString() + '0'),
    //                                 )
    //                               ],
    //                             ),
    //                             leading: CircleAvatar(
    //                               child: FittedBox(
    //                                 child: Text(
    //                                     _documentSnapshot['qty'].toString()),
    //                               ),
    //                             ),
    //                             title: Text(
    //                               _documentSnapshot['model'],
    //                               overflow: TextOverflow.ellipsis,
    //                             ),
    //                             subtitle: Text(
    //                               'Size : ' + _documentSnapshot['size'],
    //                               overflow: TextOverflow.ellipsis,
    //                             ),
    //                           ),
    //                         );
    //                       }),
    //                 ],
    //               ),
    //             );
    //           }),
    //     ),
    //   ],
    // );
  }
}
