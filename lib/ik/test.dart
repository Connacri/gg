import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final FirebaseServices firebaseServices = FirebaseServices();

    return MaterialApp(
      home: StreamProvider<List<Charges>>(
        create: (_) => firebaseServices.getUserList(),
        initialData: [],
        child: ViewUserPage(),
      ),
    );
  }
}

class FirebaseServices {
  FirebaseFirestore _fireStoreDataBase = FirebaseFirestore.instance;

  //recieve the data

  Stream<List<Charges>> getUserList() {
    return _fireStoreDataBase.collection('Charges').snapshots().map(
        (snapShot) => snapShot.docs
            .map((document) => Charges.fromJson(document.data()))
            .toList());
  }

  Stream count() {
    return _fireStoreDataBase.collection('Charges').snapshots().map(
        (snapShot) => snapShot.docs
            .map((document) => Charges.fromJson(document.data()))
            .toList()
            .length);

    // double summ = 0;
    // // var ds = snapshot.data!.docs;
    //
    // for (int i = 0; i < iint; i++) {
    //   summ += (document).toInt();
    // }
  }
}

class ViewUserPage extends StatelessWidget {
  double summ = 0;
  @override
  Widget build(BuildContext context) {
    List userList = Provider.of<List<Charges>>(context);

    for (int i = 0; i < userList.length; i++) {
      summ += (userList[i].amount).toInt();
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,
        title: Text('Stream Provider'),
      ),
      body: Center(child: Text(summ.toString())),
    );
  }
}

class Charges {
  double amount;
  Timestamp createdAt;
  bool credit;
  Timestamp date;
  int deadline;
  String model;
  bool periodic;
  String type;

  Charges.name(this.amount, this.createdAt, this.credit, this.date,
      this.deadline, this.model, this.periodic, this.type);

  Charges.fromJson(Map<String, dynamic> parsedJSON)
      : amount = parsedJSON['amount'],
        createdAt = parsedJSON['createdAt'],
        credit = parsedJSON['credit'],
        date = parsedJSON['date'],
        deadline = parsedJSON['deadline'],
        model = parsedJSON['model'],
        periodic = parsedJSON['periodic'],
        type = parsedJSON['type'];
}
