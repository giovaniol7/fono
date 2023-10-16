import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

String nomeColecaoUsuario = 'users';

fireAddUsuario(res, genero, nome, dtNascimento, email, cpf, crfa, telefone, senha, urlImage) {
  FirebaseFirestore.instance.collection(nomeColecaoUsuario).add({
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