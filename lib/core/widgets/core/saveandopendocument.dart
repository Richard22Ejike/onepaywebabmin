import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class SaveAndOpenDocument {
  static Future<File> savePdf({
    required String name,
    required pw.Document pdf
  }) async {
    final root = Platform.isAndroid
        ? await getExternalStorageDirectory()
        : await getApplicationDocumentsDirectory();
    final file = File('${root!.path}/$name');
    await file.writeAsBytes(await pdf.save());
    return file;
  }

  static Future<void> openPdf(File file) async {
    final path = file.path;
    await OpenFile.open(path);
  }
}

class SummaryScreenPdfGenerator {
  static Future<File> generatePdf({
    required String title,
    required String image,
    required int keyPage,
    required String accountNumber,
    required String accountName,
    required double amount,
    required String billType,
    required String formattedBalance,
    required bool isElectricity,
    required bool isDstv,
    required bool isStarTime,
    required bool isGotv,
  }) async {
    final pdf = pw.Document();
    final formatter = NumberFormat("#,##0.00", "en_US");

    pdf.addPage(
      pw.Page(
        build: (context) => pw.Column(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Column(
              children: [
                if (keyPage < 2)
                  pw.Container(
                    height: 72,
                    width: 72,
                    decoration: pw.BoxDecoration(
                      color: PdfColor.fromInt(0xFFF4F4F4),
                      borderRadius: pw.BorderRadius.circular(36),
                    ),
                    child: pw.Center(
                      child: pw.Image(
                        pw.MemoryImage(
                          File('assets/send-alt.svg').readAsBytesSync(),
                        ),
                        height: 42,
                        width: 42,
                      ),
                    ),
                  ),
                if (keyPage < 2)
                  pw.Text(
                    'N${formatter.format(amount)}',
                    style: pw.TextStyle(
                      fontSize: 20,
                      fontWeight: pw.FontWeight.bold,
                      color: PdfColor.fromInt(0xFF101010),
                    ),
                  ),
                if (keyPage >= 2)
                  pw.Container(
                    height: 92,
                    width: 92,
                    padding: pw.EdgeInsets.all(8),
                    decoration: pw.BoxDecoration(
                      color: PdfColor.fromInt(0xFFF4F4F4),
                      borderRadius: pw.BorderRadius.circular(46),
                    ),
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.center,
                      mainAxisAlignment: pw.MainAxisAlignment.center,
                      children: [
                        if (isElectricity)
                          pw.Image(
                            pw.MemoryImage(
                              File('assets/send-alt.svg').readAsBytesSync(),
                            ),
                            height: 42,
                            width: 42,
                          )
                        else
                          pw.Container(
                            height: isDstv || isStarTime || isGotv ? 73 : 36,
                            width: isDstv || isStarTime || isGotv ? 73 : 36,
                            decoration: pw.BoxDecoration(
                              borderRadius: pw.BorderRadius.circular(
                                  isDstv || isStarTime || isGotv ? 7 : 36),
                              image: pw.DecorationImage(
                                alignment: pw.Alignment.center,
                                image: pw.MemoryImage(
                                  File(image).readAsBytesSync(),
                                ),
                                fit: pw.BoxFit.contain,
                              ),
                            ),
                          ),
                        if (!(isDstv || isStarTime || isGotv)) pw.SizedBox(height: 5),
                        if (!(isDstv || isStarTime || isGotv))
                          pw.Text(title,),
                      ],
                    ),
                  ),
                if (keyPage >= 2)
                  pw.Text(
                    'N${formatter.format(amount)}',
                    style: pw.TextStyle(
                      fontSize: 20,
                      fontWeight: pw.FontWeight.bold,
                      color: PdfColor.fromInt(0xFF101010),
                    ),
                  ),
                pw.SizedBox(height: 30),
                if (keyPage >= 2)
                  pw.Column(
                    children: [
                      pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                        children: [
                          pw.Text('Service'),
                          pw.Text(billType),
                        ],
                      ),
                      pw.SizedBox(height: 15),
                      pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                        children: [
                          pw.Text('Amount'),
                          pw.Text('N${formatter.format(amount)}'),
                        ],
                      ),
                    ],
                  ),
                if (keyPage < 2)
                  pw.Column(
                    children: [
                      pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                        children: [
                          pw.Text('Account number'),
                          pw.Text(accountNumber),
                        ],
                      ),
                      pw.SizedBox(height: 15),
                      pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                        children: [
                          pw.Text('Account name'),
                          pw.Text(accountName),
                        ],
                      ),
                      pw.SizedBox(height: 15),
                      pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                        children: [
                          pw.Text('Amount'),
                          pw.Text('N${formatter.format(amount)}'),
                        ],
                      ),
                      pw.SizedBox(height: 15),
                      pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                        children: [
                          pw.Text('Transaction fee'),
                          pw.Text('Free'),
                        ],
                      ),
                    ],
                  ),
                pw.SizedBox(height: 30),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text(
                      'Payment Method',
                      style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold),
                    ),
                    pw.SizedBox(),
                  ],
                ),
                pw.SizedBox(height: 20),
                pw.SizedBox(height: 20),

              ],
            ),

          ],
        ),
      ),
    );

    return SaveAndOpenDocument.savePdf(name: 'summary.pdf', pdf: pdf);
  }
}
