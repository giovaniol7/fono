import 'package:cloud_firestore/cloud_firestore.dart';

import '../connections/fireAuth.dart';

String nomeColecao = 'escolas';

recuperarTodosEscolas() async {
  return await FirebaseFirestore.instance.collection(nomeColecao).where('uidFono', isEqualTo: idFonoAuth());
}

Future<String> buscarIdEscola(context, nome) async {
  String id = '';

  await FirebaseFirestore.instance
      .collection(nomeColecao)
      .where('nomeEscola', isEqualTo: nome)
      .get()
      .then((q) {
    if (q.docs.isNotEmpty) {
      id = q.docs[0].data()['uidEscola'];
    }
  });

  return id;
}

Future<List<String>> fazerListaEscolas() async {
  List<String> list = [];

  QuerySnapshot querySnapshot =
      await FirebaseFirestore.instance.collection(nomeColecao).where('uidFono', isEqualTo: idFonoAuth()).get();
  querySnapshot.docs.forEach((doc) {
    String nome = doc['nomeEscola'];
    list.add(nome);
  });

  return list;
}

Future<List<String>> fazerListaUIDEscolas() async {
  List<String> list = [];

  QuerySnapshot querySnapshot =
      await FirebaseFirestore.instance.collection(nomeColecao).where('uidFono', isEqualTo: idFonoAuth()).get();
  querySnapshot.docs.forEach((doc) {
    String id = doc.id;
    list.add(id);
  });

  return list;
}

adicionarEscola(context, uidFono, nomeEscola) async {
  try {
    CollectionReference escolas = FirebaseFirestore.instance.collection(nomeColecao);
    DocumentReference novoDocumento;
    String uidEscola = '';
    Map<String, dynamic> data = {
      'uidFono': uidFono,
      'nomeEscola': nomeEscola,
    };

    novoDocumento = await escolas.add(data);
    await FirebaseFirestore.instance
        .collection(nomeColecao)
        .where('nomeEscola', isEqualTo: nomeEscola)
        .get()
        .then((us) {
      uidEscola = us.docs[0].id;
    });
    await novoDocumento.update({'uidEscola': uidEscola});
    print('O escola foi adicionado com sucesso.');
  } catch (e) {
    print('Erro ao adicionar escola.');
  }
}

editarEscola(context, uidFono, uidEscola, nomeEscola) async {
  try {
    Map<String, dynamic> data = {
      'nomeEscola': nomeEscola,
      'uidFono': uidFono,
    };
    await FirebaseFirestore.instance.collection(nomeColecao).doc(uidEscola).update(data);
    print('O escola foi editada com sucesso.');
  } catch (e) {
    print('Erro ao editar escola.');
  }
}

apagarEscola(context, uidEscola) async {
  try {
    await FirebaseFirestore.instance.collection(nomeColecao).doc(uidEscola).delete();
    print('O escola foi apagada com sucesso.');
  } catch (e) {
    print('Erro ao remover a escola.');
  }
}

recuperarEscola(context, uid) async {
  String uidEscola = '';
  String nomeEscola = '';
  String uidFono = '';

  Map<String, dynamic> escola = {};

  await FirebaseFirestore.instance.collection(nomeColecao).where('uidEscola', isEqualTo: uid).get().then((q) {
    if (q.docs.isNotEmpty) {
      uidEscola = q.docs[0].id;
      nomeEscola = q.docs[0].data()['nomeEscola'];
      uidFono = q.docs[0].data()['uidFono'];
    }
  });

  escola = {'uidEscola': uidEscola, 'nomeEscola': nomeEscola, 'uidFono': uidFono};

  return escola;
}

recuperarEscolaPorNome(context, nome) async {
  String uidEscola = '';
  String nomeEscola = '';
  String uidFono = '';

  Map<String, dynamic> escola = {};

  await FirebaseFirestore.instance
      .collection(nomeColecao)
      .where('nomeEscola', isEqualTo: nome)
      .get()
      .then((q) {
    if (q.docs.isNotEmpty) {
      uidEscola = q.docs[0].id;
      nomeEscola = q.docs[0].data()['nomeEscola'];
      uidFono = q.docs[0].data()['uidFono'];
    }
  });

  escola = {'uidEscola': uidEscola, 'nomeEscola': nomeEscola, 'uidFono': uidFono};

  return escola;
}

confirmarEscola(context, nome) async {
  try {
    QuerySnapshot query =
        await FirebaseFirestore.instance.collection(nomeColecao).where('nomeEscola', isEqualTo: nome).get();
    return query.docs.isNotEmpty;
  } catch (e) {
    print('Erro ao verificar existência da escola: $e');
    return false;
  }
}
