import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../controllers/uploadDoc.dart';
import '../models/maps.dart';

import '../connections/fireAuth.dart';
import '../widgets/mensagem.dart';

String nomeColecao = 'pacientes';

recuperarTodosPacientes() async {
  return await FirebaseFirestore.instance.collection(nomeColecao).where('uidFono', isEqualTo: idUsuario());
}

Future<String> buscarIdPaciente(context, nome) async {
  String id = '';

  await FirebaseFirestore.instance.collection(nomeColecao).where('nomePaciente', isEqualTo: nome).get().then((q) {
    if (q.docs.isNotEmpty) {
      id = q.docs[0].data()['uidPaciente'];
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
    urlImagePaciente,
    dataAnamnesePaciente,
    nomePaciente,
    dataNascimentoPaciente,
    CPFPaciente,
    RGPaciente,
    generoPaciente,
    escolaPaciente,
    escolaridadePaciente,
    periodoEscolaPaciente,
    professoraPaciente,
    telefoneProfessoraPaciente,
    lougradouroPaciente,
    numeroPaciente,
    bairroPaciente,
    cidadePaciente,
    estadoPaciente,
    cepPaciente,
    tipoConsultaPaciente,
    descricaoPaciente,
    qtdResponsavel,
    listGeneroResponsavel,
    listNomeResponsavel,
    listIdadeResponsavel,
    listTelefoneResponsavel,
    listRelacaoResponsavel,
    listEscolaridadeResponsavel,
    listProfissaoResponsavel,
    fileDoc) async {
  try {
    String nomeSemEspacos = nomePaciente.trimRight();
    CollectionReference pacientes = FirebaseFirestore.instance.collection(nomeColecao);
    String? urlDocPaciente = fileDoc != null ? await uploadDocToFirebase(fileDoc) : '';
    DocumentReference novoDocumento = pacientes.doc();
    Map<String, dynamic> data = {
      'uidPaciente': novoDocumento.id,
      'uidFono': uidFono,
      'urlImagePaciente': urlImagePaciente,
      'dataAnamnesePaciente': dataAnamnesePaciente,
      'nomePaciente': nomeSemEspacos,
      'dtNascimentoPaciente': dataNascimentoPaciente,
      'CPFPaciente': CPFPaciente,
      'RGPaciente': RGPaciente,
      'generoPaciente': generoPaciente,
      'escolaPaciente': escolaPaciente,
      'escolaridadePaciente': escolaridadePaciente,
      'periodoEscolaPaciente': periodoEscolaPaciente,
      'professoraPaciente': professoraPaciente,
      'telefoneProfessoraPaciente': telefoneProfessoraPaciente,
      'lougradouroPaciente': lougradouroPaciente,
      'numeroPaciente': numeroPaciente,
      'bairroPaciente': bairroPaciente,
      'cidadePaciente': cidadePaciente,
      'estadoPaciente': estadoPaciente,
      'cepPaciente': cepPaciente,
      'tipoConsultaPaciente': tipoConsultaPaciente,
      'descricaoPaciente': descricaoPaciente,
      'qtdResponsavel': qtdResponsavel + 1,
      'urlDocPaciente': urlDocPaciente
    };
    for (int i = 0; i < listGeneroResponsavel.length; i++) {
      data['generoResponsavel$i'] = listGeneroResponsavel[i].toString();
      data['nomeResponsavel$i'] = listNomeResponsavel[i].text;
      data['idadeResponsavel$i'] = listIdadeResponsavel[i].text;
      data['telefoneResponsavel$i'] = listTelefoneResponsavel[i].text;
      data['relacaoResponsavel$i'] = listRelacaoResponsavel[i];
      data['escolaridadeResponsavel$i'] = listEscolaridadeResponsavel[i].text;
      data['profissaoResponsavel$i'] = listProfissaoResponsavel[i].text;
    }
    await pacientes.add(data);
    sucesso(context, 'O paciente foi adicionado com sucesso.');
    Navigator.pop(context);
  } catch (e) {
    erro(context, 'Erro ao adicionar paciente.');
  }
}

editarPaciente(
    context,
    uidFono,
    uidPaciente,
    urlImagePaciente,
    dataAnamnesePaciente,
    nomePaciente,
    dataNascimentoPaciente,
    CPFPaciente,
    RGPaciente,
    generoPaciente,
    escolaPaciente,
    escolaridadePaciente,
    periodoEscolaPaciente,
    professoraPaciente,
    telefoneProfessoraPaciente,
    lougradouroPaciente,
    numeroPaciente,
    bairroPaciente,
    cidadePaciente,
    estadoPaciente,
    cepPaciente,
    tipoConsultaPaciente,
    descricaoPaciente,
    qtdResponsavel,
    listGeneroResponsavel,
    listNomeResponsavel,
    listIdadeResponsavel,
    listTelefoneResponsavel,
    listRelacaoResponsavel,
    listEscolaridadeResponsavel,
    listProfissaoResponsavel,
    fileDoc) async {
  try{
    String nomeSemEspacos = nomePaciente.trimRight();
    String? urlDocPaciente = fileDoc != null ? await uploadDocToFirebase(fileDoc) : '';
    Map<String, dynamic> data = {
      'uidFono': uidFono,
      'urlImagePaciente': urlImagePaciente,
      'dataAnamnesePaciente': dataAnamnesePaciente,
      'nomePaciente': nomeSemEspacos,
      'dtNascimentoPaciente': dataNascimentoPaciente,
      'CPFPaciente': CPFPaciente,
      'RGPaciente': RGPaciente,
      'generoPaciente': generoPaciente,
      'escolaPaciente': escolaPaciente,
      'escolaridadePaciente': escolaridadePaciente,
      'periodoEscolaPaciente': periodoEscolaPaciente,
      'professoraPaciente': professoraPaciente,
      'telefoneProfessoraPaciente': telefoneProfessoraPaciente,
      'lougradouroPaciente': lougradouroPaciente,
      'numeroPaciente': numeroPaciente,
      'bairroPaciente': bairroPaciente,
      'cidadePaciente': cidadePaciente,
      'estadoPaciente': estadoPaciente,
      'cepPaciente': cepPaciente,
      'tipoConsultaPaciente': tipoConsultaPaciente,
      'descricaoPaciente': descricaoPaciente,
      'qtdResponsavel': qtdResponsavel,
      'urlDocPaciente': urlDocPaciente
    };
    for (int i = 0; i < listGeneroResponsavel.length; i++) {
      data['generoResponsavel$i'] = listGeneroResponsavel[i].toString();
      data['nomeResponsavel$i'] = listNomeResponsavel[i].text;
      data['idadeResponsavel$i'] = listIdadeResponsavel[i].text;
      data['telefoneResponsavel$i'] = listTelefoneResponsavel[i].text;
      data['relacaoResponsavel$i'] = listRelacaoResponsavel[i];
      data['escolaridadeResponsavel$i'] = listEscolaridadeResponsavel[i].text;
      data['profissaoResponsavel$i'] = listProfissaoResponsavel[i].text;
    }
    await FirebaseFirestore.instance.collection(nomeColecao).doc(uidPaciente).update(data);
    sucesso(context, 'O paciente foi atualizado com sucesso.');
    Navigator.pop(context);
  } catch (e) {
    erro(context, 'Erro ao editar paciente.');
  }
}

apagarPaciente(context, id) async {
  try {
    await FirebaseFirestore.instance.collection(nomeColecao).doc(id).delete();
    sucesso(context, 'Paciente apagado com sucesso!');
    Navigator.pop(context);
  } catch (e) {
    erro(context, 'Erro ao remover a paciente.');
  }
}

recuperarPaciente(context, uid) async {
  String uidPaciente = '';
  String uidFono = '';
  String urlImagePaciente = '';
  String dataAnamnesePaciente = '';
  String nomePaciente = '';
  String dtNascimentoPaciente = '';
  String CPFPaciente = '';
  String RGPaciente = '';
  Gender? generoPaciente;
  String escolaPaciente = '';
  String escolaridadePaciente = '';
  String periodoEscolaPaciente = '';
  String professoraPaciente = '';
  String telefoneProfessoraPaciente = '';
  String lougradouroPaciente = '';
  String numeroPaciente = '';
  String bairroPaciente = '';
  String cidadePaciente = '';
  String estadoPaciente = '';
  String cepPaciente = '';
  String tipoConsultaPaciente = '';
  String descricaoPaciente = '';
  int qtdResponsavel = 0;
  String urlDocPaciente = '';
  List<Gender?> listGeneroResponsavel = [];
  List<String> listNomeResponsavel = [];
  List<String> listIdadeResponsavel = [];
  List<String> listTelefoneResponsavel = [];
  List<String> listRelacaoResponsavel = [];
  List<String> listEscolaridadeResponsavel = [];
  List<String> listProfissaoResponsavel = [];

  Map<String, dynamic> paciente = {};

  await FirebaseFirestore.instance.collection(nomeColecao).where('uidPaciente', isEqualTo: uid).get().then((q) {
    if (q.docs.isNotEmpty) {
      uidPaciente = q.docs[0].id;
      uidFono = q.docs[0].data()['uidFono'];
      urlImagePaciente = q.docs[0].data()['urlImagePaciente'];
      dataAnamnesePaciente = q.docs[0].data()['dataAnamnesePaciente'];
      nomePaciente = q.docs[0].data()['nomePaciente'];
      dtNascimentoPaciente = q.docs[0].data()['dtNascimentoPaciente'];
      CPFPaciente = q.docs[0].data()['CPFPaciente'];
      RGPaciente = q.docs[0].data()['RGPaciente'];
      generoPaciente = stringToGender(q.docs[0].data()['generoPaciente']);
      escolaPaciente = q.docs[0].data()['escolaPaciente'];
      escolaridadePaciente = q.docs[0].data()['escolaridadePaciente'];
      periodoEscolaPaciente = q.docs[0].data()['periodoEscolaPaciente'];
      professoraPaciente = q.docs[0].data()['professoraPaciente'];
      telefoneProfessoraPaciente = q.docs[0].data()['telefoneProfessoraPaciente'];
      lougradouroPaciente = q.docs[0].data()['lougradouroPaciente'];
      numeroPaciente = q.docs[0].data()['numeroPaciente'];
      bairroPaciente = q.docs[0].data()['bairroPaciente'];
      cidadePaciente = q.docs[0].data()['cidadePaciente'];
      estadoPaciente = q.docs[0].data()['estadoPaciente'];
      cepPaciente = q.docs[0].data()['cepPaciente'];
      tipoConsultaPaciente = q.docs[0].data()['tipoConsultaPaciente'];
      descricaoPaciente = q.docs[0].data()['descricaoPaciente'];
      qtdResponsavel = q.docs[0].data()['qtdResponsavel'];
      urlDocPaciente = q.docs[0].data()['urlDocPaciente'];
      for (int i = 0; i < qtdResponsavel; i++) {
        listGeneroResponsavel.add(stringToGender(q.docs[0].data()['generoResponsavel$i']));
        listNomeResponsavel.add(q.docs[0].data()['nomeResponsavel$i']);
        listIdadeResponsavel.add(q.docs[0].data()['idadeResponsavel$i']);
        listTelefoneResponsavel.add(q.docs[0].data()['telefoneResponsavel$i']);
        listRelacaoResponsavel.add(q.docs[0].data()['relacaoResponsavel$i']);
        listEscolaridadeResponsavel.add(q.docs[0].data()['escolaridadeResponsavel$i']);
        listProfissaoResponsavel.add(q.docs[0].data()['profissaoResponsavel$i']);
      }
    }
  });

  paciente = {
    'uidPaciente': uidPaciente,
    'uidFono': uidFono,
    'dataAnamnesePaciente': dataAnamnesePaciente,
    'urlImagePaciente': urlImagePaciente,
    'nomePaciente': nomePaciente,
    'dtNascimentoPaciente': dtNascimentoPaciente,
    'CPFPaciente': CPFPaciente,
    'RGPaciente': RGPaciente,
    'generoPaciente': generoPaciente,
    'escolaPaciente': escolaPaciente,
    'escolaridadePaciente': escolaridadePaciente,
    'periodoEscolaPaciente': periodoEscolaPaciente,
    'professoraPaciente': professoraPaciente,
    'telefoneProfessoraPaciente': telefoneProfessoraPaciente,
    'lougradouroPaciente': lougradouroPaciente,
    'numeroPaciente': numeroPaciente,
    'bairroPaciente': bairroPaciente,
    'cidadePaciente': cidadePaciente,
    'estadoPaciente': estadoPaciente,
    'cepPaciente': cepPaciente,
    'tipoConsultaPaciente': tipoConsultaPaciente,
    'descricaoPaciente': descricaoPaciente,
    'qtdResponsavel': qtdResponsavel,
    'urlDocPaciente': urlDocPaciente,
    'listGeneroResponsavel': listGeneroResponsavel,
    'listNomeResponsavel': listNomeResponsavel,
    'listIdadeResponsavel': listIdadeResponsavel,
    'listTelefoneResponsavel': listTelefoneResponsavel,
    'listRelacaoResponsavel': listRelacaoResponsavel,
    'listEscolaridadeResponsavel': listEscolaridadeResponsavel,
    'listProfissaoResponsavel': listProfissaoResponsavel,
  };

  return paciente;
}

recuperarPacientePorNome(context, nome) async {
  String uidPaciente = '';
  String uidFono = '';
  String urlImagePaciente = '';
  String dataAnamnesePaciente = '';
  String nomePaciente = '';
  String dtNascimentoPaciente = '';
  String CPFPaciente = '';
  String RGPaciente = '';
  Gender? generoPaciente;
  String escolaPaciente = '';
  String escolaridadePaciente = '';
  String periodoEscolaPaciente = '';
  String professoraPaciente = '';
  String telefoneProfessoraPaciente = '';
  String lougradouroPaciente = '';
  String numeroPaciente = '';
  String bairroPaciente = '';
  String cidadePaciente = '';
  String estadoPaciente = '';
  String cepPaciente = '';
  String tipoConsultaPaciente = '';
  String descricaoPaciente = '';
  int qtdResponsavel = 0;
  String urlDocPaciente = '';
  List<Gender?> listGeneroResponsavel = [];
  List<String> listNomeResponsavel = [];
  List<String> listIdadeResponsavel = [];
  List<String> listTelefoneResponsavel = [];
  List<String> listRelacaoResponsavel = [];
  List<String> listEscolaridadeResponsavel = [];
  List<String> listProfissaoResponsavel = [];

  Map<String, dynamic> paciente = {};

  await FirebaseFirestore.instance.collection(nomeColecao).where('nomePaciente', isEqualTo: nome).get().then((q) {
    if (q.docs.isNotEmpty) {
      uidPaciente = q.docs[0].id;
      uidFono = q.docs[0].data()['uidFono'];
      urlImagePaciente = q.docs[0].data()['urlImagePaciente'];
      dataAnamnesePaciente = q.docs[0].data()['dataAnamnesePaciente'];
      nomePaciente = q.docs[0].data()['nomePaciente'];
      dtNascimentoPaciente = q.docs[0].data()['dtNascimentoPaciente'];
      CPFPaciente = q.docs[0].data()['CPFPaciente'];
      RGPaciente = q.docs[0].data()['RGPaciente'];
      generoPaciente = stringToGender(q.docs[0].data()['generoPaciente']);
      escolaPaciente = q.docs[0].data()['escolaPaciente'];
      escolaridadePaciente = q.docs[0].data()['escolaridadePaciente'];
      periodoEscolaPaciente = q.docs[0].data()['periodoEscolaPaciente'];
      professoraPaciente = q.docs[0].data()['professoraPaciente'];
      telefoneProfessoraPaciente = q.docs[0].data()['telefoneProfessoraPaciente'];
      lougradouroPaciente = q.docs[0].data()['lougradouroPaciente'];
      numeroPaciente = q.docs[0].data()['numeroPaciente'];
      bairroPaciente = q.docs[0].data()['bairroPaciente'];
      cidadePaciente = q.docs[0].data()['cidadePaciente'];
      estadoPaciente = q.docs[0].data()['estadoPaciente'];
      cepPaciente = q.docs[0].data()['cepPaciente'];
      tipoConsultaPaciente = q.docs[0].data()['tipoConsultaPaciente'];
      descricaoPaciente = q.docs[0].data()['descricaoPaciente'];
      qtdResponsavel = q.docs[0].data()['qtdResponsavel'];
      urlDocPaciente = q.docs[0].data()['urlDocPaciente'];
      for (int i = 0; i < qtdResponsavel; i++) {
        listGeneroResponsavel.add(stringToGender(q.docs[0].data()['generoResponsavel$i']));
        listNomeResponsavel.add(q.docs[0].data()['nomeResponsavel$i']);
        listIdadeResponsavel.add(q.docs[0].data()['idadeResponsavel$i']);
        listTelefoneResponsavel.add(q.docs[0].data()['telefoneResponsavel$i']);
        listRelacaoResponsavel.add(q.docs[0].data()['relacaoResponsavel$i']);
        listEscolaridadeResponsavel.add(q.docs[0].data()['escolaridadeResponsavel$i']);
        listProfissaoResponsavel.add(q.docs[0].data()['profissaoResponsavel$i']);
      }
    }
  });

  paciente = {
    'uidPaciente': uidPaciente,
    'uidFono': uidFono,
    'urlImagePaciente': urlImagePaciente,
    'dataAnamnesePaciente': dataAnamnesePaciente,
    'nomePaciente': nomePaciente,
    'dtNascimentoPaciente': dtNascimentoPaciente,
    'CPFPaciente': CPFPaciente,
    'RGPaciente': RGPaciente,
    'generoPaciente': generoPaciente,
    'escolaPaciente': escolaPaciente,
    'escolaridadePaciente': escolaridadePaciente,
    'periodoEscolaPaciente': periodoEscolaPaciente,
    'professoraPaciente': professoraPaciente,
    'telefoneProfessoraPaciente': telefoneProfessoraPaciente,
    'lougradouroPaciente': lougradouroPaciente,
    'numeroPaciente': numeroPaciente,
    'bairroPaciente': bairroPaciente,
    'cidadePaciente': cidadePaciente,
    'estadoPaciente': estadoPaciente,
    'cepPaciente': cepPaciente,
    'tipoConsultaPaciente': tipoConsultaPaciente,
    'descricaoPaciente': descricaoPaciente,
    'qtdResponsavel': qtdResponsavel,
    'urlDocPaciente': urlDocPaciente,
    'listGeneroResponsavel': listGeneroResponsavel,
    'listNomeResponsavel': listNomeResponsavel,
    'listIdadeResponsavel': listIdadeResponsavel,
    'listTelefoneResponsavel': listTelefoneResponsavel,
    'listRelacaoResponsavel': listRelacaoResponsavel,
    'listEscolaridadeResponsavel': listEscolaridadeResponsavel,
    'listProfissaoResponsavel': listProfissaoResponsavel,
  };

  return paciente;
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
