import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:fonocare/widgets/mensagem.dart';
import 'package:path/path.dart';

Future<String?> uploadDocToFirebase(File file) async {
  try {
    String fileName = basename(file.path);
    Reference storageReference = FirebaseStorage.instance.ref().child('documents/$fileName');
    UploadTask uploadTask = storageReference.putFile(file);
    final snapshot = await uploadTask.whenComplete(() => null);
    final url = await snapshot.ref.getDownloadURL();
    return url;
  } catch (e) {
    print('Erro durante o upload: $e');
  }
  return null;
}

Future<File?> pickDocument() async {
  try {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['doc', 'docx', 'pdf'],
    );

    if (result != null) {
      File file = File(result.files.single.path!);
      return file;
    }
  } catch (e) {
    print('Erro ao escolher o arquivo: $e');
  }
  return null;
}

String urlToString(url) {
  Uri uri = Uri.parse(url);
  String nomeDocumento = uri.pathSegments.last;
  return nomeDocumento;
}

downloadDoc(context, nomeDoArquivo) async {
  final Reference ref = FirebaseStorage.instance.ref().child(nomeDoArquivo);
  try {
    final File file = File(nomeDoArquivo);
    await ref.writeToFile(file);
    sucesso(context, 'Documento baixado com sucesso!');
  } catch (e) {
    print('Erro ao baixar o documento: $e');
  }
}
