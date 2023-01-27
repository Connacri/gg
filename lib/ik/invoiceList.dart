import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';

import 'invoiceDetail.dart';

class invoiceList extends StatelessWidget {
  invoiceList({
    Key? key,
    //required this.sumInvoices,
  }) : super(key: key);

  //final double sumInvoices;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Invoices List'),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('Invoice')
            .orderBy('date', descending: true)
            .snapshots(),
        //.get(),
        builder: (BuildContext context, snapshot) {
          if (snapshot.hasData) {
            final List<DocumentSnapshot> documents = snapshot.data!.docs;

            return documents.isEmpty
                ? Center(
                    child: Lottie.asset(
                      'assets/lotties/112136-empty-red.json',
                      fit: BoxFit.contain,
                    ),
                  )
                : ListView(
                    shrinkWrap: true,
                    children: documents
                        .map(
                          (doc) => Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => InvoiceDetail(
                                    doc: doc,
                                  ),
                                ));
                              },
                              child: Card(
                                child: ListTile(
                                  title: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text('Customer : ' +
                                          doc['customer']
                                              .toString()
                                              .toUpperCase()),
                                      Text('Invoice ID : ' +
                                          doc.id.toUpperCase()),
                                    ],
                                  ),
                                  subtitle: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                              'Total Without Tax: ' +
                                                  NumberFormat.currency(
                                                          symbol: '')
                                                      .format(doc['total']),
                                              style: TextStyle(
                                                  color: Colors.blue)),
                                          Text(
                                            'Benef : ' +
                                                NumberFormat.currency(
                                                        symbol: '')
                                                    .format(doc['benef']),
                                            style:
                                                TextStyle(color: Colors.green),
                                          ),
                                        ],
                                      ),
                                      Container(
                                        alignment: Alignment.centerRight,
                                        child: Text(
                                          'Date : ' +
                                              doc['date'].toDate().toString(),
                                          style: TextStyle(fontSize: 12),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              // Card(
                              //   child: ExpansionTile(
                              //     tilePadding: EdgeInsets.all(10),
                              //     childrenPadding: EdgeInsets.all(10),
                              //     backgroundColor: Colors.white,
                              //     //collapsedBackgroundColor: Colors.deepPurple,
                              //     textColor: Colors.black45,
                              //     // collapsedTextColor:,
                              //     // iconColor:,
                              //     // collapsedIconColor:,
                              //     title: Column(
                              //       crossAxisAlignment: CrossAxisAlignment.start,
                              //       children: [
                              //         Text('Customer : ' +
                              //             doc['customer'].toString().toUpperCase()),
                              //         Text('Code : ' + doc.id.toUpperCase()),
                              //       ],
                              //     ),
                              //     children: <Widget>[
                              //       ListView.separated(
                              //         physics: NeverScrollableScrollPhysics(),
                              //         shrinkWrap: true,
                              //         itemCount: doc['item CodeBar'].length,
                              //         itemBuilder:
                              //             (BuildContext context, int index) {
                              //           var array = doc['item CodeBar'];
                              //           return Center(
                              //             child: Row(
                              //               children: [
                              //                 Expanded(
                              //                   flex: 2,
                              //                   child: Padding(
                              //                     padding: const EdgeInsets.only(
                              //                         left: 10),
                              //                     child: Center(
                              //                       child: Text(
                              //                         array[index]['qty']
                              //                             .toString(),
                              //                         style:
                              //                             TextStyle(fontSize: 32),
                              //                       ),
                              //                     ),
                              //                   ),
                              //                 ),
                              //                 Expanded(
                              //                   flex: 12,
                              //                   child: Padding(
                              //                     padding:
                              //                         const EdgeInsets.symmetric(
                              //                             horizontal: 15),
                              //                     child: Column(
                              //                       crossAxisAlignment:
                              //                           CrossAxisAlignment.start,
                              //                       children: [
                              //                         Text(
                              //                           doc['item CodeBar'][index]
                              //                                   ['codebar']
                              //                               .toString(),
                              //                           overflow:
                              //                               TextOverflow.ellipsis,
                              //                         ),
                              //                         Text(
                              //                             array[index]['model']
                              //                                 .toString(),
                              //                             overflow: TextOverflow
                              //                                 .ellipsis),
                              //                         Row(
                              //                           mainAxisAlignment:
                              //                               MainAxisAlignment
                              //                                   .spaceBetween,
                              //                           children: [
                              //                             Text('Unit Price : ' +
                              //                                 array[index]
                              //                                         ['prixVente']
                              //                                     .toString()),
                              //                             Text('Amount : ' +
                              //                                 (array[index][
                              //                                             'prixVente'] *
                              //                                         array[index]
                              //                                             ['qty'])
                              //                                     .toString()),
                              //                           ],
                              //                         ),
                              //                       ],
                              //                     ),
                              //                   ),
                              //                 ),
                              //               ],
                              //             ),
                              //           );
                              //         },
                              //         separatorBuilder:
                              //             (BuildContext context, int index) =>
                              //                 const Divider(
                              //           thickness: 1,
                              //         ),
                              //       ),
                              //     ],
                              //     subtitle: Column(
                              //       mainAxisAlignment: MainAxisAlignment.start,
                              //       crossAxisAlignment: CrossAxisAlignment.start,
                              //       children: [
                              //         Text('Total : ' +
                              //             NumberFormat.currency(symbol: '')
                              //                 .format(doc['total']) +
                              //             '  ' +
                              //             'Benef : ' +
                              //             NumberFormat.currency(symbol: '')
                              //                 .format(doc['benef'])),
                              //         Text(
                              //           'Date : ' + doc['date'].toDate().toString(),
                              //           style: TextStyle(fontSize: 12),
                              //         )
                              //       ],
                              //     ),
                              //   ),
                              // ),
                            ),
                          ),
                        )
                        .toList());
          } else if (snapshot.hasError) {
            return Text('Its Error!');
          }
          return Center(
            child: CircularProgressIndicator(
              color: Colors.black45,
            ),
          );
        },
      ),
    );
  }
}
