// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_slidable/flutter_slidable.dart';
// import 'package:intl/intl.dart';
// import 'package:number_slide_animation/number_slide_animation.dart';
// import 'package:paginate_firestore/paginate_firestore.dart';
// import 'package:paginate_firestore/widgets/bottom_loader.dart';
// import 'package:paginate_firestore/widgets/empty_display.dart';
// import 'package:paginate_firestore/widgets/empty_separator.dart';
// import 'package:paginate_firestore/widgets/initial_loader.dart';
// import 'package:percent_indicator/percent_indicator.dart';
//
// import 'QrScanner.dart';
//
// class tetjson2firestoreGetPovider extends StatelessWidget {
//   Color color1 = const Color.fromARGB(255, 243, 236, 216);
//   Color color2 = const Color.fromARGB(255, 127, 136, 106);
//   Color color3 = const Color.fromARGB(255, 62, 80, 60);
//   final TextEditingController _modelController = TextEditingController();
//   final TextEditingController _categoryController = TextEditingController();
//   final TextEditingController _sizeController = TextEditingController();
//   final TextEditingController _descriptionController = TextEditingController();
//   final TextEditingController _stockController = TextEditingController();
//   final TextEditingController _prixAchatController = TextEditingController();
//   final TextEditingController _prixVenteController = TextEditingController();
//   final TextEditingController _origineController = TextEditingController();
//
//   final TextEditingController _userController = TextEditingController();
//   final TextEditingController _codeController = new TextEditingController()
//     ..text; // = data{'code'};
//   final TextEditingController _oldStockController = TextEditingController();
//   final TextEditingController _codebarController = TextEditingController();
//
//   late TextTheme textTheme;
//
//   final GlobalKey<FormState> _formKeyQty = GlobalKey<FormState>();
//   final TextEditingController _qtyController =
//       TextEditingController(text: '01');
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         leading: IconButton(
//           icon: const Icon(Icons.qr_code),
//           onPressed: () {
//             Navigator.of(context).push(MaterialPageRoute(
//               builder: (context) => qrScannerik(),
//             ));
//           },
//         ),
//         actions: [
//           // Padding(
//           //   padding: const EdgeInsets.all(18.0),
//           //   child: Text(Provider.of<StreamRamzy>(context).geto().toString()),
//           // ),
//         ],
//       ),
//       body: PaginateFirestore(
//           header: SliverToBoxAdapter(
//             child: Column(
//               children: [
//                 Container(
//                   height: MediaQuery.of(context).size.height / 10,
//                   width: MediaQuery.of(context).size.width,
//                   child: Center(
//                     child: StreamBuilder(
//                         stream: FirebaseFirestore.instance
//                             .collection('Adventure')
//                             .snapshots(),
//                         builder: (BuildContext context, snapshot) {
//                           if (snapshot.connectionState ==
//                               ConnectionState.waiting) {
//                             // return Padding(
//                             //   padding: const EdgeInsets.all(18.0),
//                             //   child: LinearProgressIndicator(
//                             //     color: Colors.blueGrey,
//                             //   ),
//                             // );
//                             return ListView(
//                               shrinkWrap: true,
//                               physics: NeverScrollableScrollPhysics(),
//                               children: [
//                                 Row(
//                                   mainAxisAlignment:
//                                       MainAxisAlignment.spaceAround,
//                                   crossAxisAlignment: CrossAxisAlignment.center,
//                                   children: [
//                                     Column(
//                                       children: [
//                                         Text(
//                                           'Total'.toUpperCase().trim(),
//                                         ),
//                                         Text(
//                                           '00',
//                                           style: TextStyle(fontSize: 30),
//                                         ),
//                                       ],
//                                     ),
//                                     Column(
//                                       children: [
//                                         Text(
//                                           'Stock'.toUpperCase().trim(),
//                                           style: TextStyle(color: Colors.green),
//                                         ),
//                                         Text(
//                                           '00',
//                                           style: TextStyle(
//                                               fontSize: 30,
//                                               color: Colors.green),
//                                         ),
//                                       ],
//                                     ),
//                                     Column(
//                                       children: [
//                                         Text(
//                                           'Alert'.toUpperCase().trim(),
//                                           style:
//                                               TextStyle(color: Colors.orange),
//                                         ),
//                                         Text(
//                                           '00',
//                                           style: TextStyle(
//                                               fontSize: 30,
//                                               color: Colors.orange),
//                                         ),
//                                       ],
//                                     ),
//                                     Column(
//                                       children: [
//                                         Text(
//                                           'Out'.toUpperCase().trim(),
//                                           style: TextStyle(color: Colors.red),
//                                         ),
//                                         Text(
//                                           '00',
//                                           style: TextStyle(
//                                               fontSize: 30, color: Colors.red),
//                                         ),
//                                       ],
//                                     ),
//                                   ],
//                                 ),
//                               ],
//                             );
//                           } else {
//                             var data = snapshot.data!.docs;
//
//                             final List<DocumentSnapshot> min5 = data
//                                 .where((DocumentSnapshot documentSnapshot) =>
//                                     documentSnapshot['stock'] <= 5 &&
//                                     documentSnapshot['stock'] > 0)
//                                 .toList();
//                             final int count5 = min5.length;
//                             print(count5);
//                             final List<DocumentSnapshot> min0 = data
//                                 .where((DocumentSnapshot documentSnapshot) =>
//                                     documentSnapshot['stock'] == 0)
//                                 .toList();
//                             final int count0 = min0.length;
//                             print(count0);
//                             return ListView(
//                               shrinkWrap: true,
//                               physics: NeverScrollableScrollPhysics(),
//                               children: [
//                                 Row(
//                                   mainAxisAlignment:
//                                       MainAxisAlignment.spaceAround,
//                                   crossAxisAlignment: CrossAxisAlignment.center,
//                                   children: [
//                                     Column(
//                                       children: [
//                                         Text(
//                                           'Total'.toUpperCase().trim(),
//                                         ),
//                                         NumberSlideAnimation(
//                                           number: data.length.toString(),
//                                           duration: const Duration(seconds: 1),
//                                           curve: Curves.decelerate,
//                                           textStyle: TextStyle(
//                                             fontSize: 30.0,
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                     GestureDetector(
//                                       onTap: () {
//                                         Navigator.of(context)
//                                             .push(MaterialPageRoute(
//                                           builder: (context) => StockPage(
//                                               pageQuery: FirebaseFirestore
//                                                   .instance
//                                                   .collection('Adventure')
//                                                   .where('stock',
//                                                       isGreaterThan: 0)),
//                                         ));
//                                       },
//                                       child: Column(
//                                         children: [
//                                           Text(
//                                             'Stock'.toUpperCase().trim(),
//                                             style:
//                                                 TextStyle(color: Colors.green),
//                                           ),
//                                           IgnorePointer(
//                                             child: NumberSlideAnimation(
//                                               number: (data.length - count0)
//                                                   .toString(),
//                                               duration:
//                                                   const Duration(seconds: 1),
//                                               curve: Curves.decelerate,
//                                               textStyle: TextStyle(
//                                                   fontSize: 30.0,
//                                                   color: Colors.green),
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                     GestureDetector(
//                                       onTap: () {
//                                         Navigator.of(context)
//                                             .push(MaterialPageRoute(
//                                           builder: (context) => StockPage(
//                                               pageQuery: FirebaseFirestore
//                                                   .instance
//                                                   .collection('Adventure')
//                                                   .where('stock',
//                                                       isGreaterThan: 0)
//                                                   .where('stock',
//                                                       isLessThanOrEqualTo: 5)),
//                                         ));
//                                       },
//                                       child: Column(
//                                         children: [
//                                           Text(
//                                             'Alert'.toUpperCase().trim(),
//                                             style:
//                                                 TextStyle(color: Colors.orange),
//                                           ),
//                                           IgnorePointer(
//                                             child: NumberSlideAnimation(
//                                               number: count5.toString(),
//                                               duration:
//                                                   const Duration(seconds: 1),
//                                               curve: Curves.decelerate,
//                                               textStyle: TextStyle(
//                                                   fontSize: 30.0,
//                                                   color: Colors.orange),
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                     GestureDetector(
//                                       onTap: () {
//                                         Navigator.of(context)
//                                             .push(MaterialPageRoute(
//                                           builder: (context) => StockPage(
//                                               pageQuery: FirebaseFirestore
//                                                   .instance
//                                                   .collection('Adventure')
//                                                   .where('stock',
//                                                       isLessThanOrEqualTo: 0)),
//                                         ));
//                                       },
//                                       child: Column(
//                                         children: [
//                                           Text(
//                                             'Out'.toUpperCase().trim(),
//                                             style: TextStyle(color: Colors.red),
//                                           ),
//                                           IgnorePointer(
//                                             child: NumberSlideAnimation(
//                                               number: count0.toString(),
//                                               duration:
//                                                   const Duration(seconds: 1),
//                                               curve: Curves.decelerate,
//                                               textStyle: TextStyle(
//                                                   fontSize: 30.0,
//                                                   color: Colors.red),
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ],
//                             );
//                           }
//                         }),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           itemsPerPage: 10000,
//           onEmpty: const EmptyDisplay(),
//           separator: const EmptySeparator(),
//           initialLoader: const InitialLoader(),
//           bottomLoader: const BottomLoader(),
//           shrinkWrap: true,
//           isLive: true,
//           itemBuilderType: PaginateBuilderType.listView,
//           query: FirebaseFirestore.instance.collection('Adventure'),
//           //.orderBy('createdAt', descending: true),
//           itemBuilder: (BuildContext, DocumentSnapshot, int) {
//             var data = DocumentSnapshot[int].data() as Map?;
//             String dataid = DocumentSnapshot[int].id;
//             return Slidable(
//               key: const Key('keyslidable'),
//               endActionPane: ActionPane(
//                 motion: const StretchMotion(),
//                 children: [
//                   SlidableAction(
//                     // An action can be bigger than the others.
//                     flex: 2,
//                     onPressed: (Context) async {
//                       await showAlertDialog(context, data, dataid);
//                     },
//                     backgroundColor: const Color.fromARGB(255, 255, 0, 0),
//                     foregroundColor: Colors.white,
//                     icon: Icons.delete,
//                     label: 'Delete',
//                   ),
//                 ],
//               ),
//               child: Center(
//                 child: Card(
//                   child: Row(
//                     children: [
//                       Expanded(
//                         flex: 2,
//                         child: Padding(
//                           padding: const EdgeInsets.fromLTRB(10, 10, 0, 10),
//                           child: Stack(
//                             alignment: AlignmentDirectional.center,
//                             children: [
//                               CircleAvatar(
//                                 backgroundColor: data!['stock'] <= 5
//                                     ? data['stock'] != 0
//                                         ? color2
//                                         : Colors.red
//                                     : null,
//                                 radius: 25,
//                                 child: FittedBox(
//                                   child: Padding(
//                                     padding: const EdgeInsets.all(8.0),
//                                     child: Text(
//                                       data['stock'].toString().toUpperCase(),
//                                       style: TextStyle(
//                                           color: data['stock'] <= 5
//                                               ? data['stock'] != 0
//                                                   ? Colors.red
//                                                   : Colors.white
//                                               : Colors.white,
//                                           fontSize: 20),
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                               CircularPercentIndicator(
//                                 animation: true,
//                                 animationDuration: 1000,
//                                 percent: data['stock'] > data['oldStock']
//                                     ? 1
//                                     : data['stock'] / data['oldStock'],
//                                 progressColor: Colors.greenAccent,
//                                 backgroundColor: Colors.red,
//                                 radius: 26.0,
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                       Expanded(
//                         flex: 8,
//                         child: Padding(
//                           padding: EdgeInsets.all(10),
//                           //.fromLTRB(15, 10, 0, 10),
//                           child: Column(
//                             mainAxisAlignment: MainAxisAlignment.start,
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Text(
//                                 data['model'].toString(),
//                                 overflow: TextOverflow.ellipsis,
//                               ),
//                               Text(
//                                 data['size'].toString(),
//                                 overflow: TextOverflow.ellipsis,
//                               ),
//                               FittedBox(
//                                 child: LinearPercentIndicator(
//                                   trailing: Text(
//                                     (data['stock'] * 100 / data['oldStock'])
//                                             .toString() +
//                                         '%',
//                                     style: TextStyle(fontSize: 25),
//                                   ),
//                                   width: MediaQuery.of(context).size.width,
//                                   animation: true,
//                                   lineHeight: 25.0,
//                                   animationDuration: 1000,
//                                   percent: data['stock'] > data['oldStock']
//                                       ? 1
//                                       : data['stock'] / data['oldStock'],
//                                   center: Text(
//                                     (data['stock'] * 100 / data['oldStock'])
//                                             .toString() +
//                                         '%',
//                                     style: TextStyle(),
//                                   ),
//                                   barRadius: Radius.circular(20.0),
//                                   progressColor: Colors.greenAccent,
//                                   backgroundColor: Colors.red,
//                                   restartAnimation: false,
//                                 ),
//                               )
//                             ],
//                           ),
//                         ),
//                       ),
//                       Expanded(
//                         flex: 3,
//                         child: Padding(
//                           padding: const EdgeInsets.fromLTRB(0, 10, 10, 10),
//                           child: Column(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             crossAxisAlignment: CrossAxisAlignment.end,
//                             children: [
//                               Text(
//                                 NumberFormat.currency(symbol: '')
//                                     .format(data['prixVente']),
//                                 overflow: TextOverflow.ellipsis,
//                                 style: TextStyle(
//                                     fontSize: 18, fontWeight: FontWeight.w500),
//                               ),
//                               Text(
//                                 NumberFormat.currency(symbol: '')
//                                     .format(data['prixVente'] * 0.8),
//                                 overflow: TextOverflow.ellipsis,
//                                 style: TextStyle(
//                                     fontSize: 12,
//                                     fontWeight: FontWeight.w500,
//                                     color: Colors.blueGrey),
//                               ),
//                               Text(
//                                 NumberFormat.currency(symbol: '')
//                                     .format(data['prixAchat']),
//                                 overflow: TextOverflow.ellipsis,
//                                 style: TextStyle(
//                                     fontSize: 12,
//                                     fontWeight: FontWeight.w500,
//                                     color: Colors.blueGrey),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             );
//           }),
//     );
//   }
//
//   Future<void> addItemsToDevis2(dataid, data, qty) async {
//     CollectionReference devisitem =
//         FirebaseFirestore.instance.collection('Estimate');
//
//     CollectionReference incrementQty =
//         FirebaseFirestore.instance.collection('Adventure');
//
//     DocumentSnapshot<Map<String?, dynamic>> document = await FirebaseFirestore
//         .instance
//         .collection('Estimate')
//         .doc(dataid)
//         .get();
//
//     if (!document.exists) {
//       return devisitem
//           .doc(dataid)
//           .set({
//             'createdAt': Timestamp.now().toDate(),
//             'category': data['category'],
//             'model': data['model'],
//             'description': data['description'],
//             'size': data['size'],
//             'prixAchat': data['prixAchat'],
//             'prixVente': data['prixVente'],
//             'prixDealer': data['prixDealer'],
//             'stock': data['stock'],
//             'codebar': data['codebar'],
//             'oldStock': data['oldStock'],
//             'origine': data['origine'],
//             'user': data['user'],
//             'qty': int.parse(qty),
//           }, SetOptions(merge: true))
//           .then((value) => print("Item Added to Devis"))
//           .catchError((error) => print("Failed to add Item to Devis: $error"))
//           .whenComplete(() => incrementQty
//               .doc(dataid)
//               .update({'stock': FieldValue.increment(-int.parse(qty))}));
//     } else {
//       print('kayen deja/////////////////////');
//       return devisitem
//           .doc(dataid)
//           .update({'qty': FieldValue.increment(int.parse(qty))})
//           .then((value) => print("Item update to Estimate"))
//           .catchError(
//               (error) => print("Failed to update Item to Estimate: $error"))
//           .whenComplete(() => incrementQty
//               .doc(dataid)
//               .update({'stock': FieldValue.increment(-int.parse(qty))}))
//           .then((value) =>
//               print('**********************************update c bon'));
//     }
//   }
// }
//
// // class RowClass extends StatelessWidget {
// //   const RowClass({Key? key}) : super(key: key);
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Padding(
// //       padding: const EdgeInsets.all(30.0),
// //       child: Row(
// //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //         children: [
// //           Text(Provider.of<StreamRamzy>(context).ListTata.toString()),
// //           // Text((str.ListTata.length - str.ListCount0.length).toString()),
// //           // Text(str.ListCount5.length.toString()),
// //           // Text(str.ListCount0.length.toString()),
// //         ],
// //       ),
// //     );
// //   }
// // }
//
// showAlertDialog(BuildContext context, data, dataid) {
//   // set up the buttons
//   Widget cancelButton = ElevatedButton(
//     style: ButtonStyle(
//       backgroundColor: MaterialStateProperty.all(Colors.white),
//     ),
//     child: Text(
//       "Cancel",
//       style: TextStyle(color: Colors.red),
//     ),
//     onPressed: () => Navigator.pop(context, false),
//   );
//   Widget continueButton = TextButton(
//     child: Text(
//       "I'm Sure to Remove it",
//       style: TextStyle(color: Colors.white, fontSize: 10),
//     ),
//     //child: Text("Delete"),
//     onPressed: () {
//       FirebaseFirestore.instance.collection('Adventure').doc(dataid).delete();
//       // .update({'stock': FieldValue.increment(data['qty'])}).whenComplete(
//       //     () => FirebaseFirestore.instance
//       //         .collection('Estimate') //.collection('cart')
//       //         .doc(data.id)
//       //         .delete());
//
//       Navigator.pop(context, true);
//     },
//   );
//   // set up the AlertDialog
//   AlertDialog alert = AlertDialog(
//     actionsAlignment: MainAxisAlignment.spaceAround,
//     backgroundColor: Colors.red,
//     title: Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 20),
//       child: Column(
//         children: [
//           FittedBox(
//             child: Text(
//               'Code : ' + dataid,
//               style: TextStyle(fontFamily: 'Oswald', color: Colors.white),
//             ),
//           ),
//           Text(
//             data['model'],
//             maxLines: 2,
//             textAlign: TextAlign.center,
//             style: TextStyle(
//                 fontFamily: 'Oswald', color: Colors.white, fontSize: 15),
//           ),
//         ],
//       ),
//     ),
//     content: Text(
//       "Would you like to continue\nto deleting this item?".toUpperCase(),
//       textAlign: TextAlign.center,
//       style: TextStyle(fontFamily: 'Oswald', color: Colors.white, fontSize: 18),
//     ),
//     actions: [
//       cancelButton,
//       continueButton,
//     ],
//   );
//   // show the dialog
//   showDialog(
//     context: context,
//     builder: (BuildContext context) {
//       return alert;
//     },
//   ).then((exit) {
//     if (exit == null) return;
//
//     if (exit) {
//       // user pressed Yes button
//     } else {
//       // user pressed No button
//     }
//   });
// }
//
// class StockPage extends StatelessWidget {
//   StockPage({
//     Key? key,
//     required this.pageQuery,
//   }) : super(key: key);
//
//   final pageQuery;
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(),
//       body: PaginateFirestore(
//         itemsPerPage: 10000,
//         onEmpty: const EmptyDisplay(),
//         separator: const EmptySeparator(),
//         initialLoader: const InitialLoader(),
//         // bottomLoader: const BottomLoader(),
//         shrinkWrap: true,
//         isLive: true,
//
//         itemBuilderType: PaginateBuilderType.listView,
//         query: pageQuery,
//         itemBuilder: (BuildContext, DocumentSnapshot, int) {
//           var data = DocumentSnapshot[int].data() as Map?;
//           String dataid = DocumentSnapshot[int].id;
//           return Card(
//             child: Row(
//               children: [
//                 Expanded(
//                   flex: 2,
//                   child: Padding(
//                     padding: const EdgeInsets.fromLTRB(10, 10, 0, 10),
//                     child: Stack(
//                       alignment: AlignmentDirectional.center,
//                       children: [
//                         CircleAvatar(
//                           backgroundColor: data!['stock'] <= 5
//                               ? data['stock'] != 0
//                                   ? Colors.green
//                                   : Colors.red
//                               : null,
//                           radius: 25,
//                           child: FittedBox(
//                             child: Padding(
//                               padding: const EdgeInsets.all(8.0),
//                               child: Text(
//                                 data['stock'].toString().toUpperCase(),
//                                 style: TextStyle(
//                                     color: data['stock'] <= 5
//                                         ? data['stock'] != 0
//                                             ? Colors.red
//                                             : Colors.white
//                                         : Colors.white,
//                                     fontSize: 20),
//                               ),
//                             ),
//                           ),
//                         ),
//                         CircularPercentIndicator(
//                           animation: true,
//                           animationDuration: 1000,
//                           percent: data['stock'] > data['oldStock']
//                               ? 1
//                               : data['stock'] / data['oldStock'],
//                           progressColor: Colors.greenAccent,
//                           backgroundColor: Colors.red,
//                           radius: 26.0,
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//                 Expanded(
//                   flex: 8,
//                   child: Padding(
//                     padding: EdgeInsets.all(10), //.fromLTRB(15, 10, 0, 10),
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.start,
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           data['model'].toString(),
//                           overflow: TextOverflow.ellipsis,
//                         ),
//                         Text(
//                           data['size'].toString(),
//                           overflow: TextOverflow.ellipsis,
//                         ),
//                         FittedBox(
//                           child: LinearPercentIndicator(
//                             trailing: Text(
//                               (data['stock'] * 100 / data['oldStock'])
//                                       .toString() +
//                                   '%',
//                               style: TextStyle(fontSize: 25),
//                             ),
//                             width: MediaQuery.of(context).size.width,
//                             animation: true,
//                             lineHeight: 25.0,
//                             animationDuration: 1000,
//                             percent: data['stock'] > data['oldStock']
//                                 ? 1
//                                 : data['stock'] / data['oldStock'],
//                             center: Text(
//                               (data['stock'] * 100 / data['oldStock'])
//                                       .toString() +
//                                   '%',
//                               style: TextStyle(),
//                             ),
//                             barRadius: Radius.circular(20.0),
//                             progressColor: Colors.greenAccent,
//                             backgroundColor: Colors.red,
//                             restartAnimation: false,
//                           ),
//                         )
//                       ],
//                     ),
//                   ),
//                 ),
//                 Expanded(
//                   flex: 3,
//                   child: Padding(
//                     padding: const EdgeInsets.fromLTRB(0, 10, 10, 10),
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       crossAxisAlignment: CrossAxisAlignment.end,
//                       children: [
//                         Text(
//                           NumberFormat.currency(symbol: '')
//                               .format(data['prixVente']),
//                           overflow: TextOverflow.ellipsis,
//                           style: TextStyle(
//                               fontSize: 18, fontWeight: FontWeight.w500),
//                         ),
//                         Text(
//                           NumberFormat.currency(symbol: '')
//                               .format(data['prixVente'] * 0.8),
//                           overflow: TextOverflow.ellipsis,
//                           style: TextStyle(
//                               fontSize: 12,
//                               fontWeight: FontWeight.w500,
//                               color: Colors.blueGrey),
//                         ),
//                         Text(
//                           NumberFormat.currency(symbol: '')
//                               .format(data['prixAchat'] * 3.68),
//                           overflow: TextOverflow.ellipsis,
//                           style: TextStyle(
//                               fontSize: 12,
//                               fontWeight: FontWeight.w500,
//                               color: Colors.blueGrey),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           );
//         },
//         //footer: Text('finish'),
//       ),
//     );
//   }
// }
