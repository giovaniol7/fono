import 'dart:io';
import 'package:flutter/foundation.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firedart/firedart.dart' as fd;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../widgets/mensagem.dart';
import 'fireAuth.dart';

String nomeColecaoUsuario = 'consulta';

retornarIDContas() async {
  if (kIsWeb || Platform.isAndroid || Platform.isIOS) {
    await listarContas().get().then((us) {
      return us.docs[0].id;
    });
  } else {
    await listarContas().get().then((us) {
      if (us.isNotEmpty) {
        us.forEach((doc) {
          return doc.id;
        });
      }
    });
  }
}

listarContas() async {
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

editarContas(context, id, uidFono, uidPaciente, nomePaciente, dataConsulta, horarioConsulta, duracaoConsulta,
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
  await FirebaseFirestore.instance.collection('consulta').doc(retornarIDContas()).update(data);
  sucesso(context, 'O horário foi alterado com sucesso.');
  Navigator.pop(context);
}

adicionarContas(context, listUid, listNome, uidFono, selecioneTipoTransacao, estadoTipo, nomeConta, preco,
    selecioneFormaPagamento, selecioneQntdParcelas, dataCompra, horaCompra, descricaoConta, estadoPago, estadoRecebido) async {
  if (kIsWeb || Platform.isAndroid || Platform.isIOS) {
    CollectionReference contas = FirebaseFirestore.instance.collection('contas');
    NumberFormat numberFormat = NumberFormat('#,##0.00', 'pt_BR');
    DateTime proximoMes;
    String dataFormatada = '';
    String dataHora = '';
    int qntdParcelas = int.parse(selecioneQntdParcelas.split('x')[0]);
    final dataAtual = DateTime.now();

    if (qntdParcelas != 1) {
      preco = preco.replaceAll('.', '');
      preco = preco.replaceAll(',', '.');
      double precoCompra = double.parse(preco);
      precoCompra = precoCompra / qntdParcelas;
      preco = numberFormat.format(precoCompra);
    }

    for (int parcela = 0; parcela < qntdParcelas; parcela++) {
      String uidConta = '';
      if (qntdParcelas == 1) {
        dataFormatada = dataCompra;
        dataHora = '$dataCompra $horaCompra';
      } else {
        proximoMes = DateTime(dataAtual.year, dataAtual.month + parcela, dataAtual.day);
        dataFormatada = DateFormat('dd/MM/yyyy').format(proximoMes);
        dataHora = '$dataFormatada $horaCompra';
      }
      Map<String, dynamic> data = {
        'uidFono': uidFono,
        'tipoTransacao': selecioneTipoTransacao,
        'tipo': estadoTipo,
        'nomeConta': nomeConta,
        'preco': preco,
        'formaPagamento': selecioneFormaPagamento,
        'qntdParcelas': selecioneQntdParcelas,
        'data': dataFormatada,
        'hora': horaCompra,
        'dataHora': dataHora,
        'descricaoConta': descricaoConta,
      };
      if (selecioneTipoTransacao == 'Gasto') {
        data['estadoPago'] = estadoPago;
      }
      if (selecioneTipoTransacao == 'Recebido') {
        data['estadoRecebido'] = estadoRecebido;
      }
      DocumentReference docRef = await contas.add(data);
      await FirebaseFirestore.instance
          .collection('contas')
          .where('nomeConta', isEqualTo: nomeConta)
          .where('data', isEqualTo: dataFormatada)
          .get()
          .then((us) {
        uidConta = us.docs[0].id;
      });

      if (estadoRecebido == 'Pacientes') {
        int indice = listNome.indexOf(nomeConta);

        if (indice != -1 && indice < listUid.length) {
          String uidCorrespondente = listUid[indice];
          await docRef.update({'uidPaciente': uidCorrespondente});
        }
      }

      await docRef.update({'uidConta': uidConta});
    }

    sucesso(context, 'Conta adicionada com sucesso.');
    Navigator.pop(context);
  } else {
    await fd.FirebaseAuth.initialize('AIzaSyAlG2glNY3njAvAyJ7eEMeMtLg4Wcfg8rI', fd.VolatileStore());
    fd.Firestore.initialize('programafono-7be09');
    var auth = fd.FirebaseAuth.instance;
    final emailSave = await SharedPreferences.getInstance();
    var email = emailSave.getString('email');
    final senhaSave = await SharedPreferences.getInstance();
    var senha = senhaSave.getString('senha');
    await auth.signIn(email!, senha!);
    var user = await auth.getUser();
    uidFono = user.id;

    fd.CollectionReference contas = fd.Firestore.instance.collection('contas');
    NumberFormat numberFormat = NumberFormat('#,##0.00', 'pt_BR');
    DateTime proximoMes;
    String dataFormatada = '';
    String dataHora = '';
    int qntdParcelas = int.parse(selecioneQntdParcelas.split('x')[0]);
    final dataAtual = DateTime.now();

    if (qntdParcelas != 1) {
      preco = preco.replaceAll('.', '');
      preco = preco.replaceAll(',', '.');
      double precoCompra = double.parse(preco);
      precoCompra = precoCompra / qntdParcelas;
      preco = numberFormat.format(precoCompra);
    }

    for (int parcela = 0; parcela < qntdParcelas; parcela++) {
      String uidConta = '';
      if (qntdParcelas == 1) {
        dataFormatada = dataCompra;
        dataHora = '$dataCompra $horaCompra';
      } else {
        proximoMes = DateTime(dataAtual.year, dataAtual.month + parcela, dataAtual.day);
        dataFormatada = DateFormat('dd/MM/yyyy').format(proximoMes);
        dataHora = '$dataFormatada $horaCompra';
      }
      Map<String, dynamic> data = {
        'uidFono': uidFono,
        'tipoTransacao': selecioneTipoTransacao,
        'tipo': estadoTipo,
        'nomeConta': nomeConta,
        'preco': preco,
        'formaPagamento': selecioneFormaPagamento,
        'qntdParcelas': selecioneQntdParcelas,
        'data': dataFormatada,
        'hora': horaCompra,
        'dataHora': dataHora,
        'descricaoConta': descricaoConta,
      };
      if (selecioneTipoTransacao == 'Gasto') {
        data['estadoPago'] = estadoPago;
      }
      if (selecioneTipoTransacao == 'Recebido') {
        data['estadoRecebido'] = estadoRecebido;
      }
      fd.Document doc = await contas.add(data);
      fd.DocumentReference docRef = doc.reference;
      await fd.Firestore.instance
          .collection('contas')
          .where('nomeConta', isEqualTo: nomeConta)
          .where('data', isEqualTo: dataFormatada)
          .get()
          .then((us) {
        if (us.isNotEmpty) {
          us.forEach((doc) {
            uidConta = doc['uidConta'];
          });
        }
      });

      if (estadoRecebido == 'Pacientes') {
        int indice = listNome.indexOf(nomeConta);

        if (indice != -1 && indice < listUid.length) {
          String uidCorrespondente = listUid[indice];
          await docRef.update({'uidPaciente': uidCorrespondente});
        }
      }

      await docRef.update({'uidConta': uidConta});
    }

    sucesso(context, 'Conta adicionada com sucesso.');
    Navigator.pop(context);
  }
}
