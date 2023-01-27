import 'dart:io';

import 'package:flutter/material.dart';
//import 'package:open_document/open_document.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as p;

class MainPdf extends StatefulWidget {
  const MainPdf({Key? key}) : super(key: key);

  @override
  State<MainPdf> createState() => _MainPdfState();
}

class _MainPdfState extends State<MainPdf> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Center(
              // child: ElevatedButton(
              //     child: Text('Invoice PDF'),
              //     onPressed: () async {
              //       final pdfFile =
              //           await PdfApi.generateCenteredText('sample text');
              //       PdfApi.openFile(pdfFile);
              //     }),
              )
        ],
      ),
    );
  }
}

class PdfApi {
  static Future<File> generateCenteredText(String text) async {
    final pdf = p.Document();
    pdf.addPage(p.Page(
        build: (context) => p.Center(
              child: p.Text(text, style: p.TextStyle(fontSize: 48)),
            )));
    return saveDocument(name: 'my_example.pdf', pdf: pdf);
  }

  static Future<File> saveDocument(
      {required String name, required p.Document pdf}) async {
    final bytes = await pdf.save();
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/$name');

    await file.writeAsBytes(bytes);
    print('succes saveDocument');
    print(file);

    return file;
  }

// static Future openFile(File file) async {
//   final url = file.path;
//   await OpenDocument.getNameFile(url: url);
//   print('succes openFile');
// }
}
