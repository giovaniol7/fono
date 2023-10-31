import 'dart:io';

import 'package:flutter/material.dart';

import 'package:intl/intl.dart';
import 'package:brasil_fields/brasil_fields.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

import '../connections/fireAuth.dart';
import '../controllers/uploadImage.dart';
import '../widgets/campoTexto.dart';
import '../widgets/mensagem.dart';
import '../controllers/estilos.dart';

enum Gender { male, female }

class TelaCadastro extends StatefulWidget {
  const TelaCadastro({Key? key}) : super(key: key);

  @override
  State<TelaCadastro> createState() => _TelaCadastroState();
}

class _TelaCadastroState extends State<TelaCadastro> {
  var urlImage;
  var fileImage;
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

  @override
  Widget build(BuildContext context) {
    TamanhoFonte tamanhoFonte = TamanhoFonte();

    void verificarSenhas() async {
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
                urlImage!.isEmpty ? urlImage = await uploadImageUsers(fileImage, 'users') : urlImage = '';
                criarConta(context, urlImage, _selectedGeneroFono, txtNome.text, txtDtNascimento.text, txtEmail.text,
                    txtCPF.text, txtCRFa.text, txtTelefone.text, txtSenha.text);
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
                          color: cores('corBotao'),
                        ),
                        child: InkWell(
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
                                  size: 40.0,
                                )
                              : CircleAvatar(
                                  maxRadius: 5,
                                  minRadius: 1,
                                  backgroundImage: FileImage(
                                    File(fileImage),
                                  ),
                                ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
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
                          groupValue: _selectedGeneroFono,
                          activeColor: cores('corTexto'),
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
                            style: TextStyle(color: cores('corTexto')),
                          ),
                          value: Gender.female,
                          groupValue: _selectedGeneroFono,
                          activeColor: cores('corTexto'),
                          onChanged: (value) {
                            setState(() {
                              _selectedGeneroFono = value;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
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
                          color: cores('corTexto'),
                        ),
                        onPressed: _toggle,
                      ),
                      senha: _obscureText),
                  const SizedBox(height: 20),
                  campoTexto('Confirmar Senha', txtSenhaCofirmar, Icons.lock,
                      sufIcon: IconButton(
                        icon: Icon(
                          _obscureText2 ? Icons.visibility_off : Icons.visibility,
                          color: cores('corTexto'),
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
                            'Criar',
                            style: TextStyle(fontSize: tamanhoFonte.letraPequena(context)),
                          ),
                          onPressed: () {
                            verificarSenhas();
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
            ),
          )
        ],
      ),
    );
  }
}
