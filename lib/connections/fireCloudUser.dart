import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../widgets/mensagem.dart';
import 'fireAuth.dart';

String nomeColecao = 'users';

Future<String> retornarIDUser() async {
  String id = '';

  await FirebaseFirestore.instance.collection(nomeColecao).where('uid', isEqualTo: idUsuario()).get().then((q) {
    if (q.docs.isNotEmpty) {
      id = q.docs[0].id;
    }
  });

  return id;
}

criarUsuario(context, genero, nome, dtNascimento, email, cpf, crfa, telefone, senha, urlImage) {
  FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: senha).then((res) {
    FirebaseFirestore.instance.collection(nomeColecao).add({
      'uid': res.user!.uid.toString(),
      'genero': genero,
      'nome': nome,
      'dtNascimento': dtNascimento,
      'email': email,
      'cpf': cpf,
      'crfa': crfa,
      'telefone': telefone,
      'urlImage': urlImage,
    });
    sucesso(context, 'O usuário foi criado com sucesso!');
    Navigator.pop(context);
  }).catchError((e) {
    switch (e.code) {
      case 'email-already-in-use':
        erro(context, 'O email já foi cadastrado.');
        break;
      case 'invalid-email':
        erro(context, 'O formato do email é inválido.');
        break;
      default:
        erro(context, e.code.toString());
    }
  });
}

adicionarUsuario(res, urlImage, genero, nome, dtNascimento, email, cpf, crfa, telefone, senha) {
  FirebaseFirestore.instance.collection(nomeColecao).add({
    'uid': res,
    'urlImage': urlImage,
    'genero': genero,
    'nome': nome,
    'dtNascimento': dtNascimento,
    'email': email,
    'cpf': cpf,
    'crfa': crfa,
    'telefone': telefone,
  });
}

editarUsuario(context, uid, urlImage, nome, dtNascimento, email, cpf, crfa, telefone, senha) async {
  if (senha.isNotEmpty) {
    FirebaseAuth.instance.currentUser!.updatePassword(senha);
  }
  Map<String, dynamic> data = {
    'uid': uid,
    'urlImage': urlImage,
    'nome': nome,
    'dtNascimento': dtNascimento,
    'email': email,
    'cpf': cpf,
    'crfa': crfa,
    'telefone': telefone,
  };
  String id = await retornarIDUser();
  await FirebaseFirestore.instance.collection(nomeColecao).doc(id).update(data);
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
  return usuario;
}
