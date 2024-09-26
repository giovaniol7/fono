import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../connections/fireCloudProntuarios.dart';
import '../controllers/variaveis.dart';
import '../controllers/gerarPDF.dart';
import '../controllers/estilos.dart';

class TelaDadosProntuarios extends StatefulWidget {
  const TelaDadosProntuarios({super.key});

  @override
  State<TelaDadosProntuarios> createState() => _TelaDadosProntuariosState();
}

class _TelaDadosProntuariosState extends State<TelaDadosProntuarios> {
  late String? uidPaciente;
  late String? dataClicada;

  Future<void> atualizarDados() async {
    await carregarDados();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final arguments = ModalRoute.of(context)?.settings.arguments as Map?;
      if (arguments != null && arguments['uidPaciente'] != null) {
        setState(() {
          uidPaciente = arguments['uidPaciente'] as String?;
          dataClicada = arguments['dataClicada'] as String?;
        });
        carregarDados();
      }
    });
  }

  carregarDados() async {
    AppVariaveis().prontuariosPac = await recuperarProntuarioData(context, uidPaciente, dataClicada);

    setState(() {
      AppVariaveis().nomeProntuario = AppVariaveis().prontuariosPac['nomePaciente'];
      AppVariaveis().dataProntuario = AppVariaveis().prontuariosPac['dataProntuario'];
      AppVariaveis().horarioProntuario = AppVariaveis().prontuariosPac['horarioProntuario'];
      AppVariaveis().objetivosProntuario = AppVariaveis().prontuariosPac['objetivosProntuario'];
      AppVariaveis().materiaisProntuario = AppVariaveis().prontuariosPac['materiaisProntuario'];
      AppVariaveis().resultadosProntuario = AppVariaveis().prontuariosPac['resultadosProntuario'];
    });
  }

  Widget build(BuildContext context) {
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
            AppVariaveis().resetProntuario();
            Navigator.pop(context);
          },
        ),
        title: Text(
          "${AppVariaveis().dataProntuario}",
          style: TextStyle(color: cores('corTexto')),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.picture_as_pdf),
            onPressed: () async {
              List<String> dateParts = AppVariaveis().dataProntuario.split('/');
              int day = int.parse(dateParts[0]);
              int month = int.parse(dateParts[1]);
              int year = int.parse(dateParts[2]);
              DateTime dateTime = DateTime(year, month, day);
              String novaDataString = DateFormat('dd.MM.yyyy').format(dateTime);
              await gerarPDF('${AppVariaveis().nomeProntuario}_${novaDataString}', AppVariaveis().nomeProntuario, AppVariaveis().dataProntuario,
                  AppVariaveis().horarioProntuario, AppVariaveis().objetivosProntuario, AppVariaveis().materiaisProntuario, AppVariaveis().resultadosProntuario);
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
                              fontSize: 16),
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
                                fontSize: 16),
                          ),
                          Expanded(
                            child: Text(
                              AppVariaveis().nomeProntuario,
                              style: TextStyle(
                                  color: cores('corTexto'), fontSize: 16),
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
                                fontSize: 16),
                          ),
                          Text(
                            AppVariaveis().dataProntuario,
                            style: TextStyle(
                                color: cores('corTexto'), fontSize: 16),
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
                                fontSize: 16),
                          ),
                          Text(
                            AppVariaveis().horarioProntuario,
                            style: TextStyle(
                                color: cores('corTexto'), fontSize: 16),
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
                              fontSize: 16),
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        AppVariaveis().objetivosProntuario,
                        style:
                            TextStyle(color: cores('corTexto'), fontSize: 16),
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
                              fontSize: 16),
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        AppVariaveis().materiaisProntuario,
                        style:
                            TextStyle(color: cores('corTexto'), fontSize: 16),
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
                              fontSize: 16),
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        AppVariaveis().resultadosProntuario,
                        style:
                            TextStyle(color: cores('corTexto'), fontSize: 16),
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
