import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../connections/fireCloudProntuarios.dart';
import '../connections/fireCloudConsultas.dart';
import '../connections/fireCloudPacientes.dart';
import '../controllers/formatarMesAno.dart';
import '../controllers/variaveis.dart';
import '../controllers/estilos.dart';
import '../models/maps.dart';

class TelaProntuariosPaciente extends StatefulWidget {
  const TelaProntuariosPaciente({super.key});

  @override
  State<TelaProntuariosPaciente> createState() => _TelaProntuariosPacienteState();
}

class _TelaProntuariosPacienteState extends State<TelaProntuariosPaciente> {
  late String? uidPaciente;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final arguments = ModalRoute.of(context)?.settings.arguments as Map?;
      if (arguments != null && arguments['uidPaciente'] != null) {
        setState(() {
          uidPaciente = arguments['uidPaciente'] as String?;
          AppVariaveis().uidPaciente = uidPaciente!;
          AppVariaveis().selecioneMes = 'Todos';
          AppVariaveis().selecioneAno = AppVariaveis().anoAtual;
        });
        carregarDados();
      }
    });
  }

  carregarDados() async {
    AppVariaveis().prontuarios = await recuperarTodosProntuario(uidPaciente);
    AppVariaveis().pacientePront = await recuperarPaciente(context, uidPaciente);

    setState(() {
      AppVariaveis().nomePacientePront = AppVariaveis().pacientePront['nomePaciente'].split(' ')[0];
    });
  }

  Widget build(BuildContext context) {
    TamanhoFonte tamanhoFonte = TamanhoFonte();

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: cores('corSimbolo')),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            size: 30,
          ),
          onPressed: () {
            AppVariaveis().resetProntuarioPac();
            Navigator.pop(context);
          },
        ),
        title: Text(
          "Prontuários de ${AppVariaveis().nomePacientePront}",
          style: TextStyle(color: cores('corTexto'), fontSize: 24),
        ),
        backgroundColor: cores('corTerciaria'),
      ),
      body: SingleChildScrollView(
        physics: NeverScrollableScrollPhysics(),
        child: Container(
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.only(top: 5),
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: cores('corFundo'),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Selecione o Mês e Ano: ',
                      style: TextStyle(
                          fontSize: tamanhoFonte.letraPequena(context),
                          color: cores('corTexto'),
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(width: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        DropdownButton<String>(
                          alignment: Alignment.center,
                          menuMaxHeight: 300,
                          hint: Text(
                            'Mês:',
                            style: TextStyle(color: cores('corTexto')),
                          ),
                          icon: Icon(
                            Icons.arrow_drop_down,
                            color: cores('corTexto'),
                          ),
                          iconSize: 30,
                          iconEnabledColor: cores('corTexto'),
                          style: TextStyle(
                            color: cores('corTexto'),
                            fontWeight: FontWeight.w400,
                            fontSize: tamanhoFonte.letraPequena(context),
                          ),
                          underline: Container(
                            height: 0,
                          ),
                          value: nomeMesesAbrev.contains(AppVariaveis().selecioneMes)
                              ? AppVariaveis().selecioneMes
                              : nomeMesesAbrev.first,
                          // Valor padrão se não estiver na lista
                          onChanged: (String? newValue) {
                            setState(() {
                              AppVariaveis().selecioneMes = newValue!;
                            });
                          },
                          items: nomeMesesAbrev.toSet().map((state) {
                            return DropdownMenuItem<String>(
                              value: state,
                              child: Text(state),
                            );
                          }).toList(),
                        ),
                        DropdownButton<int>(
                          alignment: Alignment.center,
                          menuMaxHeight: 300,
                          hint: Text(
                            'Ano:',
                            style: TextStyle(color: cores('corTexto')),
                          ),
                          icon: Icon(
                            Icons.arrow_drop_down,
                            color: cores('corTexto'),
                          ),
                          iconSize: 30,
                          iconEnabledColor: cores('corTexto'),
                          style: TextStyle(
                            color: cores('corTexto'),
                            fontWeight: FontWeight.w400,
                            fontSize: tamanhoFonte.letraPequena(context),
                          ),
                          underline: Container(
                            height: 0,
                          ),
                          value: AppVariaveis().selecioneAno,
                          onChanged: (int? newValue) {
                            setState(() {
                              AppVariaveis().selecioneAno = newValue!;
                            });
                          },
                          items: getAnos().map((int ano) {
                            return DropdownMenuItem<int>(
                              value: ano,
                              child: Text(ano.toString()),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10),
              Container(
                  height: MediaQuery.of(context).size.height * 0.75,
                  child: ListView(
                    children: [
                      StreamBuilder<QuerySnapshot>(
                          stream: AppVariaveis().prontuarios != null
                              ? AppVariaveis().prontuarios.orderBy('dataProntuario').snapshots()
                              : null,
                          builder: (context, snapshot) {
                            switch (snapshot.connectionState) {
                              case ConnectionState.none:
                                return const Center(
                                  child: Text('Não foi possível conectar'),
                                );
                              case ConnectionState.waiting:
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              default:
                                final dados = snapshot.requireData;
                                Map<String, List<QueryDocumentSnapshot>> prontuarioPorMes = {};

                                dados.docs.forEach((doc) {
                                  String dataString = doc['dataProntuario'];
                                  DateTime data = DateFormat('dd/MM/yyyy').parse(dataString);
                                  String mesAno = DateFormat('MM/yyyy').format(data);
                                  String ano = DateFormat('yyyy').format(data);

                                  String mesSelecionadoFormatado = intMesToAbrev.entries
                                      .firstWhere((entry) => entry.value == AppVariaveis().selecioneMes,
                                          orElse: () => MapEntry(0, ''))
                                      .key
                                      .toString()
                                      .padLeft(2, '0');

                                  if ((AppVariaveis().selecioneMes == 'Todos' ||
                                          mesAno.startsWith(mesSelecionadoFormatado)) &&
                                      (AppVariaveis().selecioneAno == 0 ||
                                          ano == AppVariaveis().selecioneAno.toString())) {
                                    if (!prontuarioPorMes.containsKey(mesAno)) {
                                      prontuarioPorMes[mesAno] = [];
                                    }
                                    prontuarioPorMes[mesAno]!.add(doc);
                                  }
                                });

                                List<DateTime> mesesOrdenados = prontuarioPorMes.keys.map((mesAno) {
                                  return DateFormat('MM/yyyy').parse(mesAno);
                                }).toList();

                                mesesOrdenados.sort((a, b) => b.compareTo(a));

                                return Column(
                                  children: mesesOrdenados.map((mesAno) {
                                    String mesAnoFormatado = DateFormat('MM/yyyy').format(mesAno);
                                    List<QueryDocumentSnapshot> prontuarios =
                                        prontuarioPorMes[mesAnoFormatado]!;
                                    return Column(
                                      children: [
                                        Text(
                                          formatarMesAno(mesAnoFormatado),
                                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                              fontWeight: FontWeight.w700, color: cores('corTexto')),
                                        ),
                                        ListView.separated(
                                          physics: const NeverScrollableScrollPhysics(),
                                          shrinkWrap: true,
                                          padding: const EdgeInsets.all(10),
                                          scrollDirection: Axis.vertical,
                                          itemBuilder: (context, index) =>
                                              cardProntuario(context, prontuarios[index]),
                                          separatorBuilder: (context, _) => const SizedBox(width: 5),
                                          itemCount: prontuarios.length,
                                        ),
                                      ],
                                    );
                                  }).toList(),
                                );
                            }
                          }),
                    ],
                  )),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        shape: CircleBorder(),
        onPressed: () async {
          var tappedAppointment = await appointmentsPorUIDPaciente(uidPaciente);
          DateTime dataProntuario = DateTime.now();
          Navigator.pushNamed(context, '/adicionarProntuarios', arguments: {
            'tipo': 'adicionar',
            'tappedAppointment': tappedAppointment,
            'dataClicada': dataProntuario
          });
        },
        child: Icon(
          Icons.add,
          color: cores('corTextoBotao'),
          size: 35,
        ),
        backgroundColor: cores('corBotao'),
      ),
    );
  }
}

Widget cardProntuario(context, doc) {
  TamanhoFonte tamanhoFonte = TamanhoFonte();

  return Container(
    child: Card(
      color: Colors.red.shade50,
      elevation: 7,
      shadowColor: cores('corSombra'),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      margin: EdgeInsets.all(5),
      child: ListTile(
        title: Text(
          doc.data()['dataProntuario'],
          style: TextStyle(
              color: cores('corTexto'),
              fontSize: tamanhoFonte.letraMedia(context),
              fontWeight: FontWeight.bold),
        ),
        trailing: IconButton(
          icon: Icon(
            Icons.edit,
            color: cores('corSimbolo'),
          ),
          onPressed: () async {
            var tappedAppointment = await appointmentsPorUIDPaciente(doc.data()['uidPaciente']);
            String dataProntuarioString = doc.data()['dataProntuario'];
            DateTime dataProntuario = DateFormat('dd/MM/yyyy').parse(dataProntuarioString);
            Navigator.pushNamed(context, '/adicionarProntuarios', arguments: {
              'tipo': 'editar',
              'tappedAppointment': tappedAppointment,
              'dataClicada': dataProntuario
            });
          },
        ),
        onTap: () {
          String dataProntuarioString = doc.data()['dataProntuario'];
          Navigator.pushNamed(context, '/dadosProntuarios',
              arguments: {'uidPaciente': doc.data()['uidPaciente'], 'dataClicada': dataProntuarioString});
        },
      ),
    ),
  );
}
