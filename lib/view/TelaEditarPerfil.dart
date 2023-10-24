import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:brasil_fields/brasil_fields.dart';

import 'package:fono/view/TelaInicial.dart';

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
  var windowsId;
  var uid;
  var id;
  var urlImage;
  var txtNome = TextEditingController();
  var txtEmail = TextEditingController();
  var txtSenha = TextEditingController();
  var txtDtNascimento = TextEditingController();
  var genero;
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

  carregarDados() async {
    var usuario = await listarUsuario();
    setState(() {
      id = usuario['id'];
      uid = usuario['uid'];
      urlImage = usuario['urlImage'];
      txtNome.text = usuario['nome']!;
      txtDtNascimento.text = usuario['dtNascimento']!;
      genero = usuario['genero'];
      txtEmail.text = usuario['email']!;
      txtTelefone.text = usuario['telefone']!;
      txtCPF.text = usuario['cpf']!;
      txtCRFa.text = usuario['crfa']!;
    });
    print(usuario);
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
            Navigator.pop(context);
          },
        ),
        title: Text(
          "Editar Perfil",
          style: TextStyle(color: cores('corTexto')),
        ),
        backgroundColor: cores('corTerciaria'),
      ),
      body: ListView(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 0.2,
            decoration: BoxDecoration(
                color: cores('corSecundaria'),
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
                  color: cores('verde'),
                ),
                child: InkWell(
                  onTap: () async {
                    urlImage = await uploadImage();
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
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 150,
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                            foregroundColor: cores('corTextoBotao'),
                            minimumSize: const Size(200, 45),
                            backgroundColor: cores('corBotao'),
                            elevation: 5,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(32),
                            )),
                        child: const Text(
                          'Editar',
                          style: TextStyle(fontSize: 18),
                        ),
                        onPressed: () {
                          verificarDados(context, uid, txtNome.text, txtDtNascimento.text, txtEmail.text, txtCPF.text,
                              txtCRFa.text, txtTelefone.text, txtSenha.text, txtSenhaCofirmar.text, urlImage);
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const TelaInicial(),
                            ),
                          );
                        },
                      ),
                    ),
                    Padding(padding: EdgeInsets.all(20)),
                    SizedBox(
                      width: 150,
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                            foregroundColor: cores('corSecundaria'),
                            minimumSize: const Size(200, 45),
                            backgroundColor: cores('corTexto'),
                            elevation: 5,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(32),
                            )),
                        child: const Text(
                          'Cancelar',
                          style: TextStyle(fontSize: 18),
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
}
