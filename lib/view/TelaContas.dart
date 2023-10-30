import 'package:fono/connections/fireCloudContas.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fono/view/TelaAdicionarContas.dart';
import '../controllers/calcularFinanceiro.dart';
import '../controllers/converterData.dart';
import '../controllers/estilos.dart';
import 'package:fono/widgets/mensagem.dart';

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
  var windowsIdFono;
  double somaDespesas = 0;
  double somaGanhos = 0;
  late double? saldo = 0.0;
  late TabController _tabController;
  NumberFormat numberFormat = NumberFormat("#,##0.00", "pt_BR");

  Future<void> atualizarDados() async {
    await carregarDados();
  }

  carregarDados() async {
    var financias = await calcularFinanceiro();
    contas = await recuperarConta();
    contasDebito = await recuperarDebito();
    contasCredito = await recuperarCredito();

    setState(() {
      saldo = financias['somaRenda'];
    });
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 3);
    calcularFinanceiro();
    carregarDados();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    TamanhoWidgets tamanhoWidgets = TamanhoWidgets();
    TamanhoFonte tamanhoFonte = TamanhoFonte();
    
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: cores('corFundo'),
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
              padding: const EdgeInsets.only(top: 5),
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: cores('corFundo'),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Center(
                    child: Padding(
                        padding: const EdgeInsets.only(top: 5, bottom: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Saldo: ',
                              style: TextStyle(
                                  color: cores('corTexto'),
                                  fontSize: tamanhoFonte.letraMedia(context),
                                  fontWeight: FontWeight.bold),
                            ),
                            Text(
                              'R\$ ${numberFormat.format(saldo)}',
                              style: TextStyle(
                                  color: cores('corTexto'),
                                  fontSize: tamanhoFonte.letraMedia(context),
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
                color: cores('corFundo'),
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
                labelStyle: TextStyle(color: cores('corTexto'), fontSize: tamanhoFonte.letraPequena(context), fontWeight: FontWeight.bold),
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
        shape: CircleBorder(),
        onPressed: () {
          String tipo = 'adicionar';
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => TelaAdicionarContas(tipo),
              ));
        },
        backgroundColor: cores('corBotao'),
        child: Icon(
          Icons.add,
          size: 35,
          color: cores('corTextoBotao'),
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
                              ?.copyWith(fontWeight: FontWeight.w700, color: cores('corTexto')),
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
    var stiloPg = doc.data()['estadoPago'] == true ? cores('corTexto') : cores('corDespesas');
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
                      child: const Text(
                        'Cancelar',
                        style: TextStyle(color: Colors.blue),
                      ),
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
          carregarDados();
          //sucesso(context, 'Atualizado com sucesso!');
        },
        /*onTap: () {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('Descrição da Transição ${doc.data()['nomeConta']}'),
                  content: Text(doc.data()['descricaoConta']),
                  actions: <Widget>[
                    TextButton(
                      child: const Text(
                        'Ok',
                        style: TextStyle(color: Colors.blue),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                );
              });
        },*/
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
          atualizarDados();
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
                          ? Icon(Icons.attach_money, color: stiloPg)
                          : Icon(
                              Icons.money_off,
                              color: stiloPg,
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
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(fontWeight: FontWeight.w700, color: stiloPg),
                                ),
                              ),
                              Text(
                                converterData(doc.data()['data']),
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 15, color: stiloPg),
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
                                style: Theme.of(context).textTheme.titleSmall?.copyWith(color: stiloPg),
                              ),
                              Icon(
                                doc.data()['tipo'] == 'Trabalho'
                                    ? FontAwesomeIcons.briefcase
                                    : (doc.data()['tipo'] == 'Pessoal'
                                        ? FontAwesomeIcons.solidUser
                                        : FontAwesomeIcons.shuffle),
                                color: stiloPg,
                              ),
                            ],
                          ),
                          const SizedBox(height: 5),
                          Text(
                            doc.data()['formaPagamento'].toUpperCase(),
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(color: stiloPg),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 5),
            ],
          ),
        ));
  }
}

/*
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
);
Widget listarContas(doc) {
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
  }
 */
