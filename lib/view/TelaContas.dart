import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fono/view/TelaAdicionarContas.dart';
import '../controllers/calcularFinanceiro.dart';
import '../controllers/converterData.dart';
import '../controllers/estilos.dart';
import 'package:firedart/firedart.dart' as fd;
import 'package:fono/widgets/mensagem.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../controllers/formatarMesAno.dart';

class TelaContas extends StatefulWidget {
  const TelaContas({super.key});

  @override
  State<TelaContas> createState() => _TelaContasState();
}

class _TelaContasState extends State<TelaContas> with SingleTickerProviderStateMixin {
  var contas;
  var contasDebito;
  var contasCredito;
  var uidFono;
  var windowsIdFono;
  double somaDespesas = 0;
  double somaGanhos = 0;
  double somaRenda = 0;
  late TabController _tabController;
  NumberFormat numberFormat = NumberFormat("#,##0.00", "pt_BR");

  retornarPacientes() async {
    DateTime now = DateTime.now();
    DateTime startOfDay = DateTime(now.year, now.month, now.day);
    if (kIsWeb || Platform.isAndroid || Platform.isIOS) {
      uidFono = FirebaseAuth.instance.currentUser!.uid.toString();
      contasCredito = FirebaseFirestore.instance
          .collection('contas')
          .where('uidFono', isEqualTo: uidFono)
          .where('tipoTransacao', isEqualTo: 'Gasto')
          .orderBy('dataHora', descending: true)
          .snapshots();
      contasDebito = FirebaseFirestore.instance
          .collection('contas')
          .where('uidFono', isEqualTo: uidFono)
          .where('tipoTransacao', isEqualTo: 'Recebido')
          .orderBy('dataHora', descending: true)
          .snapshots();
      contas = FirebaseFirestore.instance
          .collection('contas')
          .where('uidFono', isEqualTo: uidFono)
          .orderBy('dataHora', descending: true)
          .snapshots();
    } else {
      //await fd.FirebaseAuth.initialize('AIzaSyAlG2glNY3njAvAyJ7eEMeMtLg4Wcfg8rI', fd.VolatileStore());
      //await fd.Firestore.initialize('programafono-7be09');
      var auth = fd.FirebaseAuth.instance;
      final emailSave = await SharedPreferences.getInstance();
      var email = emailSave.getString('email');
      final senhaSave = await SharedPreferences.getInstance();
      var senha = senhaSave.getString('senha');
      await auth.signIn(email!, senha!);
      var user = await auth.getUser();
      windowsIdFono = user.id;

      contasCredito = fd.Firestore.instance
          .collection('contas')
          .where('uidFono', isEqualTo: windowsIdFono)
          .where('tipoTransação', isEqualTo: 'Gasto')
          .get();
      contasDebito = fd.Firestore.instance
          .collection('contas')
          .where('uidFono', isEqualTo: windowsIdFono)
          .where('tipoTransação', isEqualTo: 'Recebido')
          .get();
      contas = fd.Firestore.instance.collection('contas').where('uidFono', isEqualTo: windowsIdFono);
    }
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 3);
    retornarPacientes();
    calcularFinanceiro();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: cores('corTerciaria'),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_outlined,
            color: cores('corSimbolo'),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        /*actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.edit,
              color: cores('verde'),
            ),
            onPressed: () {},
          )
        ],*/
      ),
      body: Container(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.only(top: 15),
              width: MediaQuery.of(context).size.width,
              height: kIsWeb || Platform.isWindows
                  ? MediaQuery.of(context).size.width * 0.2
                  : MediaQuery.of(context).size.height * 0.23,
              decoration: BoxDecoration(color: cores('corTerciaria'),),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Column(
                          children: <Widget>[
                            Icon(
                              Icons.money_off,
                              color: cores('corSimbolo'),
                              size: kIsWeb || Platform.isWindows
                                  ? MediaQuery.of(context).size.width * 0.03
                                  : MediaQuery.of(context).size.height * 0.03,
                            ),
                            Text(
                              numberFormat.format(somaDespesas),
                              style: TextStyle(
                                color: cores('corTexto'),
                                fontSize: kIsWeb || Platform.isWindows
                                    ? MediaQuery.of(context).size.width * 0.02
                                    : MediaQuery.of(context).size.height * 0.02,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: Column(
                          children: <Widget>[
                            Icon(
                              Icons.monetization_on_rounded,
                              color: cores('corSimbolo'),
                              size: kIsWeb || Platform.isWindows
                                  ? MediaQuery.of(context).size.width * 0.03
                                  : MediaQuery.of(context).size.height * 0.03,
                            ),
                            Text(
                              numberFormat.format(somaGanhos),
                              style: TextStyle(
                                color: cores('corTexto'),
                                fontSize: kIsWeb || Platform.isWindows
                                    ? MediaQuery.of(context).size.width * 0.02
                                    : MediaQuery.of(context).size.height * 0.02,
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                  Center(
                    child: Padding(
                        padding: const EdgeInsets.only(top: 13, bottom: 20, left: 10),
                        child: Column(
                          children: [
                            Text(
                              'Renda',
                              style: TextStyle(
                                  color: cores('corTexto'),
                                  fontSize: kIsWeb || Platform.isWindows
                                      ? MediaQuery.of(context).size.width * 0.025
                                      : MediaQuery.of(context).size.height * 0.025,
                                  fontWeight: FontWeight.bold),
                            ),
                            Text(
                              'R\$ ${numberFormat.format(somaRenda)}',
                              style: TextStyle(
                                  color: cores('corTexto'),
                                  fontSize: kIsWeb || Platform.isWindows
                                      ? MediaQuery.of(context).size.width * 0.025
                                      : MediaQuery.of(context).size.height * 0.025,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        )),
                  ),
                ],
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: cores('corTerciaria'),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
              child: TabBar(
                controller: _tabController,
                tabs: const [
                  Tab(text: 'Crédito'),
                  Tab(text: 'Débito'),
                  Tab(text: 'Geral'),
                ],
                indicatorColor: cores('corTexto'),
                labelColor: cores('corDetalhe'),
                unselectedLabelColor: cores('corTexto'),
                labelStyle: TextStyle(color: cores('corTexto'), fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  TabContent(contasCredito),
                  TabContent(contasDebito),
                  TabContent(contas),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => TelaAdicionarContas(uidFono),
              ));
        },
        backgroundColor: cores('verde'),
        child: Icon(
          Icons.add,
          color: cores('rosa_fraco'),
        ),
      ),
    );
  }

  Widget TabContent(futurestream) {
    return ListView(
      children: [
        StreamBuilder<QuerySnapshot>(
          stream: futurestream,
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
                return const Center(
                  child: Text('Não foi possível conectar'),
                );
              case ConnectionState.waiting:
                return const Center(
                  child: CircularProgressIndicator(),
                );
              default:
                final dados = snapshot.requireData;
                Map<String, List<QueryDocumentSnapshot>> contasPorMes = {};
                dados.docs.forEach((doc) {
                  String dataString = doc['data'];
                  DateTime data = DateFormat('dd/MM/yyyy').parse(dataString);
                  String mesAno = DateFormat('MM/yyyy').format(data);
                  if (!contasPorMes.containsKey(mesAno)) {
                    contasPorMes[mesAno] = [];
                  }
                  contasPorMes[mesAno]!.add(doc);
                });

                List<String> mesesOrdenados = contasPorMes.keys.toList();
                mesesOrdenados.sort((a, b) => b.compareTo(a));

                return Column(
                  children: mesesOrdenados.map((mesAno) {
                    List<QueryDocumentSnapshot> contas = contasPorMes[mesAno]!;
                    return Column(
                      children: [
                        Text(
                          formatarMesAno(mesAno),
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge
                              ?.copyWith(fontWeight: FontWeight.w700, color: cores('verde')),
                        ),
                        ListView.separated(
                          physics: const NeverScrollableScrollPhysics(),
                          padding: const EdgeInsets.all(10),
                          scrollDirection: Axis.vertical,
                          itemBuilder: (context, index) => listarContas(contas[index]),
                          separatorBuilder: (context, _) => const SizedBox(
                            width: 1,
                          ),
                          itemCount: contas.length,
                          shrinkWrap: true,
                        ),
                      ],
                    );
                  }).toList(),
                );
            }
          },
        ),
      ],
    );
  }

  Widget listarContas(doc) {
    return InkWell(
        onDoubleTap: () async {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text('Confirmar exclusão'),
                  content: const Text('Tem certeza de que deseja apagar esta transação?'),
                  actions: <Widget>[
                    TextButton(
                      child: const Text('Cancelar'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    TextButton(
                      child: const Text(
                        'Apagar',
                        style: TextStyle(color: Colors.red),
                      ),
                      onPressed: () async {
                        try {
                          await FirebaseFirestore.instance.collection('contas').doc(doc.data()['uidConta']).delete();
                        } catch (e) {
                          erro(context, 'Erro ao deletar documento: $e');
                        }
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                );
              });
          calcularFinanceiro();
          //sucesso(context, 'Atualizado com sucesso!');
        },
        onTap: () {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('Descrição da Transição ${doc.data()['nomeConta']}'),
                  content: Text(doc.data()['descricaoConta']),
                  actions: <Widget>[
                    TextButton(
                      child: const Text('Ok'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                );
              });
        },
        onLongPress: () async {
          DocumentReference docRef = FirebaseFirestore.instance.collection('contas').doc(doc.data()['uidConta']);
          if (doc.data()['estadoPago'] == true) {
            await docRef.update({
              'estadoPago': false,
            });
          } else {
            await docRef.update({
              'estadoPago': true,
            });
          }
          calcularFinanceiro();
          //sucesso(context, 'Atualizado com sucesso!');
        },
        child: Container(
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.symmetric(vertical: 15),
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      height: 48,
                      width: 48,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color.fromARGB(255, 240, 241, 245),
                      ),
                      child: doc.data()['tipoTransacao'] == 'Recebido'
                          ? Icon(Icons.attach_money,
                              color: doc.data()['estadoPago'] == true ? cores('verde') : Colors.red)
                          : Icon(
                              Icons.money_off,
                              color: doc.data()['estadoPago'] == true ? cores('verde') : Colors.red,
                            ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  doc.data()['nomeConta'].toUpperCase(),
                                  softWrap: true,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                      fontWeight: FontWeight.w700,
                                      color: doc.data()['estadoPago'] == true ? cores('verde') : Colors.red),
                                ),
                              ),
                              Text(
                                converterData(doc.data()['data']),
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                    fontSize: 15,
                                    color: doc.data()['estadoPago'] == true ? cores('verde') : Colors.red),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          /*Text(
                        doc.data()['selecioneFormaPagamento'].toUpperCase(),
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(height: 1.5, color: cores('verde')),
                      ),
                      const SizedBox(height: 5),*/
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'R\$ ' + doc.data()['preco'],
                                style: Theme.of(context)
                                    .textTheme
                                    .titleSmall
                                    ?.copyWith(color: doc.data()['estadoPago'] == true ? cores('verde') : Colors.red),
                              ),
                              Icon(
                                doc.data()['tipo'] == 'Trabalho'
                                    ? FontAwesomeIcons.briefcase
                                    : (doc.data()['tipo'] == 'Pessoal'
                                        ? FontAwesomeIcons.solidUser
                                        : FontAwesomeIcons.shuffle),
                                color: doc.data()['estadoPago'] == true ? cores('verde') : Colors.red,
                              ),
                            ],
                          ),
                          const SizedBox(height: 5),
                          Text(
                            doc.data()['formaPagamento'].toUpperCase(),
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(color: doc.data()['estadoPago'] == true ? cores('verde') : Colors.red),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 5),
              Container(
                height: 1,
                color: const Color.fromARGB(255, 245, 245, 245),
              )
            ],
          ),
        ));
  }

/*Widget listarContas(doc) {
    return Container(
      child: Card(
        elevation: 7,
        shadowColor: cores('rosa_fraco'),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        margin: EdgeInsets.all(5),
        child: ListTile(
          leading: doc.data()['selecioneTipoConta'] == 'Recebido' ? Icon(Icons.attach_money, color: cores('verde')) : Icon(Icons.money_off, color: cores('verde'),),
          title: Expanded(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                doc.data()['nomeConta'],
                style: TextStyle(fontWeight: FontWeight.bold, color: cores('verde')),
              ),
              Text(
                doc.data()['selecioneFormaPagamento'],
                style: TextStyle(fontWeight: FontWeight.normal, color: cores('verde/azul')),
              ),
            ],
          )),
          onTap: () {},
        ),
      ),
    );
  }*/
}
