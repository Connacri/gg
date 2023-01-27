import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:number_to_character/number_to_character.dart';
import 'package:open_file_plus/open_file_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class PdfPageTa3List extends StatefulWidget {
  PdfPageTa3List({
    Key? key,
    //required this.dataDevis,
    required this.customer,
    required this.date,
    required this.codeDevis,
    required this.array,
  }) : super(key: key);

  //final List dataDevis;
  final String customer;
  final DateTime date;
  final String codeDevis;
  List array;
  @override
  State<PdfPageTa3List> createState() => _PdfPageTa3ListState();
}

class _PdfPageTa3ListState extends State<PdfPageTa3List> {
  PrintingInfo? printingInfo;

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    final info = await Printing.info();
    setState(() {
      printingInfo = info;
    });
  }

  @override
  Widget build(BuildContext context) {
    pw.RichText.debug = true;
    final actions = <PdfPreviewAction>[
      if (!kIsWeb)
        const PdfPreviewAction(icon: Icon(Icons.save), onPressed: saveAsFile)
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text('Final Invoice  ' + widget.array.length.toString()),
      ),
      body: PdfPreview(
          maxPageWidth: 700,
          actions: actions,
          onPrinted: showPrintedToast,
          onShared: showSharedToast,
          build: //generatePdf,
              //pdfPageFormat,
              (final PdfPageFormat format) async {
            final doc = pw.Document(title: 'Ramzi Flutter School');
            final logoImage = pw.MemoryImage(
              (await rootBundle.load('assets/adventure_logo.png'))
                  .buffer
                  .asUint8List(),
            );
            final footerImage = pw.MemoryImage(
              (await rootBundle.load('assets/images/oran_01.png'))
                  .buffer
                  .asUint8List(),
            );
            final font = await rootBundle.load('fonts/Oswald-Regular.ttf');
            final font2 =
                await rootBundle.load('assets/fonts/MaShanZheng-Regular.ttf');
            final ttf = pw.Font.ttf(font);
            final ttf2 = pw.Font.ttf(font2);

            final pageTheme = await _myPageTheme(format);

            List t = widget.array;
            print('arrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrra');
            print(t);
            print(
                '///////////////////////widget.dataDevis//////////////////////');
            print(t.map((e) => e['model']).toList());

            double sum = 0.0;
            for (int i = 0; i < t.length; i++) {
              sum += (t[i]['prixVente']).toDouble() * (t[i]['qty']);
            }
            var converter = NumberToCharacterConverter('en');

            doc.addPage(pw.MultiPage(
                pageTheme: pageTheme,
                header: (final context) => pw.Column(
                        mainAxisAlignment: pw.MainAxisAlignment.start,
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Row(
                              mainAxisAlignment: pw.MainAxisAlignment.start,
                              crossAxisAlignment: pw.CrossAxisAlignment.center,
                              children: [
                                pw.ClipOval(
                                  child: pw.Image(
                                    alignment: pw.Alignment.topLeft,
                                    logoImage,
                                    fit: pw.BoxFit.contain,
                                    width: 80,
                                  ),
                                ),
                                pw.SizedBox(width: 30),
                                pw.Column(
                                    crossAxisAlignment:
                                        pw.CrossAxisAlignment.start,
                                    children: [
                                      pw.Text('Adventure GG',
                                          style: pw.TextStyle(
                                              font: ttf2, fontSize: 30)),
                                      pw.Text(
                                          'Motoz Distributor in United Arab Emirates and GCC',
                                          style: pw.TextStyle(
                                              font: ttf2, fontSize: 15)),
                                    ]),

                                //pw.SizedBox(height: 200),
                              ]),
                          pw.SizedBox(height: 30),
                          pw.Text(
                              'Date : ' +
                                  DateFormat('EEEEEEEE, MMM d, '
                                          'yyyy') //('yyyy-MM-dd EEE')
                                      .format(widget.date),
                              style: pw.TextStyle(font: ttf, fontSize: 12)),
                          pw.Text(
                              'Invoice ID : ' + widget.codeDevis.toUpperCase(),
                              style: pw.TextStyle(font: ttf, fontSize: 15)),
                          pw.BarcodeWidget(
                            height: 50,
                            drawText: false,
                            data: widget.codeDevis,
                            barcode: pw.Barcode.code128(),
                          ),
                          pw.Text('Customer : ' + widget.customer.toUpperCase(),
                              style: pw.TextStyle(font: ttf, fontSize: 18)),
                          pw.SizedBox(height: 50),
                        ]),
                footer: (final context) => pw.Column(children: [
                      pw.SizedBox(height: 100),
                      pw.Text(
                          'Adventure GG Corporation Motoz Distributor in UAE and GCC',
                          style: pw.TextStyle(font: ttf)),
                      pw.Image(
                        footerImage,
                        fit: pw.BoxFit.scaleDown,
                        height: 60,
                      ),
                    ]),
                build: (final context) => [
                      pw.Row(children: [
                        pw.Expanded(
                          flex: 2,
                          child: pw.Padding(
                            padding:
                                const pw.EdgeInsets.symmetric(horizontal: 0),
                            child: pw.Align(
                              alignment: pw.Alignment.topLeft,
                              child: pw.Text('id'.toUpperCase(),
                                  style: pw.TextStyle(font: ttf)),
                            ),
                          ),
                        ),
                        pw.Expanded(
                          flex: 5,
                          child: pw.Padding(
                            padding: const pw.EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            child: pw.Align(
                              alignment: pw.Alignment.topLeft,
                              child: pw.Text(
                                'Items'.toUpperCase(),
                                style: pw.TextStyle(
                                  font: ttf,
                                ),
                              ),
                            ),
                          ),
                        ),
                        pw.Expanded(
                          flex: 1,
                          child: pw.Align(
                            alignment: pw.Alignment.topRight,
                            child: pw.Text('Unit Price'.toUpperCase(),
                                style: pw.TextStyle(font: ttf)),
                          ),
                        ),
                        pw.Expanded(
                          flex: 1,
                          child: pw.Align(
                            alignment: pw.Alignment.topCenter,
                            child: pw.Expanded(
                              child: pw.Text('qty'.toUpperCase(),
                                  style: pw.TextStyle(font: ttf)),
                            ),
                          ),
                        ),
                        pw.Expanded(
                          flex: 1,
                          child: pw.Padding(
                            padding: const pw.EdgeInsets.symmetric(
                                horizontal: 0, vertical: 5),
                            child: pw.Align(
                              alignment: pw.Alignment.topRight,
                              child: pw.Text('Amount'.toUpperCase(),
                                  style: pw.TextStyle(font: ttf)),
                            ),
                          ),
                        ),
                      ]),
                      pw.ListView.builder(
                          itemCount: widget.array.length,
                          itemBuilder: (context, int index) {
                            var _documentSnapshot = widget.array[index];
                            print(_documentSnapshot['model']);

                            return pw.Row(
                                //  mainAxisAlignment:
//                                    pw.MainAxisAlignment.spaceBetween,
                                children: [
                                  pw.Expanded(
                                    flex: 2,
                                    child: pw.Padding(
                                      padding: const pw.EdgeInsets.symmetric(
                                          horizontal: 0),
                                      child: pw.Align(
                                        alignment: pw.Alignment.topLeft,
                                        child: pw.Text(
                                            _documentSnapshot['codebar'],
                                            style: pw.TextStyle(font: ttf)),
                                      ),
                                    ),
                                  ),
                                  pw.Expanded(
                                    flex: 5,
                                    child: pw.Padding(
                                      padding: const pw.EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 5),
                                      child: pw.Align(
                                        alignment: pw.Alignment.topLeft,
                                        child: pw.Text(
                                          _documentSnapshot['model'],
                                          style: pw.TextStyle(
                                            font: ttf,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  pw.Expanded(
                                    flex: 1,
                                    child: pw.Align(
                                      alignment: pw.Alignment.topRight,
                                      child: pw.Text(
                                          _documentSnapshot['prixVente']
                                                  .toString() +
                                              '0',
                                          style: pw.TextStyle(font: ttf)),
                                    ),
                                  ),
                                  pw.Expanded(
                                    flex: 1,
                                    child: pw.Align(
                                      alignment: pw.Alignment.topCenter,
                                      child: pw.Expanded(
                                        child: pw.Text(
                                            _documentSnapshot['qty']
                                                .toInt()
                                                .toString(),
                                            style: pw.TextStyle(font: ttf)),
                                      ),
                                    ),
                                  ),
                                  pw.Expanded(
                                    flex: 1,
                                    child: pw.Padding(
                                      padding: const pw.EdgeInsets.symmetric(
                                          horizontal: 0, vertical: 5),
                                      child: pw.Align(
                                        alignment: pw.Alignment.topRight,
                                        child: pw.Text(
                                            (_documentSnapshot['prixVente'] *
                                                        _documentSnapshot[
                                                            'qty'])
                                                    .toString() +
                                                '0',
                                            style: pw.TextStyle(font: ttf)),
                                      ),
                                    ),
                                  ),
                                ]);
                          }),
                      pw.Align(
                        alignment: pw.Alignment.bottomRight,
                        child: pw.Column(
                            mainAxisAlignment: pw.MainAxisAlignment.end,
                            crossAxisAlignment: pw.CrossAxisAlignment.end,
                            children: [
                              pw.Padding(
                                padding: const pw.EdgeInsets.symmetric(
                                    horizontal: 0, vertical: 5),
                                child: pw.Text(
                                    'SubTotal : ' + sum.toString() + '0',
                                    style: pw.TextStyle(font: ttf)),
                              ),
                              pw.Padding(
                                padding: const pw.EdgeInsets.symmetric(
                                    horizontal: 0, vertical: 5),
                                child: pw.Text(
                                    'VAT 20% : ' +
                                        (sum * 0.2).toInt().toString() +
                                        '.00',
                                    style: pw.TextStyle(font: ttf)),
                              ),
                              pw.Padding(
                                padding: const pw.EdgeInsets.symmetric(
                                    horizontal: 0, vertical: 5),
                                child: pw.Text(
                                    'Total :  AED ' +
                                        (sum * 1.2).toInt().toString() +
                                        '.00',
                                    style: pw.TextStyle(font: ttf)),
                              ),
                            ]),
                      ),
                      pw.Expanded(
                        child: pw.Padding(
                          padding: const pw.EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          child: pw.Text(
                              converter
                                      .convertInt((sum * 1.2).toInt())
                                      .toUpperCase() +
                                  ' of United Arab Emirates dirham'
                                      .toUpperCase(),
                              style: pw.TextStyle(font: ttf)),
                        ),
                      ), // it shows ninety nine)

                      pw.Center(
                        child: pw.Text(
                            'We go where are your limits\n Thanks for your business'
                                .toUpperCase(),
                            textAlign: pw.TextAlign.center,
                            style: pw.TextStyle(font: ttf)),
                      )
                    ]));
            return doc.save();
          }),
    );
  }
}

Future<pw.PageTheme> _myPageTheme(PdfPageFormat format) async {
  final logoImage = pw.MemoryImage(
    (await rootBundle.load('assets/adventure_logo.png')).buffer.asUint8List(),
  );
  return pw.PageTheme(
    margin: pw.EdgeInsets.symmetric(
      horizontal: 1 * PdfPageFormat.cm,
      vertical: 0.5 * PdfPageFormat.cm,
    ),
    textDirection: pw.TextDirection.ltr,
    orientation: pw.PageOrientation.portrait,
    buildBackground: (final context) => pw.FullPage(
      ignoreMargins: true,
      child: pw.Padding(
        padding: pw.EdgeInsets.all(100),
        child: pw.Watermark(
          // angle: 20,
          child: pw.Opacity(
            opacity: 0.07,
            child: pw.Image(
              alignment: pw.Alignment.center,
              logoImage,
              fit: pw.BoxFit.cover,
            ),
          ),
        ),
      ),
    ),
  );
}

Future<void> saveAsFile(
  final BuildContext context,
  final LayoutCallback build,
  final PdfPageFormat pageFormat,
) async {
  final bytes = await build(pageFormat);
  final appDocDir = await getApplicationDocumentsDirectory();
  final appDocPath = appDocDir.path;
  final file = File('$appDocPath/document.pdf');
  print('save as file ${file.path}...');
  await file.writeAsBytes(bytes);
  await OpenFile.open(file.path);
}

void showPrintedToast(final BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
    content: Text('Document printed succesfully'),
  ));
}

void showSharedToast(final BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
    content: Text('Document shared succesfully'),
  ));
}
