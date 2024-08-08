import 'dart:io';
import 'package:flutter/services.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../connections/fireCloudUser.dart';

gerarPDF(nomeArquivo, nomePaciente, dataProntuario, horaProntuario, objetivoProntuario, materiaisProntuario,
    resultadoProntuario) async {
  String crfa = '';
  String telefone = '';

  var userFono = await recuperarPorFonoID();

  crfa = userFono['crfa'];
  telefone = userFono['telefone'];

  final pw.Document doc = pw.Document();

  final img = await rootBundle.load('images/logo.png');
  final imageBytes = img.buffer.asUint8List();
  pw.Image image1 = pw.Image(pw.MemoryImage(imageBytes), width: 150, height: 75);

  doc.addPage(pw.MultiPage(
    pageTheme: pw.PageTheme(margin: pw.EdgeInsets.zero),
    header: (context) => buildCabecalho(context, image1, nomePaciente, dataProntuario, horaProntuario),
    footer: (context) => buildRodape(context, crfa, telefone),
    build: (context) => buildCorpo(context, objetivoProntuario, materiaisProntuario, resultadoProntuario),
  ));

  List<int> bytes = await doc.save();
  final directory = await getApplicationSupportDirectory();
  final path = directory.path;
  File file = File('$path/$nomeArquivo.pdf');
  await file.writeAsBytes(bytes, flush: true);
  OpenFile.open('$path/$nomeArquivo.pdf');
}

pw.Widget buildCabecalho(pw.Context context, logo, nomePaciente, dataProntuario, horaProntuario) {
  return pw.Container(
    color: PdfColors.white,
    child: pw.Padding(
        padding: pw.EdgeInsets.only(top: 10, bottom: 10, left: 40, right: 40),
        child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.center,
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Padding(
                padding: pw.EdgeInsets.zero,
                child: logo,
              ),
              pw.Padding(
                  padding: pw.EdgeInsets.zero,
                  child: pw.Text('Evolução de Atendimento',
                      style: pw.TextStyle(fontSize: 22, fontWeight: pw.FontWeight.bold))),
              pw.SizedBox(height: 10),
              pw.Row(children: [
                pw.Padding(
                    padding: pw.EdgeInsets.zero,
                    child: pw.Text('Nome do Paciente: ',
                        style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold))),
                pw.Padding(
                    padding: pw.EdgeInsets.zero,
                    child: pw.Text('$nomePaciente', style: pw.TextStyle(fontSize: 14)))
              ]),
              pw.SizedBox(height: 5),
              pw.Row(children: [
                pw.Padding(
                    padding: pw.EdgeInsets.zero,
                    child: pw.Text('Data do Prontuário: ',
                        style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold))),
                pw.Padding(
                    padding: pw.EdgeInsets.zero,
                    child: pw.Text('$dataProntuario', style: pw.TextStyle(fontSize: 14)))
              ]),
              pw.SizedBox(height: 5),
              pw.Row(children: [
                pw.Padding(
                    padding: pw.EdgeInsets.zero,
                    child: pw.Text('Horário do Prontuário: ',
                        style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold))),
                pw.Padding(
                    padding: pw.EdgeInsets.zero,
                    child: pw.Text('$horaProntuario', style: pw.TextStyle(fontSize: 14)))
              ]),
              pw.SizedBox(height: 10),
              pw.Divider(
                thickness: 2,
                height: 1,
                color: PdfColors.black,
              ),
            ])),
  );
}

List<pw.Widget> buildCorpo(pw.Context context, objetivoProntuario, materiaisProntuario, resultadoProntuario) {
  return [
    pw.Container(
      color: PdfColors.white,
      child: pw.Padding(
          padding: pw.EdgeInsets.only(bottom: 10, left: 40, right: 40),
          child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Padding(
                    padding: pw.EdgeInsets.zero,
                    child: pw.Text('Objetivos da Sessão: ',
                        style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold))),
                pw.SizedBox(height: 10),
                pw.Padding(
                    padding: pw.EdgeInsets.zero,
                    child: pw.Text('$objetivoProntuario',
                        style: pw.TextStyle(fontSize: 12), textAlign: pw.TextAlign.justify)),
                pw.SizedBox(height: 10),
                pw.Divider(
                  thickness: 2,
                  height: 1,
                  color: PdfColors.black,
                ),
                pw.SizedBox(height: 10),
                pw.Padding(
                    padding: pw.EdgeInsets.zero,
                    child: pw.Text('Materiais/Estratégias: ',
                        style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold))),
                pw.SizedBox(height: 10),
                pw.Padding(
                    padding: pw.EdgeInsets.zero,
                    child: pw.Text('$materiaisProntuario',
                        style: pw.TextStyle(fontSize: 12,), textAlign: pw.TextAlign.justify)),
                pw.SizedBox(height: 10),
                pw.Divider(
                  thickness: 2,
                  height: 1,
                  color: PdfColors.black,
                ),
                pw.SizedBox(height: 10),
                pw.Padding(
                    padding: pw.EdgeInsets.zero,
                    child: pw.Text('Resultados: ',
                        style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold))),
                pw.SizedBox(height: 10),
                pw.Padding(
                    padding: pw.EdgeInsets.zero,
                    child: pw.Text('$resultadoProntuario',
                        style: pw.TextStyle(fontSize: 12), textAlign: pw.TextAlign.justify)),
              ])),
    )
  ];
}

pw.Widget buildRodape(pw.Context context, crfa, telefone) {
  return pw.Container(
    color: PdfColors.white,
    child: pw.Padding(
      padding: pw.EdgeInsets.only(bottom: 10, left: 40, right: 40),
      child: pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          mainAxisAlignment: pw.MainAxisAlignment.end,
          children: [
            pw.Divider(
              thickness: 1.5,
              height: 1,
              color: PdfColors.grey,
            ),
            pw.Row(
                crossAxisAlignment: pw.CrossAxisAlignment.center,
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Padding(
                      padding: pw.EdgeInsets.zero,
                      child: pw.Text('CRFa: $crfa', style: pw.TextStyle(fontSize: 8, color: PdfColors.grey))),
                  pw.Padding(
                      padding: pw.EdgeInsets.zero,
                      child: pw.Text('1 de 1', style: pw.TextStyle(fontSize: 8, color: PdfColors.grey))),
                ]),
          ]),
    ),
  );
}
