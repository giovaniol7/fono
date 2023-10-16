import 'dart:io';
import 'package:flutter/material.dart';

import '../widgets/campoTexto.dart';
import '../widgets/mensagem.dart';
import 'package:fono/view/controllers/coresPrincipais.dart';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firedart/firedart.dart' as fd;

import 'package:brasil_fields/brasil_fields.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

enum Gender { male, female }

class TelaCadastro extends StatefulWidget {
  const TelaCadastro({Key? key}) : super(key: key);

  @override
  State<TelaCadastro> createState() => _TelaCadastroState();
}

class _TelaCadastroState extends State<TelaCadastro> {
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
  Gender? _selectedGeneroFono;

  @override
  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  void _toggle2() {
    setState(() {
      _obscureText2 = !_obscureText2;
    });
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
          txtCRFa.text.isNotEmpty &&
          txtTelefone.text.isNotEmpty &&
          txtSenha.text.isNotEmpty &&
          txtSenhaCofirmar.text.isNotEmpty &&
          _selectedGeneroFono != null) {
        if (idade >= 18) {
          if (txtEmail.text.contains('@')) {
            if (txtSenha.text != txtSenhaCofirmar.text) {
              erro(context, 'Senhas não coincidem.');
            } else {
              if (txtSenha.text.length >= 6) {
                criarConta(_selectedGeneroFono, txtNome.text, txtDtNascimento.text, txtEmail.text, txtCPF.text,
                    txtCRFa.text, txtTelefone.text, txtSenha.text, urlImage);
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
        iconTheme: IconThemeData(color: cores('verde')),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          "Cadastro",
          style: TextStyle(color: cores('verde')),
        ),
        backgroundColor: cores('rosa_fraco'),
      ),
      body: ListView(
        children: [
          Column(
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
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Center(
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
                  ],
                ),
              ),
            ],
          ),
          Center(
            child: Text(
              'Sexo:',
              style: TextStyle(fontSize: 16, color: cores('verde'), fontWeight: FontWeight.bold),
            ),
          ),
          Row(
            children: [
              Expanded(
                child: RadioListTile<Gender>(
                  title: Text(
                    'Masculino',
                    style: TextStyle(color: cores('verde')),
                  ),
                  value: Gender.male,
                  groupValue: _selectedGeneroFono,
                  activeColor: cores('verde'),
                  onChanged: (value) {
                    setState(() {
                      _selectedGeneroFono = value;
                    });
                  },
                ),
              ),
              Expanded(
                child: RadioListTile<Gender>(
                  title: Text(
                    'Feminino',
                    style: TextStyle(color: cores('verde')),
                  ),
                  value: Gender.female,
                  groupValue: _selectedGeneroFono,
                  activeColor: cores('verde'),
                  onChanged: (value) {
                    setState(() {
                      _selectedGeneroFono = value;
                    });
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Container(
            padding: EdgeInsets.all(16),
            child: Center(
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  campoTexto(
                    'Nome Completo',
                    txtNome,
                    Icons.person,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Este campo é obrigatório.';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  campoTexto('Data de Nascimento', txtDtNascimento, Icons.date_range,
                      formato: DataInputFormatter(), numeros: true),
                  const SizedBox(height: 20),
                  campoTexto('Email', txtEmail, Icons.email),
                  const SizedBox(height: 20),
                  campoTexto('CPF', txtCPF, Icons.credit_card, formato: CpfInputFormatter(), numeros: true),
                  const SizedBox(height: 20),
                  campoTexto('CRFa', txtCRFa, Icons.credit_card,
                      formato: MaskTextInputFormatter(
                        mask: '#######-#', // A máscara define 8 dígitos obrigatórios
                        filter: {"#": RegExp(r'[0-9]')}, // Permite apenas dígitos numéricos
                      ),
                      numeros: true),
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
                            'Criar',
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

  //
  // CRIAR CONTA no Firebase Auth
  //
  void criarConta(genero, nome, dtNascimento, email, cpf, crfa, telefone, senha, urlImage) {
    if (kIsWeb || Platform.isAndroid || Platform.isIOS) {
      FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: senha).then((res) {
        FirebaseFirestore.instance.collection('users').add({
          'uid': res.user!.uid.toString(),
          'genero': genero,
          'nome': nome,
          'dtNascimento': dtNascimento,
          'email': email,
          'cpf': cpf,
          'crfa': crfa,
          'telefone': telefone,
          'urlImage': urlImage,
        });
        sucesso(context, 'O usuário foi criado com sucesso!');
        Navigator.pop(context);
      }).catchError((e) {
        switch (e.code) {
          case 'email-already-in-use':
            erro(context, 'O email já foi cadastrado.');
            break;
          case 'invalid-email':
            erro(context, 'O formato do email é inválido.');
            break;
          default:
            erro(context, e.code.toString());
        }
      });
    } else {
      FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: senha).then((res) {
        fd.Firestore.instance.collection('users').add({
          'uid': res.user!.uid.toString(),
          'nome': nome,
          'dtNascimento': dtNascimento,
          'email': email,
          'cpf': cpf,
          'crfa': crfa,
          'telefone': telefone,
          'urlImage': urlImage,
        });
        sucesso(context, 'O usuário foi criado com sucesso!');
        Navigator.pop(context);
      }).catchError((e) {
        switch (e.code) {
          case 'email-already-in-use':
            erro(context, 'O email já foi cadastrado.');
            break;
          case 'invalid-email':
            erro(context, 'O formato do email é inválido.');
            break;
          default:
            erro(context, e.code.toString());
        }
      });
    }
  }
}
