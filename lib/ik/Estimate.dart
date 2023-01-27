import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';

import 'CustomerOrDealer.dart';
import 'testjason2firestoreGet.dart';

class estimateik extends StatefulWidget {
  const estimateik({Key? key}) : super(key: key);

  @override
  State<estimateik> createState() => _estimateikState();
}

class _estimateikState extends State<estimateik> {
  Color colorRed = Color.fromARGB(255, 213, 2, 2); //Colors.deepPurple;
  Color colorOrange =
      Color.fromARGB(255, 255, 95, 0); //Colors.deepOrangeAccent;
  Color colorGreen = Color.fromARGB(255, 139, 169, 2); //Colors.greenAccent;
  Color colorBlue = Color.fromARGB(255, 66, 58, 41);
  final TextEditingController _priceController = TextEditingController();
  final _formKeyDevis = GlobalKey<FormState>();
  final TextEditingController _qtyController =
      TextEditingController(text: '01');

  // final TextEditingController dateinput = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: StreamBuilder(
              stream:
                  FirebaseFirestore.instance.collection('Estimate').snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return Center(
                    child: Text("Something is wrong"),
                  );
                }
                try {
                  if (snapshot.data!.docs.length == 0) {
                    return Scaffold(
                        backgroundColor: Colors.white,
                        body: Center(
                          child: Lottie.asset(
                              'assets/lotties/89832-empty-list.json',
                              fit: BoxFit.contain),
                          // child: Text(
                          //   'GG Adventure \nEstimate Is Empty',
                          //   textAlign: TextAlign.center,
                          //   style: TextStyle(fontSize: 20),
                          // ),
                        ));
                  }
                } catch (exception) {}

                return Scaffold(
                  appBar: AppBar(
                    toolbarHeight: 90.0,
                    title: Text('Estimate'),
                    actions: [
                      // IconButton(
                      //   onPressed: () {
                      //     print(
                      //         '******************************************************'); //
                      //
                      //     List LLIst = snapshot.data!.docs
                      //         .map((DocumentSnapshot document) {
                      //       Map<String, dynamic> data =
                      //           document.data()! as Map<String, dynamic>;
                      //       return data;
                      //     }).toList();
                      //
                      //     double summ = 0;
                      //     var ds = snapshot.data!.docs;
                      //
                      //     for (int i = 0; i < ds.length; i++) {
                      //       summ +=
                      //           (ds[i]['prixVente']).toInt() * (ds[i]['qty']);
                      //     }
                      //
                      //     addDevisToInvoiceList(
                      //       LLIst,
                      //       summ.toString(),
                      //     ); //**********************************
                      //   },
                      //   icon: const Icon(Icons.add),
                      // ),
                      IconButton(
                        icon: const Icon(Icons.account_balance_sharp),
                        onPressed: () {
                          List LLIst = snapshot.data!.docs
                              .map((DocumentSnapshot document) {
                            Map<String, dynamic> data =
                                document.data()! as Map<String, dynamic>;
                            return data;
                          }).toList();

                          double summ = 0;
                          var ds = snapshot.data!.docs;

                          for (int i = 0; i < ds.length; i++) {
                            summ +=
                                (ds[i]['prixVente']).toInt() * (ds[i]['qty']);
                          }
                          //
                          // double cout = 0;
                          // for (int i = 0; i < ds.length; i++) {
                          //   cout += ds[i]['prixAchat'] * (ds[i]['qty']);
                          // }
                          double countEarn = 0;

                          for (int i = 0; i < ds.length; i++) {
                            double ss = ds[i]['prixVente'] - ds[i]['PUA'];
                            countEarn += ss * (ds[i]['qty']);
                          }

                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => CustomerOrDealer(
                                    dataDevis: LLIst,
                                    sum: summ,
                                    benef: countEarn,
                                    dataDealer: {},
                                    switched: false,
                                  )));
                        },
                      ),
                      // IconButton(
                      //   icon: const Icon(Icons.picture_as_pdf),
                      //   onPressed: () {
                      //     // int itemcount = code.length;
                      //     // uploadItems(itemcount);
                      //
                      //     // Navigator.of(context).push(MaterialPageRoute(
                      //     //   builder: (context) => PdfPageRamzy2(
                      //     //     dataDevis: snapshot.data!.docs,
                      //     //     customer: '',
                      //     //     date: DateTime.now(),
                      //     //     codeDevis: '',
                      //     //   ),
                      //     // ));
                      //
                      //     Navigator.of(context).push(MaterialPageRoute(
                      //       builder: (context) => addCustomerToEstimate(
                      //         dataDevis: snapshot.data!.docs,
                      //       ),
                      //     ));
                      //   },
                      // ),
                      // buildTotal(),
                    ],
                  ),
                  body: ListView(
                    children: [
                      buildTotal(colorRed, colorOrange, colorGreen, colorBlue),
                      ListView.builder(
                          shrinkWrap: true,
                          itemCount: snapshot.data == null
                              ? 0
                              : snapshot.data!.docs.length,
                          itemBuilder: (_, index) {
                            DocumentSnapshot _documentSnapshot =
                                snapshot.data!.docs[index];
                            double sum = 0.0;
                            var ds = snapshot.data!.docs;

                            return Slidable(
                              key: const Key('keyslidable'),
                              closeOnScroll: true,
                              endActionPane: ActionPane(
                                extentRatio: 0.25,
                                motion: const StretchMotion(),
                                children: [
                                  SlidableAction(
                                    // An action can be bigger than the others.
                                    //flex: 2,
                                    onPressed: (Context) async {
                                      await showAlertDialog(
                                          context, _documentSnapshot);
                                      print(_documentSnapshot.id);
                                    },
                                    backgroundColor: Colors.red,
                                    foregroundColor: Colors.white,
                                    icon: Icons.delete,
                                    label: 'Delete',
                                  ),
                                ],
                              ),
                              startActionPane: ActionPane(
                                extentRatio: 0.25,
                                motion: const StretchMotion(),
                                children: [
                                  SlidableAction(
                                    // An action can be bigger than the others.
                                    //flex: 2,
                                    onPressed: (Context) async {
                                      await _upDateDevis(_documentSnapshot.id,
                                          _documentSnapshot);
                                    },
                                    backgroundColor: colorGreen,
                                    foregroundColor: Colors.white,
                                    icon: Icons.edit,
                                    label: 'Edit',
                                  ),
                                ],
                              ),
                              child: ListTile(
                                trailing: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      NumberFormat.currency(
                                              //locale: 'aed',
                                              symbol: '')
                                          .format(
                                              (_documentSnapshot['prixVente'] *
                                                  _documentSnapshot['qty'])),
                                      // .toString() +  '0',
                                      style: TextStyle(fontSize: 15),
                                    ),
                                    Text(
                                      NumberFormat.currency(
                                              //locale: 'aed',
                                              symbol: '')
                                          .format(((_documentSnapshot[
                                                      'prixVente'] -
                                                  _documentSnapshot['PUA']) *
                                              _documentSnapshot['qty'])),
                                      // .toString() +  '0',
                                      style: TextStyle(
                                          fontSize: 15, color: colorGreen),
                                    ),
                                  ],
                                ),
                                leading: CircleAvatar(
                                  child: FittedBox(
                                    child: Text(
                                        _documentSnapshot['qty'].toString()),
                                  ),
                                ),
                                title: Text(
                                  _documentSnapshot['model'],
                                  overflow: TextOverflow.ellipsis,
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Size : ' + _documentSnapshot['size'],
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          NumberFormat.currency(symbol: 'PU ')
                                              .format(_documentSnapshot[
                                                  'prixVente']), //.toString() + '0'),
                                        ),
                                        SizedBox(
                                          width: 30,
                                        ),
                                        Text(
                                          NumberFormat.currency(symbol: 'Earn ')
                                              .format(_documentSnapshot[
                                                      'prixVente'] -
                                                  _documentSnapshot[
                                                      'PUA']), //.toString() + '0'),
                                          style: TextStyle(color: colorGreen),
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            );
                          }),
                    ],
                  ),
                );
              }),
        ),
      ],
    );
  }

  Future<void> _upDateDevis(String dataid, data) async {
    if (data != null) {
      int a = data['prixVente'].toInt();
      _priceController.text = a.toString();
      _qtyController.text = data['qty'].toString();
    }

    await showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (BuildContext ctx) {
          return Form(
            key: _formKeyDevis,
            child: Padding(
              padding: EdgeInsets.only(
                  top: 20,
                  left: 20,
                  right: 20,
                  bottom: MediaQuery.of(ctx).viewInsets.bottom + 20),
              child: ListView(
                children: [
                  Stack(
                    alignment: AlignmentDirectional.bottomCenter,
                    children: [
                      Container(
                          height: MediaQuery.of(context).size.width * .7,
                          child: Lottie.asset('assets/123750-creepy-cat.json')),
                      Center(
                        child: Text(
                          dataid.toUpperCase().toString(),
                          style: const TextStyle(
                              fontSize: 15, color: Colors.black45),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    inputFormatters: [
                      //FilteringTextInputFormatter.deny(RegExp(r'[,]')),
                      //FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                      CommaTextInputFormatter(),
                    ],
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 25,
                    ),
                    decoration: const InputDecoration(
                      fillColor: Colors.white,
                      hintText: 'Price',
                      border: InputBorder.none,
                      filled: true,
                      contentPadding: EdgeInsets.all(15),
                    ),
                    keyboardType: TextInputType.number,
                    controller: _priceController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter Price';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  // TextFormField(
                  //   textAlign: TextAlign.center,
                  //   style: const TextStyle(
                  //     fontSize: 25,
                  //   ),
                  //   decoration: const InputDecoration(
                  //     fillColor: Colors.white,
                  //     hintText: 'Quantity',
                  //     border: InputBorder.none,
                  //     filled: true,
                  //     contentPadding: EdgeInsets.all(15),
                  //   ),
                  //   keyboardType: TextInputType.number,
                  //   controller: _qtyController,
                  //   validator: (value) {
                  //     if (value == null || value.isEmpty) {
                  //       return 'Please enter Quantity';
                  //     }
                  //     return null;
                  //   },
                  // ),
                  Padding(
                    padding: const EdgeInsets.all(58.0),
                    child: ElevatedButton(
                        onPressed: () async {
                          if (_formKeyDevis.currentState!.validate()) {
                            // if (dataz['stock'] >=
                            //     int.parse(_qtyController.text)) {
                            final int _price = int.parse(_priceController.text);
                            final int _qty = int.parse(_qtyController.text);
                            final int _qtyEstimate = data['stock'];

                            final int d = _qty - _qtyEstimate;

                            CollectionReference incrementQty = FirebaseFirestore
                                .instance
                                .collection('Adventure');
                            await FirebaseFirestore.instance
                                .collection('Estimate')
                                .doc(dataid)
                                .update({
                              'prixVente': _price,
                              'qty': _qty,
                              'createdAt': Timestamp.now().toDate(),
                            });
                            // .whenComplete(() => incrementQty
                            //     .doc(dataid)
                            //     .update(
                            //         {'stock': FieldValue.increment(d)}));

                            Navigator.of(context, rootNavigator: true).pop();
                            //}
                          }
                        },
                        child: Text(
                          'Update'.toUpperCase(),
                        )),
                  ),
                ],
              ),
            ),
          );
        });
  }

  buildTotal(colorRed, colorOrange, colorGreen, colorBlue) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance.collection('Estimate').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Padding(
              padding: const EdgeInsets.only(right: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        'Total: ',
                        style: const TextStyle(
                            color: Colors.blue,
                            fontFamily: 'Oswald',
                            fontSize: 17,
                            fontWeight: FontWeight.normal),
                      ),
                      Text(
                        '0.00',
                        style: TextStyle(
                            color: colorBlue,
                            fontFamily: 'Oswald',
                            fontSize: 17,
                            fontWeight: FontWeight.normal),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        'Cout: ',
                        style: TextStyle(
                            color: colorOrange,
                            fontFamily: 'Oswald',
                            fontSize: 17,
                            fontWeight: FontWeight.normal),
                      ),
                      Text(
                        '0.00',
                        style: TextStyle(
                            color: colorOrange,
                            fontFamily: 'Oswald',
                            fontSize: 17,
                            fontWeight: FontWeight.normal),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        'Benef: ',
                        style: TextStyle(
                            color: colorGreen,
                            fontFamily: 'Oswald',
                            fontSize: 17,
                            fontWeight: FontWeight.normal),
                      ),
                      Text(
                        '0.00', //.toString() + '0',
                        style: TextStyle(
                            color: colorGreen,
                            fontFamily: 'Oswald',
                            fontSize: 17,
                            fontWeight: FontWeight.normal),
                      ),
                    ],
                  ),
                ],
              ),
            );
          } else {
            double summ = 0;
            var ds = snapshot.data!.docs;

            for (int i = 0; i < ds.length; i++) {
              summ += (ds[i]['prixVente']).toInt() * (ds[i]['qty']);
            }

            double cout = 0;
            for (int i = 0; i < ds.length; i++) {
              cout += ds[i]['prixAchat'] * (ds[i]['qty']);
            }

            double countEarn = 0;
            for (int i = 0; i < ds.length; i++) {
              countEarn += ds[i]['PUA'] * (ds[i]['qty']);
            }
            return Padding(
              padding: const EdgeInsets.only(right: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        'Total: ',
                        style: TextStyle(
                            color: colorBlue,
                            fontFamily: 'Oswald',
                            fontSize: 17,
                            fontWeight: FontWeight.normal),
                      ),
                      Text(
                        NumberFormat.currency(symbol: '')
                            .format(summ), //.toString() + '0',
                        style: TextStyle(
                            color: colorBlue,
                            fontFamily: 'Oswald',
                            fontSize: 17,
                            fontWeight: FontWeight.normal),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        'Benef: ',
                        style: TextStyle(
                            color: colorGreen,
                            fontFamily: 'Oswald',
                            fontSize: 17,
                            fontWeight: FontWeight.normal),
                      ),
                      Text(
                        NumberFormat.currency(symbol: '')
                            .format(summ - countEarn), //.toString() + '0',
                        style: TextStyle(
                            color: colorGreen,
                            fontFamily: 'Oswald',
                            fontSize: 15,
                            fontWeight: FontWeight.normal),
                      ),
                    ],
                  ),
                ],
              ),
            );
          }
        });
  }
}

showAlertDialog(BuildContext context, data) {
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
      FirebaseFirestore.instance
          .collection('Adventure')
          .doc(data.id)
          .update({'stock': FieldValue.increment(data['qty'])}).whenComplete(
              () => FirebaseFirestore.instance
                  .collection('Estimate') //.collection('cart')
                  .doc(data.id)
                  .delete());

      Navigator.pop(context, true);
    },
  );
  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    actionsAlignment: MainAxisAlignment.spaceAround,
    backgroundColor: Colors.red,
    title: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Column(
        children: [
          FittedBox(
            child: Text(
              data['model'],
              style: TextStyle(fontFamily: 'Oswald', color: Colors.white),
            ),
          ),
          FittedBox(
            child: Text(
              data.id,
              style: TextStyle(fontFamily: 'Oswald', color: Colors.white),
            ),
          ),
        ],
      ),
    ),
    content: Text(
      "Would you like to continue to deleting this item?",
      style: TextStyle(fontFamily: 'Oswald', color: Colors.white),
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

Future<void> addDevisToInvoiceList(
    List data, sum, benef, customer, date) async {
  final numero = await data.length;
  print('data');
  print(data);

  print('length :${data.length}');

  final numbers = List.generate(numero, (index) => index);
  final postCollectionItemsSuperette =
      FirebaseFirestore.instance.collection('Invoice').doc();
  for (final number in numbers) {
    final item = data[number];
    print('**************users[number]*****user.category*************');

    // .collection('invoices')
    // .doc(item['codebar']);
    postCollectionItemsSuperette
        .set({'item CodeBar': ''})
        .whenComplete(() => postCollectionItemsSuperette.update(
              //.set(

              {
                'item CodeBar': FieldValue.arrayUnion([
                  {
                    'createdAt': Timestamp.now().toDate(),
                    'category': item['category'],
                    'model': item['model'],
                    'description': item['description'],
                    'size': item['size'],
                    'prixAchat': item['prixAchat'],
                    'prixVente': item['prixVente'],
                    'stock': item['stock'],
                    'codebar': item['codebar'],
                    'oldStock': item['oldStock'],
                    'origine': item['origine'],
                    'user': item['user'],
                    'qty': item['qty'],
                  }
                ]),
                'total': double.parse(sum),
                'customer': customer,
                'date': date,
                'benef': benef,
              }, //SetOptions(merge: false)
            ))
        .then((value) => print("Item Added"))
        .catchError((error) => print("Failed to Add: $error"));
  }
}

Future<void> addItemsToDevis2(dataid, data, qty) async {
  CollectionReference devisitem =
      FirebaseFirestore.instance.collection('Estimate');

  CollectionReference incrementQty =
      FirebaseFirestore.instance.collection('Adventure');

  DocumentSnapshot<Map<String?, dynamic>> document =
      await FirebaseFirestore.instance.collection('Estimate').doc(dataid).get();

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
          'prixDealer': data['prixDealer'],
          'stock': data['stock'],
          'codebar': data['codebar'],
          'oldStock': data['oldStock'],
          'origine': data['origine'],
          'user': data['user'],
          'qty': int.parse(qty),
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
        .then(
            (value) => print('**********************************update c bon'));
  }
}

// class addCustomerToEstimate extends StatefulWidget {
//   addCustomerToEstimate({
//     Key? key,
//     required this.dataDevis,
//   }) : super(key: key);
//
//   final List dataDevis;
//
//   @override
//   State<addCustomerToEstimate> createState() => _addCustomerToEstimateState();
// }
//
// class _addCustomerToEstimateState extends State<addCustomerToEstimate> {
//   final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
//
//   final TextEditingController _customerController = TextEditingController();
//
//   final TextEditingController _codeDevisController = TextEditingController();
//
//   final TextEditingController dateinput = TextEditingController();
//   var datepass;
//
//   @override
//   void initState() {
//     dateinput.text = DateFormat('yyyy-MM-dd')
//         .format(DateTime.now()); //set the initial value of text field
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Center(
//           child: FittedBox(
//             child: Text(
//               'Finalisation'.toUpperCase(),
//               style: TextStyle(
//                 color: Colors.blue, // Colors.orange,
//               ),
//             ),
//           ),
//         ),
//         actions: [],
//       ),
//       body: Form(
//         key: _formKey,
//         child: Column(
//           children: [
//             TextFormField(
//               autofocus: true,
//               textAlign: TextAlign.center,
//               style: const TextStyle(
//                 fontSize: 25,
//               ),
//               keyboardType: TextInputType.text,
//               controller: _customerController,
//               validator: (value) => value!.isEmpty ||
//                       value == null ||
//                       int.tryParse(value.toString()) == 0
//                   ? 'Cant be Empty'
//                   : null,
//               decoration: const InputDecoration(
//                 border: InputBorder.none,
//                 filled: true,
//                 contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
//
//                 hintText: 'Customer Name',
//                 fillColor: Colors.white,
//                 //filled: true,
//               ),
//             ),
//             TextField(
//               controller: dateinput,
//               //editing controller of this TextField
//               style: const TextStyle(
//                 fontSize: 25,
//               ),
//               autofocus: true,
//               textAlign: TextAlign.center,
//               decoration: const InputDecoration(
//                 border: InputBorder.none,
//                 filled: true,
//                 contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
//
//                 hintText: 'Estimate Number',
//                 fillColor: Colors.white,
//                 //filled: true,
//               ),
//               readOnly: true,
//               //set it true, so that user will not able to edit text
//               onTap: () async {
//                 DateTime? pickedDate = await showDatePicker(
//                     context: context,
//                     initialDate: DateTime.now(),
//                     firstDate: DateTime(2000),
//                     //DateTime.now() - not to allow to choose before today.
//                     lastDate: DateTime(2101));
//
//                 if (pickedDate != null) {
//                   print(
//                       pickedDate); //pickedDate output format => 2021-03-10 00:00:00.000
//                   String formattedDate =
//                       DateFormat('yyyy-MM-dd').format(pickedDate);
//                   print(
//                       formattedDate); //formatted date output using intl package =>  2021-03-16
//                   //you can implement different kind of Date Format here according to your requirement
//
//                   setState(() {
//                     datepass = pickedDate;
//                     dateinput.text =
//                         formattedDate; //set output date to TextField value.
//                   });
//                 } else {
//                   print("Date is not selected");
//                 }
//               },
//             ),
//             TextFormField(
//               autofocus: true,
//               textAlign: TextAlign.center,
//               style: const TextStyle(
//                 fontSize: 25,
//               ),
//               keyboardType: TextInputType.text,
//               controller: _codeDevisController,
//               validator: (value) => value!.isEmpty ||
//                       value == null ||
//                       int.tryParse(value.toString()) == 0
//                   ? 'Cant be Empty'
//                   : null,
//               decoration: const InputDecoration(
//                 border: InputBorder.none,
//                 filled: true,
//                 contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
//
//                 hintText: 'Estimate Number',
//                 fillColor: Colors.white,
//                 //filled: true,
//               ),
//             ),
//             SizedBox(
//               height: 100,
//             ),
//             Center(
//               child: ElevatedButton(
//                   onPressed: () {
//                     // Validate returns true if the form is valid, or false otherwise.
//                     if (_formKey.currentState!.validate()) {
//                       // If the form is valid, display a snackbar. In the real world,
//                       // you'd often call a server or save the information in a database.
//                       ScaffoldMessenger.of(context).showSnackBar(
//                         const SnackBar(content: Text('Processing Data')),
//                       );
//                       Navigator.of(context)
//                           .push(MaterialPageRoute(
//                             builder: (context) => PdfPageRamzy2(
//                               dataDevis: widget.dataDevis,
//                               customer: _customerController.text,
//                               date: datepass ?? DateTime.now(),
//                               codeDevis: _codeDevisController.text,
//                             ),
//                           ))
//                           .whenComplete(() => debugPrint(
//                               'is fiiiiiiiiiiiiiiiiiiiiiiiinishhhhhhhhhh'));
//                       print(widget.dataDevis.length);
//                       print(_customerController.text);
//                       print(dateinput.text);
//                       print(_codeDevisController.text);
//                       print(widget.dataDevis.map((e) => e['model']).toList());
//                     }
//                   },
//                   child: Text(
//                     'Add To Invoice'.toUpperCase(),
//                     style: const TextStyle(fontSize: 15, color: Colors.black54),
//                   )),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }

// class addCustomerToEstimate2 extends StatefulWidget {
//   addCustomerToEstimate2({
//     Key? key,
//     required this.dataDevis,
//     required this.sum,
//     required this.benef,
//     required this.userDisplayName,
//   }) : super(key: key);
//
//   final List dataDevis;
//   final double sum;
//   final double benef;
//   final String userDisplayName;
//
//   @override
//   State<addCustomerToEstimate2> createState() => _addCustomerToEstimate2State();
// }
//
// class _addCustomerToEstimate2State extends State<addCustomerToEstimate2> {
//   Color colorRed = Color.fromARGB(255, 213, 2, 2); //Colors.deepPurple;
//   Color colorOrange =
//       Color.fromARGB(255, 255, 95, 0); //Colors.deepOrangeAccent;
//   Color colorGreen = Color.fromARGB(255, 139, 169, 2); //Colors.greenAccent;
//   Color colorBlue = Color.fromARGB(255, 66, 58, 41);
//   final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
//
//   final TextEditingController _customerController = TextEditingController();
//
//   final TextEditingController dateinput = TextEditingController();
//   var datepass;
//
//   @override
//   void initState() {
//     dateinput.text = DateFormat('yyyy-MM-dd')
//         .format(DateTime.now()); //set the initial value of text field
//     final String dealerName = widget.userDisplayName;
//     super.initState();
//   }
//
//   bool isSwitched = false;
//   @override
//   Widget build(BuildContext context) {
//     final TextEditingController _customerControllerSwitched =
//         TextEditingController(text: widget.userDisplayName);
//     return Scaffold(
//       appBar: AppBar(
//         title: Center(
//           child: FittedBox(
//             child: Text(
//               'Finalisation'.toUpperCase(),
//               style: TextStyle(
//                 color: Colors.blue, // Colors.orange,
//               ),
//             ),
//           ),
//         ),
//         actions: [],
//       ),
//       body: Form(
//         key: _formKey,
//         child: ListView(
//           children: [
//             Center(
//               child: Text(
//                 'AED ' + NumberFormat.currency(symbol: '').format(widget.sum),
//                 style: const TextStyle(fontSize: 25, color: Colors.blue),
//               ),
//             ),
//             Center(
//               child: Text(
//                 'AED ' + NumberFormat.currency(symbol: '').format(widget.benef),
//                 style: TextStyle(fontSize: 25, color: colorGreen),
//               ),
//             ),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Text(
//                   'Retail',
//                   style: TextStyle(
//                       fontSize: 20,
//                       fontWeight: FontWeight.w500,
//                       color: !isSwitched
//                           ? Color.fromRGBO(126, 13, 13, 1.0)
//                           : Colors.black54),
//                 ),
//                 Switch(
//                   activeColor: Colors.cyan,
//                   activeTrackColor: Colors.cyan.shade100,
//                   inactiveThumbColor: Color.fromRGBO(126, 13, 13, 1.0),
//                   inactiveTrackColor:
//                       Color.fromRGBO(126, 13, 13, 0.4235294117647059),
//                   splashRadius: 50.0,
//                   value: isSwitched,
//                   onChanged: (value) => setState(() => isSwitched = value),
//                 ),
//                 Text(
//                   'Dealer',
//                   style: TextStyle(
//                       fontSize: 20,
//                       fontWeight: FontWeight.w500,
//                       color: isSwitched
//                           ? Colors.cyan //Color.fromRGBO(139, 169, 2, 1.0)
//                           : Colors.black54),
//                 ),
//               ],
//             ), // Switch
//
//             Padding(
//               padding:
//                   const EdgeInsets.symmetric(vertical: 25.0, horizontal: 80),
//               child: isSwitched
//                   ? TextButton.icon(
//                       onPressed: () => Navigator.of(context).push(
//                           MaterialPageRoute(
//                               builder: (context) => ListDealers(
//                                   LLIst: widget.dataDevis,
//                                   summ: widget.sum,
//                                   countEarn: widget.benef,
//                                   userDisplayName: ''))),
//                       icon: Icon(
//                         Icons.account_circle_rounded,
//                         color: Colors.cyan,
//                       ),
//                       label: Text(
//                         'Select Dealer',
//                         style: TextStyle(color: Colors.cyan),
//                       ))
//                   : null,
//             ),
//
//             TextFormField(
//               autofocus: true,
//               textAlign: TextAlign.center,
//               style: const TextStyle(
//                 fontSize: 25,
//               ),
//               keyboardType: TextInputType.text,
//               controller: isSwitched
//                   ? _customerControllerSwitched
//                   : _customerController,
//               validator: (value) => value!.isEmpty ||
//                       value == null ||
//                       int.tryParse(value.toString()) == 0
//                   ? 'Cant be Empty'
//                   : null,
//               decoration: InputDecoration(
//                 border: InputBorder.none,
//                 filled: true,
//                 contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
//
//                 hintText: 'Customer Name',
//                 fillColor: Colors.white,
//                 //filled: true,
//               ),
//             ),
//             Divider(),
//             TextField(
//               controller: dateinput,
//               //editing controller of this TextField
//               style: const TextStyle(
//                 fontSize: 25,
//               ),
//               autofocus: true,
//               textAlign: TextAlign.center,
//               decoration: const InputDecoration(
//                 border: InputBorder.none,
//                 filled: true,
//                 contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
//
//                 hintText: 'Estimate Number',
//                 fillColor: Colors.white,
//                 //filled: true,
//               ),
//               readOnly: true,
//               //set it true, so that user will not able to edit text
//               onTap: () async {
//                 DateTime? pickedDate = await showDatePicker(
//                     context: context,
//                     initialDate: DateTime.now(),
//                     firstDate: DateTime(2000),
//                     //DateTime.now() - not to allow to choose before today.
//                     lastDate: DateTime(2101));
//
//                 if (pickedDate != null) {
//                   print(
//                       pickedDate); //pickedDate output format => 2021-03-10 00:00:00.000
//                   String formattedDate =
//                       DateFormat('yyyy-MM-dd').format(pickedDate);
//                   print(
//                       formattedDate); //formatted date output using intl package =>  2021-03-16
//                   //you can implement different kind of Date Format here according to your requirement
//
//                   setState(() {
//                     datepass = pickedDate;
//                     dateinput.text =
//                         formattedDate; //set output date to TextField value.
//                   });
//                 } else {
//                   print("Date is not selected");
//                 }
//               },
//             ),
//             SizedBox(
//               height: 100,
//             ),
//             Center(
//               child: ElevatedButton(
//                   onPressed: () {
//                     // Validate returns true if the form is valid, or false otherwise.
//                     if (_formKey.currentState!.validate()) {
//                       // If the form is valid, display a snackbar. In the real world,
//                       // you'd often call a server or save the information in a database.
//                       ScaffoldMessenger.of(context).showSnackBar(
//                         const SnackBar(content: Text('Processing Data')),
//                       );
//
//                       print(
//                           '******************************************************'); //
//                       isSwitched
//                           ? addDealer(
//                               widget.dataDevis,
//                               widget.sum.toString(),
//                               widget.benef,
//                               _customerController.text,
//                               DateTime.now(),
//                             )
//                           : addDevisToInvoiceList(
//                               widget.dataDevis,
//                               widget.sum.toString(),
//                               widget.benef,
//                               _customerController.text,
//                               DateTime.now(),
//                             );
//                     }
//                     ;
//                     _deleteAllEstimate();
//
//                     Navigator.of(context).pushAndRemoveUntil(
//                       MaterialPageRoute(
//                         builder: (context) => invoiceList(),
//                       ),
//                       (route) => route.isFirst,
//                     );
//                   },
//                   child: Text(
//                     'Add To Invoice'.toUpperCase(),
//                     style: const TextStyle(fontSize: 15, color: Colors.black54),
//                   )),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }

// Future<void> _deleteAllEstimate() async {
//   CollectionReference collection =
//       FirebaseFirestore.instance.collection('Estimate'); //var
//   QuerySnapshot snapshot = await collection.get(); //var
//   for (var doc in snapshot.docs) {
//     await doc.reference.delete();
//     print(doc.reference);
//     print('deleted');
//   }
// }

Future<void> addDealer(List data, sum, benef, customer, date) async {
  final numero = await data.length;
  print('data');
  print(data);

  print('length :${data.length}');

  final numbers = List.generate(numero, (index) => index);
  final addDealerName = FirebaseFirestore.instance.collection('Dealers');
  final postCollectionItems = FirebaseFirestore.instance
      .collection('Dealers')
      .doc()
      .collection('DealerList');
//  WriteBatch batch = FirebaseFirestore.instance.batch();

  addDealerName.doc().set({
    'name': customer,
  });
  for (final number in numbers) {
    final item = data[number];

    postCollectionItems
        .doc(item['codebar'])
        .set({
          'createdAt': Timestamp.now().toDate(),
          'category': item['category'],
          'model': item['model'],
          'description': item['description'],
          'size': item['size'],
          'prixAchat': item['prixAchat'],
          'prixVente': item['prixVente'],
          'stock': item['stock'],
          'codebar': item['codebar'],
          'oldStock': item['oldStock'],
          'origine': item['origine'],
          'user': item['user'],
          'qty': item['qty'],
        }, SetOptions(merge: true))
        .then((value) => print("Item Added to Dealer"))
        .catchError((error) => print("Failed to add Item to Dealer: $error"));
    // .whenComplete(() => incrementQty
    //     .doc(item['codebar'])
    //     .update({'stock': FieldValue.increment(-item['qty'])}));
    // ;
  }
  ;
}

Future addCoin(String id, double amount) async {
  try {
    // String uid = FirebaseFirestore.instance.currentUser.uid;
    var value = amount; // double.parse(amount);
    DocumentReference documentReference = FirebaseFirestore.instance
        .collection('users')
        .doc('Ramzy') //.doc(uid)
        .collection('Coins')
        .doc(id);

    FirebaseFirestore.instance.runTransaction((transaction) async {
      DocumentSnapshot snapshot = await transaction.get(documentReference);

      if (!snapshot.exists) {
        documentReference.set({'Amount': value});
        return true;
      }
      double newAmount = snapshot['Amount'] + value;
      transaction.update(documentReference, {'Amount': newAmount});
      return true;
    });
  } catch (e) {
    return false;
  }
}
