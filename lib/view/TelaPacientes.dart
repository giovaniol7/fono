import 'package:flutter/material.dart';
import 'package:fonocare/connections/fireAuth.dart';

import 'package:fonocare/view/TelaAdicionarPaciente.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../connections/fireCloudPacientes.dart';
import '../widgets/TextFieldSuggestions.dart';
import '../controllers/estilos.dart';
import '../widgets/cardPaciente.dart';

class TelaPacientes extends StatefulWidget {
  const TelaPacientes({super.key});

  @override
  State<TelaPacientes> createState() => _TelaPacientesState();
}

class _TelaPacientesState extends State<TelaPacientes> {
  var pacientes;
  var nomePaciente;
  var tipoPaciente;
  String _paciente = '';
  List<String> listaPaciente = [];
  String _outroPaciente = "";
  var user;

  carregarDados() async {
    List<String> lista = await fazerListaPacientes();
    pacientes = await recuperarTodosPacientes();
    setState(() {
      listaPaciente = lista;
    });
  }

  @override
  void initState() {
    super.initState();
    carregarDados();
  }

  @override
  Widget build(BuildContext context) {
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
          "Pacientes",
          style: TextStyle(color: cores('corTexto'), fontSize: 24),
        ),
        backgroundColor: cores('corTerciaria'),
      ),
      body: SingleChildScrollView(
        physics: NeverScrollableScrollPhysics(),
        child: Container(
          child: Column(
            children: [
              Padding(padding: EdgeInsets.only(top: 20)),
              TextFieldSuggestions(
                  margem: EdgeInsets.only(top: 5, left: 20, bottom: 5, right: 20),
                  list: listaPaciente,
                  labelText: _outroPaciente,
                  textSuggetionsColor: cores('corTexto'),
                  suggetionsBackgroundColor: cores('branco'),
                  outlineInputBorderColor: cores('corTexto'),
                  returnedValue: (String value) {
                    setState(() {
                      _paciente = value;
                    });
                  },
                  onTap: () {},
                  height: 200),
              Container(
                height: MediaQuery.of(context).size.height * 0.75,
                child: StreamBuilder<QuerySnapshot>(
                    stream: pacientes != null
                        ? (_paciente.isEmpty
                            ? pacientes.orderBy('nomePaciente').snapshots()
                            : pacientes.where('nomePaciente', isEqualTo: _paciente).snapshots())
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
                          return ListView.separated(
                              padding: EdgeInsets.all(10),
                              scrollDirection: Axis.vertical,
                              itemBuilder: (context, index) => listarPaciente(context, dados.docs[index], 'pacientes'),
                              separatorBuilder: (context, _) => const SizedBox(height: 5),
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
        onPressed: () {
          String tipo = 'adicionar';
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => TelaAdicionarPaciente(tipo, idUsuario()),
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
