import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';

import 'AddingCharges.dart';

class chargeList extends StatelessWidget {
  final TextEditingController _periodicController = TextEditingController();
  final TextEditingController _creditController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _deadlineController =
      TextEditingController(text: '00');
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _modelController = TextEditingController();
  late String dropdownValue;
  final TextEditingController _createdAtController = TextEditingController();
  final TextEditingController _typeController = TextEditingController();
  final TextEditingController _stockController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('Charges')
          .orderBy('date', descending: true)
          .snapshots(),
      // .get(),
      builder: (BuildContext context, snapshot) {
        if (snapshot.hasData) {
          final List<DocumentSnapshot> documents = snapshot.data!.docs;
          double summ = 0;
          // var ds = snapshot.data!.docs;

          for (int i = 0; i < documents.length; i++) {
            summ += (documents[i]['amount']).toInt();
          }

          return Scaffold(
            appBar: AppBar(
              title: Text('Charges List'),
              actions: [
                Center(
                  child: Text(NumberFormat.currency(symbol: '').format(summ)),
                ),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => AddingCharges(),
                    ));
                  },
                ),
              ],
            ),
            body: documents.isEmpty
                ? Center(
                    child:
                        Lottie.asset('assets/lotties/130689-send-data-2.json'),
                  )
                : ListView(
                    shrinkWrap: true,
                    children: documents
                        .map(
                          (doc) => Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Card(
                              child: Slidable(
                                key: const Key('keyslidable2'),
                                startActionPane: ActionPane(
                                  key: Key('updatingCost'),
                                  dragDismissible: true,
                                  motion: const StretchMotion(),
                                  extentRatio: 0.25,
                                  children: [
                                    SlidableAction(
                                      onPressed: (Context) =>
                                          //print(doc['amount']),
                                          _upDate(Context, doc.id, doc),
                                      borderRadius: BorderRadius.circular(10),
                                      backgroundColor: Colors.green,
                                      foregroundColor: Colors.white,
                                      icon: Icons.edit,
                                      label: 'Edit',
                                    ),
                                  ],
                                ),
                                endActionPane: ActionPane(
                                  key: Key('deletingCost'),
                                  motion: const StretchMotion(),
                                  extentRatio: 0.25,
                                  children: [
                                    SlidableAction(
                                      onPressed: (BuildContext) async {
                                        print(doc.id);
                                        await _deleteDialog(
                                            context, doc, doc.id);
                                      },
                                      borderRadius: BorderRadius.circular(10),
                                      backgroundColor: Colors.red,
                                      foregroundColor: Colors.white,
                                      icon: Icons.delete,
                                      label: 'Delete',
                                    ),
                                  ],
                                ),
                                child: ListTile(
                                  leading: doc['type'] == 'one time'
                                      ? CircleAvatar(
                                          backgroundColor: Colors.blueAccent,
                                          child: Padding(
                                            padding: const EdgeInsets.all(4.0),
                                            child: FittedBox(
                                              child: Text(
                                                doc['type'].toString(),
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                            ),
                                          ),
                                        )
                                      : CircleAvatar(
                                          backgroundColor: Colors.cyan,
                                          child: Padding(
                                            padding: const EdgeInsets.all(4.0),
                                            child: FittedBox(
                                              child: Text(
                                                doc['type'].toString(),
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                            ),
                                          ),
                                        ),
                                  trailing: Text(
                                    NumberFormat.currency(symbol: '')
                                        .format(doc['amount']),
                                    style: TextStyle(
                                      color: Colors.cyan,
                                    ),
                                  ),
                                  title: Text(
                                    'Model : ' +
                                        doc['model'].toString().toUpperCase(),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  subtitle: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      // Text(
                                      //     'Deadline: ' +
                                      //         (doc['deadline'].toString()) +
                                      //         ' Days',
                                      //     style: TextStyle(
                                      //       color: Colors.cyan,
                                      //     )),
                                      Text(
                                          'Daily : ' +
                                              (doc['type'] == 'Annual'
                                                  ? NumberFormat.currency(
                                                          symbol: '')
                                                      .format(
                                                          doc['amount'] / 360)
                                                  : doc['type'] == 'Monthly'
                                                      ? NumberFormat.currency(
                                                              symbol: '')
                                                          .format(
                                                              doc['amount'] /
                                                                  30)
                                                      : NumberFormat.currency(
                                                              symbol: '')
                                                          .format(doc['amount'])
                                                          .toString()),
                                          style: TextStyle(
                                            color: Colors.cyan,
                                          )),
                                      Text(
                                        'Date : ' +
                                            doc['date']
                                                .toDate()
                                                .day
                                                .toString() +
                                            '/' +
                                            doc['date']
                                                .toDate()
                                                .month
                                                .toString() +
                                            '/' +
                                            doc['date']
                                                .toDate()
                                                .year
                                                .toString(),
                                        style: TextStyle(fontSize: 12),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        )
                        .toList()),
          );
        } else if (snapshot.hasError) {
          return Text('Its Error!');
        }
        return Center(
          child: CircularProgressIndicator(
            color: Colors.black45,
          ),
        );
      },
    );
  }

  Future<void> _upDate(context, dataid, data) async {
    if (data != null) {
      _periodicController.text = data['periodic'];
      _creditController.text = data['credit'];
      _dateController.text = data['date'];
      _modelController.text = data['model'];
      _deadlineController.text = data['deadline'];
      _amountController.text = data['amount'];
      _createdAtController.text = data['createdAt'];
      _typeController.text = data['type'];
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
                ToggleButtons(children: [
                  Text('Yes'),
                  Text('no'),
                ], isSelected: [
                  true
                ]),
                TextField(
                  controller: _creditController,
                  decoration: const InputDecoration(
                    label: Text('CodeBar'),
                  ),
                ),
                TextField(
                  controller: _dateController,
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
                  controller: _deadlineController,
                  decoration: const InputDecoration(
                    label: Text('Description'),
                  ),
                ),
                TextField(
                  controller: _amountController,
                  decoration: const InputDecoration(
                    label: Text('Size'),
                  ),
                ),
                TextField(
                  controller: _typeController,
                  decoration: const InputDecoration(
                    label: Text('Size'),
                  ),
                ),
                ElevatedButton(
                    onPressed: () async {
                      final String _createdAt = _createdAtController.text;
                      final String _periodic = _periodicController.text;
                      final String _credit = _creditController.text;
                      final String _date = _dateController.text;
                      final String _model = _modelController.text;
                      final String _deadline = _deadlineController.text;
                      final String _amount = _amountController.text;
                      final String _type = _typeController.text;

                      await FirebaseFirestore.instance
                          .collection('Adventure')
                          .doc(dataid)
                          .update({
                        'createdAt': Timestamp.now().toDate(),
                        'model': _modelController.text,
                        'date': DateTime.parse(_dateController.text),
                        'amount': double.parse(_amountController.text),
                        'deadline': int.parse(_deadlineController.text),
                        'type': //_typeController.text,
                            dropdownValue,
                        'periodic': _periodicController.text,
                        'credit': _creditController.text,
                      });

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
}

_deleteDialog(BuildContext context, data, dataid) {
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
      "I'm Sure to Delete it",
      style: TextStyle(color: Colors.white, fontSize: 10),
    ),
    onPressed: () {
      FirebaseFirestore.instance
          .collection('Charges')
          .doc(dataid)
          .delete()
          .whenComplete(() => debugPrint('Cost Deleted...'));

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
