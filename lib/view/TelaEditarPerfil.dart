import 'dart:io';
import 'package:flutter/material.dart';

import 'package:brasil_fields/brasil_fields.dart';
import 'package:provider/provider.dart';

import '../connections/fireCloudUser.dart';
import '../controllers/variaveis.dart';
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
  carregarDados() async {
    var usuario = await listarUsuario();
    setState(() {
      AppVariaveis().idFono = usuario['id']!;
      AppVariaveis().uidAuthFono = usuario['uid']!;
      AppVariaveis().urlImageFono = usuario['urlImage']!;
      AppVariaveis().txtNome.text = usuario['nome']!;
      AppVariaveis().txtEmail.text = usuario['email']!;
      AppVariaveis().txtDtNascimento.text = usuario['dtNascimento']!;
      AppVariaveis().txtCPF.text = usuario['cpf']!;
      AppVariaveis().txtCRFa.text = usuario['crfa']!;
      AppVariaveis().txtTelefone.text = usuario['telefone']!;
    });
  }

  @override
  void initState() {
    super.initState();
    carregarDados();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        iconTheme: IconThemeData(color: cores('corSimbolo')),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            AppVariaveis().resetUser();
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
                borderRadius:
                    BorderRadius.only(bottomRight: Radius.circular(16), bottomLeft: Radius.circular(16))),
            child: Center(
              child: Container(
                width: 80.0,
                height: 80.0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: cores('corBotao'),
                ),
                child: AppVariaveis().urlImageFono.isEmpty
                    ? InkWell(
                        onTap: () async {
                          AppVariaveis().fileImageFono = await pickedImage();
                          setState(() {
                            AppVariaveis().fileImageFono = AppVariaveis().fileImageFono!;
                          });
                        },
                        child: AppVariaveis().fileImageFono == null
                            ? Icon(Icons.person_add_alt_rounded, color: cores('corTextoBotao'), size: 16)
                            : CircleAvatar(
                                maxRadius: 5,
                                minRadius: 1,
                                backgroundImage: FileImage(
                                  File(AppVariaveis().fileImageFono.path),
                                ),
                              ),
                      )
                    : Stack(children: [
                        CircleAvatar(
                          radius: 80,
                          backgroundImage: NetworkImage(AppVariaveis().urlImageFono),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.5),
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: IconButton(
                              icon: Icon(Icons.delete, color: cores('corSimbolo'), size: 16),
                              onPressed: () {
                                setState(() {
                                  AppVariaveis().boolApagarImagem = true;
                                  AppVariaveis().urlImageFono = '';
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
                campoTexto('Nome Completo', AppVariaveis().txtNome, Icons.person),
                const SizedBox(height: 20),
                campoTexto('Email', AppVariaveis().txtEmail, Icons.email),
                const SizedBox(height: 20),
                campoTexto('Telefone', AppVariaveis().txtTelefone, Icons.phone,
                    formato: TelefoneInputFormatter(), boardType: 'numeros'),
                const SizedBox(height: 20),
                Consumer<AppVariaveis>(builder: (context, appVariaveis, child) {
                  return campoTexto('Senha', AppVariaveis().txtSenha, Icons.lock,
                      sufIcon: IconButton(
                        icon: Icon(
                          AppVariaveis().obscureText ? Icons.visibility_off : Icons.visibility,
                          color: cores('corSimbolo'),
                        ),
                        onPressed: () {
                          AppVariaveis().toggleObscureText();
                        },
                      ),
                      senha: AppVariaveis().obscureText);
                }),
                const SizedBox(height: 20),
                Consumer<AppVariaveis>(builder: (context, appVariaveis, child) {
                  return campoTexto(
                    'Confirmar Senha',
                    AppVariaveis().txtSenhaConfirmar,
                    Icons.lock,
                    sufIcon: IconButton(
                      icon: Icon(
                        appVariaveis.obscureText2 ? Icons.visibility_off : Icons.visibility,
                        color: cores('corSimbolo'),
                      ),
                      onPressed: () {
                        AppVariaveis().toggleObscureText2();
                      },
                    ),
                    senha: appVariaveis.obscureText2,
                  );
                }),
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
                      child: Text('Editar', style: TextStyle(fontSize: 16)),
                      onPressed: () async {
                        AppVariaveis().fileImageFono != null
                            ? AppVariaveis().urlImageFono =
                                (await uploadImageUsers(AppVariaveis().fileImageFono, 'users'))!
                            : AppVariaveis().urlImageFono = '';

                        if (AppVariaveis().boolApagarImagem == true) {
                          await deletarImagem(AppVariaveis().urlImageFono);
                          await apagarImagemUser(AppVariaveis().idFono);
                        }

                        verificarDados(
                            context,
                            AppVariaveis().uidAuthFono,
                            AppVariaveis().urlImageFono,
                            AppVariaveis().txtNome.text,
                            AppVariaveis().txtDtNascimento.text,
                            AppVariaveis().txtEmail.text,
                            AppVariaveis().txtCPF.text,
                            AppVariaveis().txtCRFa.text,
                            AppVariaveis().txtTelefone.text,
                            AppVariaveis().txtSenha.text,
                            AppVariaveis().txtSenhaConfirmar.text);
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
                      child: Text('Cancelar', style: TextStyle(fontSize: 16)),
                      onPressed: () {
                        AppVariaveis().resetUser();
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
