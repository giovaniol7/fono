import 'dart:io';
import 'package:flutter/foundation.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../widgets/mensagem.dart';
import 'fireAuth.dart';

String nomeColecao = 'contas';

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
  return FirebaseFirestore.instance.collection(nomeColecao).where('uidFono', isEqualTo: idUsuario());
}

/*editarContas(context, id, uidFono, uidPaciente, nomePaciente, dataConsulta, horarioConsulta, duracaoConsulta,
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
}*/

adicionarContas(
    context,
    listUid,
    listNome,
    uidFono,
    selecioneTipoTransacao,
    selecioneEstadoRecebido,
    selecioneEstadoPago,
    selecioneEstadoTipo,
    nomeConta,
    preco,
    selecioneFormaPagamento,
    selecioneQntdParcelas,
    dataCompra,
    horaCompra,
    descricaoConta) async {
  if (selecioneTipoTransacao != null &&
      selecioneEstadoTipo != null &&
      nomeConta != null &&
      preco != null &&
      selecioneFormaPagamento != null &&
      selecioneQntdParcelas != null &&
      dataCompra != null &&
      horaCompra != null) {
    try {
      if (selecioneEstadoRecebido == 'Pacientes') {
        adicionarContasSemanais(
            context,
            listUid,
            listNome,
            uidFono,
            selecioneTipoTransacao,
            selecioneEstadoRecebido,
            selecioneEstadoPago,
            selecioneEstadoTipo,
            nomeConta,
            preco,
            selecioneFormaPagamento,
            selecioneQntdParcelas,
            dataCompra,
            horaCompra,
            descricaoConta);
      } else {
        CollectionReference contas = FirebaseFirestore.instance.collection(nomeColecao);
        NumberFormat numberFormat = NumberFormat('#,##0.00', 'pt_BR');
        DateTime proximoMes;
        String dataFormatada = '';
        String dataHora = '';
        int qntdParcelas = int.parse(selecioneQntdParcelas.split('x')[0]);
        final dataAtual = DateTime.now();

        DocumentReference novoDocumento = contas.doc();

        if (qntdParcelas != 1) {
          preco = preco.replaceAll('.', '');
          preco = preco.replaceAll(',', '.');
          double precoCompra = double.parse(preco);
          precoCompra = precoCompra / qntdParcelas;
          preco = numberFormat.format(precoCompra);
        }

        for (int parcela = 0; parcela < qntdParcelas; parcela++) {
          if (qntdParcelas == 1) {
            dataFormatada = dataCompra;
            dataHora = '$dataCompra $horaCompra';
          } else {
            proximoMes = DateTime(dataAtual.year, dataAtual.month + parcela, dataAtual.day);
            dataFormatada = DateFormat('dd/MM/yyyy').format(proximoMes);
            dataHora = '$dataFormatada $horaCompra';
          }
          Map<String, dynamic> data = {
            'uidConta': novoDocumento.id,
            'uidFono': uidFono,
            'tipoTransacao': selecioneTipoTransacao,
            'tipo': selecioneEstadoTipo,
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
            data['estadoPago'] = selecioneEstadoPago;
          }
          if (selecioneTipoTransacao == 'Recebido') {
            data['estadoRecebido'] = selecioneEstadoRecebido;
          }

          await novoDocumento.set(data);
        }
      }
      sucesso(context, 'Conta adicionada com sucesso.');
      Navigator.pop(context);
    } catch (e) {
      erro(context, 'Erro ao adicionar contas.');
    }
  } else {
    erro(context, 'Preencha os campos obrigatórios.');
  }
}

adicionarContasSemanais(
    context,
    listUid,
    listNome,
    uidFono,
    selecioneTipoTransacao,
    selecioneEstadoRecebido,
    selecioneEstadoPago,
    selecioneEstadoTipo,
    nomeConta,
    preco,
    selecioneFormaPagamento,
    selecioneQntdParcelas,
    dataCompra,
    horaCompra,
    descricaoConta) async {
  CollectionReference contas = FirebaseFirestore.instance.collection(nomeColecao);
  String dataFormatada = '';
  String dataHora = '';
  DateTime dataAtual = DateTime.now();

  for (int i = 0; i < 52; i++) {
    DateTime dataConta = dataAtual.add(Duration(days: i * 7));
    dataFormatada = DateFormat('dd/MM/yyyy').format(dataConta);

    DocumentReference novoDocumento = contas.doc();

    Map<String, dynamic> data = {
      'uidConta': novoDocumento.id,
      'uidFono': uidFono,
      'tipoTransacao': selecioneTipoTransacao,
      'tipo': selecioneEstadoTipo,
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
      data['estadoPago'] = selecioneEstadoPago;
    }
    if (selecioneTipoTransacao == 'Recebido') {
      data['estadoRecebido'] = selecioneEstadoRecebido;
    }

    await novoDocumento.set(data);

    if (selecioneEstadoRecebido == 'Pacientes') {
      int indice = listNome.indexOf(nomeConta);

      if (indice != -1 && indice < listUid.length) {
        String uidCorrespondente = listUid[indice];
        await novoDocumento.update({'uidPaciente': uidCorrespondente});
      }
    }
  }
}

Stream<QuerySnapshot<Object?>> recuperarCredito() {
  return FirebaseFirestore.instance
      .collection('contas')
      .where('uidFono', isEqualTo: idUsuario())
      .where('tipoTransacao', isEqualTo: 'Gasto')
      .orderBy('dataHora', descending: true)
      .snapshots();
}

Stream<QuerySnapshot<Object?>> recuperarDebito() {
  return FirebaseFirestore.instance
      .collection('contas')
      .where('uidFono', isEqualTo: idUsuario())
      .where('tipoTransacao', isEqualTo: 'Recebido')
      .orderBy('dataHora', descending: true)
      .snapshots();
}

Stream<QuerySnapshot<Object?>> recuperarGeral() {
  return FirebaseFirestore.instance.collection(nomeColecao).where('uidFono', isEqualTo: idUsuario()).snapshots();
}
