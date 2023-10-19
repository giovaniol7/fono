import 'package:intl/intl.dart';

import '../connections/fireCloudUser.dart';
import '../widgets/mensagem.dart';

void verificarDados(context, uid, nome, dtNascimento, email, cpf, crfa, telefone, senha, senhaconfirmar, urlImage) {
  final DateFormat formatter = DateFormat('dd/MM/yyyy');
  final DateTime dataNascimento = formatter.parse(dtNascimento.text);
  final DateTime agora = DateTime.now();
  final int idade = agora.difference(dataNascimento).inDays ~/ 365;
  if (cpf.text.isNotEmpty &&
      email.text.isNotEmpty &&
      nome.text.isNotEmpty &&
      dtNascimento.text.isNotEmpty &&
      telefone.text.isNotEmpty) {
    if (idade >= 18) {
      if (email.text.contains('@')) {
        if (senha.text != senhaconfirmar.text) {
          erro(context, 'Senhas não coincidem.');
        } else {
          if (senha.text.length >= 6 || senha.text.isEmpty) {
            editarUsuario(context, uid, nome, dtNascimento, email, cpf, crfa, telefone, senha, urlImage);
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
