import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firedart/firedart.dart' as fd;
import 'package:fono/view/TelaAdicionarPaciente.dart';
import 'package:fono/view/TelasEspecificoPaciente/TelaEspecificoPaciente.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../widgets/TextFieldSuggestions.dart';
import 'controllers/coresPrincipais.dart';

class TelaPaciente extends StatefulWidget {
  const TelaPaciente({super.key});

  @override
  State<TelaPaciente> createState() => _TelaPacienteState();
}

class _TelaPacienteState extends State<TelaPaciente> {
  var windowsIdFono;
  var pacientes;
  var pacientesOrdem;
  var uidFono;
  var nomePaciente;
  var tipoPaciente;
  String _paciente = '';
  List<String> _list = [];
  String _outroPaciente = "";
  var user;

  retornarPacientes() async {
    if (kIsWeb || Platform.isAndroid || Platform.isIOS) {
      pacientes = FirebaseFirestore.instance.collection('pacientes').where('uidFono', isEqualTo: uidFono);
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('pacientes').where('uidFono', isEqualTo: uidFono).get();
      querySnapshot.docs.forEach((doc) {
        String nome = doc['nomePaciente'];
        _list.add(nome);
      });
    } else {
      //await fd.FirebaseAuth.initialize('AIzaSyAlG2glNY3njAvAyJ7eEMeMtLg4Wcfg8rI', fd.VolatileStore());
      //await fd.Firestore.initialize('programafono-7be09');
      var auth = fd.FirebaseAuth.instance;
      final emailSave = await SharedPreferences.getInstance();
      var email = emailSave.getString('email');
      final senhaSave = await SharedPreferences.getInstance();
      var senha = senhaSave.getString('senha');
      await auth.signIn(email!, senha!);
      var user = await auth.getUser();
      windowsIdFono = user.id;

      List<fd.Document> querySnapshot = await fd.Firestore.instance
          .collection('pacientes')
          .where('uidFono', isEqualTo: uidFono)
          .orderBy('nomePaciente')
          .get();
      querySnapshot.forEach((doc) {
        String nome = doc['nomePaciente'];
        _list.add(nome);
      });

      pacientes = await fd.Firestore.instance.collection('pacientes').where('uidFono', isEqualTo: uidFono);

      pacientesOrdem = await pacientes.orderBy('nomePaciente');

      pacientesOrdem = await pacientesOrdem.get();

      print(pacientes);
      print(pacientesOrdem);
    }
  }

  @override
  void initState() {
    super.initState();
    retornarPacientes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: cores('verde')),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          "Pacientes",
          style: TextStyle(color: cores('verde')),
        ),
        backgroundColor: cores('rosa_fraco'),
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              Padding(padding: EdgeInsets.only(top: 20)),
              TextFieldSuggestions(
                  margem: EdgeInsets.only(top: 5, left: 24, bottom: 20, right: 24),
                  list: _list,
                  labelText: _outroPaciente,
                  textSuggetionsColor: cores('verde'),
                  suggetionsBackgroundColor: Colors.white,
                  outlineInputBorderColor: cores('verde'),
                  returnedValue: (String value) {
                    setState(() {
                      _paciente = value;
                    });
                  },
                  onTap: () {},
                  height: 200),
              Container(
                height: MediaQuery.of(context).size.height,
                child: StreamBuilder<QuerySnapshot>(
                    stream: _paciente.isEmpty
                        ? pacientes.orderBy('nomePaciente').snapshots()
                        : pacientes.where('nomePaciente', isEqualTo: _paciente).snapshots(),
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
                              itemBuilder: (context, index) => listarPaciente(dados.docs[index]),
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
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => TelaAdicionarPaciente(uidFono),
              ));
        },
        child: Icon(
          Icons.add,
          color: cores('rosa_fraco'),
        ),
        backgroundColor: cores('verde'),
      ),
    );
  }

  Widget listarPaciente(doc) {
    return Container(
      child: Card(
        elevation: 7,
        shadowColor: cores('rosa_fraco'),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        margin: EdgeInsets.all(5),
        child: ListTile(
          /*leading: CircleAvatar(
            backgroundImage: NetworkImage(
              doc.data()['urlImagePaciente'],
            ),
          ),*/
          title: Expanded(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                doc.data()['nomePaciente'],
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                doc.data()['tipoConsultaPaciente'],
                style: TextStyle(fontWeight: FontWeight.normal, color: Colors.grey),
              ),
            ],
          )),
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TelaEspecificoPaciente(doc.data()['uidPaciente']),
                ));
          },
        ),
      ),
    );
  }
}
