// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// ignore_for_file: public_member_api_docs

import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencedTestik extends StatelessWidget {
  const SharedPreferencedTestik({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'SharedPreferences Demo',
      home: SharedPreferencesDemo(),
    );
  }
}

class SharedPreferencesDemo extends StatefulWidget {
  const SharedPreferencesDemo({Key? key}) : super(key: key);

  @override
  SharedPreferencesDemoState createState() => SharedPreferencesDemoState();
}

class SharedPreferencesDemoState extends State<SharedPreferencesDemo> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: Center(
            child: ElevatedButton(
          onPressed: () {
            getFromSharedAsMap();
          },
          child: Text('get'),
        )));
    // ListView.builder(
    //     // itemCount: values.length,
    //     itemBuilder: (BuildContext context, int i) {
    //   //String key = values.keys.elementAt(i);
    //   return new Column(
    //     children: <Widget>[
    //       new ListTile(
    //           //title: new Text("$key"),
    //           //subtitle: new Text("${values[key]}"),
    //           ),
    //       new Divider(
    //         height: 2.0,
    //       ),
    //     ],
    //   );
    // }));
  }

  Future<void> getFromSharedAsMap() async {
    Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    final SharedPreferences prefs = await _prefs;

    var jsonString = prefs.getString("dataid");
    var _res = jsonDecode(jsonString!);
    print('//////////////////get the list////////////////////////');
    print(_res);
  }
}
