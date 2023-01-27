import 'package:barcode_widget/barcode_widget.dart' as bbarcode;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Addingitems extends StatelessWidget {
  Addingitems({
    Key? key,
    required this.code,
  }) : super(key: key);

  final String code;
  final TextEditingController _modelController = TextEditingController();
  final TextEditingController _codeController = TextEditingController();
  final TextEditingController _stockController = TextEditingController();
  final TextEditingController _sizeController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _prixAchatController = TextEditingController();
  final TextEditingController _prixVenteController = TextEditingController();
  final TextEditingController _codebarController = TextEditingController();
  final TextEditingController _origineController = TextEditingController();
  final TextEditingController _userController = TextEditingController();
  final TextEditingController _saleController = TextEditingController();
  final TextEditingController _qtyController = TextEditingController();
  final TextEditingController _oldStockController = TextEditingController();
  final TextEditingController _dealerNameController = TextEditingController();
  final _formKeyPneux = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    _codeController.text = code;
    bool isvisible = false;
    return Scaffold(
      appBar: AppBar(
        //leading: Icon(Icons.add_box_outlined),
        title: Text('Adding Product'),
      ),
      body: Form(
        key: _formKeyPneux,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
          child: ListView(
            children: [
              Center(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                  child: bbarcode.BarcodeWidget(
                    barcode: bbarcode.Barcode.code128(),
                    data: _codeController.text.toString(),
                    drawText: false,
                    color: Colors.black,
                    //width: MediaQuery.of(context).size.width * 0.6,
                    height: 60,
                  ),
                ),
              ),
              Center(
                  child: Text(
                _codeController.text,
                style: Theme.of(context).textTheme.headline4,
              )),
              Divider(),
              TextFormField(
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 25,
                ),
                controller: _categoryController,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  labelStyle: TextStyle(
                    fontSize: 12,
                  ),
                  hintText: 'Category',
                  fillColor: Colors.white,
                  filled: true,
                  contentPadding: EdgeInsets.all(15),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter Category';
                  }
                  return null;
                },
              ), // category
              Divider(),
              TextFormField(
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 25,
                ),
                enableSuggestions: true,
                controller: _modelController,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  labelStyle: TextStyle(
                    fontSize: 12,
                  ),
                  hintText: 'Product',
                  fillColor: Colors.white,
                  filled: true,
                  contentPadding: EdgeInsets.all(15),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter Product';
                  }
                  return null;
                },
              ), // model,
              Divider(),
              TextFormField(
                textAlign: TextAlign.center,
                //textAlignVertical: TextAlignVertical.center,
                maxLines: 3,
                style: const TextStyle(
                  fontSize: 15,
                ),
                controller: _descriptionController,
                decoration: const InputDecoration(
                  fillColor: Colors.white,
                  border: InputBorder.none,
                  hintText: ' \nDescription Max 200 Characters\n ',
                  filled: true,
                  contentPadding: EdgeInsets.all(15),
                ),
                // validator: (value) {
                //   if (value == null || value.isEmpty) {
                //     return 'Please enter Description';
                //   }
                //   return null;
                // },
              ),
              Divider(),
              TextFormField(
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 25,
                ),
                controller: _sizeController,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  labelStyle: TextStyle(
                    fontSize: 12,
                  ),
                  hintText: 'Size',
                  fillColor: Colors.white,
                  filled: true,
                  contentPadding: EdgeInsets.all(15),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter Size';
                  }
                  return null;
                },
              ), // size
              Divider(),
              TextFormField(
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 25,
                ),
                keyboardType: TextInputType.number,
                controller: _prixAchatController,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  labelStyle: TextStyle(
                    fontSize: 12,
                  ),
                  hintText: 'Factory Price in AED',
                  fillColor: Colors.white,
                  filled: true,
                  contentPadding: EdgeInsets.all(15),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter Model';
                  }
                  return null;
                },
              ), // factory price
              Divider(),
              TextFormField(
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 25,
                ),
                decoration: const InputDecoration(
                  fillColor: Colors.white,
                  hintText: 'Retail Price',
                  border: InputBorder.none,
                  filled: true,
                  contentPadding: EdgeInsets.all(15),
                ),
                keyboardType: TextInputType.number,
                controller: _prixVenteController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Retail Price';
                  }
                  return null;
                },
              ), // Retail Price
              Divider(),
              TextFormField(
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 25,
                ),
                decoration: const InputDecoration(
                  fillColor: Colors.white,
                  hintText: 'Quantity',
                  border: InputBorder.none,
                  filled: true,
                  contentPadding: EdgeInsets.all(15),
                ),
                keyboardType: TextInputType.number,
                controller: _stockController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter Quantity';
                  }
                  return null;
                },
              ), // Stock
              // TextFormField(
              //   textAlign: TextAlign.center,
              //   style: const TextStyle(
              //     fontSize: 25,
              //   ),
              //   decoration: const InputDecoration(
              //     fillColor: Colors.white,
              //     hintText: 'Retail Price',
              //     border: InputBorder.none,
              //     filled: true,
              //     contentPadding: EdgeInsets.all(15),
              //   ),
              //   keyboardType: TextInputType.number,
              //   controller: _codebarController,
              //   validator: (value) {
              //     if (value == null || value.isEmpty) {
              //       return 'Please enter CodeBar';
              //     }
              //     return null;
              //   },
              // ), // codebar
              // TextFormField(
              //   textAlign: TextAlign.center,
              //   style: const TextStyle(
              //     fontSize: 25,
              //   ),
              //   decoration: const InputDecoration(
              //     fillColor: Colors.white,
              //     hintText: 'Old Stock',
              //     border: InputBorder.none,
              //     filled: true,
              //     contentPadding: EdgeInsets.all(15),
              //   ),
              //   keyboardType: TextInputType.number,
              //   controller: _oldStockController,
              //   validator: (value) {
              //     if (value == null || value.isEmpty) {
              //       return 'Please enter OldStock';
              //     }
              //     return null;
              //   },
              // ), // oldStock
              Divider(),
              TextFormField(
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 25,
                ),
                decoration: const InputDecoration(
                  fillColor: Colors.white,
                  hintText: 'Made In',
                  border: InputBorder.none,
                  filled: true,
                  contentPadding: EdgeInsets.all(15),
                ),
                keyboardType: TextInputType.text,
                controller: _origineController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please Enter Origine';
                  }
                  return null;
                },
              ), // Origine
              Divider(),
              // TextFormField(
              //   textAlign: TextAlign.center,
              //   style: const TextStyle(
              //     fontSize: 25,
              //   ),
              //   decoration: const InputDecoration(
              //     fillColor: Colors.white,
              //     hintText: 'User',
              //     border: InputBorder.none,
              //     filled: true,
              //     contentPadding: EdgeInsets.all(15),
              //   ),
              //   keyboardType: TextInputType.text,
              //   controller: _userController,
              //   validator: (value) {
              //     if (value == null || value.isEmpty) {
              //       return 'Please Enter User';
              //     }
              //     return null;
              //   },
              // ), // user

              Padding(
                padding: const EdgeInsets.all(30.0),
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.black45),
                    foregroundColor: MaterialStateProperty.all(Colors.white),
                    fixedSize: MaterialStateProperty.all(Size.fromWidth(30)),
                  ),
                  onPressed: () async {
                    // Validate returns true if the form is valid, or false otherwise.
                    if (_formKeyPneux.currentState!.validate()) {
                      // showDialog(
                      //   context: context,
                      //   builder: (context) =>
                      //       Center(child: CircularProgressIndicator()),
                      // );
                      await AddItem(code).whenComplete(() {
                        Navigator.pop(context);
                        Navigator.of(context, rootNavigator: true).pop();
                      });
                      // Navigator.pop(context);
                      // ScaffoldMessenger.of(context).showSnackBar(
                      //   const SnackBar(content: Text('Processing Data')),
                      // );

                    }
                    // Navigator.of(context, rootNavigator: true).pop();
                    // Navigator.pop(context);
                  },
                  child: const Text('Submit'),
                ),
              ),
              // Padding(
              //   padding: const EdgeInsets.all(30.0),
              //   child: ElevatedButton(
              //     style: ButtonStyle(
              //       backgroundColor: MaterialStateProperty.all(Colors.green),
              //       fixedSize: MaterialStateProperty.all(Size.fromWidth(30)),
              //     ),
              //     onPressed: () async {
              //       showDialog(
              //         context: context,
              //         builder: (context) =>
              //             Center(child: CircularProgressIndicator()),
              //       );
              //       await AddPneu();
              //       Navigator.pop(context);
              //     },
              //     child: Text("Saving"),
              //   ),
              // )
              // Center(
              //   child: bbarcode.BarcodeWidget(
              //     barcode: bbarcode.Barcode.pdf417(),
              //     data: _codeController.text.toString(),
              //     drawText: false,
              //     color: Colors.black,
              //     width: MediaQuery.of(context).size.width, // * 0.6,
              //     //height: 150,
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> AddItem(code) async {
    CollectionReference ItemDetail =
        FirebaseFirestore.instance.collection('Adventure');
    User? user = FirebaseAuth.instance.currentUser;
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
          'user': user!.uid,
        }, SetOptions(merge: true))
        .then((value) => print("Item Added"))
        .catchError((error) => print("Failed to Add: $error"));
    // .whenComplete(() => PriceDealer.doc().set({
    //       'price': int.parse(_saleController.text),
    //       'dealerName': _dealerNameController.text,
    //     }, SetOptions(merge: true)));
  }
}
