import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../view/TelaPacientes.dart';

import '../connections/fireAuth.dart';
import '../widgets/mensagem.dart';

String nomeColecao = 'pacientes';

recuperarPacientes() async {
  return await FirebaseFirestore.instance.collection(nomeColecao).where('uidFono', isEqualTo: idUsuario());
}

Future<String> buscarIdPaciente(context, nome) async {
  String id = '';

  await FirebaseFirestore.instance.collection(nomeColecao).where('nomePaciente', isEqualTo: nome).get().then((q) {
    if (q.docs.isNotEmpty) {
      id = q.docs[0].id;
    }
  });

  return id;
}

Future<List<String>> fazerListaPacientes() async {
  List<String> list = [];

  QuerySnapshot querySnapshot =
      await FirebaseFirestore.instance.collection(nomeColecao).where('uidFono', isEqualTo: idUsuario()).get();
  querySnapshot.docs.forEach((doc) {
    String nome = doc['nomePaciente'];
    list.add(nome);
  });

  return list;
}

Future<List<String>> fazerListaUIDPacientes() async {
  List<String> list = [];

  QuerySnapshot querySnapshot =
      await FirebaseFirestore.instance.collection(nomeColecao).where('uidFono', isEqualTo: idUsuario()).get();
  querySnapshot.docs.forEach((doc) {
    String id = doc.id;
    list.add(id);
  });

  return list;
}

adicionarPaciente(
    context,
    uidFono,
    dataInicio,
    urlImage,
    nomePaciente,
    dataNascimento,
    telefone,
    genero,
    lougradouro,
    numero,
    bairro,
    cidade,
    estado,
    cep,
    tipoConsulta,
    descricao,
    generoResponsavel,
    nomeResponsavel,
    dataNascimentoResponsavel,
    relacaoResponsavel,
    escolaridadeResponsavel,
    profissaoResponsavel) async {
  CollectionReference pacientes = FirebaseFirestore.instance.collection(nomeColecao);
  String uidPaciente = '';
  Map<String, dynamic> data = {
    'uidFono': uidFono,
    'dataInicioPaciente': dataInicio,
    'urlImagePaciente': urlImage,
    'nomePaciente': nomePaciente,
    'dtNascimentoPaciente': dataNascimento,
    'telefonePaciente': telefone,
    'generoPaciente': genero,
    'lougradouroPaciente': lougradouro,
    'numeroPaciente': numero,
    'bairroPaciente': bairro,
    'cidadePaciente': cidade,
    'estadoPaciente': estado,
    'cepPaciente': cep,
    'tipoConsultaPaciente': tipoConsulta,
    'descricaoPaciente': descricao,
  };
  for (int i = 0; i < generoResponsavel.length; i++) {
    data['generoResponsavel$i'] = generoResponsavel[i].toString();
    data['nomeResponsavel$i'] = nomeResponsavel[i].text;
    data['dataNascimentoResponsavel$i'] = dataNascimentoResponsavel[i].text;
    data['relacaoResponsavel$i'] = relacaoResponsavel[i];
    data['escolaridadeResponsavel$i'] = escolaridadeResponsavel[i].text;
    data['profissaoResponsavel$i'] = profissaoResponsavel[i].text;
  }
  DocumentReference docRef = await pacientes.add(data);
  await FirebaseFirestore.instance
      .collection('pacientes')
      .where('nomePaciente', isEqualTo: nomePaciente)
      .get()
      .then((us) {
    uidPaciente = us.docs[0].id;
  });
  await docRef.update({'uidPaciente': uidPaciente});
  sucesso(context, 'O paciente foi adicionado com sucesso.');
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(
      builder: (context) => const TelaPacientes(),
    ),
  );
}

/*else {
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
    }*/
