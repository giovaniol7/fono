import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:fono/view/TelaAgenda.dart';
import 'package:fono/view/TelaContas.dart';
import 'package:fono/view/TelaEditarPerfil.dart';
import 'package:fono/view/TelaPacientes.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:window_manager/window_manager.dart';
import '../connections/firebase_options.dart';
import 'package:fono/view/TelaLogin.dart';
import 'package:fono/view/TelaInicial.dart';
import 'package:fono/view/TelaCadastro.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

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
      WindowOptions windowOptions = const WindowOptions(
        size: Size(800, 600),
        center: true,
        minimumSize: Size(800, 600),
      );
      windowManager.waitUntilReadyToShow(windowOptions, () async {
        await windowManager.show();
        await windowManager.focus();
      });
    }

    final tokenSave = await SharedPreferences.getInstance();
    token = tokenSave.getString('token');

    runApp(MaterialApp(
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: [
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
