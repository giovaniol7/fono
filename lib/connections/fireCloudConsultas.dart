import 'dart:io';
import 'package:flutter/foundation.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firedart/firedart.dart' as fd;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../widgets/mensagem.dart';
import 'fireAuth.dart';

String nomeColecaoUsuario = 'consulta';

retornarIDConsultas() async {
  if (kIsWeb || Platform.isAndroid || Platform.isIOS) {
    await listarConsultas().get().then((us) {
      return us.docs[0].id;
    });
  } else {
    await listarConsultas().get().then((us) {
      if (us.isNotEmpty) {
        us.forEach((doc) {
          return doc.id;
        });
      }
    });
  }
}

listarConsultas() async {
  if (kIsWeb || Platform.isAndroid || Platform.isIOS) {
    return FirebaseFirestore.instance.collection(nomeColecaoUsuario).where('uidFono', isEqualTo: idUsuario());
  } else {
    await fd.FirebaseAuth.initialize('AIzaSyAlG2glNY3njAvAyJ7eEMeMtLg4Wcfg8rI', fd.VolatileStore());
    await fd.Firestore.initialize('programafono-7be09');

    var auth = fd.FirebaseAuth.instance;
    final emailSave = await SharedPreferences.getInstance();
    var email = emailSave.getString('email');
    final senhaSave = await SharedPreferences.getInstance();
    var senha = senhaSave.getString('senha');
    await auth.signIn(email!, senha!);
    var user = await auth.getUser();
    String uidFono = user.id;

    return fd.Firestore.instance.collection(nomeColecaoUsuario).where('uidFono', isEqualTo: uidFono);
  }
}

editarConsultas(context, id, uidFono, uidPaciente, nomePaciente, dataConsulta, horarioConsulta, duracaoConsulta,
    frequenciaConsulta, semanaConsulta, colorConsulta) async {
  Map<String, dynamic> data = {
    'uidFono': uidFono,
    'nomePaciente': nomePaciente,
    'uidPaciente': uidPaciente,
    'dataConsulta': dataConsulta,
    'horarioConsulta': horarioConsulta,
    'duracaoConsulta': duracaoConsulta,
    'frequenciaConsulta': frequenciaConsulta,
    'semanaConsulta': semanaConsulta,
    'colorConsulta': colorConsulta,
  };
  await FirebaseFirestore.instance.collection('consulta').doc(retornarIDConsultas()).update(data);
  sucesso(context, 'O horário foi alterado com sucesso.');
  Navigator.pop(context);
}

adicionarConsultas(context, uidFono, nomePaciente, dataConsulta, horarioConsulta, duracaoConsulta, frequenciaConsulta,
    semanaConsulta, colorConsulta) async {
  QuerySnapshot querySnapshot =
      await FirebaseFirestore.instance.collection('pacientes').where('nomePaciente', isEqualTo: nomePaciente).get();
  String uidPaciente = querySnapshot.docs[0].id;
  Map<String, dynamic> data = {
    'uidFono': uidFono,
    'uidPaciente': uidPaciente,
    'nomePaciente': nomePaciente,
    'dataConsulta': dataConsulta,
    'horarioConsulta': horarioConsulta,
    'duracaoConsulta': duracaoConsulta,
    'frequenciaConsulta': frequenciaConsulta,
    'semanaConsulta': semanaConsulta,
    'colorConsulta': colorConsulta,
  };
  FirebaseFirestore.instance.collection('consulta').add(data);
  sucesso(context, 'O horário foi agendado com sucesso.');
  Navigator.pop(context);
}
