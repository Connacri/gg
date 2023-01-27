import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:printing/printing.dart';
import 'package:pdf/widgets.dart' as pw;
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:open_file_plus/open_file_plus.dart';
import 'package:pdf/pdf.dart';
import 'package:path_provider/path_provider.dart';

class PdfPageRamzy extends StatefulWidget {
  PdfPageRamzy({
    Key? key,
    required this.dataDevis,
  }) : super(key: key);

  final List dataDevis;

  @override
  State<PdfPageRamzy> createState() => _PdfPageRamzyState();
}

class _PdfPageRamzyState extends State<PdfPageRamzy> {
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
        title: Text('Ramzi Pdf'),
      ),
      body: PdfPreview(
        maxPageWidth: 700,
        actions: actions,
        onPrinted: showPrintedToast,
        onShared: showSharedToast,
        build: generatePdf,
      ),
    );
  }
}

Future<Uint8List> generatePdf(final PdfPageFormat format) async {
  final doc = pw.Document(title: 'Ramzi Flutter School');
  final logoImage = pw.MemoryImage(
    (await rootBundle.load('assets/adventure_logo.png')).buffer.asUint8List(),
  );
  final footerImage = pw.MemoryImage(
    (await rootBundle.load('assets/images/oran_01.png')).buffer.asUint8List(),
  );
  final font = await rootBundle.load('fonts/Oswald-Regular.ttf');
  final ttf = pw.Font.ttf(font);

  final pageTheme = await _myPageTheme(format);

  doc.addPage(pw.MultiPage(
      pageTheme: pageTheme,
      header: (final context) => pw.ClipOval(
            child: pw.Image(
              alignment: pw.Alignment.topLeft,
              logoImage,
              fit: pw.BoxFit.contain,
              width: 80,
            ),
          ),
      footer: (final context) => pw.Column(children: [
            pw.Text('Adventure GG Corporation', style: pw.TextStyle(font: ttf)),
            pw.Image(
              footerImage,
              fit: pw.BoxFit.scaleDown,
              height: 60,
            ),
          ]),
      build: (final context) => [
            pw.Container(
                padding: const pw.EdgeInsets.only(left: 30, bottom: 20),
                child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.center,
                    mainAxisAlignment: pw.MainAxisAlignment.start,
                    children: [
                      pw.Padding(
                        padding: pw.EdgeInsets.only(top: 20),
                      ),
                      pw.Row(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                          children: [
                            pw.Column(
                                crossAxisAlignment: pw.CrossAxisAlignment.end,
                                children: [
                                  pw.Text('Phone: ',
                                      style: pw.TextStyle(font: ttf)),
                                  pw.Text('Email : ',
                                      style: pw.TextStyle(font: ttf)),
                                  pw.Text('Instagram : ',
                                      style: pw.TextStyle(font: ttf)),
                                ]),
                            pw.Column(children: [
                              // pw.BarcodeWidget(
                              //   data: 'Flutter Codebar',
                              //   barcode: pw.Barcode.qrCode(),
                              //   drawText: false,
                              // ),
                            ])
                          ])
                    ]))
          ]));
  return doc.save();
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
      child: pw.Watermark(
          // angle: 20,
          child: pw.Opacity(
              opacity: 0.07,
              child: pw.Image(
                alignment: pw.Alignment.center,
                logoImage,
                fit: pw.BoxFit.cover,
              ))),
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
