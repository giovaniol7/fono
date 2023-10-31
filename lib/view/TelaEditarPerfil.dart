import 'dart:io';
import 'package:flutter/material.dart';

import 'package:brasil_fields/brasil_fields.dart';

import '../connections/fireCloudUser.dart';
import '../controllers/uploadImage.dart';
import '../controllers/verificarDados.dart';
import '../controllers/estilos.dart';
import '../widgets/campoTexto.dart';

class TelaEditarPerfil extends StatefulWidget {
  const TelaEditarPerfil({Key? key}) : super(key: key);

  @override
  State<TelaEditarPerfil> createState() => _TelaEditarPerfilState();
}

class _TelaEditarPerfilState extends State<TelaEditarPerfil> {
  var uid;
  var id;
  var fileImage;
  var apagarImagem;
  String urlImage = '';
  late var txtNome = TextEditingController();
  late var txtEmail = TextEditingController();
  late var txtSenha = TextEditingController();
  late var txtDtNascimento = TextEditingController();
  late var genero;
  late var txtCPF = TextEditingController();
  late var txtCRFa = TextEditingController();
  late var txtTelefone = TextEditingController();
  late var txtSenhaCofirmar = TextEditingController();
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

  carregarDados() async {
    var usuario = await listarUsuario();
    setState(() {
      id = usuario['id'];
      uid = usuario['uid'];
      urlImage = usuario['urlImage']!;
      txtNome.text = usuario['nome']!;
      txtDtNascimento.text = usuario['dtNascimento']!;
      genero = usuario['genero'];
      txtEmail.text = usuario['email']!;
      txtTelefone.text = usuario['telefone']!;
      txtCPF.text = usuario['cpf']!;
      txtCRFa.text = usuario['crfa']!;
    });
  }

  @override
  void initState() {
    super.initState();
    carregarDados();
  }

  @override
  Widget build(BuildContext context) {
    TamanhoFonte tamanhoFonte = TamanhoFonte();

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        iconTheme: IconThemeData(color: cores('corSimbolo')),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          "Editar Perfil",
          style: TextStyle(color: cores('corTexto')),
        ),
        backgroundColor: cores('corFundo'),
      ),
      body: ListView(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 0.2,
            decoration: BoxDecoration(
                color: cores('corFundo'),
                boxShadow: [
                  BoxShadow(offset: Offset(0, 3), color: cores('corDetalhe'), blurRadius: 5),
                ],
                borderRadius: BorderRadius.only(bottomRight: Radius.circular(16), bottomLeft: Radius.circular(16))),
            child: Center(
              child: Container(
                width: 80.0,
                height: 80.0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: cores('corBotao'),
                ),
                child: urlImage.isEmpty
                    ? InkWell(
                        onTap: () async {
                          fileImage = await pickedImage();
                          setState(() {
                            fileImage = fileImage!;
                          });
                        },
                        child: fileImage == null
                            ? Icon(
                                Icons.person_add_alt_rounded,
                                color: cores('corTextoBotao'),
                                size: tamanhoFonte.iconPequeno(context),
                              )
                            : CircleAvatar(
                                maxRadius: 5,
                                minRadius: 1,
                                backgroundImage: FileImage(
                                  File(fileImage.path),
                                ),
                              ),
                      )
                    : Stack(children: [
                        CircleAvatar(
                          radius: 80,
                          backgroundImage: NetworkImage(urlImage),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.5),
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: IconButton(
                              icon: Icon(
                                Icons.delete,
                                color: cores('corSimbolo'),
                                size: tamanhoFonte.iconPequeno(context),
                              ),
                              onPressed: () {
                                setState(() {
                                  apagarImagem == true;
                                  urlImage = '';
                                });
                              },
                            ),
                          ),
                        ),
                      ]),
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
                        color: cores('corSimbolo'),
                      ),
                      onPressed: _toggle,
                    ),
                    senha: _obscureText),
                const SizedBox(height: 20),
                campoTexto('Confirmar Senha', txtSenhaCofirmar, Icons.lock,
                    sufIcon: IconButton(
                      icon: Icon(
                        _obscureText2 ? Icons.visibility_off : Icons.visibility,
                        color: cores('corSimbolo'),
                      ),
                      onPressed: _toggle2,
                    ),
                    senha: _obscureText2),
                const SizedBox(height: 40),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    OutlinedButton(
                      style: OutlinedButton.styleFrom(
                          foregroundColor: cores('corTextoBotao'),
                          backgroundColor: cores('corBotao'),
                          elevation: 5,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(32),
                          )),
                      child: Text(
                        'Editar',
                        style: TextStyle(fontSize: tamanhoFonte.letraPequena(context)),
                      ),
                      onPressed: () async {
                        fileImage != null ? urlImage = (await uploadImageUsers(fileImage, 'users'))! : urlImage = '';

                        if (apagarImagem == true) {
                          await deletarImagem(urlImage);
                          await apagarImagemUser(id);
                        }

                        verificarDados(context, uid, urlImage, txtNome.text, txtDtNascimento.text, txtEmail.text,
                            txtCPF.text, txtCRFa.text, txtTelefone.text, txtSenha.text, txtSenhaCofirmar.text);
                      },
                    ),
                    SizedBox(width: 10),
                    OutlinedButton(
                      style: OutlinedButton.styleFrom(
                          foregroundColor: cores('corSecundaria'),
                          backgroundColor: cores('corTexto'),
                          elevation: 5,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(32),
                          )),
                      child: Text(
                        'Cancelar',
                        style: TextStyle(fontSize: tamanhoFonte.letraPequena(context)),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
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
}
