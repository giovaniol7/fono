import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../widgets/mensagem.dart';

String nomeColecao = 'prontuarios';

Future<String?> buscarIdProntuario(context, nome) async {
  var id = '';

  await FirebaseFirestore.instance.collection(nomeColecao).where('nomePaciente', isEqualTo: nome).get().then((q) {
    if (q.docs.isNotEmpty) {
      id = q.docs[0].id;
    }
  });

  return id;
}

adicionarProntuario(context, uidFono, uidPaciente, nomePaciente, dataProntuario, horarioProntuario, objetivosProntuario,
    materiaisProntuario, resultadosProntuario) async {
  CollectionReference prontuarios = FirebaseFirestore.instance.collection(nomeColecao);
  Map<String, dynamic> data = {
    'uidFono': uidFono,
    'uidPaciente': uidPaciente,
    'nomePaciente': nomePaciente,
    'dataProntuario': dataProntuario,
    'horarioProntuario': horarioProntuario,
    'objetivosProntuario': objetivosProntuario,
    'materiaisProntuario': materiaisProntuario,
    'resultadosProntuario': resultadosProntuario,
  };
  await prontuarios.add(data);
  sucesso(context, 'O prontuário foi adicionado com sucesso.');
  Navigator.pop(context);
}

editarProntuario(context, uidFono, uidPaciente, nomePaciente, dataProntuario, horarioProntuario, objetivosProntuario,
    materiaisProntuario, resultadosProntuario) async {
  Map<String, dynamic> data = {
    'uidFono': uidFono,
    'uidPaciente': uidPaciente,
    'nomePaciente': nomePaciente,
    'dataProntuario': dataProntuario,
    'horarioProntuario': horarioProntuario,
    'objetivosProntuario': objetivosProntuario,
    'materiaisProntuario': materiaisProntuario,
    'resultadosProntuario': resultadosProntuario,
  };
  String? idProntuario = await buscarIdProntuario(context, nomePaciente);
  await FirebaseFirestore.instance.collection(nomeColecao).doc(idProntuario).update(data);
  sucesso(context, 'O prontuário foi atualizado com sucesso.');
  Navigator.pop(context);
}

apagarProntuario(context, id) async {
  try {
    await FirebaseFirestore.instance.collection(nomeColecao).doc(id).delete();
    sucesso(context, 'Prontuário apagado com sucesso!');
    Navigator.pop(context);
  } catch (e) {
    erro(context, 'Erro ao remover a consulta');
  }
}

recuperarTodosProntuario(uidPaciente) async {
  return await FirebaseFirestore.instance.collection(nomeColecao).where('uidPaciente', isEqualTo: uidPaciente);
}

recuperarProntuario(context, uid) async {
  String uidProntuario = '';
  String uidFono = '';
  String uidPaciente = '';
  String nomePaciente = '';
  String dataProntuario = '';
  String horarioProntuario = '';
  String objetivosProntuario = '';
  String materiaisProntuario = '';
  String resultadosProntuario = '';

  Map<String, dynamic> prontuarios = {};

  await FirebaseFirestore.instance.collection(nomeColecao).where('uidPaciente', isEqualTo: uid).get().then((q) {
    if (q.docs.isNotEmpty) {
      uidProntuario = q.docs[0].id;
      uidFono = q.docs[0].data()['uidFono'];
      uidPaciente = q.docs[0].data()['uidPaciente'];
      nomePaciente = q.docs[0].data()['nomePaciente'];
      dataProntuario = q.docs[0].data()['dataProntuario'];
      horarioProntuario = q.docs[0].data()['horarioProntuario'];
      objetivosProntuario = q.docs[0].data()['objetivosProntuario'];
      materiaisProntuario = q.docs[0].data()['materiaisProntuario'];
      resultadosProntuario = q.docs[0].data()['resultadosProntuario'];
    }
  });

  prontuarios = {
    'uidProntuario': uidProntuario,
    'uidFono': uidFono,
    'uidPaciente': uidPaciente,
    'nomePaciente': nomePaciente,
    'dataProntuario': dataProntuario,
    'horarioProntuario': horarioProntuario,
    'objetivosProntuario': objetivosProntuario,
    'materiaisProntuario': materiaisProntuario,
    'resultadosProntuario': resultadosProntuario,
  };

  return prontuarios;
}

recuperarProntuarioData(context, uid, data) async {
  String uidProntuario = '';
  String uidFono = '';
  String uidPaciente = '';
  String nomePaciente = '';
  String dataProntuario = '';
  String horarioProntuario = '';
  String objetivosProntuario = '';
  String materiaisProntuario = '';
  String resultadosProntuario = '';

  Map<String, dynamic> prontuarios = {};

  await FirebaseFirestore.instance.collection(nomeColecao).where('uidPaciente', isEqualTo: uid).where('dataProntuario', isEqualTo: data).get().then((q) {
    if (q.docs.isNotEmpty) {
      uidProntuario = q.docs[0].id;
      uidFono = q.docs[0].data()['uidFono'];
      uidPaciente = q.docs[0].data()['uidPaciente'];
      nomePaciente = q.docs[0].data()['nomePaciente'];
      dataProntuario = q.docs[0].data()['dataProntuario'];
      horarioProntuario = q.docs[0].data()['horarioProntuario'];
      objetivosProntuario = q.docs[0].data()['objetivosProntuario'];
      materiaisProntuario = q.docs[0].data()['materiaisProntuario'];
      resultadosProntuario = q.docs[0].data()['resultadosProntuario'];
    }
  });

  prontuarios = {
    'uidProntuario': uidProntuario,
    'uidFono': uidFono,
    'uidPaciente': uidPaciente,
    'nomePaciente': nomePaciente,
    'dataProntuario': dataProntuario,
    'horarioProntuario': horarioProntuario,
    'objetivosProntuario': objetivosProntuario,
    'materiaisProntuario': materiaisProntuario,
    'resultadosProntuario': resultadosProntuario,
  };

  return prontuarios;
}
