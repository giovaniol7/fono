import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:fonocare/view/TelaAdicionarAgenda.dart';
import 'package:fonocare/view/TelaAdicionarBlocoNotas.dart';
import 'package:fonocare/view/TelaAdicionarContas.dart';
import 'package:fonocare/view/TelaAdicionarPaciente.dart';
import 'package:fonocare/view/TelaAdicionarProntuarios.dart';
import 'package:fonocare/view/TelaBlocoDeNotas.dart';
import 'package:fonocare/view/TelaDadosPacientes.dart';
import 'package:fonocare/view/TelaDadosProntuarios.dart';
import 'package:fonocare/view/TelaProntuarios.dart';
import 'package:fonocare/view/TelaProntuariosPaciente.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:window_manager/window_manager.dart';

import '../connections/firebase_options.dart';
import '../view/TelaLogin.dart';
import '../view/TelaInicial.dart';
import '../view/TelaCadastro.dart';
import '../view/TelaAgenda.dart';
import '../view/TelaContas.dart';
import '../view/TelaEditarPerfil.dart';
import '../view/TelaPacientes.dart';
import 'controllers/variaveis.dart';

void main() async {
  String? token;

  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  if (kIsWeb) {
    final tokenSave = await SharedPreferences.getInstance();
    token = tokenSave.getString('token');

    runApp(ChangeNotifierProvider(
        create: (context) => AppVariaveis(),
        child: MaterialApp(
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('en'),
            Locale('pt'),
            Locale('es'),
          ],
          locale: const Locale('pt', 'BR'),
          debugShowCheckedModeBanner: false,
          title: 'FonoCare',
          initialRoute: token == null || token == '' ? '/login' : '/principal',
          routes: {
            '/login': (context) => const TelaLogin(),
            '/cadastro': (context) => const TelaCadastro(),
            '/editarPerfil': (context) => const TelaEditarPerfil(),
            '/principal': (context) => const TelaInicial(),
            '/pacientes': (context) => const TelaPacientes(),
            //'/dadosPacientes': (context) => const TelaDadosPacientes(uidPaciente),
            //'/adicionarPacientes': (context) => const TelaAdicionarPaciente(tipo, uid),
            '/prontuarios': (context) => const TelaProntuarios(),
            //'/adicionarProntuarios': (context) => const TelaAdicionarProntuarios(),
            //'/pacienteProntuarios': (context) => const TelaProntuariosPaciente(),
            //'/dadosProntuarios': (context) => const TelaDadosProntuarios(),
            '/agenda': (context) => const TelaAgenda(),
            '/adicionarAgenda': (context) => const TelaAdicionarAgenda(),
            '/contas': (context) => const TelaContas(),
            //'/adicionarContas': (context) => const TelaAdicionarContas(tipo),
          },
        )));
  } else {
    if (Platform.isWindows || Platform.isMacOS) {
      await windowManager.ensureInitialized();

      WindowOptions windowOptions = const WindowOptions(
        size: Size(800, 700),
        center: true,
        minimumSize: Size(800, 700),
      );
      windowManager.waitUntilReadyToShow(windowOptions, () async {
        await windowManager.show();
        await windowManager.focus();
      });
    }

    final tokenSave = await SharedPreferences.getInstance();
    token = tokenSave.getString('token');

    runApp(ChangeNotifierProvider(
        create: (context) => AppVariaveis(),
        child: MaterialApp(
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('en'),
            Locale('pt'),
            Locale('es'),
          ],
          locale: Locale('pt', 'BR'),
          debugShowCheckedModeBanner: false,
          title: 'FonoCare',
          //home: token == null || token == '' ? TelaLogin() : TelaInicial(),
          initialRoute: token == null || token == '' ? '/login' : '/principal',
          routes: {
            '/login': (context) => const TelaLogin(),
            '/cadastro': (context) => const TelaCadastro(),
            '/editarPerfil': (context) => const TelaEditarPerfil(),
            '/principal': (context) => const TelaInicial(),
            '/pacientes': (context) => const TelaPacientes(),
            '/adicionarPacientes': (context) => const TelaAdicionarPaciente(),
            '/dadosPacientes': (context) => const TelaDadosPacientes(),
            '/prontuarios': (context) => const TelaProntuarios(),
            '/adicionarProntuarios': (context) => const TelaAdicionarProntuarios(),
            '/pacienteProntuarios': (context) => const TelaProntuariosPaciente(),
            '/dadosProntuarios': (context) => const TelaDadosProntuarios(),
            '/agenda': (context) => const TelaAgenda(),
            '/adicionarAgenda': (context) => const TelaAdicionarAgenda(),
            '/contas': (context) => const TelaContas(),
            '/adicionarContas': (context) => const TelaAdicionarContas(),
            '/blocoNotas': (context) => const TelaBlocoDeNotas(),
            '/adicionarBlocoNotas': (context) => const TelaAdicionarBlocoNotas(),
          },
        )));
  }
}
