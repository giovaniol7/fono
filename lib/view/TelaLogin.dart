import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../controllers/estilos.dart';
import '../controllers/resolucoesTela.dart';
import '../connections/fireAuth.dart';
import '../widgets/campoTexto.dart';
import '../widgets/customButton.dart';
import '../widgets/logoCapa.dart';

class TelaLogin extends StatefulWidget {
  const TelaLogin({Key? key}) : super(key: key);

  @override
  State<TelaLogin> createState() => _TelaLoginState();
}

class _TelaLoginState extends State<TelaLogin> {
  var txtEmail = TextEditingController();
  var txtSenha = TextEditingController();
  bool _obscureText = true;

  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  ratioScreen ratio = ratioScreen();

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    var form = Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          campoTexto('Email', txtEmail, Icons.email, senha: false),
          const SizedBox(
            height: 10,
          ),
          campoTexto('Senha', txtSenha, Icons.lock,
              sufIcon: IconButton(
                icon: Icon(
                  _obscureText ? Icons.visibility_off : Icons.visibility,
                  color: cores('verde'),
                ),
                onPressed: _toggle,
              ),
              senha: _obscureText),
          const SizedBox(
            height: 20,
          ),
          customButton(
            text: "Entrar",
            textStyle: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),
            buttonColor: cores('verde'),
            padding: ratio.screen(context) == 'grande'
                ? const EdgeInsets.fromLTRB(32, 20, 32, 20)
                : const EdgeInsets.fromLTRB(32, 10, 32, 10),
            margin: const EdgeInsets.only(top: 20, bottom: 10),
            onPressed: () {
              autenticarConta(context, txtEmail.text, txtSenha.text);
            },
          ),
          Align(
            alignment: Alignment.center,
            child: Text(
              "ou",
              style: TextStyle(color: cores('verde'), fontSize: 18),
            ),
          ),
          customButton(
            text: "Entrar com o Google",
            textStyle: const TextStyle(color: Colors.pinkAccent, fontSize: 15, fontWeight: FontWeight.bold),
            buttonColor: cores('verde/azul'),
            padding: ratio.screen(context) == 'grande'
                ? const EdgeInsets.fromLTRB(32, 20, 32, 20)
                : const EdgeInsets.fromLTRB(32, 10, 32, 10),
            margin: const EdgeInsets.only(top: 15, bottom: 10),
            onPressed: () {
              autenticarConta(context, txtEmail, txtSenha);
            },
          ),
          Align(
            alignment: Alignment.center,
            child: Text(
              "Não possui cadastro.",
              style: TextStyle(color: cores('verde'), fontSize: 18),
            ),
          ),
          const SizedBox(
            height: 3,
          ),
          Center(
            child: GestureDetector(
              child: Text(
                "Faça seu cadastro!",
                style: TextStyle(decoration: TextDecoration.underline, color: cores('verde'), fontSize: 18, fontWeight: FontWeight.w500),
              ),
              onTap: () {
                Navigator.pushNamed(context, '/cadastro');
              },
            ),
          ),
        ],
      ),
    );

    return Scaffold(
      backgroundColor: cores('rosa_fraco'),
      body: ratio.screen(context) == 'pequeno'
          ? ListView(
              children: [
                Column(
                  children: [
                    const logoCapa(),
                    Container(
                      decoration: BoxDecoration(color: cores('rosa_fraco')),
                      child: Column(
                        children: [
                          form,
                        ],
                      ),
                    )
                  ],
                ),
              ],
            )
          : Row(
              children: [
                SizedBox(width: width * 0.5, child: Stack(children: [logoCapa()])),
                Expanded(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Login",
                      style: TextStyle(
                        color: Color(0xFF37513F),
                        fontFamily: 'Adage',
                        fontSize: 128,
                      ),
                    ),
                    form
                  ],
                ))
              ],
            ),
    );
  }
}
