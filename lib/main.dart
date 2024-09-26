import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:window_manager/window_manager.dart';

import '../connections/firebase_options.dart';
import '../controllers/variaveis.dart';
import '../view/TelaAdicionarAgenda.dart';
import '../view/TelaAdicionarBlocoNotas.dart';
import '../view/TelaAdicionarContas.dart';
import '../view/TelaAdicionarPaciente.dart';
import '../view/TelaAdicionarProntuarios.dart';
import '../view/TelaBlocoDeNotas.dart';
import '../view/TelaDadosPacientes.dart';
import '../view/TelaDadosProntuarios.dart';
import '../view/TelaProntuarios.dart';
import '../view/TelaProntuariosPaciente.dart';
import '../view/TelaLogin.dart';
import '../view/TelaInicial.dart';
import '../view/TelaCadastro.dart';
import '../view/TelaAgenda.dart';
import '../view/TelaContas.dart';
import '../view/TelaEditarPerfil.dart';
import '../view/TelaPacientes.dart';

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
          localizationsDelegates: [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate
          ],
          supportedLocales: const [Locale('en'), Locale('pt'), Locale('es')],
          locale: const Locale('pt', 'BR'),
          debugShowCheckedModeBanner: false,
          title: 'FonoCare',
          initialRoute: token == '' ? '/login' : '/principal',
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
  } else {
    if (Platform.isWindows || Platform.isMacOS) {
      await windowManager.ensureInitialized();

      WindowOptions windowOptions = const WindowOptions(
        size: Size(850, 750),
        center: true,
        minimumSize: Size(850, 750),
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
          localizationsDelegates: [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate
          ],
          supportedLocales: const [Locale('en'), Locale('pt'), Locale('es')],
          locale: Locale('pt', 'BR'),
          debugShowCheckedModeBanner: false,
          title: 'FonoCare',
          //home: token == null || token == '' ? TelaLogin() : TelaInicial(),
          initialRoute: token == '' ? '/login' : '/principal',
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
