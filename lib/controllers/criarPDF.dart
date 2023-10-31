import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

Future<void> savePdf() async {
  final pdf = pw.Document();

  pdf.addPage(
    pw.Page(
      build: (pw.Context context) => pw.Center(
        child: pw.Text('Hello World!'),
      ),
    ),
  );

  final directory = await getApplicationDocumentsDirectory();
  final path = '${directory.path}/meu_pdf.pdf';
  final output = File(path);
  await output.writeAsBytes(await pdf.save());
}