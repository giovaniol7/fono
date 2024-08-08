import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../connections/fireAuth.dart';
import '../controllers/variaveis.dart';
import '../widgets/mensagem.dart';

String nomeColecao = 'blocoNotas';

recuperarBlocosNotas() {
  return FirebaseFirestore.instance.collection(nomeColecao).where('uidFono', isEqualTo: idFonoAuth());
}

adicionarBlocoNota(context, uidFono, nomeBloco, dataBloco, nomeResponsavel, telefoneBloco) async {
  if (nomeBloco != null && dataBloco != null && nomeResponsavel != null && telefoneBloco != null) {
    try {
      CollectionReference blocoNot = FirebaseFirestore.instance.collection(nomeColecao);
      DocumentReference novoDocumento;
      String uidBloco = '';
      Map<String, dynamic> data = {
        'uidFono': uidFono,
        'nomeBloco': nomeBloco,
        'dataBloco': dataBloco,
        'nomeResponsavel': nomeResponsavel,
        'telefoneBloco': telefoneBloco,
      };
      novoDocumento = await blocoNot.add(data);
      await FirebaseFirestore.instance
          .collection(nomeColecao)
          .where('nomeBloco', isEqualTo: nomeBloco)
          .get()
          .then((us) {
        uidBloco = us.docs[0].id;
      });
      await novoDocumento.update({'uidBloco': uidBloco});

      sucesso(context, 'Notas foi adicionado com sucesso.');
      AppVariaveis().reset();
      Navigator.pop(context);
    } catch (e) {
      erro(context, 'Erro ao adicionar anotação.');
    }
  } else {
    erro(context, 'Preencha os campos obrigatórios.');
  }
}

editarBlocoNota(context, uidBloco, uidFono, nomeBloco, dataBloco, nomeResponsavel, telefoneBloco) async {
  if (nomeBloco != null && dataBloco != null && nomeResponsavel != null && telefoneBloco != null) {
    try {
      Map<String, dynamic> data = {
        'uidBloco': uidBloco,
        'uidFono': uidFono,
        'nomeBloco': nomeBloco,
        'dataBloco': dataBloco,
        'nomeResponsavel': nomeResponsavel,
        'telefoneBloco': telefoneBloco,
      };

      await FirebaseFirestore.instance.collection(nomeColecao).doc(uidBloco).update(data);
      sucesso(context, 'Notas foi atualizado com sucesso.');
      AppVariaveis().reset();
      Navigator.pop(context);
    } catch (e) {
      erro(context, 'Erro ao editar anotação.');
    }
  } else {
    erro(context, 'Preencha os campos obrigatórios.');
  }
}

apagarBlocoNota(context, id) async {
  try {
    await FirebaseFirestore.instance.collection(nomeColecao).doc(id).delete();
    sucesso(context, 'Notas apagado com sucesso!');
    AppVariaveis().reset();
    Navigator.pop(context);
  } catch (e) {
    erro(context, 'Erro ao remover a anotação.');
  }
}

recuperarNota(context, uid) async {
  String uidBloco = '';
  String uidFono = '';
  String nomeBloco = '';
  String dataBloco = '';
  String nomeResponsavel = '';
  String telefoneBloco = '';

  Map<String, dynamic> notas = {};

  await FirebaseFirestore.instance.collection(nomeColecao).where('uidBloco', isEqualTo: uid).get().then((q) {
    if (q.docs.isNotEmpty) {
      uidBloco = q.docs[0].id;
      uidFono = q.docs[0].data()['uidFono'];
      nomeBloco = q.docs[0].data()['nomeBloco'];
      dataBloco = q.docs[0].data()['dataBloco'];
      nomeResponsavel = q.docs[0].data()['nomeResponsavel'];
      telefoneBloco = q.docs[0].data()['telefoneBloco'];
    }
  });

  notas = {
    'uidBloco': uidBloco,
    'uidFono': uidFono,
    'nomeBloco': nomeBloco,
    'dataBloco': dataBloco,
    'nomeResponsavel': nomeResponsavel,
    'telefoneBloco': telefoneBloco,
  };

  return notas;
}
