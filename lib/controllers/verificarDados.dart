import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../connections/fireCloudUser.dart';
import '../view/TelaInicial.dart';
import '../widgets/mensagem.dart';

void verificarDados(context, uid, urlImage, nome, dtNascimento, email, cpf, crfa, telefone, senha, senhaconfirmar) {
  final DateFormat formatter = DateFormat('dd/MM/yyyy');
  final DateTime dataNascimento = formatter.parse(dtNascimento);
  final DateTime agora = DateTime.now();
  final int idade = agora.difference(dataNascimento).inDays ~/ 365;
  if (cpf.isNotEmpty &&
      email.isNotEmpty &&
      nome.isNotEmpty &&
      dtNascimento.isNotEmpty &&
      telefone.isNotEmpty) {
    if (idade >= 18) {
      if (email.contains('@')) {
        if (senha != senhaconfirmar) {
          erro(context, 'Senhas não coincidem.');
        } else {
          if (senha.length >= 6 || senha.isEmpty) {
            editarUsuario(context, uid, urlImage, nome, dtNascimento, email, cpf, crfa, telefone, senha);
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const TelaInicial(),
              ),
            );
          } else {
            erro(context, 'Senha deve possuir mais de 6 caracteres.');
          }
        }
      } else {
        erro(context, 'Formato de e-mail inválido.');
      }
    } else {
      erro(context, 'É preciso ter mais que 18 anos.');
    }
  } else {
    erro(context, 'Preencha Corretamento todos os campos.');
  }
}
