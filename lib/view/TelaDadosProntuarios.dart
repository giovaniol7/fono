import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../connections/fireCloudProntuarios.dart';
import '../controllers/criarPDF.dart';
import '../controllers/estilos.dart';

class TelaDadosProntuarios extends StatefulWidget {
  final String uidPaciente;
  final String dataClicada;

  const TelaDadosProntuarios(this.uidPaciente, this.dataClicada, {super.key});

  @override
  State<TelaDadosProntuarios> createState() => _TelaDadosProntuariosState();
}

class _TelaDadosProntuariosState extends State<TelaDadosProntuarios> {
  var prontuarios;
  String nomeProntuario = '';
  String dataProntuario = '';
  String horarioProntuario = '';
  String objetivosProntuario = '';
  String materiaisProntuario = '';
  String resultadosProntuario = '';

  Future<void> atualizarDados() async {
    await carregarDados();
  }

  carregarDados() async {
    prontuarios = await recuperarProntuarioData(context, widget.uidPaciente, widget.dataClicada);

    setState(() {
      nomeProntuario = prontuarios['nomePaciente'];
      dataProntuario = prontuarios['dataProntuario'];
      horarioProntuario = prontuarios['horarioProntuario'];
      objetivosProntuario = prontuarios['objetivosProntuario'];
      materiaisProntuario = prontuarios['materiaisProntuario'];
      resultadosProntuario = prontuarios['resultadosProntuario'];
    });
  }

  @override
  void initState() {
    super.initState();
    carregarDados();
  }

  Widget build(BuildContext context) {
    TamanhoFonte tamanhoFonte = TamanhoFonte();

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: cores('corFundo'),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_outlined,
            color: cores('corSimbolo'),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          "$dataProntuario",
          style: TextStyle(color: cores('corTexto')),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.picture_as_pdf),
            onPressed: () async {
              List<String> dateParts = dataProntuario.split('/');
              int day = int.parse(dateParts[0]);
              int month = int.parse(dateParts[1]);
              int year = int.parse(dateParts[2]);
              DateTime dateTime = DateTime(year, month, day);
              String novaDataString = DateFormat('dd.MM.yyyy').format(dateTime);
              await createPDF('${nomeProntuario}_${novaDataString}', nomeProntuario, dataProntuario, horarioProntuario,
                  objetivosProntuario, materiaisProntuario, resultadosProntuario);
            },
          ),
        ],
      ),
      body: ListView(
        children: [
          Column(
            children: [
              Container(
                  padding: EdgeInsets.all(20),
                  //height: tamanhoWidgets.getHeight(context),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Center(
                        child: Text(
                          'Dados Paciente:',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: cores('corTexto'),
                              fontSize: tamanhoFonte.letraMedia(context)),
                        ),
                      ),
                      SizedBox(height: 5),
                      Row(
                        //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Text(
                            'Nome Paciente: ',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: cores('corTexto'),
                                fontSize: tamanhoFonte.letraPequena(context)),
                          ),
                          Expanded(
                            child: Text(
                              nomeProntuario,
                              style: TextStyle(color: cores('corTexto'), fontSize: tamanhoFonte.letraPequena(context)),
                              maxLines: 1,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 5),
                      Row(
                        //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Text(
                            'Data do Prontuário: ',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: cores('corTexto'),
                                fontSize: tamanhoFonte.letraPequena(context)),
                          ),
                          Text(
                            dataProntuario,
                            style: TextStyle(color: cores('corTexto'), fontSize: tamanhoFonte.letraPequena(context)),
                          ),
                        ],
                      ),
                      SizedBox(height: 5),
                      Row(
                        //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Text(
                            'Horário do Prontuário: ',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: cores('corTexto'),
                                fontSize: tamanhoFonte.letraPequena(context)),
                          ),
                          Text(
                            horarioProntuario,
                            style: TextStyle(color: cores('corTexto'), fontSize: tamanhoFonte.letraPequena(context)),
                          ),
                        ],
                      ),
                    ],
                  )),
              Divider(
                thickness: 2,
                height: 1,
                color: cores('corTexto'),
              ),
              Container(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Text(
                          'Objetivos da Sessão:',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: cores('corTexto'),
                              fontSize: tamanhoFonte.letraMedia(context)),
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        objetivosProntuario,
                        style: TextStyle(color: cores('corTexto'), fontSize: tamanhoFonte.letraPequena(context)),
                      ),
                    ],
                  )),
              Divider(
                thickness: 2,
                height: 1,
                color: cores('corTexto'),
              ),
              Container(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Text(
                          'Materiais/Estratégias:',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: cores('corTexto'),
                              fontSize: tamanhoFonte.letraMedia(context)),
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        materiaisProntuario,
                        style: TextStyle(color: cores('corTexto'), fontSize: tamanhoFonte.letraPequena(context)),
                      ),
                    ],
                  )),
              Divider(
                thickness: 2,
                height: 1,
                color: cores('corTexto'),
              ),
              Container(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Text(
                          'Resultados:',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: cores('corTexto'),
                              fontSize: tamanhoFonte.letraMedia(context)),
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        resultadosProntuario,
                        style: TextStyle(color: cores('corTexto'), fontSize: tamanhoFonte.letraPequena(context)),
                      ),
                    ],
                  )),
            ],
          )
        ],
      ),
    );
  }
}
