import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:firedart/firedart.dart' as fd;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../widgets/mensagem.dart';
import 'sharedPreference.dart';
import 'fireCloudUser.dart';

idUsuario() {
  return FirebaseAuth.instance.currentUser!.uid;
}

criarConta(context, genero, nome, dtNascimento, email, cpf, crfa, telefone, senha, urlImage) {
  FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: senha).then((res) {
    adicionarUsuario(res.user!.uid.toString(), genero, nome, dtNascimento, email, cpf, crfa, telefone, senha, urlImage);
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

autenticarConta(context, email, senha) async {
  if(email.isNotEmpty && senha.isNotEmpty){
    await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: senha).then((res) {
      sucesso(context, 'Usuário autenticado com sucesso!');
      saveValor();
      Navigator.pushReplacementNamed(context, '/principal');
    }).catchError((e) {
      switch (e.code) {
        case 'invalid-email':
          erro(context, 'O formato do email é inválido.');
          break;
        case 'user-not-found':
          erro(context, 'Usuário não encontrado.');
          break;
        case 'wrong-password':
          erro(context, 'Senha incorreta.');
          break;
        default:
          print(e.code.toString());
          erro(context, e.code.toString());
      }
    });
  }
}

/*  //if (kIsWeb || Platform.isAndroid || Platform.isIOS) {
      }else{
    await Firebase.initializeApp();
    await fd.FirebaseAuth.initialize('AIzaSyAlG2glNY3njAvAyJ7eEMeMtLg4Wcfg8rI', fd.VolatileStore());
    await fd.Firestore.initialize('programafono-7be09');
    fd.FirebaseAuth.instance.signIn(email, senha).then((res) async {
      sucesso(context, 'Usuário autenticado com sucesso!');
      final emailSave = await SharedPreferences.getInstance();
      await emailSave.setString('email', email);
      final senhaSave = await SharedPreferences.getInstance();
      await senhaSave.setString('senha', senha);
      saveValor();
      Navigator.pushReplacementNamed(context, '/principal');
    }).catchError((e) {
      switch (e.code) {
        case 'invalid-email':
          erro(context, 'O formato do email é inválido.');
          break;
        case 'user-not-found':
          erro(context, 'Usuário não encontrado.');
          break;
        case 'wrong-password':
          erro(context, 'Senha incorreta.');
          break;
        default:
          erro(context, e.code.toString());
      }
    });
  }*/

signOut(context) async {
  if (kIsWeb || Platform.isAndroid || Platform.isIOS) {
    try {
      await FirebaseAuth.instance.signOut();
      deleteValor();
      sucesso(context, 'O usuário deslogado!');
      Navigator.pushReplacementNamed(context, '/login');
    } catch (e) {
      print(e.toString());
      return null;
    }
  } else {
    //fd.FirebaseAuth.initialize('AIzaSyAlG2glNY3njAvAyJ7eEMeMtLg4Wcfg8rI', fd.VolatileStore());
    //fd.Firestore.initialize('programafono-7be09');
    try {
      fd.FirebaseAuth.instance.signOut();
      deleteValor();
      sucesso(context, 'O usuário deslogado!');
      Navigator.pushReplacementNamed(context, '/login');
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
