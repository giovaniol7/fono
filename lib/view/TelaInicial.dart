import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../view/controllers/coresPrincipais.dart';
import '../widgets/DrawerNavigation.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firedart/firedart.dart' as fd;
import 'package:cloud_firestore/cloud_firestore.dart';

import 'controllers/resolucoesTela.dart';

class TelaInicial extends StatefulWidget {
  const TelaInicial({Key? key}) : super(key: key);

  @override
  State<TelaInicial> createState() => _TelaInicialState();
}

class _TelaInicialState extends State<TelaInicial> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

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

  ratioScreen ratio = ratioScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        drawer: DrawerNavigation(uidFono, urlImage, genero, nomeUsuario),
        body: ListView(
          children: [
            Stack(
              children: [
                ratio.screen(context) == 'pequeno' ? Center(
                  child: Column(
                    children: [
                      SizedBox(
                        height: 50,
                      ),
                      contaHome(context),
                      SizedBox(
                        height: 20,
                      ),
                      calendarHome(context),
                    ],
                  ),
                ) : Center(
                  child: Row(
                    children: [
                      SizedBox(
                        height: 50,
                      ),
                      contaHome(context),
                      SizedBox(
                        height: 20,
                      ),
                      calendarHome(context),
                    ],
                  ),
                ),
                SafeArea(
                  child: GestureDetector(
                    onTap: () {
                      _scaffoldKey.currentState!.openDrawer();
                    },
                    child: Container(
                      margin: EdgeInsets.only(left: 16, top: 16),
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                          color: cores('verde/azul'),
                          shape: BoxShape.circle,
                          boxShadow: [BoxShadow(color: cores('rosa_fraco'), offset: Offset(0, 3), blurRadius: 8)]),
                      child: Icon(
                        Icons.menu,
                        color: cores('verde'),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ));
  }
}

contaHome(context) {
  return Container(
    padding: EdgeInsets.all(10),
    width: MediaQuery.of(context).size.width * 0.9,
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12.0),
      boxShadow: [
        BoxShadow(
          color: cores('rosa_medio'),
          offset: Offset(0, 2),
          blurRadius: 5.0,
          spreadRadius: 3.0,
        ),
      ],
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Text('Resumo Financeiro',
            style: TextStyle(color: Colors.grey.shade600, fontSize: 40, fontWeight: FontWeight.bold)),
        SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Container(
              alignment: Alignment.centerLeft,
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12.0),
                boxShadow: [
                  BoxShadow(
                    color: cores('rosa_fraco'),
                    offset: Offset(2, 3),
                    blurRadius: 10.0,
                    spreadRadius: 3.0,
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Icon(
                    Icons.trending_up,
                    color: Colors.blue,
                    size: 80,
                  ),
                  Text(
                    'Receitas',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 17,
                    ),
                  ),
                  Text(
                    'R\$ 0,00',
                    style: TextStyle(color: Colors.blue, fontSize: 38, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12.0),
                boxShadow: [
                  BoxShadow(
                    color: cores('rosa_fraco'),
                    offset: Offset(2, 3),
                    blurRadius: 10.0,
                    spreadRadius: 3.0,
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Icon(
                    Icons.trending_down,
                    color: Colors.red,
                    size: 80,
                  ),
                  Text(
                    'Despesas',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 17,
                    ),
                  ),
                  Text(
                    'R\$ 0,00',
                    style: TextStyle(color: Colors.red, fontSize: 38, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ],
        ),
        SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              'Saldo: ',
              style: TextStyle(color: Colors.black, fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Text(
              'R\$ 0,00',
              style: TextStyle(color: Colors.black, fontSize: 26, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        SizedBox(
          height: 20,
        ),
        Container(
          width: MediaQuery.of(context).size.longestSide,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12.0),
            boxShadow: [
              BoxShadow(
                color: cores('rosa_medio'),
                offset: Offset(0, 2),
                blurRadius: 5.0,
                spreadRadius: 3.0,
              ),
            ],
          ),
          child: Column(
            children: [
              Text('Fluxo de Caixa',
                  style: TextStyle(color: Colors.grey.shade700, fontSize: 24, fontWeight: FontWeight.bold)),
              SizedBox(
                height: 10,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Card(
                    color: Colors.blue.shade100,
                    elevation: 7,
                    shadowColor: cores('rosa_fraco'),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    margin: EdgeInsets.all(5),
                    child: ListTile(
                      trailing: Icon(
                        Icons.account_balance,
                        color: Colors.black,
                        size: 40,
                      ),
                      title: Expanded(
                          child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'A Receber',
                            style: TextStyle(fontSize: 18),
                          ),
                          Text(
                            'R\$ 0,00',
                            style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.blue),
                          ),
                        ],
                      )),
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Card(
                    color: Colors.red.shade100,
                    elevation: 7,
                    shadowColor: cores('rosa_fraco'),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    margin: EdgeInsets.all(5),
                    child: ListTile(
                      trailing: Icon(
                        Icons.credit_card,
                        color: Colors.black,
                        size: 40,
                      ),
                      title: Expanded(
                          child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'A Pagar',
                            style: TextStyle(fontSize: 18),
                          ),
                          Text(
                            'R\$ 0,00',
                            style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.red),
                          ),
                        ],
                      )),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

calendarHome(context) {
  return Container(
    width: MediaQuery.of(context).size.width * 0.9,
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12.0),
      boxShadow: [
        BoxShadow(
          color: cores('rosa_medio'),
          offset: Offset(0, 2),
          blurRadius: 5.0,
          spreadRadius: 3.0,
        ),
      ],
    ),
    child: Column(
      children: [
        Text('Próximos Horários'),
      ],
    ),
  );
}
