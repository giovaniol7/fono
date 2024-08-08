
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../widgets/mensagem.dart';
import 'fireAuth.dart';

String nomeColecao = 'users';

Future<String> retornarIDUser() async {
  String id = '';

  await FirebaseFirestore.instance.collection(nomeColecao).where('uid', isEqualTo: idFonoAuth()).get().then((q) {
    if (q.docs.isNotEmpty) {
      id = q.docs[0].id;
    }
  });

  return id;
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

  await FirebaseFirestore.instance.collection(nomeColecao).where('uid', isEqualTo: idFonoAuth()).get().then((q) {
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

recuperarPorFonoID() async {
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

  await FirebaseFirestore.instance.collection(nomeColecao).where('uid', isEqualTo: idFonoAuth()).get().then((q) {
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