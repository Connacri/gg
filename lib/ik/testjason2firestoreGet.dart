import 'dart:core';
import 'dart:math';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutterflow_paginate_firestore/paginate_firestore.dart';
import 'package:flutterflow_paginate_firestore/widgets/bottom_loader.dart';
import 'package:flutterflow_paginate_firestore/widgets/empty_display.dart';
import 'package:flutterflow_paginate_firestore/widgets/empty_separator.dart';
import 'package:flutterflow_paginate_firestore/widgets/initial_loader.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:provider/provider.dart';

import 'AddingItems.dart';
import 'Estimate.dart';
import 'QrScanner.dart';
import 'classes.dart';
import 'invoiceList.dart';
import 'pdf/chargesList.dart';

class mainPageFirestoreGetik extends StatefulWidget {
  const mainPageFirestoreGetik({Key? key}) : super(key: key);

  @override
  State<mainPageFirestoreGetik> createState() => _mainPageFirestoreGetikState();
}

class _mainPageFirestoreGetikState extends State<mainPageFirestoreGetik> {
  final TextEditingController _modelController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _sizeController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _stockController = TextEditingController();
  final TextEditingController _prixAchatController = TextEditingController();
  final TextEditingController _prixVenteController = TextEditingController();
  final TextEditingController _origineController = TextEditingController();

  final TextEditingController _userController = TextEditingController();
  final TextEditingController _codeController = new TextEditingController()
    ..text; // = data{'code'};
  final TextEditingController _oldStockController = TextEditingController();
  final TextEditingController _codebarController = TextEditingController();

  late TextTheme textTheme;
  final navigatorKey = GlobalKey<NavigatorState>();
  final GlobalKey<FormState> _formKeyQty = GlobalKey<FormState>();
  final TextEditingController _qtyController =
      TextEditingController(text: '01');

  Color colorRed = Color.fromARGB(255, 213, 2, 2); //Colors.deepPurple;
  Color colorOrange =
      Color.fromARGB(255, 255, 95, 0); //Colors.deepOrangeAccent;
  Color colorGreen = Color.fromARGB(255, 139, 169, 2); //Colors.greenAccent;
  Color colorBlue = Color.fromARGB(255, 66, 58, 41); //Colors.blueAccent;

  Color color1 = const Color.fromARGB(255, 243, 236, 216);
  Color color2 = const Color.fromARGB(255, 127, 136, 106);
  Color color3 = const Color.fromARGB(255, 62, 80, 60);

  @override
  void initState() {
    // getdatata();
    super.initState();
  }

  final _formKeyPneu = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    double sumTaxeImport = 0;
    List userList = Provider.of<List<Charges>>(context);

    for (int i = 0; i < userList.length; i++) {
      sumTaxeImport += (userList[i].amount).toInt();
    }

    double summCosts = 0;
    List costsList = Provider.of<List<Charges>>(context);

    for (int i = 0; i < costsList.length; i++) {
      summCosts += (costsList[i].amount).toDouble();
    }

    double summItems = 0;
    List itemsList = Provider.of<List<ItemsA>>(context);

    for (int i = 0; i < itemsList.length; i++) {
      summItems += (itemsList[i].prixAchat * itemsList[i].oldStock).toDouble();
    }

    return Scaffold(
      appBar: buildAppBar(context),
      body: PaginateFirestore(
          header: SLiverHeader(
              sum: summCosts,
              colorGreen: colorGreen,
              colorOrange: colorOrange,
              colorRed: colorRed),
          itemsPerPage: 10000,
          onEmpty: const EmptyDisplay(),
          separator: const EmptySeparator(),
          initialLoader: const InitialLoader(),
          bottomLoader: const BottomLoader(),
          shrinkWrap: true,
          isLive: true,
          itemBuilderType: PaginateBuilderType.listView,
          query: FirebaseFirestore.instance.collection('Adventure'),
          //.orderBy('createdAt', descending: true),
          itemBuilder: (BuildContext, DocumentSnapshot, int) {
            var data = DocumentSnapshot[int].data() as Map?;
            String dataid = DocumentSnapshot[int].id;
            // final double earn =
            //     (sumTaxeImport * data!['prixAchat'] / summItems) +
            //         data['prixAchat'];
            final double PUA =
                (sumTaxeImport * data!['prixAchat'] / summItems) +
                    data['prixAchat'];

            // final double earn = data['prixVente'] -
            //     ((sumTaxeImport * data['prixAchat'] / summItems) +
            //         data['prixAchat']);
            final double earn = data['prixVente'] - PUA;
            return Column(
              children: [
                GestureDetector(
                  onTap: () async {
                    if (data['stock'] == 0) {
                      await showAlertDialogOut();
                    } else {
                      await addToDevisDialog(
                        dataid,
                        data,
                        /*earn*/ PUA,
                      );
                    }
                  },
                  child: Slidable(
                    key: const Key('keyslidable'),
                    startActionPane: ActionPane(
                      extentRatio: 0.25,
                      // A motion is a widget used to control how the pane animates.
                      motion: const StretchMotion(),

                      // A pane can dismiss the Slidable.
                      //dismissible: DismissiblePane(onDismissed: () {}),//******************* */

                      // All actions are defined in the children parameter.
                      children: [
                        // A SlidableAction can have an icon and/or a label.
                        SlidableAction(
                          onPressed: (Context) => _upDate(dataid, data),
                          backgroundColor: color3,
                          // Colors.orange,
                          foregroundColor: Colors.white,
                          icon: Icons.edit,
                          label: 'Edit',
                        ),
                      ],
                    ),
                    endActionPane: ActionPane(
                      extentRatio: 0.25,
                      motion: const StretchMotion(),
                      children: [
                        SlidableAction(
                          // An action can be bigger than the others.
                          flex: 2,
                          onPressed: (Context) async {
                            await showAlertDialogRemove(context, data, dataid);
                          },
                          backgroundColor: colorRed,
                          foregroundColor: Colors.white,
                          icon: Icons.delete,
                          label: 'Delete',
                        ),
                      ],
                    ),
                    child: Center(
                      child: Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(10, 10, 0, 10),
                              child: Column(
                                children: [
                                  Stack(
                                    alignment: AlignmentDirectional.center,
                                    children: [
                                      CircleAvatar(
                                        backgroundColor: data['stock'] <= 5
                                            ? data['stock'] != 0
                                                ? colorOrange
                                                : colorRed
                                            : colorBlue,
                                        radius: 25,
                                        child: FittedBox(
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                              data['stock']
                                                  .toString()
                                                  .toUpperCase(),
                                              style: TextStyle(
                                                  color: data['stock'] <= 5
                                                      ? data['stock'] != 0
                                                          ? Colors.black54
                                                          : Colors.white
                                                      : Colors.white,
                                                  fontSize: 20),
                                            ),
                                          ),
                                        ),
                                      ),
                                      CircularPercentIndicator(
                                        circularStrokeCap:
                                            CircularStrokeCap.round,
                                        lineWidth: 6.0,
                                        backgroundWidth: 3.0,
                                        animation: true,
                                        animationDuration: 1000,
                                        percent: data['stock'] >
                                                    data['oldStock'] ||
                                                data['stock'] < 0
                                            ? 1
                                            : data['stock'] / data['oldStock'],
                                        progressColor: colorGreen,
                                        backgroundColor: colorRed,
                                        radius: 26.0,
                                      ),
                                    ],
                                  ),
                                  Text(
                                    data['code'],
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 8,
                            child: Padding(
                              padding: EdgeInsets.all(10),
                              //.fromLTRB(15, 10, 0, 10),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    data['model'].toString().toUpperCase(),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Text(
                                    data['size'].toString(),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.factory,
                                        color: colorGreen,
                                        size: 18,
                                      ),
                                      Text(
                                        NumberFormat.currency(symbol: '')
                                            .format(data['prixAchat']),
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500,
                                            color: colorGreen),
                                      ),
                                      Spacer(),
                                      FaIcon(
                                        FontAwesomeIcons.scissors,
                                        size: 15,
                                        color: colorRed,
                                      ),
                                      Text(
                                        NumberFormat.currency(symbol: '')
                                            .format(sumTaxeImport *
                                                data['prixAchat'] /
                                                summItems),
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500,
                                            color: colorRed),
                                      ),
                                      Spacer(),
                                      Spacer(),
                                      Spacer()
                                    ],
                                  ),
                                  FittedBox(
                                    child: LinearPercentIndicator(
                                      trailing: data['stock'] > data['oldStock']
                                          ? Icon(FontAwesomeIcons.infinity)
                                          // Text(
                                          //         '100%',
                                          //         style: TextStyle(fontSize: 25),
                                          //       )
                                          : Text(
                                              NumberFormat.currency(
                                                          symbol: '',
                                                          decimalDigits: 0)
                                                      .format((data['stock'] *
                                                          100 /
                                                          data['oldStock'])) +
                                                  '%',
                                              style: TextStyle(fontSize: 25),
                                            ),
                                      width: MediaQuery.of(context).size.width,
                                      animation: true,
                                      lineHeight: 25.0,
                                      animationDuration: 1000,
                                      percent: data['stock'] >
                                                  data['oldStock'] ||
                                              data['stock'] < 0
                                          ? 1
                                          : data['stock'] / data['oldStock'],
                                      // center: Text(
                                      //   NumberFormat.currency(
                                      //               symbol: '', decimalDigits: 0)
                                      //           .format((data['stock'] *
                                      //               100 /
                                      //               data['oldStock'])) +
                                      //       '%',
                                      //   style: TextStyle(),
                                      // ),
                                      barRadius: Radius.circular(20.0),
                                      progressColor: colorGreen,
                                      backgroundColor: colorRed,
                                      restartAnimation: false,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 3,
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(0, 10, 10, 10),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    NumberFormat.currency(symbol: ' ')
                                        .format(data['prixVente']),
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  Text(
                                    NumberFormat.currency(symbol: 'DAP ')
                                        .format(PUA),
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                        color: colorRed),
                                  ),
                                  // Text(
                                  //   NumberFormat.currency(symbol: 'WASLA ')
                                  //       .format(PUA),
                                  //   overflow: TextOverflow.ellipsis,
                                  //   style: TextStyle(
                                  //       fontSize: 12,
                                  //       fontWeight: FontWeight.w500,
                                  //       color: colorRed),
                                  // ),
                                  earn > 0
                                      ? Text(
                                          NumberFormat.currency(symbol: 'Earn ')
                                              .format(data['prixVente'] -
                                                  (PUA
                                                  // (sumTaxeImport *
                                                  //     data['prixAchat'] /
                                                  //     summItems) +
                                                  // data['prixAchat']
                                                  )),
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w500,
                                              color: colorGreen),
                                        )
                                      : Icon(
                                          Icons.error,
                                          color: colorRed,
                                        )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Divider(),
              ],
            );
          }),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      leading: IconButton(
        icon: const Icon(Icons.qr_code),
        onPressed: () {
          // int itemcount = code.length;
          // uploadItems(itemcount);
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) =>
                // MainPageik(),
                qrScannerik(),
          ));
        },
      ),
      actions: [
        // IconButton(
        //   onPressed: () {
        //     Navigator.of(context).push(MaterialPageRoute(
        //       builder: (context) => MainPageik(),
        //     ));
        //   },
        //   icon: Icon(Icons.connecting_airports_sharp),
        // ),
        IconButton(
            onPressed: () async {
              await addCode();
            },
            icon: Icon(Icons.add)),
        IconButton(
          icon: const Icon(Icons.incomplete_circle),
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => chargeList(),
            ));
          },
        ),
        IconButton(
          icon: const Icon(Icons.face),
          onPressed: () {
            // int itemcount = code.length;
            // uploadItems(itemcount);
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => invoiceList(),
            ));
          },
        ),
        Padding(
          padding: const EdgeInsets.only(right: 15),
          child: IconButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const estimateik(),
                ));
              },
              icon: const Icon(Icons.add_shopping_cart)),
        ),
      ],
    );
  }

  // Future addToEstimateDialog(String dataid, earn, Map data) => showDialog(
  //       context: context,
  //       builder: (context) => AlertDialog(
  //         title: Center(
  //           child: FittedBox(
  //             child: Text(
  //               'Item : ${data['model'].toString()}'.toUpperCase(),
  //               style: TextStyle(
  //                 color: Colors.blue, // Colors.orange,
  //               ),
  //             ),
  //           ),
  //         ),
  //         actions: [
  //           Center(
  //             child: ElevatedButton(
  //                 onPressed: () {
  //                   // Validate returns true if the form is valid, or false otherwise.
  //                   if (!_formKeyQty.currentState!.validate()) {
  //                     return;
  //                   } else {
  //                     //  setState(() {
  //                     addItemsToDevis2(
  //                       dataid,
  //                       data,
  //                       earn,
  //                       _qtyController.text,
  //                     );
  //                     //_qtyController.clear();
  //                     // });
  //                   }
  //
  //                   Navigator.pop(context, false);
  //                 },
  //                 child: Text(
  //                   'Add to Estimate'.toUpperCase(),
  //                   style: const TextStyle(fontSize: 15, color: Colors.black54),
  //                 )),
  //           )
  //         ],
  //         content: Form(
  //           key: _formKeyQty,
  //           child: TextFormField(
  //             autofocus: true,
  //             textAlign: TextAlign.center,
  //             style: const TextStyle(
  //               fontSize: 25,
  //             ),
  //             keyboardType: TextInputType.number,
  //             controller: _qtyController,
  //             validator: (valueQty) => valueQty!.isEmpty ||
  //                     valueQty == null ||
  //                     int.tryParse(valueQty.toString()) == 0
  //                 ? 'Cant be 0 or Empty'
  //                 : null,
  //             decoration: const InputDecoration(
  //               border: InputBorder.none,
  //               filled: true,
  //               contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
  //
  //               hintText: 'Quantity',
  //               fillColor: Colors.white,
  //               //filled: true,
  //             ),
  //           ),
  //         ), // availibility,
  //       ),
  //     );

  Future addCode() => showDialog<void>(
        context: context,
        builder: (BuildContext dialogContext) {
          return AlertDialog(
            title: Center(child: FittedBox(child: Text('Tyres Adding'))),
            content: Form(
              key: _formKeyPneu,
              child: TextFormField(
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 25,
                ),
                controller: _codeController,
                autofocus: true,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  labelStyle: TextStyle(
                    fontSize: 12,
                  ),
                  hintText: 'BarCode',
                  fillColor: Colors.white,
                  filled: true,
                  contentPadding: EdgeInsets.all(15),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter Barcode';
                  }
                  return null;
                },
              ),
            ),
            actions: <Widget>[
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.blue),
                  foregroundColor: MaterialStateProperty.all(Colors.white),
                  fixedSize: MaterialStateProperty.all(Size.fromWidth(100)),
                ),
                onPressed: () async {
                  // Validate returns true if the form is valid, or false otherwise.
                  if (_formKeyPneu.currentState!.validate()) {
                    // showDialog(
                    //   context: context,
                    //   builder: (context) =>
                    //       Center(child: CircularProgressIndicator()),
                    // );

                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (BuildContext context) => Addingitems(
                            code: _codeController.text.toString())));
                    //
                    // Navigator.pop(context);
                    // Navigator.of(context, rootNavigator: true).pop();

                    // Navigator.pop(context);
                    // ScaffoldMessenger.of(context).showSnackBar(
                    //   const SnackBar(content: Text('Processing Data')),
                    // );
                  }
                  // Navigator.of(context, rootNavigator: true).pop();
                  // Navigator.pop(context);
                },
                child: const Text('Next'),
              ),
              TextButton(
                child: Text('Cancel'),
                onPressed: () {
                  Navigator.of(dialogContext).pop(); // Dismiss alert dialog
                },
              ),
            ],
          );
        },
      );

  Future addToDevisDialog(
          dataid,
          data,
          /*earn*/
          PUA) =>
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Center(
            child: FittedBox(
              child: data['stock'] <= 5
                  ? data['stock'] != 0
                      ? Text(
                          'Item : ${data['model'].toString()}\n Left-Over : ${data['stock'].toString()}'
                              .toUpperCase(),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: colorOrange, // Colors.orange,
                          ),
                        )
                      : Text(
                          'Item : ${data['model'].toString()}'.toUpperCase(),
                          style: TextStyle(
                            color: colorRed, // Colors.orange,
                          ),
                        )
                  : Text(
                      'Item : ${data['model'].toString()}'.toUpperCase(),
                      style: TextStyle(
                        color: colorBlue, // Colors.orange,
                      ),
                    ),
            ),
          ),
          actions: [
            Center(
              child: ElevatedButton(
                  onPressed: () {
                    // Validate returns true if the form is valid, or false otherwise.
                    if (!_formKeyQty.currentState!.validate()) {
                      return;
                    } else if (data['stock'] >=
                        int.parse(_qtyController.text)) {
                      // FirebaseFirestore.instance
                      //     .collection('Market')
                      //     .doc(dataid)
                      //     .update({
                      //   'stock': FieldValue.increment(
                      //       -int.parse(_qtyController.text))
                      // });
                      // setState(() {
                      _addToDevisFunction(
                          dataid, data, /*earn,*/ PUA, _qtyController.text);
                      _qtyController.clear();
                      // });
                    } else {
                      return;
                    }
                    Navigator.pop(context, false);
                  },
                  child: Text(
                    'Add to Estimate'.toUpperCase(),
                    style: const TextStyle(fontSize: 15, color: Colors.black54),
                  )),
            )
          ],
          content: Form(
            key: _formKeyQty,
            child: TextFormField(
              inputFormatters: [
                //FilteringTextInputFormatter.deny(RegExp(r'[,]')),
                FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                //CommaTextInputFormatter(),
              ],
              autofocus: true,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 25,
              ),
              keyboardType: TextInputType.number,
              controller: _qtyController,
              validator: (valueQty) => valueQty!.isEmpty ||
                      valueQty == null ||
                      int.tryParse(valueQty.toString()) == 0
                  ? 'Cant be 0 or Empty'
                  : null,
              decoration: const InputDecoration(
                border: InputBorder.none,
                filled: true,
                contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),

                hintText: 'Quantity',
                fillColor: Colors.white,
                //filled: true,
              ),
            ),
          ),
        ),
      );

  Future showAlertDialogOut() => showDialog(
      context: context,
      builder: (context) => AlertDialog(
            backgroundColor: Colors.red.shade200,
            title: Center(
              child: Text(
                'alert!!!'.toUpperCase(),
                style: TextStyle(
                  color: colorRed,
                ),
              ),
            ),
            actions: [
              Center(
                child: TextButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(colorRed),
                      foregroundColor: MaterialStateProperty.all(colorGreen),
                      minimumSize:
                          MaterialStateProperty.all(const Size(200, 50)),
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
                      'Cancel'.toUpperCase(),
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.red.shade100,
                      ),
                    )),
              )
            ],
            content: Text(
              'out of stock'.toUpperCase(),
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 30, color: colorRed),
            ),
          ));

  Future<void> _addToDevisFunction(dataid, data, /*earn,*/ PUA, qty) async {
    User? _user = FirebaseAuth.instance.currentUser;

    CollectionReference devisitem =
        FirebaseFirestore.instance.collection('Estimate');

    CollectionReference incrementQty =
        FirebaseFirestore.instance.collection('Adventure');

    DocumentSnapshot<Map<String?, dynamic>> document = await FirebaseFirestore
        .instance
        .collection('Estimate')
        .doc(dataid)
        .get();

    if (!document.exists) {
      return devisitem
          .doc(dataid)
          .set({
            'createdAt': Timestamp.now().toDate(),
            'category': data['category'],
            'model': data['model'],
            'description': data['description'],
            'size': data['size'],
            'prixAchat': data['prixAchat'],
            'prixVente': data['prixVente'],
            'stock': data['stock'],
            'codebar': data['codebar'],
            'oldStock': data['oldStock'],
            'origine': data['origine'],
            'user': _user!.uid, //data['user'],
            'qty': int.parse(qty),
            //'earn': earn,
            'PUA': PUA,
          }, SetOptions(merge: true))
          .then((value) => print("Item Added to Devis"))
          .catchError((error) => print("Failed to add Item to Devis: $error"))
          .whenComplete(() => incrementQty
              .doc(dataid)
              .update({'stock': FieldValue.increment(-int.parse(qty))}));
    } else {
      print('kayen deja/////////////////////');
      return devisitem
          .doc(dataid)
          .update({'qty': FieldValue.increment(int.parse(qty))})
          .then((value) => print("Item update to Estimate"))
          .catchError(
              (error) => print("Failed to update Item to Estimate: $error"))
          .whenComplete(() => incrementQty
              .doc(dataid)
              .update({'stock': FieldValue.increment(-int.parse(qty))}))
          .then((value) =>
              print('**********************************update c bon'));
    }
  }

  Future<void> _upDate(String dataid, Map data) async {
    if (data != null) {
      _codeController.text = data['code'];
      _codebarController.text = data['codebar'];
      _categoryController.text = data['category'];
      _modelController.text = data['model'];
      _descriptionController.text = data['description'];
      _sizeController.text = data['size'];
      _stockController.text = data['stock'].toString();
      _prixAchatController.text = data['prixAchat'].toString();
      _prixVenteController.text = data['prixVente'].toString();
      _origineController.text = data['origine'].toString();
      _oldStockController.text = data['oldStock'].toString();
      _userController.text = data['user']; //.toString();
    }
    await showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (BuildContext ctx) {
          return Padding(
            padding: EdgeInsets.only(
                top: 20,
                left: 20,
                right: 20,
                bottom: MediaQuery.of(ctx).viewInsets.bottom + 20),
            child: ListView(
              children: [
                Container(
                    height: MediaQuery.of(context).size.width * .7,
                    child: Lottie.asset('assets/123750-creepy-cat.json')),
                Center(
                  child: Text(
                    dataid.toUpperCase().toString(),
                  ),
                ),
                TextField(
                  controller: _codebarController,
                  decoration: const InputDecoration(
                    label: Text('CodeBar'),
                  ),
                ),
                TextField(
                  controller: _categoryController,
                  decoration: const InputDecoration(
                    label: Text('Category'),
                  ),
                ),
                TextField(
                  controller: _modelController,
                  decoration: const InputDecoration(
                    label: Text('Model'),
                  ),
                ),
                TextField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(
                    label: Text('Description'),
                  ),
                ),
                TextField(
                  controller: _sizeController,
                  decoration: const InputDecoration(
                    label: Text('Size'),
                  ),
                ),
                TextField(
                  inputFormatters: [
                    //FilteringTextInputFormatter.deny(RegExp(r'[,]')),
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                    //CommaTextInputFormatter(),
                  ],
                  controller: _stockController,
                  decoration: const InputDecoration(
                    label: Text('Stock Dispo'),
                  ),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  inputFormatters: [
                    //FilteringTextInputFormatter.deny(RegExp(r'[,]')),
                    CommaTextInputFormatter(),
                  ],
                  controller: _prixAchatController,
                  decoration: const InputDecoration(
                    label: Text('Factory Price'),
                  ),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  inputFormatters: [
                    //FilteringTextInputFormatter.deny(RegExp(r'[,]')),
                    //FilteringTextInputFormatter.deny(RegExp(r'[0-9]')),
                    CommaTextInputFormatter(),
                  ],
                  controller: _prixVenteController,
                  decoration: const InputDecoration(
                    label: Text('Retail Price'),
                  ),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: _origineController,
                  decoration: const InputDecoration(
                    label: Text('Origine'),
                  ),
                ),
                TextField(
                  inputFormatters: [
                    //FilteringTextInputFormatter.deny(RegExp(r'[,]')),
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                    //CommaTextInputFormatter(),
                  ],
                  controller: _oldStockController,
                  decoration: const InputDecoration(
                    label: Text('Initial Stock'),
                  ),
                  keyboardType: TextInputType.number,
                ),
                ElevatedButton(
                    onPressed: () async {
                      final String _code = _codeController.text;
                      final String _codebar = _codebarController.text;
                      final String _category = _categoryController.text;
                      final String _model = _modelController.text;
                      final String _description = _descriptionController.text;
                      final String _size = _sizeController.text;
                      final int _stock = int.parse(_stockController.text);
                      final double _prixAchat =
                          double.parse(_prixAchatController.text);

                      final double _prixVente =
                          double.parse(_prixVenteController.text);
                      final int _oldStock = int.parse(_oldStockController.text);
                      final String _user =
                          FirebaseAuth.instance.currentUser!.uid;
                      final String _origine = _origineController.text;

                      //final double _price =  double.tryParse(_priceController.text);
                      //if (dealer != null) {
                      await FirebaseFirestore.instance
                          .collection('Adventure')
                          .doc(dataid)
                          .update({
                        'code': _code,
                        'codebar': _codebar,
                        'category': _category,
                        'model': _model,
                        'description': _description,
                        'size': _size,
                        'stock': _stock,
                        'prixAchat': _prixAchat,
                        'prixVente': _prixVente,
                        'oldStock': _oldStock,
                        'user': _user,
                        'origine': _origine,
                      });

                      // Navigator.of(context).pop();
                      Navigator.of(context, rootNavigator: true).pop();
                      // setState(() {
                      //   data.clear();
                      // });
                    },
                    child: Text(
                      'Update'.toUpperCase(),
                    )),
              ],
            ),
          );
        });
  }

  Future<void> AddItem(code) async {
    CollectionReference ItemDetail =
        FirebaseFirestore.instance.collection('Adventure');
    return ItemDetail.doc(_codeController.text)
        .set({
          'createdAt': Timestamp.now().toDate(), //*****
          'category': _categoryController.text, //*****
          'code': code.toString(), //*****
          'model': _modelController.text, //*****
          'description': _descriptionController.text, //*****
          'size': _sizeController.text, //*****
          'prixAchat': double.parse(_prixAchatController.text), //*****
          'prixVente': double.parse(_prixVenteController.text), //*****
          'stock': int.parse(_stockController.text), //*****
          'codebar': code.toString(), //*****
          'oldStock': int.parse(_stockController.text), //*****
          'origine': _origineController.text, //*****
          'user': 'unknow', //*****
        }, SetOptions(merge: true))
        .then((value) => print("Item Added"))
        .catchError((error) => print("Failed to Add: $error"));
    // .whenComplete(() => PriceDealer.doc().set({
    //       'price': int.parse(_saleController.text),
    //       'dealerName': _dealerNameController.text,
    //     }, SetOptions(merge: true)));
  }
}

class CommaTextInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    String truncated = newValue.text;
    final TextSelection newSelection = newValue.selection;
    if (newValue.text.contains(',')) {
      truncated = newValue.text.replaceFirst(RegExp(','), '.');
    }
    return TextEditingValue(
      text: truncated,
      selection: newSelection,
    );
  }
}

class SLiverHeader extends StatelessWidget {
  const SLiverHeader({
    Key? key,
    required this.sum,
    required this.colorGreen,
    required this.colorOrange,
    required this.colorRed,
  }) : super(key: key);

  final Color colorGreen;
  final Color colorOrange;
  final Color colorRed;
  final double sum;

  @override
  Widget build(BuildContext context) {
    // var userDetail = Provider.of<googleSignInProvider>(context).readUserX();
    Random random = new Random();
    return SliverToBoxAdapter(
      child: Column(
        children: [
          Container(
            height: MediaQuery.of(context).size.height / 8,
            width: MediaQuery.of(context).size.width,
            child: Center(
              child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('Adventure') //.get(),
                      .snapshots(),
                  builder: (BuildContext context, snapshot) {
                    // if (snapshot.connectionState == ConnectionState.waiting) {
                    //   return Container(); //CircularProgressIndicator();
                    // } else
                    // if (snapshot.connectionState == ConnectionState.active ||
                    //     snapshot.connectionState == ConnectionState.done)
                    {
                      if (snapshot.hasError) {
                        return const Text('Error');
                      } else if (snapshot.hasData) {
                        var data = snapshot.data!.docs;

                        final List<DocumentSnapshot> min5 = data
                            .where((DocumentSnapshot documentSnapshot) =>
                                documentSnapshot['stock'] <= 5 &&
                                documentSnapshot['stock'] > 0)
                            .toList();

                        final int count5 = min5.length;
                        //print(count5);
                        final List<DocumentSnapshot> min0 = data
                            .where((DocumentSnapshot documentSnapshot) =>
                                documentSnapshot['stock'] == 0)
                            .toList();
                        final int count0 = min0.length;

                        int totalPneux = 0;
                        final List<DocumentSnapshot> totalPneuxList = data
                            // .where((DocumentSnapshot documentSnapshot) =>
                            //     documentSnapshot['stock'])
                            .toList();
                        // print('XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX');
                        // print(totalPneuxList[0]['stock']);
                        int tota = 0;
                        for (int i = 0; i < totalPneuxList.length; i++) {
                          tota += totalPneuxList[i]['stock'] as int;
                        }
                        // print('88888888888888888888888');
                        // print(tota);

                        //print(count0);
                        return ListView(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 18.0, right: 18),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 4.0, right: 4),
                                      child: Container(
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            gradient: RadialGradient(
                                                radius: 1,
                                                tileMode: TileMode.clamp,
                                                colors: [
                                                  Color.fromARGB(255, 243, 236,
                                                      216), //Colors.greenAccent;
                                                  Color.fromARGB(
                                                      255, 66, 58, 41),
                                                ])),
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Column(
                                            children: [
                                              Text(
                                                'Total'.toUpperCase().trim(),
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                              Text(
                                                // data.length.toString() +
                                                //     '/' +
                                                tota.toString(),
                                                style: TextStyle(
                                                    fontSize: 30.0,
                                                    color: Colors.white),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                      child: Padding(
                                          padding: const EdgeInsets.only(
                                              left: 4.0, right: 4),
                                          child: Container(
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                gradient: RadialGradient(
                                                    radius: 1,
                                                    tileMode: TileMode.clamp,
                                                    colors: [
                                                      Color.fromARGB(
                                                          255,
                                                          139,
                                                          169,
                                                          2), //Colors.greenAccent;
                                                      Color.fromARGB(
                                                          255, 66, 58, 41),
                                                    ])),
                                            child: GestureDetector(
                                              onTap: () {
                                                Navigator.of(context)
                                                    .push(MaterialPageRoute(
                                                  builder: (context) =>
                                                      StockPage(
                                                    pageQuery: FirebaseFirestore
                                                        .instance
                                                        .collection('Adventure')
                                                        .where('stock',
                                                            isGreaterThan: 0),
                                                    colorGreen: colorGreen,
                                                    colorRed: colorRed,
                                                  ),
                                                ));
                                              },
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Column(
                                                  children: [
                                                    Text(
                                                      'Stock'
                                                          .toUpperCase()
                                                          .trim(),
                                                      style: TextStyle(
                                                          color: Colors.yellow),
                                                    ),
                                                    Column(
                                                      children: [
                                                        Text(
                                                          (data.length - count0)
                                                              .toString(),
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.yellow,
                                                              fontSize: 30),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ))),
                                  Expanded(
                                      child: Padding(
                                          padding: const EdgeInsets.only(
                                              left: 4.0, right: 4),
                                          child: Container(
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                gradient: RadialGradient(
                                                    radius: 1,
                                                    tileMode: TileMode.clamp,
                                                    colors: [
                                                      Color.fromARGB(
                                                          255,
                                                          255,
                                                          196,
                                                          0), //Colors.greenAccent;
                                                      Color.fromARGB(
                                                          255, 143, 4, 4),
                                                    ])),
                                            child: GestureDetector(
                                              onTap: () {
                                                Navigator.of(context)
                                                    .push(MaterialPageRoute(
                                                  builder: (context) =>
                                                      StockPage(
                                                    pageQuery: FirebaseFirestore
                                                        .instance
                                                        .collection('Adventure')
                                                        .where('stock',
                                                            isGreaterThan: 0)
                                                        .where('stock',
                                                            isLessThanOrEqualTo:
                                                                5),
                                                    colorGreen: colorGreen,
                                                    colorRed: colorRed,
                                                  ),
                                                ));
                                              },
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Column(
                                                  children: [
                                                    Text(
                                                      'Alert'
                                                          .toUpperCase()
                                                          .trim(),
                                                      style: TextStyle(
                                                          color:
                                                              Colors.black54),
                                                    ),
                                                    Text(
                                                      count5.toString(),
                                                      style: TextStyle(
                                                          color: Colors.black54,
                                                          fontSize: 30),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ))),
                                  Expanded(
                                      child: Padding(
                                          padding: const EdgeInsets.only(
                                              left: 4.0, right: 4),
                                          child: Container(
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                gradient: RadialGradient(
                                                    radius: 1,
                                                    tileMode: TileMode.clamp,
                                                    colors: [
                                                      Color.fromARGB(
                                                          255,
                                                          255,
                                                          95,
                                                          0), //Colors.greenAccent;
                                                      Color.fromARGB(
                                                          255, 38, 32, 20),
                                                    ])),
                                            child: GestureDetector(
                                              onTap: () {
                                                Navigator.of(context)
                                                    .push(MaterialPageRoute(
                                                  builder: (context) =>
                                                      StockPage(
                                                    pageQuery: FirebaseFirestore
                                                        .instance
                                                        .collection('Adventure')
                                                        .where('stock',
                                                            isLessThanOrEqualTo:
                                                                0),
                                                    colorGreen: colorGreen,
                                                    colorRed: colorRed,
                                                  ),
                                                ));
                                              },
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Column(
                                                  children: [
                                                    Text(
                                                      'Out'
                                                          .toUpperCase()
                                                          .trim(),
                                                      style: TextStyle(
                                                          color: Colors.white),
                                                    ),
                                                    Text(
                                                      count0.toString(),
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 30),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ))),
                                ],
                              ),
                            ),
                          ],
                        );
                      } else {
                        return const Text('Empty data');
                      }
                    }
                    // else {
                    //   return Text('State: ${snapshot.connectionState}');
                    // }
                  }),
            ),
          ),
          ViewGlobalCompte(),
          Container(
            height: 200,
            child: StreamBuilder(
                stream:
                    FirebaseFirestore.instance.collection('Users').snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Text('');
                  } else {
                    return //Text(snapshot.data!.size.toString());
                        Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListView.builder(
                          physics: BouncingScrollPhysics(),
                          scrollDirection: Axis.horizontal,
                          itemCount: snapshot.data!.docs.length,
                          shrinkWrap: true,
                          itemBuilder: (_, intex) {
                            DocumentSnapshot _UnsplashUrlSnapshot =
                                snapshot.data!.docs[intex];

                            //final int inte = random.nextInt(13 - intex);
                            final int inte = random.nextInt(13);

                            return Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Stack(
                                alignment: Alignment.topCenter,
                                children: [
                                  ShaderMask(
                                    shaderCallback: (rect) {
                                      return const RadialGradient(
                                        radius: 1,
                                        colors: [Colors.white, Colors.black54],
                                      ).createShader(rect);
                                    },
                                    blendMode: BlendMode.darken,
                                    child: Stack(
                                      children: [
                                        Container(
                                          height: 250,
                                          width: 100,
                                          child: CachedNetworkImage(
                                            imageUrl:
                                                'https://firebasestorage.googleapis.com/v0/b/adventure-eb4ca.appspot.com/o/carre%2Fcarre%20(${inte}).jpg?alt=media&token=fbcb6223-39c8-4ed7-9b62-13acac60fe94',
                                            fit: BoxFit.cover,
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
                                                color: Colors.grey
                                                    .withOpacity(0.1),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 15.0),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        UnsplashAvatar(
                                            UnsplashUrl: _UnsplashUrlSnapshot[
                                                'userAvatar']),
                                        Container(
                                          width: 90,
                                          child: FittedBox(
                                            child: RatingBar.builder(
                                              initialRating: double.parse(
                                                  _UnsplashUrlSnapshot[
                                                          'userItemsNbr']
                                                      .toString()),
                                              ignoreGestures: true,
                                              minRating: 1,
                                              direction: Axis.horizontal,
                                              allowHalfRating: true,
                                              itemCount: 5,
                                              itemPadding: EdgeInsets.symmetric(
                                                  horizontal: 4.0),
                                              itemBuilder: (context, _) => Icon(
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
                                              _UnsplashUrlSnapshot[
                                                      'userDisplayName']
                                                  .toString()
                                                  .toUpperCase(),
                                              style: TextStyle(
                                                  color: Colors.white70,
                                                  fontSize: 28,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ),
                                        _UnsplashUrlSnapshot['userRole'] ==
                                                'admin'
                                            ? ShaderMask(
                                                blendMode: BlendMode.srcIn,
                                                shaderCallback: (Rect bounds) =>
                                                    LinearGradient(
                                                      colors: <Color>[
                                                        Colors.red,
                                                        Colors.yellowAccent,
                                                        Color.fromRGBO(
                                                            246, 132, 2, 1.0),
                                                      ],
                                                      begin: Alignment.topLeft,
                                                      end:
                                                          Alignment.bottomRight,
                                                    ).createShader(bounds),
                                                child: Text(
                                                  _UnsplashUrlSnapshot[
                                                          'userRole']
                                                      .toString()
                                                      .toUpperCase(),
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ))
                                            : Text(
                                                _UnsplashUrlSnapshot['userRole']
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
                                  _UnsplashUrlSnapshot['userRole'] == 'admin'
                                      ? Positioned(
                                          top: 8,
                                          child: ShaderMask(
                                            blendMode: BlendMode.srcIn,
                                            shaderCallback: (Rect bounds) =>
                                                LinearGradient(
                                              colors: <Color>[
                                                Colors.red,
                                                Colors.yellowAccent,
                                                Color.fromRGBO(
                                                    246, 132, 2, 1.0),
                                              ],
                                              begin: Alignment.topLeft,
                                              end: Alignment.bottomRight,
                                            ).createShader(bounds),
                                            child: Icon(
                                              FontAwesomeIcons.crown,
                                              color: Colors.amber,
                                            ),
                                          ))
                                      : Container()
                                ],
                              ),
                            ); //['userAvatar']
                          }),
                    );
                  }
                }),
          ),
          // Container(
          //   height: 60,
          //   child: ListView(
          //     shrinkWrap: true,
          //     physics: BouncingScrollPhysics(),
          //     scrollDirection: Axis.horizontal,
          //     children: [
          //       UnsplashAvatar(
          //           UnsplashUrl:
          //               'https://img1.wsimg.com/isteam/ip/d48b4882-6d43-4aed-ac22-2834c9891797/ADV%20TYRES%20MOTOZ.jpg/:/cr=t:0%25,l:0%25,w:100%25,h:100%25/rs=w:1300,h:800'),
          //       UnsplashAvatar(
          //           UnsplashUrl:
          //               'https://source.unsplash.com/random/250×200/?motocycle'),
          //       UnsplashAvatar(
          //           UnsplashUrl:
          //               'https://source.unsplash.com/random/400×300/?motocycle'),
          //       UnsplashAvatar(
          //           UnsplashUrl:
          //               'https://source.unsplash.com/random/300×200/?motos'),
          //       UnsplashAvatar(
          //           UnsplashUrl:
          //               'https://source.unsplash.com/random/300×300/?moto'),
          //       UnsplashAvatar(
          //           UnsplashUrl:
          //               'https://source.unsplash.com/random/300×200/?motor'),
          //       UnsplashAvatar(
          //           UnsplashUrl:
          //               'https://img1.wsimg.com/isteam/ip/d48b4882-6d43-4aed-ac22-2834c9891797/Motoz_edits-8402-resized.jpg/:/rs=w:1300,h:800'),
          //       UnsplashAvatar(
          //           UnsplashUrl:
          //               'https://img1.wsimg.com/isteam/ip/d48b4882-6d43-4aed-ac22-2834c9891797/4.jpg/:/rs=w:1300,h:800'),
          //       UnsplashAvatar(
          //           UnsplashUrl:
          //               'https://img1.wsimg.com/isteam/ip/d48b4882-6d43-4aed-ac22-2834c9891797/motoz-505.jpg/:/rs=w:1300,h:800'),
          //     ],
          //   ),
          // ),
        ],
      ),
    );
  }
}

showAlertDialogRemove(BuildContext context, data, dataid) {
  // set up the buttons
  Widget cancelButton = ElevatedButton(
    style: ButtonStyle(
      backgroundColor: MaterialStateProperty.all(Colors.white),
    ),
    child: Text(
      "Cancel",
      style: TextStyle(color: Colors.red),
    ),
    onPressed: () => Navigator.pop(context, false),
  );
  Widget continueButton = TextButton(
    child: Text(
      "I'm Sure to Remove it",
      style: TextStyle(color: Colors.white, fontSize: 10),
    ),
    //child: Text("Delete"),
    onPressed: () {
      FirebaseFirestore.instance.collection('Adventure').doc(dataid).delete();
      // .update({'stock': FieldValue.increment(data['qty'])}).whenComplete(
      //     () => FirebaseFirestore.instance
      //         .collection('Estimate') //.collection('cart')
      //         .doc(data.id)
      //         .delete());

      Navigator.pop(context, true);
    },
  );
  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    actionsAlignment: MainAxisAlignment.spaceAround,
    backgroundColor: Colors.red,
    title: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          FittedBox(
            child: Text(
              'Code : ' + dataid,
              style: TextStyle(fontFamily: 'Oswald', color: Colors.white),
            ),
          ),
          Text(
            data['model'],
            maxLines: 2,
            textAlign: TextAlign.center,
            style: TextStyle(
                fontFamily: 'Oswald', color: Colors.white, fontSize: 15),
          ),
        ],
      ),
    ),
    content: Text(
      "Would you like to continue\nto deleting this item?".toUpperCase(),
      textAlign: TextAlign.center,
      style: TextStyle(fontFamily: 'Oswald', color: Colors.white, fontSize: 18),
    ),
    actions: [
      cancelButton,
      continueButton,
    ],
  );
  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  ).then((exit) {
    if (exit == null) return;

    if (exit) {
      // user pressed Yes button
    } else {
      // user pressed No button
    }
  });
}

class StockPage extends StatelessWidget {
  const StockPage({
    Key? key,
    required this.pageQuery,
    required this.colorGreen,
    required this.colorRed,
  }) : super(key: key);

  final Color colorGreen;
  final Color colorRed;
  final pageQuery;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: PaginateFirestore(
        itemsPerPage: 10000,
        onEmpty: const EmptyDisplay(),
        separator: const EmptySeparator(),
        initialLoader: const InitialLoader(),
        // bottomLoader: const BottomLoader(),
        shrinkWrap: true,
        isLive: true,

        itemBuilderType: PaginateBuilderType.listView,
        query: pageQuery,
        itemBuilder: (BuildContext, DocumentSnapshot, int) {
          var data = DocumentSnapshot[int].data() as Map?;
          String dataid = DocumentSnapshot[int].id;
          return Card(
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(10, 10, 0, 10),
                    child: Stack(
                      alignment: AlignmentDirectional.center,
                      children: [
                        CircleAvatar(
                          backgroundColor: data!['stock'] <= 5
                              ? data['stock'] != 0
                                  ? Colors.green
                                  : Colors.red
                              : null,
                          radius: 25,
                          child: FittedBox(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                data['stock'].toString().toUpperCase(),
                                style: TextStyle(
                                    color: data['stock'] <= 5
                                        ? data['stock'] != 0
                                            ? Colors.red
                                            : Colors.white
                                        : Colors.white,
                                    fontSize: 20),
                              ),
                            ),
                          ),
                        ),
                        CircularPercentIndicator(
                          animation: true,
                          animationDuration: 1000,
                          percent: data['stock'] > data['oldStock']
                              ? 1
                              : data['stock'] / data['oldStock'],
                          progressColor: Colors.greenAccent,
                          backgroundColor: Colors.red,
                          radius: 26.0,
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  flex: 8,
                  child: Padding(
                    padding: EdgeInsets.all(10), //.fromLTRB(15, 10, 0, 10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          data['model'].toString(),
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          data['size'].toString(),
                          overflow: TextOverflow.ellipsis,
                        ),
                        FittedBox(
                          child: LinearPercentIndicator(
                            trailing: data['stock'] > data['oldStock']
                                ? Icon(FontAwesomeIcons.infinity)
                                // Text(
                                //         '100%',
                                //         style: TextStyle(fontSize: 25),
                                //       )
                                : Text(
                                    NumberFormat.currency(
                                                symbol: '', decimalDigits: 0)
                                            .format((data['stock'] *
                                                100 /
                                                data['oldStock'])) +
                                        '%',
                                    style: TextStyle(fontSize: 25),
                                  ),
                            width: MediaQuery.of(context).size.width,
                            animation: true,
                            lineHeight: 25.0,
                            animationDuration: 1000,
                            percent: data['stock'] > data['oldStock'] ||
                                    data['stock'] < 0
                                ? 1
                                : data['stock'] / data['oldStock'],
                            // center: Text(
                            //   NumberFormat.currency(
                            //               symbol: '', decimalDigits: 0)
                            //           .format((data['stock'] *
                            //               100 /
                            //               data['oldStock'])) +
                            //       '%',
                            //   style: TextStyle(),
                            // ),
                            barRadius: Radius.circular(20.0),
                            progressColor: colorGreen,
                            backgroundColor: colorRed,
                            restartAnimation: false,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(0, 10, 10, 10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          NumberFormat.currency(symbol: '')
                              .format(data['prixVente']),
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w500),
                        ),
                        Text(
                          NumberFormat.currency(symbol: '')
                              .format(data['prixVente'] * 0.8),
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: Colors.blueGrey),
                        ),
                        Text(
                          NumberFormat.currency(symbol: '')
                              .format(data['prixAchat'] * 3.68),
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: Colors.blueGrey),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
        //footer: Text('finish'),
      ),
    );
  }
}

class ViewGlobalCompte extends StatelessWidget {
  Color colorWhite = Colors.white;

  Color colorRed = Color.fromARGB(255, 213, 2, 2); //Colors.deepPurple;
  Color colorOrange =
      Color.fromARGB(255, 255, 95, 0); //Colors.deepOrangeAccent;
  Color colorGreen = Color.fromARGB(255, 139, 169, 2); //Colors.greenAccent;
  Color colorBrown = Color.fromARGB(255, 66, 58, 41); //Colors.blueAccent;

  @override
  Widget build(BuildContext context) {
    double sumTaxeImport = 0;

    List userList = Provider.of<List<Charges>>(context);

    for (int i = 0; i < userList.length; i++) {
      sumTaxeImport += (userList[i].amount).toInt();
    }

    double summItems = 0;
    List itemsList = Provider.of<List<ItemsA>>(context);

    for (int i = 0; i < itemsList.length; i++) {
      summItems += (itemsList[i].prixAchat * itemsList[i].oldStock).toDouble();
    }

    List invoiceList = Provider.of<List<Invoice>>(context);
    double sumInvoice = 0;
    double sumTotalInvoice = 0;

    for (int i = 0; i < invoiceList.length; i++) {
      sumInvoice += (invoiceList[i].benef).toDouble();
      List ListItemsInvoice = invoiceList[i].itemCodeBar;
      for (int ii = 0; ii < ListItemsInvoice.length; ii++) {
        sumTotalInvoice +=
            (ListItemsInvoice[ii]['prixVente'] * ListItemsInvoice[ii]['qty'])
                .toDouble();
      }
    }

    //print(sumTotalInvoice);
    Random random = new Random();

    int intex = random.nextInt(19);
    return Padding(
      padding: const EdgeInsets.all(18.0),
      child: Stack(
        children: [
          ShaderMask(
            shaderCallback: (rect) {
              return const RadialGradient(
                radius: 1,
                colors: [Colors.white, Colors.black54],
              ).createShader(rect);
            },
            blendMode: BlendMode.darken,
            child: Stack(
              children: [
                Container(
                  height: 150,
                  width: MediaQuery.of(context).size.width,
                  child: CachedNetworkImage(
                    imageUrl:
                        'https://firebasestorage.googleapis.com/v0/b/adventure-eb4ca.appspot.com/o/wall%2Fwall%20(${intex}).jpg?alt=media&token=84432892-026e-458f-a0fb-b5a11123a880',
                    fit: BoxFit.cover,
                  ),
                ),
                BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
                  child: Container(
                    alignment: Alignment.center,
                    color: Colors.grey.withOpacity(0.1),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Whole Invest'.toUpperCase(),
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w500),
                    ),
                    Text(
                      NumberFormat.currency(symbol: '')
                          .format(sumTaxeImport + summItems),
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Factory Order'.toUpperCase(),
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          color: colorWhite,
                          fontSize: 14,
                          fontWeight: FontWeight.w500),
                    ),
                    Text(
                      NumberFormat.currency(symbol: '').format(summItems),
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          color: colorWhite,
                          fontSize: 14,
                          fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Fix Taxes'.toUpperCase(),
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Colors.yellow),
                    ),
                    Text(
                      NumberFormat.currency(symbol: '').format(sumTaxeImport),
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.yellow,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Sales Total'.toUpperCase(),
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          color: colorWhite,
                          fontSize: 12,
                          fontWeight: FontWeight.w500),
                    ),
                    Text(
                      NumberFormat.currency(symbol: '').format(sumTotalInvoice),
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          color: colorWhite,
                          fontSize: 12,
                          fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Earnings '.toUpperCase(),
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.greenAccent),
                    ),
                    Text(
                      NumberFormat.currency(symbol: '').format(sumInvoice),
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.greenAccent),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class UnsplashAvatar extends StatelessWidget {
  const UnsplashAvatar({
    Key? key,
    required this.UnsplashUrl,
  }) : super(key: key);

  final String UnsplashUrl;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: 40.0,
        height: 40.0,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
        ),
        child: CachedNetworkImage(
          imageUrl: UnsplashUrl,
          imageBuilder: (context, imageProvider) => Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
            ),
          ),
          errorWidget: (context, url, error) => Icon(Icons.error),
        ),
      ),
    );
  }
}
