import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fonocare/connections/fireCloudProntuarios.dart';
import 'package:fonocare/view/TelaDadosProntuarios.dart';
import 'package:intl/intl.dart';

import '../connections/fireCloudConsultas.dart';
import '../connections/fireCloudPacientes.dart';
import '../controllers/estilos.dart';
import 'TelaAdicionarProntuarios.dart';

class TelaProntuariosPaciente extends StatefulWidget {
  final String uidPaciente;

  const TelaProntuariosPaciente(this.uidPaciente, {super.key});

  @override
  State<TelaProntuariosPaciente> createState() => _TelaProntuariosPacienteState();
}

class _TelaProntuariosPacienteState extends State<TelaProntuariosPaciente> {
  var prontuarios;
  var paciente;
  String nomePaciente = '';

  carregarDados() async {
    prontuarios = await recuperarTodosProntuario(widget.uidPaciente);
    paciente = await recuperarPaciente(context, widget.uidPaciente);

    setState(() {
      nomePaciente = paciente['nomePaciente'];
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
        iconTheme: IconThemeData(color: cores('corSimbolo')),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            size: 30,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          "Prontuários",
          style: TextStyle(color: cores('corTexto'), fontSize: 24),
        ),
        backgroundColor: cores('corTerciaria'),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(10),
          child: Column(
            children: [
              Center(
                child: Text(
                  'Prontuários de $nomePaciente',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: cores('corTexto'),
                      fontSize: tamanhoFonte.letraMedia(context)),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                height: MediaQuery.of(context).size.height,
                child: StreamBuilder<QuerySnapshot>(
                    stream: prontuarios != null ? prontuarios.orderBy('dataProntuario').snapshots() : null,
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
                          return ListView.separated(
                              padding: EdgeInsets.all(10),
                              scrollDirection: Axis.vertical,
                              itemBuilder: (context, index) => cardProntuario(context, dados.docs[index]),
                              separatorBuilder: (context, _) => SizedBox(
                                    width: 1,
                                  ),
                              itemCount: dados.size);
                      }
                    }),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        shape: CircleBorder(),
        onPressed: () async {
          String tipo = 'adicionar';
          var appointment = await appointmentsPorUIDPaciente(widget.uidPaciente);
          DateTime dataProntuario = DateTime.now();
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => TelaAdicionarProntuarios(tipo, appointment, dataProntuario),
              ));
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
              color: cores('corTexto'), fontSize: tamanhoFonte.letraMedia(context), fontWeight: FontWeight.bold),
        ),
        trailing: IconButton(
          icon: Icon(
            Icons.edit,
            color: cores('corSimbolo'),
          ),
          onPressed: () async {
            String tipo = 'editar';
            var appointment = await appointmentsPorUIDPaciente(doc.data()['uidPaciente']);
            String dataProntuarioString = doc.data()['dataProntuario'];
            DateTime dataProntuario = DateFormat('dd/MM/yyyy').parse(dataProntuarioString);
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TelaAdicionarProntuarios(tipo, appointment, dataProntuario),
                ));
          },
        ),
        onTap: () {
          String dataProntuarioString = doc.data()['dataProntuario'];
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => TelaDadosProntuarios(doc.data()['uidPaciente'], dataProntuarioString),
              ));
        },
      ),
    ),
  );
}
