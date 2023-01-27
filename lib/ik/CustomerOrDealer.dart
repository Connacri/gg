import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'Estimate.dart';
import 'invoiceList.dart';

class CustomerOrDealer extends StatefulWidget {
  const CustomerOrDealer(
      {Key? key,
      required this.dataDealer,
      required this.dataDevis,
      required this.sum,
      required this.benef,
      required this.switched})
      : super(key: key);
  final Map dataDealer;
  final List dataDevis;
  final double sum;
  final double benef;
  final bool switched;

  @override
  State<CustomerOrDealer> createState() => _CustomerOrDealerState();
}

class _CustomerOrDealerState extends State<CustomerOrDealer> {
  Color colorRed = Color.fromARGB(255, 213, 2, 2); //Colors.deepPurple;
  Color colorOrange =
      Color.fromARGB(255, 255, 95, 0); //Colors.deepOrangeAccent;
  Color colorGreen = Color.fromARGB(255, 139, 169, 2); //Colors.greenAccent;
  Color colorBlue = Color.fromARGB(255, 66, 58, 41);
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController dateinput = TextEditingController();
  var datepass;

  late bool isSwitched = widget.switched;
  // bool isSwitched = true;
  @override
  void initState() {
    dateinput.text = DateFormat('yyyy-MM-dd')
        .format(DateTime.now()); //set the initial value of text field
    super.initState();
  }

  // bool isSwitched = widget.switched;

  @override
  Widget build(BuildContext context) {
    final String userDisplayName = 'sz';
    final TextEditingController _customerControllerSwitched =
        TextEditingController(text: widget.dataDealer['userDisplayName']);

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
                      color: !isSwitched // !isSwitched
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
                    onChanged: (value) {
                      setState(() {
                        isSwitched = value;
                      });
                    }),
                Text(
                  'Dealer',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      color: isSwitched //isSwitched
                          ? Colors.cyan //Color.fromRGBO(139, 169, 2, 1.0)
                          : Colors.black54),
                ),
              ],
            ), // Switch

            buildColumn(
              formKey: _formKey,
              dateinput: dateinput,
              isSwitched: isSwitched, //isSwitched,
              // customerControllerSwitched: customerControllerSwitched,
              // customerController: customerController,
              userDisplayName: userDisplayName,
              dataDevis: widget.dataDevis,
              sum: widget.sum,
              benef: widget.benef,
            )
          ],
        ),
      ),
    );
  }

  StreamBuilder<QuerySnapshot<Map<String, dynamic>>> DealersList() {
    return StreamBuilder(
        stream: FirebaseFirestore.instance.collection('Users').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
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
                    itemCount:
                        snapshot.data == null ? 0 : snapshot.data!.docs.length,
                    itemBuilder: (_, index) {
                      DocumentSnapshot _documentSnapshot =
                          snapshot.data!.docs[index];

                      return ListTile(
                        onTap: () {
                          // Navigator.of(context).push(MaterialPageRoute(
                          //   builder: (context) => addCustomerToEstimate3(
                          //     dataDevis: LLIst,
                          //     sum: summ,
                          //     benef: countEarn,
                          //     userDisplayName:
                          //     _documentSnapshot['userDisplayName'],
                          //   ),
                          // ));
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
                            imageBuilder: (context, imageProvider) => Container(
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
        });
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

class buildColumn extends StatefulWidget {
  buildColumn(
      {Key? key,
      required this.formKey,
      required this.dateinput,
      required this.isSwitched,
      // required this.customerControllerSwitched,
      // required this.customerController,
      required this.userDisplayName,
      required this.dataDevis,
      required this.sum,
      required this.benef})
      : super(key: key);
  GlobalKey<FormState> formKey;
  final dateinput;
  final bool isSwitched;
  // final  customerControllerSwitched;
  // final  customerController;
  final String userDisplayName;
  final List dataDevis;
  final double sum;
  final double benef;

  var datepass;

  @override
  _buildColumnState createState() {
    return _buildColumnState();
  }
}

class _buildColumnState extends State<buildColumn> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  final TextEditingController customerController = TextEditingController();
  final TextEditingController customerControllerSwitched =
      TextEditingController();
  String id = '';
  String name = '';
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Center(child: Text(id.toUpperCase())),
        Center(child: Text(name.toUpperCase())),
        TextFormField(
          autofocus: true,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 25,
          ),
          onChanged: (value) {
            print(value);
            print(customerControllerSwitched.text);
            setState(() {
              if (value != name) {
                id = '';
                name = '';
              } else {
                id;
                name;
              }
            });
          },
          keyboardType: TextInputType.text,
          controller: widget.isSwitched
              ? customerControllerSwitched
              : customerController,
          validator: (value) => value!.isEmpty ||
                  value == null ||
                  int.tryParse(value.toString()) == 0
              ? 'Cant be Empty'
              : null,
          decoration: InputDecoration(
            suffixIcon: widget.isSwitched
                ? IconButton(
                    onPressed: () async {
                      var DealersListChoice = await showModalBottomSheet(
                          context: context,
                          builder: (context) {
                            return FutureBuilder(
                                future: getposts(),
                                //future: FirebaseFirestore.instance.collection('Adventure').get(),
                                builder:
                                    (BuildContext, AsyncSnapshot snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.none) {
                                    return Text(
                                      'Error!!!',
                                      style:
                                          Theme.of(context).textTheme.headline5,
                                    );
                                  }
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return Center(
                                      child: CircularProgressIndicator(
                                        color: Colors.black45,
                                      ),
                                    );
                                  }
                                  if (snapshot.connectionState ==
                                      ConnectionState.done) {
                                    if (snapshot.hasData) {
                                      return ListView.builder(
                                        itemCount: snapshot.data.length,
                                        itemBuilder: (_, index) {
                                          var data = snapshot.data![index];
                                          return ListTile(
                                            onTap: () async {
                                              setState(() {
                                                customerControllerSwitched
                                                        .text =
                                                    data['userDisplayName'];
                                                id = data.id;
                                                name = data['userDisplayName'];
                                              });
                                              Navigator.of(context).pop();
                                            },
                                            leading: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                              child: CachedNetworkImage(
                                                width: 50,
                                                fit: BoxFit.cover,
                                                imageUrl: data['userAvatar'],
                                              ),
                                            ),
                                            title: Text(data['userDisplayName']
                                                .toString()),
                                            subtitle: Text(
                                                data['userEmail'].toString()),
                                          );

                                          //   Center(
                                          //   child: Text(snapshot.data[index].id.toString()),
                                          // );
                                        },
                                      );
                                    }
                                  }
                                  return Center(child: Text('no data'));
                                });
                          });
                    },
                    icon: Icon(
                      Icons.account_circle_rounded,
                    ))
                : null,
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
          controller: widget.dateinput,
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
                widget.datepass = pickedDate;
                widget.dateinput.text =
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
                if (widget.formKey.currentState!.validate()) {
                  // If the form is valid, display a snackbar. In the real world,
                  // you'd often call a server or save the information in a database.
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Processing Data')),
                  );

                  print(
                      '******************************************************'); //
                  widget.isSwitched
                      ? addDealer(
                          widget.dataDevis,
                          widget.sum.toString(),
                          widget.benef,
                          customerControllerSwitched.text,
                          DateTime.now(),
                        )
                      : addDevisToInvoiceList(
                          widget.dataDevis,
                          widget.sum.toString(),
                          widget.benef,
                          customerController.text,
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
        ),
      ],
    );
  }
}

Future getposts() async {
  var firestore = FirebaseFirestore.instance;
  QuerySnapshot qn = await firestore.collection('Users').get();
  return qn.docs;
}
