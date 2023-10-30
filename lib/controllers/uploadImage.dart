import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

pickedImage() async {
  final picker = ImagePicker();
  final pickedFile = await picker.pickImage(source: ImageSource.gallery);

  return pickedFile;
}

Future<String?> uploadImageUsers(pickedFile, colecao) async {
  if (pickedFile != null) {
    final ref = FirebaseStorage.instance.ref().child('$colecao/${DateTime.now().toString()}');

    final uploadTask = ref.putFile(File(pickedFile.path));
    final snapshot = await uploadTask.whenComplete(() => null);

    final url = await snapshot.ref.getDownloadURL();

    return url;
  }
  return null;
}

Future<void> deletarImagem(String caminho) async {
  var referencia = FirebaseStorage.instance.refFromURL(caminho);

  await referencia.delete();
}

Future<void> apagarImagemUser(String idDoDocumento) async {
  DocumentReference documentoRef = FirebaseFirestore.instance.collection('users').doc(idDoDocumento);
  String urlImage = '';

  await documentoRef.update({'urlImage': urlImage});
}
