import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart' as pw;
import 'package:syncfusion_flutter_pdf/pdf.dart';

createPDF(nomeArquivo, nomePaciente, dataProntuario, horaProntuario, objetivoProntuario, materiaisProntuario,
    resultadoProntuario) async {
  PdfDocument document = PdfDocument();

  //Adds page settings
  document.pageSettings.orientation = PdfPageOrientation.portrait;
  document.pageSettings.margins.all = 50;

  final pageWidth = pw.PdfPageFormat.a4.width;
  final pageHeight = pw.PdfPageFormat.a4.height;

  //Adds a page to the document
  PdfPage page = document.pages.add();
  PdfGraphics graphics = page.graphics;
  var width = graphics.clientSize.width;

  final ByteData data = await rootBundle.load('images/logo.png');
  final List<int> imageB = data.buffer.asUint8List();
  var height = 100.0;

  PdfImage image = PdfBitmap(imageB);
  page.graphics.drawImage(image, Rect.fromLTWH(175, 10, 175, 100));

  graphics.drawString('Nome Paciente: $nomePaciente', PdfStandardFont(PdfFontFamily.timesRoman, 18),
      brush: PdfBrushes.black, bounds: Rect.fromLTWH(10, height+25, width, 100));

  graphics.drawString('Data do Prontuário: $dataProntuario', PdfStandardFont(PdfFontFamily.timesRoman, 18),
      brush: PdfBrushes.black, bounds: Rect.fromLTWH(10, height+50, width, 200));

  graphics.drawString('Hora do Prontuário: $horaProntuario', PdfStandardFont(PdfFontFamily.timesRoman, 18),
      brush: PdfBrushes.black, bounds: Rect.fromLTWH(10, height+75, width, 300));

  graphics.drawLine(PdfPen(PdfColor(0, 0, 0), width: 1), Offset(10, height+125), Offset(width, height+125));

  graphics.drawString('Objetivos da Sessão:', PdfStandardFont(PdfFontFamily.timesRoman, 20),
      brush: PdfBrushes.black, bounds: Rect.fromLTWH(10, height+150, width, 50));

  graphics.drawString('$objetivoProntuario', PdfStandardFont(PdfFontFamily.timesRoman, 16),
      brush: PdfBrushes.black, bounds: Rect.fromLTWH(10, height+175, width, 50));

  graphics.drawLine(PdfPen(PdfColor(0, 0, 0), width: 1), Offset(10, height+250), Offset(width, height+250));

  graphics.drawString('Materiais/Estratégias:', PdfStandardFont(PdfFontFamily.timesRoman, 20),
      brush: PdfBrushes.black, bounds: Rect.fromLTWH(10, height+275, width, 50));

  graphics.drawString('$materiaisProntuario', PdfStandardFont(PdfFontFamily.timesRoman, 16),
      brush: PdfBrushes.black, bounds: Rect.fromLTWH(10, height+300, width, 50));

  graphics.drawLine(PdfPen(PdfColor(0, 0, 0), width: 1), Offset(10, height+375), Offset(width, height+375));

  graphics.drawString('Resultados:', PdfStandardFont(PdfFontFamily.timesRoman, 20),
      brush: PdfBrushes.black, bounds: Rect.fromLTWH(10, height+400, width, 50));

  graphics.drawString('$resultadoProntuario', PdfStandardFont(PdfFontFamily.timesRoman, 16),
      brush: PdfBrushes.black, bounds: Rect.fromLTWH(10, height+425, width, 50));

  //Save the document
  List<int> bytes = await document.save();

  //Dispose the document
  document.dispose();

  //Get external storage directory
  final directory = await getApplicationSupportDirectory();

  //Get directory path
  final path = directory.path;

  //Create an empty file to write PDF data
  File file = File('$path/$nomeArquivo.pdf');

  //Write PDF data
  await file.writeAsBytes(bytes, flush: true);

  //Open the PDF document in mobile
  OpenFile.open('$path/$nomeArquivo.pdf');
}
