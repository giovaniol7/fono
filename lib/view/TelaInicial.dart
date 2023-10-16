import 'package:firebase_core/firebase_core.dart';
import 'package:firedart/firestore/token_authenticator.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fono/view/TelaAgenda.dart';
import 'package:fono/view/TelaContas.dart';
import 'package:fono/view/TelaPacientes.dart';
import 'dart:io';
import 'package:fono/view/controllers/coresPrincipais.dart';
import 'package:fono/view/TelaEditarPerfil.dart';
import '../widgets/mensagem.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firedart/firedart.dart' as fd;
import 'package:cloud_firestore/cloud_firestore.dart';

class TelaInicial extends StatefulWidget {
  const TelaInicial({Key? key}) : super(key: key);

  @override
  State<TelaInicial> createState() => _TelaInicialState();
}

class _TelaInicialState extends State<TelaInicial> {
  var uidFono;
  late String nomeUsuario = '';
  String urlImage = '';
  late String genero = 'Gender.male';

  /*late String CRFa = '';
  late String dtNascimento = '';
  late String idadeUsuario = '';*/

  /*calculateAge(DateTime birthDate) {
    final now = DateTime.now();
    int age = now.year - birthDate.year;
    if (now.month < birthDate.month || (now.month == birthDate.month && now.day < birthDate.day)) {
      age--;
    }
    setState(() {
      idadeUsuario = age.toString();
    });
  }*/

  retornarNomeUsuario() async {
    if (kIsWeb || Platform.isAndroid || Platform.isIOS) {
      uidFono = FirebaseAuth.instance.currentUser!.uid.toString();
      FirebaseFirestore.instance.collection('users').where('uid', isEqualTo: uidFono).get().then((q) {
        if (q.docs.isNotEmpty) {
          setState(() {
            nomeUsuario = q.docs[0].data()['nome'];
            urlImage = q.docs[0].data()['urlImage'];
            print(urlImage);
            genero = q.docs[0].data()['genero'];
            /*dtNascimento = q.docs[0].data()['dtNascimento'];
            List<String> partesData = dtNascimento.split('/');
            int dia = int.parse(partesData[0]);
            int mes = int.parse(partesData[1]);
            int ano = int.parse(partesData[2]);
            DateTime dataNascimento = DateTime(ano, mes, dia);
            calculateAge(dataNascimento);
            CRFa = q.docs[0].data()['crfa'];*/
          });
        }
      });
    } else {
      await fd.FirebaseAuth.initialize('AIzaSyAlG2glNY3njAvAyJ7eEMeMtLg4Wcfg8rI', fd.VolatileStore());
      await fd.Firestore.initialize('programafono-7be09');
      var auth = fd.FirebaseAuth.instance;
      final emailSave = await SharedPreferences.getInstance();
      var email = emailSave.getString('email');
      final senhaSave = await SharedPreferences.getInstance();
      var senha = senhaSave.getString('senha');
      await auth.signIn(email!, senha!);
      var user = await auth.getUser();
      uidFono = user.id;

      fd.Firestore.instance.collection('users').where('uid', isEqualTo: uidFono).get().then((q) {
        if (q.isNotEmpty) {
          q.forEach((doc) {
            setState(() {
              nomeUsuario = doc['nome'];
              urlImage = doc['urlImage'];
              genero = doc['genero'];
              //dtNascimento = doc['dtNascimento'];
              //calculateAge(DateTime.parse(dtNascimento));
            });
          });
        }
      });
    }
  }

  @override
  void initState() {
    super.initState();
    retornarNomeUsuario();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      child: ListView(
        children: [
          Column(
            children: [
              Container(
                padding: EdgeInsets.only(left: 20, right: 20),
                width: MediaQuery.of(context).size.width,
                height: kIsWeb || Platform.isWindows
                    ? MediaQuery.of(context).size.height * 0.4
                    : MediaQuery.of(context).size.height * 0.3,
                decoration: BoxDecoration(
                    color: cores('rosa_medio'),
                    boxShadow: [
                      BoxShadow(offset: Offset(0, 3), color: cores('verde/azul'), blurRadius: 5),
                    ],
                    borderRadius: BorderRadius.only(bottomRight: Radius.circular(16), bottomLeft: Radius.circular(16))),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Padding(padding: EdgeInsets.only(top: 5)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                          icon: Icon(
                            Icons.edit,
                            color: cores('verde'),
                          ),
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => TelaEditarPerfil()));
                          },
                        ),
                      ],
                    ),
                    Padding(padding: EdgeInsets.only(top: 10)),
                    Center(
                      child: Container(
                        width: kIsWeb || Platform.isWindows
                            ? MediaQuery.of(context).size.width * 0.06
                            : MediaQuery.of(context).size.width * 0.20,
                        height: kIsWeb || Platform.isWindows
                            ? MediaQuery.of(context).size.width * 0.06
                            : MediaQuery.of(context).size.height * 0.1,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: cores('verde'),
                        ),
                        child: urlImage.isEmpty
                            ? Icon(
                                Icons.person,
                                color: cores('rosa_medio'),
                                size: MediaQuery.of(context).size.height * 0.08,
                              )
                            : CircleAvatar(
                                child: ClipOval(
                                  child: Image.network(
                                    urlImage,
                                    width: kIsWeb || Platform.isWindows
                                        ? MediaQuery.of(context).size.width * 0.2
                                        : MediaQuery.of(context).size.width * 0.3,
                                    height: kIsWeb || Platform.isWindows
                                        ? MediaQuery.of(context).size.height * 0.4
                                        : MediaQuery.of(context).size.height * 0.3,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                      ),
                    ),
                    Padding(padding: EdgeInsets.only(top: 20)),
                    Expanded(
                      child: Center(
                        child: Text(
                          nomeUsuario.toString(),
                          style: TextStyle(
                              color: cores('verde'),
                              fontSize: kIsWeb || Platform.isWindows
                                  ? MediaQuery.of(context).size.height * 0.07
                                  : MediaQuery.of(context).size.width * 0.07,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Center(
                        child: Text(
                          genero == 'Gender.male' ? 'Fonoaudiólogo' : 'Fonoaudióloga',
                          style: TextStyle(
                            color: cores('verde'),
                            fontSize: kIsWeb || Platform.isWindows
                                ? MediaQuery.of(context).size.height * 0.04
                                : MediaQuery.of(context).size.width * 0.04,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Container(
            padding: EdgeInsets.only(left: 5, right: 5),
            height: MediaQuery.of(context).size.height * 0.5,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.30,
                      height: MediaQuery.of(context).size.height * 0.10,
                      child: ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStatePropertyAll<Color>(cores('verde/azul')),
                            elevation: MaterialStateProperty.all<double>(5),
                            shadowColor: MaterialStatePropertyAll<Color>(cores('rosa_fraco')),
                          ),
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => TelaPaciente()));
                          },
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.person,
                                color: cores('verde'),
                              ),
                              Text(
                                'Pacientes',
                                style: TextStyle(color: cores('verde'), fontWeight: FontWeight.bold),
                              )
                            ],
                          )),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.30,
                      height: MediaQuery.of(context).size.height * 0.10,
                      child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStatePropertyAll<Color>(cores('verde/azul')),
                          elevation: MaterialStateProperty.all<double>(5),
                          shadowColor: MaterialStatePropertyAll<Color>(cores('rosa_fraco')),
                        ),
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => TelaContas()));
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.payments,
                              color: cores('verde'),
                            ),
                            SizedBox(height: 5),
                            Text(
                              'Contas',
                              style: TextStyle(
                                color: cores('verde'),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.30,
                      height: MediaQuery.of(context).size.height * 0.10,
                      child: ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStatePropertyAll<Color>(cores('verde/azul')),
                            elevation: MaterialStateProperty.all<double>(5),
                            shadowColor: MaterialStatePropertyAll<Color>(cores('rosa_fraco')),
                          ),
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => TelaAgenda(uidFono)));
                          },
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.calendar_month,
                                color: cores('verde'),
                              ),
                              MediaQuery.of(context).size.height >= 2
                                  ? Text(
                                      'Agenda',
                                      style: TextStyle(color: cores('verde'), fontWeight: FontWeight.bold),
                                    )
                                  : Container(),
                            ],
                          )),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.30,
                      height: MediaQuery.of(context).size.height * 0.10,
                      child: ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStatePropertyAll<Color>(cores('verde/azul')),
                            elevation: MaterialStateProperty.all<double>(5),
                            shadowColor: MaterialStatePropertyAll<Color>(cores('rosa_fraco')),
                          ),
                          onPressed: () {},
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.assignment,
                                color: cores('verde'),
                              ),
                              Text(
                                'Relatório',
                                style: TextStyle(color: cores('verde'), fontWeight: FontWeight.bold),
                              )
                            ],
                          )),
                    ),
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.30,
                      height: MediaQuery.of(context).size.height * 0.10,
                      child: ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStatePropertyAll<Color>(cores('verde/azul')),
                            elevation: MaterialStateProperty.all<double>(5),
                            shadowColor: MaterialStatePropertyAll<Color>(cores('rosa_fraco')),
                          ),
                          onPressed: () {},
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.analytics_outlined,
                                color: cores('verde'),
                              ),
                              Text(
                                'Dados',
                                style: TextStyle(color: cores('verde'), fontWeight: FontWeight.bold),
                              )
                            ],
                          )),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.30,
                      height: MediaQuery.of(context).size.height * 0.10,
                      child: ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStatePropertyAll<Color>(cores('verde/azul')),
                            elevation: MaterialStateProperty.all<double>(5),
                            shadowColor: MaterialStatePropertyAll<Color>(cores('rosa_fraco')),
                          ),
                          onPressed: () {
                            signOut();
                          },
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.logout,
                                color: cores('verde'),
                              ),
                              Text(
                                'Sair',
                                style: TextStyle(color: cores('verde'), fontWeight: FontWeight.bold),
                              )
                            ],
                          )),
                    )
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    ));
  }

  void signOut() async {
    if (kIsWeb || Platform.isAndroid || Platform.isIOS) {
      try {
        await FirebaseAuth.instance.signOut();
        saveValor();
        sucesso(context, 'O usuário deslogado!');
        Navigator.pushReplacementNamed(context, '/login');
      } catch (e) {
        // ignore: avoid_print
        print(e.toString());
        return null;
      }
    } else {
      //fd.FirebaseAuth.initialize('AIzaSyAlG2glNY3njAvAyJ7eEMeMtLg4Wcfg8rI', fd.VolatileStore());
      //fd.Firestore.initialize('programafono-7be09');
      try {
        fd.FirebaseAuth.instance.signOut();
        saveValor();
        sucesso(context, 'O usuário deslogado!');
        Navigator.pushReplacementNamed(context, '/login');
      } catch (e) {
        // ignore: avoid_print
        print(e.toString());
        return null;
      }
    }
  }

  void saveValor() async {
    SharedPreferences tokenSave = await SharedPreferences.getInstance();
    await tokenSave.setString('token', '');
  }
}
