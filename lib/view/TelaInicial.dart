import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fono/controllers/calcularFinanceiro.dart';
import 'package:intl/intl.dart';

import '../connections/fireAuth.dart';
import '../connections/fireCloudUser.dart';
import '../controllers/estilos.dart';
import '../controllers/resolucoesTela.dart';
import '../widgets/DrawerNavigation.dart';

class TelaInicial extends StatefulWidget {
  const TelaInicial({Key? key}) : super(key: key);

  @override
  State<TelaInicial> createState() => _TelaInicialState();
}

class _TelaInicialState extends State<TelaInicial> {
  NumberFormat numberFormat = NumberFormat("#,##0.00", "pt_BR");
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  ratioScreen ratio = ratioScreen();

  late var uidFono = '';
  late String? nome = '';
  late String? urlImage = '';
  late String? genero = 'Gender.male';
  late double? receitas = 0.0;
  late double? despesas = 0.0;
  late double? saldo = 0.0;
  late double? aReceber = 0.0;
  late double? aPagar = 0.0;
  bool _obscureText = false;

  carregarDados() async {
    var financias = await calcularFinanceiro();
    var usuario = await listarUsuario();
    double rec = await calcularAReceber();
    double pag = await calcularAPagar();

    setState(() {
      receitas = financias['somaGanhos'];
      despesas = financias['somaDespesas'];
      saldo = financias['somaRenda'];

      nome = usuario['nome'];
      urlImage = usuario['urlImage'];
      genero = usuario['genero'];

      aReceber = rec;
      aPagar = pag;
    });
  }

  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  void initState() {
    super.initState();
    carregarDados();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        drawer: DrawerNavigation(uidFono, urlImage!, genero!, nome!),
        body: ListView(
          padding: EdgeInsets.only(bottom: 20),
          children: [
            Stack(
              children: [
                ratio.screen(context) == 'pequeno'
                    ? Center(
                        child: Column(
                          children: [
                            SizedBox(
                              height: 40,
                            ),
                            Container(
                              padding: EdgeInsets.only(right: 10),
                              alignment: Alignment.topRight,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  IconButton(
                                    icon: Icon(
                                      _obscureText == false ? Icons.visibility_off : Icons.visibility,
                                      color: cores('corSimbolo'),
                                      size: 35,
                                    ),
                                    onPressed: _toggle,
                                  ),
                                  IconButton(
                                    icon: Icon(
                                      Icons.help,
                                      color: cores('corSimbolo'),
                                      size: 30,
                                    ),
                                    onPressed: (){},
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            contaHome(context, setState, receitas, despesas, saldo, aReceber, aPagar, _obscureText),
                            SizedBox(
                              height: 20,
                            ),
                            calendarHome(context),
                          ],
                        ),
                      )
                    : Row(
                        children: [
                          SizedBox(
                            height: 50,
                          ),
                          contaHome(context, setState, receitas, despesas, saldo, aReceber, aPagar, _obscureText),
                          SizedBox(
                            height: 20,
                          ),
                          calendarHome(context),
                        ],
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
                      decoration: decoracaoContainer('decDraw'),
                      child: Icon(
                        Icons.menu,
                        color: cores('corSimbolo'),
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

contaHome(context, setState, receitas, despesas, saldo, aReceber, aPagar, _obscureText) {
  NumberFormat numberFormat = NumberFormat("#,##0.00", "pt_BR");

  return Container(
    padding: EdgeInsets.all(10),
    width: MediaQuery.of(context).size.width * 0.9,
    decoration: decoracaoContainer('decPadrao'),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Text('Resumo Financeiro',
            style: textStyle('styleTitulo')),
        SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Container(
              alignment: Alignment.center,
              width: 150,
              decoration: decoracaoContainer('decPadrao'),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Icon(
                    Icons.trending_up,
                    color: cores('corReceitas'),
                    size: 80,
                  ),
                  Text(
                    'Receitas',
                    style: TextStyle(
                      color: cores('corTextoPadrao'),
                      fontSize: 17,
                    ),
                  ),
                  Text(
                    _obscureText == true ? 'R\$ ${numberFormat.format(receitas)}' : '${"⬮" * 4}',
                    style: TextStyle(color: cores('corReceitas'), fontSize: 26, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            Container(
              alignment: Alignment.center,
              width: 150,
              decoration: decoracaoContainer('decPadrao'),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Icon(
                    Icons.trending_down,
                    color: cores('corDespesas'),
                    size: 80,
                  ),
                  Text(
                    'Despesas',
                    style: TextStyle(
                      color: cores('corTextoPadrao'),
                      fontSize: 17,
                    ),
                  ),
                  Text(
                    _obscureText == true ? 'R\$ ${numberFormat.format(despesas)}' : '${"⬮" * 4}',
                    style: TextStyle(color: cores('corDespesas'), fontSize: 26, fontWeight: FontWeight.bold),
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
              style: TextStyle(color: cores('corTextoPadrao'), fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Text(
              _obscureText == true ? 'R\$ ${numberFormat.format(saldo)}' : '${"⬮" * 4}',
              style: TextStyle(color: cores('corTextoPadrao'), fontSize: 26, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        SizedBox(
          height: 20,
        ),
        Container(
          width: MediaQuery.of(context).size.longestSide,
          decoration: decoracaoContainer('decPadrao'),
          child: Column(
            children: [
              Text('Fluxo de Caixa',
                  style: textStyle('styleSubtitulo')),
              SizedBox(
                height: 10,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Card(
                    color: cores('corReceitasCard'),
                    elevation: 7,
                    shadowColor: cores('corSombra'),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    margin: EdgeInsets.all(5),
                    child: ListTile(
                      trailing: Icon(
                        Icons.account_balance,
                        color: cores('corTextoPadrao'),
                        size: 40,
                      ),
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'A Receber',
                            style: TextStyle(color: cores('corTextoPadrao'), fontSize: 18),
                          ),
                          Text(
                            _obscureText == true ? 'R\$ ${numberFormat.format(aReceber)}' : '${"⬮" * 4}',
                            style: TextStyle(color: cores('corReceitas'), fontSize: 26, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Card(
                    color: cores('corDespesasCard'),
                    elevation: 7,
                    shadowColor: cores('corSombra'),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    margin: EdgeInsets.all(5),
                    child: ListTile(
                        trailing: Icon(
                          Icons.credit_card,
                          color: cores('corTextoPadrao'),
                          size: 40,
                        ),
                        title: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'A Pagar',
                              style: TextStyle(color: cores('corTextoPadrao'), fontSize: 18),
                            ),
                            Text(
                              _obscureText == true ? 'R\$ ${numberFormat.format(aPagar)}' : '${"⬮" * 4}',
                              style: TextStyle(color: cores('corDespesas'), fontSize: 26, fontWeight: FontWeight.bold),
                            ),
                          ],
                        )),
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
    decoration: decoracaoContainer('decPadrao'),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text('Próximos Horários',
            style: TextStyle(color: cores('corTitulo'), fontSize: 40, fontWeight: FontWeight.bold)),
        Container(
          alignment: Alignment.topCenter,
          padding: EdgeInsets.all(5),
          width: MediaQuery.of(context).size.width * 0.8,
          decoration: decoracaoContainer('decPadrao'),
          child: Padding(
            padding: const EdgeInsets.all(1),
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('consulta')
                  .where('uidFono', isEqualTo: idUsuario())
                  .snapshots(),
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.none:
                    return Center(
                      child: Text('Não foi possível conectar.'),
                    );
                  case ConnectionState.waiting:
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  default:
                    final dados = snapshot.requireData;
                    if (dados.size > 0) {
                      return ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: dados.size,
                        itemBuilder: (context, index) {
                          String id = dados.docs[index].id;
                          dynamic item = dados.docs[index].data();
                          return Card(
                            color: cores('corTerciaria'),
                            elevation: 5,
                            shadowColor: cores('corSombra'),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            margin: EdgeInsets.all(5),
                            child: ListTile(
                              leading: Icon(Icons.calendar_month, color: cores('corSimboloPadrao'),),
                              title: Text(
                                item['nomePaciente'],
                                style: TextStyle(color: cores('corTextoPadrao'), fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                              subtitle: Text(
                                item['dataConsulta'],
                                style: TextStyle(
                                  color: cores('corTextoPadrao'),
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    } else {
                      return Center(
                        child: Text('Nenhuma tarefa encontrada.'),
                      );
                    }
                }
              },
            ),
          ),
        ),
        SizedBox(
          height: 20,
        ),
      ],
    ),
  );
}
