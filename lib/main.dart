import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:firebase_core/firebase_core.dart';
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

void main() async {
  String? token;

  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  if (kIsWeb) {
    final tokenSave = await SharedPreferences.getInstance();
    token = tokenSave.getString('token');

    runApp(MaterialApp(
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
      title: 'Clínica Fonoaudiologia',
      initialRoute: token == null || token == '' ? '/login' : '/principal',
      routes: {
        '/login': (context) => const TelaLogin(),
        '/principal': (context) => const TelaInicial(),
        '/cadastro': (context) => const TelaCadastro(),
      },
    ));
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

    runApp(MaterialApp(
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
      title: 'Clínica Fonoaudiologia',
      //home: token == null || token == '' ? TelaLogin() : TelaInicial(),
      initialRoute: token == null || token == '' ? '/login' : '/principal',
      routes: {
        '/login': (context) => const TelaLogin(),
        '/principal': (context) => const TelaInicial(),
        '/cadastro': (context) => const TelaCadastro(),
        '/pacientes': (context) => const TelaPacientes(),
        '/contas': (context) => const TelaContas(),
        '/agenda': (context) => const TelaAgenda(),
        '/editarPerfil': (context) => const TelaEditarPerfil(),
      },
    ));
  }
}
