import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

Future<String?> uploadImage() async {
  final picker = ImagePicker();
  final pickedFile = await picker.pickImage(source: ImageSource.gallery);

  if (pickedFile != null) {
    // Crie uma referência única para a imagem no Firebase Storage
    final ref = FirebaseStorage.instance.ref().child('users/${DateTime.now().toString()}');

    // Faça o upload da imagem para o Firebase Storage
    final uploadTask = ref.putFile(File(pickedFile.path));
    final snapshot = await uploadTask.whenComplete(() => null);

    // Recupere a URL da imagem no Firebase Storage
    final url = await snapshot.ref.getDownloadURL();

    return url;
  }
}