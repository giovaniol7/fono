import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fono/connections/fireAuth.dart';

String nomeColecao = 'pacientes';

recuperarPacientes() async {
  return await FirebaseFirestore.instance.collection(nomeColecao).where('uidFono', isEqualTo: idUsuario());
}

Future<List<String>> fazerListaPacientes() async {
  List<String> list = [];

  QuerySnapshot querySnapshot =
      await FirebaseFirestore.instance.collection(nomeColecao).where('uidFono', isEqualTo: idUsuario()).get();
  querySnapshot.docs.forEach((doc) {
    String nome = doc['nomePaciente'];
    list.add(nome);
  });


  /*else {
      //await fd.FirebaseAuth.initialize('AIzaSyAlG2glNY3njAvAyJ7eEMeMtLg4Wcfg8rI', fd.VolatileStore());
      //await fd.Firestore.initialize('programafono-7be09');
      var auth = fd.FirebaseAuth.instance;
      final emailSave = await SharedPreferences.getInstance();
      var email = emailSave.getString('email');
      final senhaSave = await SharedPreferences.getInstance();
      var senha = senhaSave.getString('senha');
      await auth.signIn(email!, senha!);
      var user = await auth.getUser();
      windowsIdFono = user.id;

      List<fd.Document> querySnapshot = await fd.Firestore.instance
          .collection('pacientes')
          .where('uidFono', isEqualTo: uidFono)
          .orderBy('nomePaciente')
          .get();
      querySnapshot.forEach((doc) {
        String nome = doc['nomePaciente'];
        _list.add(nome);
      });

      pacientes = await fd.Firestore.instance.collection('pacientes').where('uidFono', isEqualTo: uidFono);

      pacientesOrdem = await pacientes.orderBy('nomePaciente');

      pacientesOrdem = await pacientesOrdem.get();

      print(pacientes);
      print(pacientesOrdem);
    }*/
  return list;
}
