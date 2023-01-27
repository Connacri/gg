import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:barcode_widget/barcode_widget.dart' as bbarcode;

class AddingDealerPrice extends StatefulWidget {
  AddingDealerPrice({
    Key? key,
    required this.code,
  }) : super(key: key);

  final String code;

  @override
  State<AddingDealerPrice> createState() => _AddingDealerPriceState();
}

class _AddingDealerPriceState extends State<AddingDealerPrice> {
  final TextEditingController _saleController = TextEditingController();
  final TextEditingController _dealerNameController = TextEditingController();
  final _formKeyp = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text('Add Dealer Name & Price'),
        ),
      ),
      body: Form(
        key: _formKeyp,
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
                    data: widget.code.toString(),
                    drawText: false,
                    color: Colors.black,
                    //width: MediaQuery.of(context).size.width * 0.6,
                    height: 60,
                  ),
                ),
              ),
              Center(
                  child: Text(
                widget.code.toString(),
                style: Theme.of(context).textTheme.headline4,
              )),
              Divider(),
              TextFormField(
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 25,
                ),
                keyboardType: TextInputType.number,
                controller: _saleController,
                decoration: const InputDecoration(
                  fillColor: Colors.white,
                  hintText: 'Price',
                  border: InputBorder.none,
                  filled: true,
                  contentPadding: EdgeInsets.all(15),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter Model';
                  }
                  return null;
                },
              ), // sale
              // TextFormField(
              //   style: const TextStyle(
              //     fontFamily: 'Oswald',
              //     fontSize: 12,
              //   ),
              //   keyboardType: TextInputType.number,
              //   controller: _oldStockController,
              //   decoration: const InputDecoration(
              //     hintText: 'Old Stock',
              //     prefixIcon: Icon(
              //       Icons.auto_awesome_outlined,
              //       size: 30,
              //     ),
              //     fillColor: Colors.white,
              //     filled: true,
              //     contentPadding: EdgeInsets.all(15),
              //   ),
              //   validator: (value) {
              //     if (value == null || value.isEmpty) {
              //       return 'Please enter Model';
              //     }
              //     return null;
              //   },
              // ), // oldStock
              // TextFormField(
              //   style: const TextStyle(
              //     fontFamily: 'Oswald',
              //     fontSize: 12,
              //   ),
              //   keyboardType: TextInputType.number,
              //   controller: _dealerController,
              //   decoration: const InputDecoration(
              //     hintText: 'Dealer',
              //     prefixIcon: Icon(
              //       Icons.storage,
              //       size: 30,
              //     ),
              //     fillColor: Colors.white,
              //     filled: true,
              //     contentPadding: EdgeInsets.all(15),
              //   ),
              //   validator: (value) {
              //     if (value == null || value.isEmpty) {
              //       return 'Please enter Model';
              //     }
              //     return null;
              //   },
              // ), // dealer
              // TextFormField(
              //   style: const TextStyle(
              //     fontFamily: 'Oswald',
              //     fontSize: 12,
              //   ),
              //   keyboardType: TextInputType.number,
              //   controller: _retailController,
              //   decoration: const InputDecoration(
              //     hintText: 'Retail Price',
              //     prefixIcon: Icon(
              //       Icons.monetization_on,
              //       size: 30,
              //     ),
              //     fillColor: Colors.white,
              //     filled: true,
              //     contentPadding: EdgeInsets.all(15),
              //   ),
              //   validator: (value) {
              //     if (value == null || value.isEmpty) {
              //       return 'Please enter Retail Price';
              //     }
              //     return null;
              //   },
              // ), // retail
              // ElevatedButton(
              //   onPressed: AddPneu,
              //   child: const Text(
              //     'Add Pneux',
              //     style: TextStyle(
              //       fontFamily: 'Oswald',
              //       fontSize: 12,
              //     ),
              //   ),
              // ),
              SizedBox(
                height: 10,
              ),
              TextFormField(
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontFamily: 'Oswald',
                  fontSize: 25,
                ),
                keyboardType: TextInputType.text,
                controller: _dealerNameController,
                decoration: const InputDecoration(
                  hintText: 'Dealer Name',
                  border: InputBorder.none,
                  fillColor: Colors.white,
                  filled: true,
                  contentPadding: EdgeInsets.all(15),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please Enter Dealer Name';
                  }
                  return null;
                },
              ), // dealerName
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
                    if (_formKeyp.currentState!.validate()) {
                      // ScaffoldMessenger.of(context).showSnackBar(
                      //     const SnackBar(content: Text('Processing Data')));
                      // showDialog(
                      //   context: context,
                      //   builder: (context) =>
                      //       Center(child: CircularProgressIndicator()),
                      // );
                      await AddDealerPrice(widget.code).whenComplete(() {
                        Navigator.pop(context);
                        //Navigator.of(context, rootNavigator: true).pop();
                      });
                      // Navigator.pop(context);
                      // ScaffoldMessenger.of(context).showSnackBar(
                      //   const SnackBar(content: Text('Processing Data')),
                      // );

                    } else
                      return;
                  },
                  child: const Text('Add'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> AddDealerPrice(code) async {
    CollectionReference _dealerPrice =
        FirebaseFirestore.instance.collection('superette');
    return _dealerPrice.doc(code).set({
      'dealer': FieldValue.arrayUnion([
        {
          'price': int.parse(_saleController.text),
          'name': _dealerNameController.text,
        }
      ]),
    }, SetOptions(merge: true));
  }
}
