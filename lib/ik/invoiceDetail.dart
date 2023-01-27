import 'package:barcode_widget/barcode_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'pdf/pdf_printing/pdfTa3List.dart';

class InvoiceDetail extends StatefulWidget {
  // test github
  const InvoiceDetail({
    Key? key,
    required this.doc,
  }) : super(key: key);
  final doc;
  @override
  State<InvoiceDetail> createState() => _InvoiceDetailState();
}

class _InvoiceDetailState extends State<InvoiceDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: const Icon(Icons.picture_as_pdf),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Processing Data')),
              );
              Navigator.of(context)
                  .push(MaterialPageRoute(
                    builder: (context) => PdfPageTa3List(
                      array: widget.doc['item CodeBar'],
                      //dataDevis: widget.doc,
                      customer: widget.doc['customer'],
                      date: widget.doc['date'].toDate() ?? DateTime.now(),
                      codeDevis: widget.doc.id,
                    ),
                  ))
                  .whenComplete(() =>
                      debugPrint('is fiiiiiiiiiiiiiiiiiiiiiiiinishhhhhhhhhh'));
              //print(widget.doc['item CodeBar']);
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Center(
          child: ListView(children: [
            Center(
              child: Text(
                'Invoice'.toUpperCase(),
                style: TextStyle(fontSize: 50),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: BarcodeWidget(
                  height: 50,
                  drawText: false,
                  data: widget.doc.id.toString(),
                  barcode: Barcode.code128()),
            ),
            Center(child: Text('Invoice N° : ' + widget.doc.id.toUpperCase())),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  'HT ' +
                      NumberFormat.currency(symbol: '')
                          .format(widget.doc['total']),
                  style: TextStyle(fontSize: 20),
                ),
                Text(
                  'B ' +
                      NumberFormat.currency(symbol: '')
                          .format(widget.doc['benef']),
                  style: TextStyle(color: Colors.green, fontSize: 20),
                ),
              ],
            ),
            SizedBox(
              height: 15,
            ),
            Text('Customer : ' +
                widget.doc['customer'].toString().toUpperCase()),
            Text('Date : ' +
                widget.doc['date'].toDate().toString().toUpperCase()),
            Divider(
              thickness: 1,
            ),
            ListView.separated(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: widget.doc['item CodeBar'].length,
              itemBuilder: (BuildContext context, int index) {
                var array = widget.doc['item CodeBar'];
                return Center(
                  child: Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: Center(
                            child: Text(
                              array[index]['qty'].toString(),
                              style: TextStyle(fontSize: 32),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 12,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.doc['item CodeBar'][index]['codebar']
                                    .toString(),
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(array[index]['model'].toString(),
                                  overflow: TextOverflow.ellipsis),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Unit Price : ' +
                                      NumberFormat.currency(symbol: '')
                                          .format(array[index]['prixVente'])),
                                  Text('Amount : ' +
                                      NumberFormat.currency(symbol: '').format(
                                          (array[index]['prixVente'] *
                                              array[index]['qty']))),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
              separatorBuilder: (BuildContext context, int index) =>
                  const Divider(
                thickness: 1,
              ),
            ),
            Divider(
              thickness: 1,
            ),
            Container(
              alignment: Alignment.centerRight,
              child: Text(
                'Total : ' +
                    NumberFormat.currency(symbol: '')
                        .format(widget.doc['total']),
                style: TextStyle(fontSize: 18),
              ),
            ),
            Container(
              alignment: Alignment.centerRight,
              child: Text(
                'Vat 0% : ' +
                    NumberFormat.currency(symbol: '')
                        .format((widget.doc['total'] * 0.0))
                        .toString(),
                style: TextStyle(fontSize: 12),
              ),
            ),
            Container(
              alignment: Alignment.centerRight,
              child: Text('TTC : ' +
                  NumberFormat.currency(symbol: '').format(
                      (widget.doc['total'] * 0.0) + widget.doc['total'])),
            ),
            Container(
              alignment: Alignment.centerRight,
              child: Text(
                'Benef : ' +
                    NumberFormat.currency(symbol: '')
                        .format(widget.doc['benef']),
                style: TextStyle(color: Colors.green),
              ),
            ),
            TextButton(
                onPressed: () async {
                  await Recover(widget.doc['item CodeBar'], widget.doc.id);
                  Navigator.of(context).pop();
                },
                child: Text(
                  'Delete Forever',
                  style: TextStyle(color: Colors.redAccent),
                )),
          ]),
        ),
      ),
    );
  }
}

Recover(itemDel, docid) async {
  final numbers = List.generate(itemDel.length, (index) => index);

  for (final number in numbers) {
    final items = itemDel[number];
    //print(itemDel[number]);
    print(numbers);
    //print('codebar : ' + items['codebar'] + '/ Qty : ' + items['qty']);

    CollectionReference ItemDetail =
        FirebaseFirestore.instance.collection('Adventure');

    // return print(items['codebar']);

    ItemDetail.doc(items['codebar'].toString())
        .update(
          {
            'stock': FieldValue.increment(items['qty']),
          },
        )
        .then((value) => print("Qty ${items['qty']} recovered N° ${number}"))
        .catchError((error) => print("Failed to Add: $error"));
  }

  FirebaseFirestore.instance
      .collection('Invoice')
      .doc(docid)
      .delete()
      .then((value) => print("Invoice Deleted"));
}
