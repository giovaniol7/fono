import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../view/TelaInicial.dart';
import 'controllers/coresPrincipais.dart';
import '../widgets/mensagem.dart';
import '../widgets/campoTexto.dart';
import 'package:brasil_fields/brasil_fields.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:firedart/firedart.dart' as fd;

class TelaEditarPerfil extends StatefulWidget {
  const TelaEditarPerfil({Key? key}) : super(key: key);

  @override
  State<TelaEditarPerfil> createState() => _TelaEditarPerfilState();
}

class _TelaEditarPerfilState extends State<TelaEditarPerfil> {
  var windowsId;
  var uid;
  String id = '';
  var urlImage;
  var txtNome = TextEditingController();
  var txtEmail = TextEditingController();
  var txtSenha = TextEditingController();
  var txtDtNascimento = TextEditingController();
  var txtCPF = TextEditingController();
  var txtCRFa = TextEditingController();
  var txtTelefone = TextEditingController();
  var txtSenhaCofirmar = TextEditingController();
  bool _obscureText = true;
  bool _obscureText2 = true;

  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  void _toggle2() {
    setState(() {
      _obscureText2 = !_obscureText2;
    });
  }

  Future<void> buscarId() async {
    if (kIsWeb || Platform.isAndroid || Platform.isIOS) {
      uid = await FirebaseAuth.instance.currentUser!.uid.toString();
      retornarUsuario();
    } else {
      windowsId = await fd.FirebaseAuth.instance.getUser();
      retornarUsuario();
    }
  }

  @override
  void initState() {
    super.initState();
    buscarId();
  }

  retornarUsuario() async {
    if (kIsWeb || Platform.isAndroid || Platform.isIOS) {
      await FirebaseFirestore.instance.collection('users').where('uid', isEqualTo: uid).get().then((us) {
        setState(() {
          id = us.docs[0].id;
          uid = us.docs[0].data()['uid'];
          urlImage = us.docs[0].data()['urlImage'];
          txtNome.text = us.docs[0].data()['nome'];
          txtDtNascimento.text = us.docs[0].data()['dtNascimento'];
          txtEmail.text = us.docs[0].data()['email'];
          txtCPF.text = us.docs[0].data()['cpf'];
          txtCRFa.text = us.docs[0].data()['crfa'];
          txtTelefone.text = us.docs[0].data()['telefone'];
        });
      });
    } else {
      await fd.Firestore.instance.collection('users').where('uid', isEqualTo: windowsId).get().then((us) {
        if (us.isNotEmpty) {
          us.forEach((doc) {
            setState(() {
              id = doc.id;
              uid = doc['uid'];
              urlImage = doc['urlImage'];
              txtNome.text = doc['nome'];
              txtDtNascimento.text = doc['dtNascimento'];
              txtEmail.text = doc['email'];
              txtCPF.text = doc['cpf'];
              txtCRFa.text = doc['crfa'];
              txtTelefone.text = doc['telefone'];
            });
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    void verificarSenhas() {
      final DateFormat formatter = DateFormat('dd/MM/yyyy');
      final DateTime dataNascimento = formatter.parse(txtDtNascimento.text);
      final DateTime agora = DateTime.now();
      final int idade = agora.difference(dataNascimento).inDays ~/ 365;
      if (txtCPF.text.isNotEmpty &&
          txtEmail.text.isNotEmpty &&
          txtNome.text.isNotEmpty &&
          txtDtNascimento.text.isNotEmpty &&
          txtTelefone.text.isNotEmpty) {
        if (idade >= 18) {
          if (txtEmail.text.contains('@')) {
            if (txtSenha.text != txtSenhaCofirmar.text) {
              erro(context, 'Senhas não coincidem.');
            } else {
              if (txtSenha.text.length >= 6 || txtSenha.text.isEmpty) {
                editarConta(
                    uid,
                    txtNome.text,
                    txtDtNascimento.text,
                    txtEmail.text,
                    txtCPF.text,
                    txtCRFa.text,
                    txtTelefone.text,
                    txtSenha.text,
                    urlImage);
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

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        iconTheme: IconThemeData(color: cores('verde')),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          "Editar Perfil",
          style: TextStyle(color: cores('verde')),
        ),
        backgroundColor: cores('rosa_fraco'),
      ),
      body: ListView(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 0.2,
            decoration: BoxDecoration(
                color: cores('rosa_medio'),
                boxShadow: [
                  BoxShadow(offset: Offset(0, 3), color: cores('verde/azul'), blurRadius: 5),
                ],
                borderRadius: BorderRadius.only(bottomRight: Radius.circular(16), bottomLeft: Radius.circular(16))),
            child: Center(
              child: Container(
                width: 80.0,
                height: 80.0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: cores('verde'),
                ),
                child: InkWell(
                  onTap: () async {
                    urlImage = await _uploadImage();
                    setState(() {
                      urlImage = urlImage!;
                    });
                  },
                  child: urlImage == null
                      ? Icon(
                          Icons.person_add_alt_rounded,
                          color: cores('rosa_fraco'),
                          size: 40.0,
                        )
                      : CircleAvatar(
                          maxRadius: 5,
                          minRadius: 1,
                          backgroundImage: NetworkImage(urlImage),
                        ),
                ),
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                const SizedBox(height: 20),
                campoTexto('Nome Completo', txtNome, Icons.person),
                const SizedBox(height: 20),
                campoTexto('Email', txtEmail, Icons.email),
                const SizedBox(height: 20),
                campoTexto('Telefone', txtTelefone, Icons.phone, formato: TelefoneInputFormatter(), numeros: true),
                const SizedBox(height: 20),
                campoTexto('Senha', txtSenha, Icons.lock,
                    sufIcon: IconButton(
                      icon: Icon(
                        _obscureText ? Icons.visibility_off : Icons.visibility,
                        color: cores('verde'),
                      ),
                      onPressed: _toggle,
                    ),
                    senha: _obscureText),
                const SizedBox(height: 20),
                campoTexto('Confirmar Senha', txtSenhaCofirmar, Icons.lock,
                    sufIcon: IconButton(
                      icon: Icon(
                        _obscureText2 ? Icons.visibility_off : Icons.visibility,
                        color: cores('verde'),
                      ),
                      onPressed: _toggle2,
                    ),
                    senha: _obscureText2),
                const SizedBox(height: 40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 150,
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                            primary: cores('rosa_medio'),
                            minimumSize: const Size(200, 45),
                            backgroundColor: cores('verde'),
                            elevation: 5,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(32),
                            )),
                        child: const Text(
                          'Editar',
                          style: TextStyle(fontSize: 16),
                        ),
                        onPressed: () {
                          verificarSenhas();
                        },
                      ),
                    ),
                    Padding(padding: EdgeInsets.all(20)),
                    SizedBox(
                      width: 150,
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                            primary: cores('rosa_medio'),
                            minimumSize: const Size(200, 45),
                            backgroundColor: cores('verde'),
                            elevation: 5,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(32),
                            )),
                        child: const Text(
                          'Cancelar',
                          style: TextStyle(fontSize: 16),
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 60),
              ],
            ),
          )
        ],
      ),
    );
  }

  Future<String?> _uploadImage() async {
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

  Future<void> editarConta(uid, nome, dtNascimento, email, cpf, crfa, telefone, senha, urlImage) async {
      if (txtSenha.text.isNotEmpty) {
        FirebaseAuth.instance.currentUser!.updatePassword(txtSenha.text);
      }
      Map<String, dynamic> data = {
        'uid': uid,
        'nome': nome,
        'dtNascimento': dtNascimento,
        'email': email,
        'cpf': cpf,
        'crfa': crfa,
        'telefone': telefone,
        'urlImage': urlImage,
      };
      await FirebaseFirestore.instance.collection('users').doc(id).update(data);
      sucesso(context, 'O usuário foi editado com sucesso!');
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const TelaInicial(),
        ),
      );
    }
}
