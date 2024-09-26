import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:brasil_fields/brasil_fields.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:provider/provider.dart';

import '../connections/fireAuth.dart';
import '../controllers/variaveis.dart';
import '../controllers/uploadImage.dart';
import '../controllers/estilos.dart';
import '../widgets/campoTexto.dart';
import '../widgets/mensagem.dart';

class TelaCadastro extends StatefulWidget {
  const TelaCadastro({Key? key}) : super(key: key);

  @override
  State<TelaCadastro> createState() => _TelaCadastroState();
}

class _TelaCadastroState extends State<TelaCadastro> {
  bool validarCampos() {
    return (AppVariaveis().keyNome.currentState!.validate() &&
        AppVariaveis().keyDtNascimento.currentState!.validate() &&
        AppVariaveis().keyEmail.currentState!.validate() &&
        AppVariaveis().keyCPF.currentState!.validate() &&
        AppVariaveis().keyCRFa.currentState!.validate() &&
        AppVariaveis().keyTelefone.currentState!.validate() &&
        AppVariaveis().keySenha.currentState!.validate() &&
        AppVariaveis().keySenhaConfirmar.currentState!.validate());
  }

  @override
  Widget build(BuildContext context) {
    void verificarSenhas() async {
      final DateFormat formatter = DateFormat('dd/MM/yyyy');
      final DateTime dataNascimento = formatter.parse(AppVariaveis().txtDtNascimento.text);
      final DateTime agora = DateTime.now();
      final int idade = agora.difference(dataNascimento).inDays ~/ 365;
      if (AppVariaveis().txtCPF.text.isNotEmpty &&
          AppVariaveis().txtEmail.text.isNotEmpty &&
          AppVariaveis().txtNome.text.isNotEmpty &&
          AppVariaveis().txtDtNascimento.text.isNotEmpty &&
          AppVariaveis().txtCRFa.text.isNotEmpty &&
          AppVariaveis().txtTelefone.text.isNotEmpty &&
          AppVariaveis().txtSenha.text.isNotEmpty &&
          AppVariaveis().txtSenhaConfirmar.text.isNotEmpty &&
          AppVariaveis().selectedGeneroFono != null) {
        if (idade >= 18) {
          if (AppVariaveis().txtEmail.text.contains('@')) {
            if (AppVariaveis().txtSenha.text != AppVariaveis().txtSenhaConfirmar.text) {
              erro(context, 'Senhas não coincidem.');
            } else {
              if (AppVariaveis().txtSenha.text.length >= 6) {
                AppVariaveis().urlImageFono.isNotEmpty
                    ? AppVariaveis().urlImageFono =
                        (await uploadImageUsers(AppVariaveis().fileImageFono, 'users'))!
                    : AppVariaveis().urlImageFono = '';
                criarConta(
                    context,
                    AppVariaveis().urlImageFono,
                    AppVariaveis().selectedGeneroFono.toString(),
                    AppVariaveis().txtNome.text,
                    AppVariaveis().txtDtNascimento.text,
                    AppVariaveis().txtEmail.text,
                    AppVariaveis().txtCPF.text,
                    AppVariaveis().txtCRFa.text,
                    AppVariaveis().txtTelefone.text,
                    AppVariaveis().txtSenha.text);
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
        iconTheme: IconThemeData(color: cores('corTexto')),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            AppVariaveis().resetUser();
            Navigator.pop(context);
          },
        ),
        title: Text(
          "Cadastro",
          style: TextStyle(color: cores('corTexto')),
        ),
        backgroundColor: cores('corFundo'),
      ),
      body: ListView(
        children: [
          Column(
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.2,
                decoration: BoxDecoration(
                    color: cores('corFundo'),
                    boxShadow: [
                      BoxShadow(offset: Offset(0, 3), color: cores('corSombra'), blurRadius: 5),
                    ],
                    borderRadius:
                        BorderRadius.only(bottomRight: Radius.circular(16), bottomLeft: Radius.circular(16))),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Center(
                      child: Container(
                        width: 80.0,
                        height: 80.0,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: cores('corBotao'),
                        ),
                        child: InkWell(
                          onTap: () async {
                            AppVariaveis().fileImageFono = await pickedImage();
                            setState(() {
                              AppVariaveis().fileImageFono = AppVariaveis().fileImageFono!;
                            });
                          },
                          child: AppVariaveis().fileImageFono == null
                              ? Icon(Icons.person_add_alt_rounded, color: cores('corTextoBotao'), size: 40.0)
                              : CircleAvatar(
                                  maxRadius: 5,
                                  minRadius: 1,
                                  backgroundImage: FileImage(File(AppVariaveis().fileImageFono)),
                                ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Container(
            padding: EdgeInsets.all(10),
            child: Center(
              child: Column(
                children: [
                  Center(
                    child: Text(
                      'Sexo:',
                      style: TextStyle(fontSize: 16, color: cores('corTexto'), fontWeight: FontWeight.bold),
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: RadioListTile<Gender>(
                          title: Text(
                            'Masculino',
                            style: TextStyle(color: cores('corTexto')),
                          ),
                          value: Gender.male,
                          groupValue: AppVariaveis().selectedGeneroFono,
                          activeColor: cores('corTexto'),
                          onChanged: (value) {
                            setState(() {
                              AppVariaveis().selectedGeneroFono = value;
                            });
                          },
                        ),
                      ),
                      Expanded(
                        child: RadioListTile<Gender>(
                          title: Text(
                            'Feminino',
                            style: TextStyle(color: cores('corTexto')),
                          ),
                          value: Gender.female,
                          groupValue: AppVariaveis().selectedGeneroFono,
                          activeColor: cores('corTexto'),
                          onChanged: (value) {
                            setState(() {
                              AppVariaveis().selectedGeneroFono = value;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  campoTexto('Nome Completo', AppVariaveis().txtNome, Icons.person,
                      key: AppVariaveis().keyNome, validator: true),
                  const SizedBox(height: 20),
                  campoTexto('Data de Nascimento', AppVariaveis().txtDtNascimento, Icons.date_range,
                      formato: DataInputFormatter(),
                      boardType: 'numeros',
                      key: AppVariaveis().keyDtNascimento,
                      validator: true),
                  const SizedBox(height: 20),
                  campoTexto('Email', AppVariaveis().txtEmail, Icons.email,
                      key: AppVariaveis().keyEmail, validator: true),
                  const SizedBox(height: 20),
                  campoTexto('CPF', AppVariaveis().txtCPF, Icons.credit_card,
                      formato: CpfInputFormatter(),
                      boardType: 'numeros',
                      key: AppVariaveis().keyCPF,
                      validator: true),
                  const SizedBox(height: 20),
                  campoTexto('CRFa', AppVariaveis().txtCRFa, Icons.credit_card,
                      formato: MaskTextInputFormatter(
                        mask: '#-#####',
                        filter: {"#": RegExp(r'[0-9]')},
                      ),
                      boardType: 'numeros',
                      key: AppVariaveis().keyCRFa,
                      validator: true),
                  const SizedBox(height: 20),
                  campoTexto('Telefone', AppVariaveis().txtTelefone, Icons.phone,
                      formato: TelefoneInputFormatter(),
                      boardType: 'numeros',
                      key: AppVariaveis().keyTelefone,
                      validator: true),
                  const SizedBox(height: 20),
                  Consumer<AppVariaveis>(builder: (context, appVariaveis, child) {
                    return campoTexto(
                      'Senha',
                      AppVariaveis().txtSenha,
                      Icons.lock,
                      key: AppVariaveis().keySenha,
                      validator: true,
                      sufIcon: IconButton(
                        icon: Icon(
                          AppVariaveis().obscureText ? Icons.visibility_off : Icons.visibility,
                          color: cores('corTexto'),
                        ),
                        onPressed: () {
                          AppVariaveis().toggleObscureText();
                        },
                      ),
                      senha: AppVariaveis().obscureText,
                    );
                  }),
                  const SizedBox(height: 20),
                  Consumer<AppVariaveis>(builder: (context, appVariaveis, child) {
                    return campoTexto('Confirmar Senha', AppVariaveis().txtSenhaConfirmar, Icons.lock,
                        key: AppVariaveis().keySenhaConfirmar,
                        validator: true,
                        sufIcon: IconButton(
                          icon: Icon(
                            AppVariaveis().obscureText2 ? Icons.visibility_off : Icons.visibility,
                            color: cores('corTexto'),
                          ),
                          onPressed: () {
                            AppVariaveis().toggleObscureText2();
                          },
                        ),
                        senha: AppVariaveis().obscureText2);
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
                        child: Text('Criar', style: TextStyle(fontSize: 16)),
                        onPressed: () {
                          if (validarCampos()) {
                            verificarSenhas();
                          }
                        },
                      ),
                      SizedBox(width: 10),
                      OutlinedButton(
                        style: OutlinedButton.styleFrom(
                            foregroundColor: cores('corTextoBotao'),
                            backgroundColor: cores('corBotao'),
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
            ),
          )
        ],
      ),
    );
  }
}
