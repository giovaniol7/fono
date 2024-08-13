import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../connections/fireAuth.dart';
import '../connections/fireCloudPacientes.dart';
import '../controllers/estilos.dart';
import '../widgets/TextFieldSuggestions.dart';
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
  var varAtivo = '1';
  String _paciente = '';
  List<String> listaPaciente = [];
  String _outroPaciente = "Nome do Paciente";
  var user;

  carregarDados() async {
    List<String> lista = await fazerListaPacientes(varAtivo);
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
        actions: [
          PopupMenuButton<String>(
            onSelected: (String result) {
              if (result == 'opcao1') {
                setState(() {
                  varAtivo = '1';
                  carregarDados();
                });
              }
              if (result == 'opcao2') {
                setState(() {
                  varAtivo = '0';
                  carregarDados();
                });
              }
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              const PopupMenuItem<String>(
                value: 'opcao1',
                child: Text('Pacientes Não Arquivados'),
              ),
              const PopupMenuItem<String>(
                value: 'opcao2',
                child: Text('Pacientes Arquivados'),
              ),
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        physics: NeverScrollableScrollPhysics(),
        child: Container(
          child: Column(
            children: [
              Padding(padding: EdgeInsets.only(top: 20)),
              TextFieldSuggestions(
                  tipo: 'paciente',
                  margem: EdgeInsets.only(left: 20, bottom: 5, right: 20),
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
                            ? pacientes
                                .orderBy('nomePaciente')
                                .where('ativoPaciente', isEqualTo: varAtivo)
                                .snapshots()
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
                                  itemBuilder: (context, index) =>
                                      listarPaciente(context, dados.docs[index], 'pacientes'),
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
          Navigator.pushNamed(context, '/adicionarPacientes', arguments: {'tipo': 'adicionar', 'uidFono': idFonoAuth()});
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
