import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

import '../models/maps.dart';
import '../connections/fireCloudContas.dart';
import '../controllers/variaveis.dart';
import '../controllers/calcularFinanceiro.dart';
import '../controllers/converterData.dart';
import '../controllers/estilos.dart';
import '../controllers/formatarMesAno.dart';
import '../widgets/mensagem.dart';

class TelaContas extends StatefulWidget {
  const TelaContas();

  @override
  State<TelaContas> createState() => _TelaContasState();
}

class _TelaContasState extends State<TelaContas> with SingleTickerProviderStateMixin {
  Future<void> atualizarDados() async {
    await carregarDados();
  }

  carregarDados() async {
    var financias = await calcularFinanceiro();
    AppVariaveis().geralContas = await recuperarGeral();
    AppVariaveis().contasDebito = await recuperarDebito();
    AppVariaveis().contasCredito = await recuperarCredito();

    setState(() {
      int mesAtual = DateTime.now().month;
      int anoAtual = DateTime.now().year;
      AppVariaveis().selecioneMesConta = intMesToAbrev[mesAtual] ?? 'Todos';
      AppVariaveis().selecioneAnoConta = anoAtual;
      AppVariaveis().saldoConta = financias['somaRenda']!;
    });
  }

  @override
  void initState() {
    super.initState();
    AppVariaveis().tabController = TabController(vsync: this, length: 3);
    carregarDados();
  }

  @override
  Widget build(BuildContext context) {
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
            AppVariaveis().resetContabilidadeConta();
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
                  Text(
                    'Selecione o Mês e Ano: ',
                    style: TextStyle(fontSize: 16, color: cores('corTexto'), fontWeight: FontWeight.bold),
                  ),
                  SizedBox(width: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      DropdownButton<String>(
                        alignment: Alignment.center,
                        menuMaxHeight: 300,
                        hint: Text(
                          'Mês:',
                          style: TextStyle(color: cores('corTexto')),
                        ),
                        icon: Icon(
                          Icons.arrow_drop_down,
                          color: cores('corTexto'),
                        ),
                        iconSize: 30,
                        iconEnabledColor: cores('corTexto'),
                        style: TextStyle(color: cores('corTexto'), fontWeight: FontWeight.w400, fontSize: 16),
                        underline: Container(
                          height: 0,
                        ),
                        value: AppVariaveis().selecioneMesConta,
                        onChanged: (String? newValue) {
                          setState(() {
                            AppVariaveis().selecioneMesConta = newValue!;
                          });
                        },
                        items: nomeMesesAbrev.map((state) {
                          return DropdownMenuItem(
                            value: state,
                            child: Text(state),
                          );
                        }).toList(),
                      ),
                      DropdownButton<int>(
                        alignment: Alignment.center,
                        menuMaxHeight: 300,
                        hint: Text(
                          'Ano:',
                          style: TextStyle(color: cores('corTexto')),
                        ),
                        icon: Icon(
                          Icons.arrow_drop_down,
                          color: cores('corTexto'),
                        ),
                        iconSize: 30,
                        iconEnabledColor: cores('corTexto'),
                        style: TextStyle(color: cores('corTexto'), fontWeight: FontWeight.w400, fontSize: 16),
                        underline: Container(
                          height: 0,
                        ),
                        value: AppVariaveis().selecioneAnoConta,
                        onChanged: (int? newValue) {
                          setState(() {
                            AppVariaveis().selecioneAnoConta = newValue!;
                          });
                        },
                        items: getAnos().map((int ano) {
                          return DropdownMenuItem<int>(
                            value: ano,
                            child: Text(ano.toString()),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                  Center(
                    child: Padding(
                        padding: const EdgeInsets.only(top: 5, bottom: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Saldo: ',
                              style: TextStyle(
                                  color: cores('corTexto'), fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              'R\$ ${AppVariaveis().numberFormat.format(AppVariaveis().saldoConta)}',
                              style: TextStyle(
                                  color: cores('corTexto'), fontSize: 16, fontWeight: FontWeight.bold),
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
                controller: AppVariaveis().tabController,
                tabs: const [
                  Tab(text: 'Saídas'),
                  Tab(text: 'Entradas'),
                  Tab(text: 'Tudo'),
                ],
                indicatorColor: cores('corTexto'),
                labelColor: cores('corDetalhe'),
                unselectedLabelColor: cores('corTexto'),
                labelStyle: TextStyle(color: cores('corTexto'), fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            Expanded(
              child: TabBarView(
                controller: AppVariaveis().tabController,
                children: [
                  TabContent(AppVariaveis().contasCredito),
                  TabContent(AppVariaveis().contasDebito),
                  TabContent(AppVariaveis().geralContas),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        shape: CircleBorder(),
        onPressed: () {
          Navigator.pushNamed(context, '/adicionarContas', arguments: {'tipo': 'adicionar'});
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
                  String ano = DateFormat('yyyy').format(data);

                  String mesSelecionadoFormatado = intMesToAbrev.entries
                      .firstWhere(
                        (entry) => entry.value == AppVariaveis().selecioneMesConta,
                        orElse: () => MapEntry(0, ''),
                      )
                      .key
                      .toString()
                      .padLeft(2, '0');

                  if ((AppVariaveis().selecioneMesConta == 'Todos' ||
                          mesAno.startsWith(mesSelecionadoFormatado)) &&
                      (AppVariaveis().selecioneAnoConta == 0 ||
                          ano == AppVariaveis().selecioneAnoConta.toString())) {
                    if (!contasPorMes.containsKey(mesAno)) {
                      contasPorMes[mesAno] = [];
                    }
                    contasPorMes[mesAno]!.add(doc);
                  }
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
    var stiloPg = doc.data()['estadoPago'] == 'Pago' ? cores('corTexto') : cores('corDespesas');
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
                          await FirebaseFirestore.instance
                              .collection('contas')
                              .doc(doc.data()['uidConta'])
                              .delete();
                        } catch (e) {
                          erro(context, 'Erro ao deletar contas: $e');
                        }
                        Navigator.of(context).pop();
                      },
                    ),
                    doc.data()['estadoRecebido'] == 'Pacientes'
                        ? TextButton(
                            child: const Text(
                              'Apagar Todos',
                              style: TextStyle(color: Colors.red),
                            ),
                            onPressed: () async {
                              try {
                                CollectionReference colecao = FirebaseFirestore.instance.collection('contas');
                                QuerySnapshot consulta = await colecao
                                    .where('uidPaciente', isEqualTo: doc.data()['uidPaciente'])
                                    .get();
                                for (QueryDocumentSnapshot doc in consulta.docs) {
                                  await colecao.doc(doc.id).delete();
                                }
                                sucesso(context, 'Contas apagados com sucesso!');
                              } catch (e) {
                                erro(context, 'Erro ao apagar contas: $e');
                              }
                              Navigator.of(context).pop();
                            },
                          )
                        : Column(),
                  ],
                );
              });
          carregarDados();
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
                      child: const Text(
                        'Editar',
                        style: TextStyle(color: Colors.blue),
                      ),
                      onPressed: () {
                        Navigator.pushNamed(context, '/adicionarContas',
                            arguments: {'tipo': 'editar', 'nomeConta': doc.data()['nomeConta']});
                      },
                    ),
                    TextButton(
                      child: const Text(
                        'Cancelar',
                        style: TextStyle(color: Colors.blue),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                );
              });
        },
        onLongPress: () async {
          DocumentReference docRef =
              FirebaseFirestore.instance.collection('contas').doc(doc.data()['uidConta']);
          if (doc.data()['estadoPago'] == 'Pago') {
            await docRef.update({
              'estadoPago': 'Não Pago',
            });
          } else {
            await docRef.update({
              'estadoPago': 'Pago',
            });
          }
          atualizarDados();
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
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(fontSize: 15, color: stiloPg),
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
