import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fono/controllers/calcularFinanceiro.dart';
import 'package:fono/view/TelaAdicionarProntuarios.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import '../connections/fireCloudConsultas.dart';
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

  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  Future<void> atualizarDados() async {
    await carregarDados();
  }

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

  @override
  void initState() {
    super.initState();
    carregarDados();
  }

  @override
  Widget build(BuildContext context) {
    TamanhoWidgets tamanhoWidgets = TamanhoWidgets();
    TamanhoFonte tamanhoFonte = TamanhoFonte();

    return Scaffold(
        key: _scaffoldKey,
        drawer: DrawerNavigation(urlImage!, genero!, nome!),
        body: RefreshIndicator(
            color: cores('corSimbolo'),
            onRefresh: atualizarDados,
            child: ListView(
              children: [
                Stack(
                  children: [
                    ratio.screen(context) == 'pequeno'
                        ? Center(
                            child: Column(
                              children: [
                                const SizedBox(
                                  height: 60,
                                ),
                                calendarHome(context, tamanhoWidgets, tamanhoFonte),
                                const SizedBox(
                                  height: 10,
                                ),
                                contaHome(context, setState, tamanhoWidgets, tamanhoFonte, ratio, receitas, despesas,
                                    saldo, aReceber, aPagar, _obscureText),
                              ],
                            ),
                          )
                        : Container(
                            padding: EdgeInsets.all(10),
                            child: Row(
                              children: [
                                Expanded(
                                  child: calendarHome(context, tamanhoWidgets, tamanhoFonte),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                  child: contaHome(context, setState, tamanhoWidgets, tamanhoFonte, ratio, receitas,
                                      despesas, saldo, aReceber, aPagar, _obscureText),
                                ),
                              ],
                            ),
                          ),
                    Container(
                      margin: EdgeInsets.only(right: 10, top: 10),
                      alignment: Alignment.topRight,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          kIsWeb || Platform.isWindows
                              ? IconButton(
                                  icon: Icon(
                                    Icons.refresh,
                                    color: cores('corSimbolo'),
                                    size: tamanhoFonte.iconPequeno(context),
                                  ),
                                  onPressed: () {
                                    atualizarDados();
                                  },
                                )
                              : Container(),
                          IconButton(
                            icon: Icon(
                              _obscureText == false ? Icons.visibility_off : Icons.visibility,
                              color: cores('corSimbolo'),
                              size: tamanhoFonte.iconPequeno(context),
                            ),
                            onPressed: _toggle,
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.help,
                              color: cores('corSimbolo'),
                              size: tamanhoFonte.iconPequeno(context),
                            ),
                            onPressed: () {},
                          ),
                        ],
                      ),
                    ),
                    SafeArea(
                      child: GestureDetector(
                        onTap: () {
                          _scaffoldKey.currentState!.openDrawer();
                        },
                        child: Container(
                          margin: EdgeInsets.only(left: 10, top: 16),
                          height: tamanhoFonte.iconPequeno(context),
                          width: tamanhoFonte.iconPequeno(context),
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
            )));
  }
}

calendarHome(context, tamanhoWidgets, tamanhoFonte) {
  final CalendarController _calendarController = CalendarController();

  return Container(
    width: tamanhoWidgets.getWidth(context),
    height: tamanhoWidgets.getHeight(context),
    decoration: decoracaoContainer('decPadrao'),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text('Próximos Horários', style: textStyle(context, 'styleTitulo')),
        Expanded(
          child: Container(
            child: FutureBuilder<DataSource>(
              future: getDataSource(),
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
                    if (snapshot.hasError) {
                      return Center(
                        child: Text('Erro: ${snapshot.error}'),
                      );
                    } else {
                      DataSource dataSource = snapshot.data!;
                      return SfCalendar(
                        minDate: DateTime.now(),
                        showTodayButton: true,
                        controller: _calendarController,
                        showWeekNumber: false,
                        firstDayOfWeek: 7,
                        showDatePickerButton: true,
                        dataSource: dataSource,
                        headerDateFormat: 'MMM yyyy',
                        todayHighlightColor: cores('corSimbolo'),
                        onTap: (CalendarTapDetails details) {
                          if (details.targetElement == CalendarElement.appointment) {
                            Appointment tappedAppointment = details.appointments!.first;
                            DateTime dataClicada = details.date!;
                            String tipo = 'adicionar';
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => TelaAdicionarProntuarios(tipo, tappedAppointment, dataClicada),
                              ),
                            );
                          }
                        },
                        headerStyle: CalendarHeaderStyle(
                            textStyle: TextStyle(color: cores('corTexto'), fontSize: 20),
                            textAlign: TextAlign.center,
                            backgroundColor: cores('corDetalhe')),
                        view: CalendarView.schedule,
                        scheduleViewSettings: ScheduleViewSettings(
                            weekHeaderSettings: WeekHeaderSettings(
                              height: 0,
                            ),
                            monthHeaderSettings: MonthHeaderSettings(
                                monthFormat: 'MMM yyyy',
                                height: 45,
                                textAlign: TextAlign.center,
                                backgroundColor: cores('corDetalhe'),
                                monthTextStyle:
                                    TextStyle(color: cores('corTexto'), fontSize: 15, fontWeight: FontWeight.w500)),
                            hideEmptyScheduleWeek: true,
                            dayHeaderSettings: DayHeaderSettings(
                                dayFormat: 'EEE',
                                width: 50,
                                dayTextStyle: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                  color: cores('corTexto'),
                                ),
                                dateTextStyle: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                  color: cores('corSimbolo'),
                                )),
                            appointmentTextStyle:
                                TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.white)),
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

contaHome(
    context, setState, tamanhoWidgets, tamanhoFonte, ratio, receitas, despesas, saldo, aReceber, aPagar, _obscureText) {
  NumberFormat numberFormat = NumberFormat("#,##0.00", "pt_BR");

  return Container(
    width: tamanhoWidgets.getWidth(context),
    height: tamanhoWidgets.getHeight(context),
    decoration: decoracaoContainer('decPadrao'),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Text('Resumo Financeiro', style: textStyle(context, 'styleTitulo')),
        SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Container(
              alignment: Alignment.center,
              width: ratio.screen(context) == 'pequeno'
                  ? tamanhoWidgets.outroWidth(context, 0.37)
                  : tamanhoWidgets.outroHeight(context, 0.25),
              height: ratio.screen(context) == 'pequeno'
                  ? tamanhoWidgets.outroWidth(context, 0.37)
                  : tamanhoWidgets.outroHeight(context, 0.25),
              decoration: decoracaoContainer('decPadrao'),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Icon(
                    Icons.trending_up,
                    color: cores('corReceitas'),
                    size: tamanhoFonte.iconMedio(context),
                  ),
                  Text(
                    'Receitas',
                    style: TextStyle(
                      color: cores('corTextoPadrao'),
                      fontSize: tamanhoFonte.letraPequena(context),
                    ),
                  ),
                  Text(
                    _obscureText == true ? 'R\$ ${numberFormat.format(receitas)}' : '${"⬮" * 4}',
                    style: TextStyle(
                        color: cores('corReceitas'),
                        fontSize: tamanhoFonte.letraMedia(context),
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            Container(
              alignment: Alignment.center,
              width: ratio.screen(context) == 'pequeno'
                  ? tamanhoWidgets.outroWidth(context, 0.37)
                  : tamanhoWidgets.outroHeight(context, 0.25),
              height: ratio.screen(context) == 'pequeno'
                  ? tamanhoWidgets.outroWidth(context, 0.37)
                  : tamanhoWidgets.outroHeight(context, 0.25),
              decoration: decoracaoContainer('decPadrao'),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Icon(
                    Icons.trending_down,
                    color: cores('corDespesas'),
                    size: tamanhoFonte.iconMedio(context),
                  ),
                  Text(
                    'Despesas',
                    style: TextStyle(
                      color: cores('corTextoPadrao'),
                      fontSize: tamanhoFonte.letraPequena(context),
                    ),
                  ),
                  Text(
                    _obscureText == true ? 'R\$ ${numberFormat.format(despesas)}' : '${"⬮" * 4}',
                    style: TextStyle(
                        color: cores('corDespesas'),
                        fontSize: tamanhoFonte.letraMedia(context),
                        fontWeight: FontWeight.bold),
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
              style: TextStyle(
                  color: cores('corTextoPadrao'),
                  fontSize: tamanhoFonte.letraMedia(context),
                  fontWeight: FontWeight.bold),
            ),
            Text(
              _obscureText == true ? 'R\$ ${numberFormat.format(saldo)}' : '${"⬮" * 4}',
              style: TextStyle(
                  color: cores('corTextoPadrao'),
                  fontSize: tamanhoFonte.letraMedia(context),
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
        SizedBox(
          height: 10,
        ),
        Container(
          margin: EdgeInsets.all(10),
          decoration: decoracaoContainer('decPadrao'),
          child: Column(
            children: [
              Text('Fluxo de Caixa', style: textStyle(context, 'styleSubtitulo')),
              SizedBox(
                height: 10,
              ),
              Column(
                //mainAxisAlignment: MainAxisAlignment.center,
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
                        size: tamanhoFonte.iconPequeno(context),
                      ),
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'A Receber',
                            style:
                                TextStyle(color: cores('corTextoPadrao'), fontSize: tamanhoFonte.letraPequena(context)),
                          ),
                          Text(
                            _obscureText == true ? 'R\$ ${numberFormat.format(aReceber)}' : '${"⬮" * 4}',
                            style: TextStyle(
                                color: cores('corReceitas'),
                                fontSize: tamanhoFonte.letraMedia(context),
                                fontWeight: FontWeight.bold),
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
                          size: tamanhoFonte.iconPequeno(context),
                        ),
                        title: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'A Pagar',
                              style: TextStyle(
                                  color: cores('corTextoPadrao'), fontSize: tamanhoFonte.letraPequena(context)),
                            ),
                            Text(
                              _obscureText == true ? 'R\$ ${numberFormat.format(aPagar)}' : '${"⬮" * 4}',
                              style: TextStyle(
                                  color: cores('corDespesas'),
                                  fontSize: tamanhoFonte.letraMedia(context),
                                  fontWeight: FontWeight.bold),
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
