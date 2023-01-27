import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'Estimate.dart';
import 'invoiceList.dart';

class ListDealers extends StatelessWidget {
  ListDealers({
    Key? key,
    required this.LLIst,
    required this.summ,
    required this.countEarn,
    required this.userDisplayName,
  }) : super(key: key);

  final List LLIst;
  final double summ;
  final double countEarn;
  final String userDisplayName;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance.collection('Users').snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
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
                      // child: Lottie.asset(
                      //     'assets/lotties/89832-empty-list.json',
                      //     fit: BoxFit.contain),
                      child: Text(
                        'Users List Is Empty',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 20),
                      ),
                    ));
              }
            } catch (exception) {}

            return Scaffold(
              appBar: AppBar(
                toolbarHeight: 90.0,
                title: Text('Users List'),
              ),
              body: ListView(
                children: [
                  ListView.builder(
                      shrinkWrap: true,
                      itemCount: snapshot.data == null
                          ? 0
                          : snapshot.data!.docs.length,
                      itemBuilder: (_, index) {
                        DocumentSnapshot _documentSnapshot =
                            snapshot.data!.docs[index];

                        return ListTile(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => addCustomerToEstimate3(
                                dataDevis: LLIst,
                                sum: summ,
                                benef: countEarn,
                                userDisplayName:
                                    _documentSnapshot['userDisplayName'],
                              ),
                            ));
                          },
                          leading: Container(
                            width: 50.0,
                            height: 50.0,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                            ),
                            child: CachedNetworkImage(
                              imageUrl:
                                  _documentSnapshot['userAvatar'].toString(),
                              imageBuilder: (context, imageProvider) =>
                                  Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                      image: imageProvider, fit: BoxFit.cover),
                                ),
                              ),
                              errorWidget: (context, url, error) =>
                                  Icon(Icons.error),
                            ),
                          ),
                          title: Row(
                            children: [
                              Text(
                                _documentSnapshot['userRole']
                                        .toString()
                                        .toUpperCase() ??
                                    'unknow',
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(color: Colors.red),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                _documentSnapshot['userDisplayName']
                                    .toString()
                                    .toUpperCase(),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'ID : ' +
                                    _documentSnapshot['userID']
                                        .toString()
                                        .toUpperCase(),
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                'Phone : ' +
                                    _documentSnapshot['userPhone'].toString(),
                                overflow: TextOverflow.ellipsis,
                              )
                            ],
                          ),
                        );
                      }),
                ],
              ),
            );
          }),
    );
  }
}

class addCustomerToEstimate3 extends StatefulWidget {
  addCustomerToEstimate3({
    Key? key,
    required this.dataDevis,
    required this.sum,
    required this.benef,
    required this.userDisplayName,
  }) : super(key: key);

  final List dataDevis;
  final double sum;
  final double benef;
  final String userDisplayName;

  @override
  State<addCustomerToEstimate3> createState() => _addCustomerToEstimate3State();
}

class _addCustomerToEstimate3State extends State<addCustomerToEstimate3> {
  Color colorRed = Color.fromARGB(255, 213, 2, 2); //Colors.deepPurple;
  Color colorOrange =
      Color.fromARGB(255, 255, 95, 0); //Colors.deepOrangeAccent;
  Color colorGreen = Color.fromARGB(255, 139, 169, 2); //Colors.greenAccent;
  Color colorBlue = Color.fromARGB(255, 66, 58, 41);
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _customerController = TextEditingController();

  final TextEditingController dateinput = TextEditingController();
  var datepass;

  @override
  void initState() {
    dateinput.text = DateFormat('yyyy-MM-dd')
        .format(DateTime.now()); //set the initial value of text field
    final String dealerName = widget.userDisplayName;
    super.initState();
  }

  bool isSwitched = false;
  @override
  Widget build(BuildContext context) {
    final TextEditingController _customerControllerSwitched =
        TextEditingController(text: widget.userDisplayName);
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: FittedBox(
            child: Text(
              'Finalisation'.toUpperCase(),
              style: TextStyle(
                color: Colors.blue, // Colors.orange,
              ),
            ),
          ),
        ),
        actions: [],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          children: [
            Center(
              child: Text(
                'AED ' + NumberFormat.currency(symbol: '').format(widget.sum),
                style: const TextStyle(fontSize: 25, color: Colors.blue),
              ),
            ),
            Center(
              child: Text(
                'AED ' + NumberFormat.currency(symbol: '').format(widget.benef),
                style: TextStyle(fontSize: 25, color: colorGreen),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Retail',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      color: !isSwitched
                          ? Color.fromRGBO(126, 13, 13, 1.0)
                          : Colors.black54),
                ),
                Switch(
                  activeColor: Colors.cyan,
                  activeTrackColor: Colors.cyan.shade100,
                  inactiveThumbColor: Color.fromRGBO(126, 13, 13, 1.0),
                  inactiveTrackColor:
                      Color.fromRGBO(126, 13, 13, 0.4235294117647059),
                  splashRadius: 50.0,
                  value: isSwitched,
                  onChanged: (value) => setState(() => isSwitched = value),
                ),
                Text(
                  'Dealer',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      color: isSwitched
                          ? Colors.cyan //Color.fromRGBO(139, 169, 2, 1.0)
                          : Colors.black54),
                ),
              ],
            ), // Switch

            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 25.0, horizontal: 80),
              child: isSwitched
                  ? TextButton.icon(
                      onPressed: () => {},
                      // Navigator.of(context).push(
                      // MaterialPageRoute(
                      //     builder: (context) => ListDealers())),
                      icon: Icon(
                        Icons.account_circle_rounded,
                        color: Colors.cyan,
                      ),
                      label: Text(
                        'Select Dealer',
                        style: TextStyle(color: Colors.cyan),
                      ))
                  : null,
            ),

            TextFormField(
              autofocus: true,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 25,
              ),
              keyboardType: TextInputType.text,
              controller: isSwitched
                  ? _customerControllerSwitched
                  : _customerController,
              validator: (value) => value!.isEmpty ||
                      value == null ||
                      int.tryParse(value.toString()) == 0
                  ? 'Cant be Empty'
                  : null,
              decoration: InputDecoration(
                border: InputBorder.none,
                filled: true,
                contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),

                hintText: 'Customer Name',
                fillColor: Colors.white,
                //filled: true,
              ),
            ),
            Divider(),
            TextField(
              controller: dateinput,
              //editing controller of this TextField
              style: const TextStyle(
                fontSize: 25,
              ),
              autofocus: true,
              textAlign: TextAlign.center,
              decoration: const InputDecoration(
                border: InputBorder.none,
                filled: true,
                contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),

                hintText: 'Estimate Number',
                fillColor: Colors.white,
                //filled: true,
              ),
              readOnly: true,
              //set it true, so that user will not able to edit text
              onTap: () async {
                DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    //DateTime.now() - not to allow to choose before today.
                    lastDate: DateTime(2101));

                if (pickedDate != null) {
                  print(
                      pickedDate); //pickedDate output format => 2021-03-10 00:00:00.000
                  String formattedDate =
                      DateFormat('yyyy-MM-dd').format(pickedDate);
                  print(
                      formattedDate); //formatted date output using intl package =>  2021-03-16
                  //you can implement different kind of Date Format here according to your requirement

                  setState(() {
                    datepass = pickedDate;
                    dateinput.text =
                        formattedDate; //set output date to TextField value.
                  });
                } else {
                  print("Date is not selected");
                }
              },
            ),
            SizedBox(
              height: 100,
            ),
            Center(
              child: ElevatedButton(
                  onPressed: () {
                    // Validate returns true if the form is valid, or false otherwise.
                    if (_formKey.currentState!.validate()) {
                      // If the form is valid, display a snackbar. In the real world,
                      // you'd often call a server or save the information in a database.
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Processing Data')),
                      );

                      print(
                          '******************************************************'); //
                      isSwitched
                          ? addDealer(
                              widget.dataDevis,
                              widget.sum.toString(),
                              widget.benef,
                              _customerController.text,
                              DateTime.now(),
                            )
                          : addDevisToInvoiceList(
                              widget.dataDevis,
                              widget.sum.toString(),
                              widget.benef,
                              _customerController.text,
                              DateTime.now(),
                            );
                    }
                    ;
                    _deleteAllEstimate();

                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                        builder: (context) => invoiceList(),
                      ),
                      (route) => route.isFirst,
                    );
                  },
                  child: Text(
                    'Add To Invoice'.toUpperCase(),
                    style: const TextStyle(fontSize: 15, color: Colors.black54),
                  )),
            )
          ],
        ),
      ),
    );
  }
}

Future<void> _deleteAllEstimate() async {
  CollectionReference collection =
      FirebaseFirestore.instance.collection('Estimate'); //var
  QuerySnapshot snapshot = await collection.get(); //var
  for (var doc in snapshot.docs) {
    await doc.reference.delete();
    print(doc.reference);
    print('deleted');
  }
}
