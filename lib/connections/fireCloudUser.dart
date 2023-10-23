import 'dart:io';
import 'package:flutter/foundation.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firedart/firedart.dart' as fd;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../widgets/mensagem.dart';
import 'fireAuth.dart';

String nomeColecao = 'users';

retornarIDUser() async {
  if (kIsWeb || Platform.isAndroid || Platform.isIOS) {
    FirebaseFirestore.instance.collection(nomeColecao).where('uid', isEqualTo: idUsuario()).get().then((q) {
      if (q.docs.isNotEmpty) {
        return q.docs[0].id;
      }
    });
  } else {
    fd.Firestore.instance.collection(nomeColecao).where('uid', isEqualTo: idUsuario()).get().then((us) {
      if (us.isNotEmpty) {
        us.forEach((doc) {
          // return doc.id;
        });
      }
    });
  }
}

adicionarUsuario(res, genero, nome, dtNascimento, email, cpf, crfa, telefone, senha, urlImage) {
  FirebaseFirestore.instance.collection(nomeColecao).add({
    'uid': res,
    'genero': genero,
    'nome': nome,
    'dtNascimento': dtNascimento,
    'email': email,
    'cpf': cpf,
    'crfa': crfa,
    'telefone': telefone,
    'urlImage': urlImage,
  });
}

editarUsuario(context, uid, nome, dtNascimento, email, cpf, crfa, telefone, senha, urlImage) async {
  if (senha.isNotEmpty) {
    FirebaseAuth.instance.currentUser!.updatePassword(senha);
  }
  Map<String, dynamic> data = {
    'uid': uid,
    'nome': nome,
    'dtNascimento': dtNascimento,
    'email': email,
    'cpf': cpf,
    'crfa': crfa,
    'telefone': telefone,
    'urlImage': urlImage,
  };
  await FirebaseFirestore.instance.collection('users').doc(retornarIDUser()).update(data);
  sucesso(context, 'O usuário foi editado com sucesso!');
}

Future<Map<String, String>> listarUsuario() async {
  String id = '';
  String uid = '';
  String urlImage = '';
  String nome = '';
  String dtNascimento = '';
  String genero = '';
  String email = '';
  String cpf = '';
  String crfa = '';
  String telefone = '';
  Map<String, String> usuario = {};

  //if (kIsWeb || Platform.isAndroid || Platform.isIOS) {
  await FirebaseFirestore.instance.collection(nomeColecao).where('uid', isEqualTo: idUsuario()).get().then((q) {
    if (q.docs.isNotEmpty) {
      id = q.docs[0].id;
      uid = q.docs[0].data()['uid'];
      urlImage = q.docs[0].data()['urlImage'];
      nome = q.docs[0].data()['nome'];
      dtNascimento = q.docs[0].data()['dtNascimento'];
      genero = q.docs[0].data()['genero'];
      email = q.docs[0].data()['email'];
      cpf = q.docs[0].data()['cpf'];
      crfa = q.docs[0].data()['crfa'];
      telefone = q.docs[0].data()['telefone'];
    }
  });

  usuario = {
    'id': id,
    'uid': uid,
    'urlImage': urlImage,
    'nome': nome,
    'dtNascimento': dtNascimento,
    'genero': genero,
    'email': email,
    'telefone': telefone,
    'cpf': cpf,
    'crfa': crfa,
  };
  /*} else {
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

    fd.Firestore.instance.collection(nomeColecao).where('uid', isEqualTo: uidFono).get().then((us) {
      if (us.isNotEmpty) {
        us.forEach((doc) {
          nome = doc['nome'];
          urlImage = doc['urlImage'];
          genero = doc['genero'];
        });
      }
    });
    usuario = {
      'nome': nome,
      'urlImage': urlImage,
      'genero': genero,
    };
  }*/
  return usuario;
}
