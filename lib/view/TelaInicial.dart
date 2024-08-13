import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import '../connections/fireCloudConsultas.dart';
import '../connections/fireCloudPacientes.dart';
import '../connections/fireCloudUser.dart';
import '../controllers/variaveis.dart';
import '../controllers/calcularFinanceiro.dart';
import '../controllers/estilos.dart';
import '../controllers/resolucoesTela.dart';
import '../widgets/helpDialog.dart';
import '../widgets/DrawerNavigation.dart';
import '../widgets/cardPaciente.dart';

class TelaInicial extends StatefulWidget {
  const TelaInicial({Key? key}) : super(key: key);

  @override
  State<TelaInicial> createState() => _TelaInicialState();
}

class _TelaInicialState extends State<TelaInicial> {
  NumberFormat numberFormat = NumberFormat("#,##0.00", "pt_BR");
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  ratioScreen ratio = ratioScreen();

  Future<void> atualizarDados() async {
    await carregarDados();
  }

  carregarDados() async {
    var financias = await calcularFinanceiro();
    var usuario = await listarUsuario();
    double rec = await calcularAReceber();
    double pag = await calcularAPagar();
    AppVariaveis().pacientes = await recuperarTodosPacientes();

    setState(() {
      AppVariaveis().entradas = financias['somaGanhos']!;
      AppVariaveis().saidas = financias['somaDespesas']!;
      AppVariaveis().saldo = financias['somaRenda']!;

      AppVariaveis().nome = usuario['nome']!;
      AppVariaveis().urlImage = usuario['urlImage']!;
      AppVariaveis().genero = usuario['genero']!;

      AppVariaveis().aReceber = rec;
      AppVariaveis().aPagar = pag;
    });
  }

  @override
  void initState() {
    super.initState();
    carregarDados();
  }

  Widget build(BuildContext context) {
    TamanhoWidgets tamanhoWidgets = TamanhoWidgets();
    TamanhoFonte tamanhoFonte = TamanhoFonte();

    return Scaffold(
        key: _scaffoldKey,
        drawer: DrawerNavigation(AppVariaveis().urlImage, AppVariaveis().genero, AppVariaveis().nome),
        body: RefreshIndicator(
            color: cores('corSimbolo'),
            onRefresh: atualizarDados,
            child: ListView(
              physics: AlwaysScrollableScrollPhysics(),
              children: [
                Stack(
                  children: [
                    ratio.screen(context) == 'pequeno'
                        ? Center(
                            child: Column(
                              children: [
                                const SizedBox(height: 60),
                                calendarHome(context, tamanhoWidgets, tamanhoFonte),
                                const SizedBox(height: 10),
                                contaHome(
                                    context,
                                    setState,
                                    tamanhoWidgets,
                                    tamanhoFonte,
                                    ratio,
                                    AppVariaveis().entradas,
                                    AppVariaveis().saidas,
                                    AppVariaveis().saldo,
                                    AppVariaveis().aReceber,
                                    AppVariaveis().aPagar,
                                    AppVariaveis().obscureNum),
                                const SizedBox(height: 10),
                              ],
                            ),
                          )
                        : Container(
                            padding: EdgeInsets.all(10),
                            child: Row(
                              children: [
                                Expanded(child: calendarHome(context, tamanhoWidgets, tamanhoFonte)),
                                const SizedBox(width: 10),
                                Expanded(
                                    child: prontuariosHome(context, setState, tamanhoWidgets, tamanhoFonte,
                                        AppVariaveis().varAtivoPaciente, AppVariaveis().pacientes))
                              ],
                            ),
                          ),
                    Container(
                      margin: EdgeInsets.only(right: 10, top: 10),
                      alignment: Alignment.topRight,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          kIsWeb || Platform.isWindows || Platform.isIOS
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
                          kIsWeb || Platform.isWindows || Platform.isIOS
                              ? Container()
                              : Consumer<AppVariaveis>(builder: (context, appVariaveis, child) {
                                  return IconButton(
                                    icon: Icon(
                                      AppVariaveis().obscureNum == false
                                          ? Icons.visibility_off
                                          : Icons.visibility,
                                      color: cores('corSimbolo'),
                                      size: tamanhoFonte.iconPequeno(context),
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        AppVariaveis().toggleObscureNum();
                                      });
                                    },
                                  );
                                }),
                          IconButton(
                            icon: Icon(
                              Icons.help,
                              color: cores('corSimbolo'),
                              size: tamanhoFonte.iconPequeno(context),
                            ),
                            onPressed: () {
                              helpDialog(context);
                            },
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
                      _calendarController.selectedDate = DateTime.now();
                      _calendarController.displayDate = DateTime.now();
                      return SfCalendar(
                        //timeZone: 'America/Sao_Paulo',
                        minDate: DateTime.now().subtract(Duration(days: 7)),
                        initialDisplayDate: DateTime.now(),
                        initialSelectedDate: DateTime.now(),
                        showTodayButton: true,
                        controller: _calendarController,
                        firstDayOfWeek: 7,
                        showDatePickerButton: true,
                        dataSource: dataSource,
                        headerDateFormat: 'MMM yyyy',
                        todayHighlightColor: cores('corSimbolo'),
                        onTap: (CalendarTapDetails details) {
                          if (details.targetElement == CalendarElement.appointment) {
                            Appointment? tappedAppointment = details.appointments!.first;
                            DateTime dataClicada = details.date!;
                            Navigator.pushNamed(context, '/adicionarProntuarios', arguments: {
                              'tipo': 'adicionar',
                              'tappedAppointment': tappedAppointment,
                              'dataClicada': dataClicada
                            });
                          }
                        },
                        headerStyle: CalendarHeaderStyle(
                            textStyle: TextStyle(color: cores('corTexto'), fontSize: 20),
                            textAlign: TextAlign.center,
                            backgroundColor: cores('corDetalhe')),
                        view: CalendarView.schedule,
                        scheduleViewSettings: ScheduleViewSettings(
                          hideEmptyScheduleWeek: true,
                          appointmentTextStyle:
                              TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.white),
                          weekHeaderSettings: WeekHeaderSettings(height: 0),
                          monthHeaderSettings: MonthHeaderSettings(
                              monthFormat: 'MMM yyyy',
                              height: 50,
                              textAlign: TextAlign.center,
                              backgroundColor: cores('corDetalhe'),
                              monthTextStyle: TextStyle(
                                  color: cores('corTexto'), fontSize: 15, fontWeight: FontWeight.w500)),
                          dayHeaderSettings: DayHeaderSettings(
                              dayFormat: 'EEE',
                              width: 50,
                              dayTextStyle: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: cores('corTexto'),
                              ),
                              dateTextStyle: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: cores('corSimbolo'),
                              )),
                        ),
                      );
                    }
                }
              },
            ),
          ),
        ),
        SizedBox(height: 20),
      ],
    ),
  );
}

contaHome(context, setState, tamanhoWidgets, tamanhoFonte, ratio, entradas, saidas, saldo, aReceber, aPagar,
    obscureNum) {
  NumberFormat numberFormat = NumberFormat("#,##0.00", "pt_BR");

  return Container(
    width: tamanhoWidgets.getWidth(context),
    decoration: decoracaoContainer('decPadrao'),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Text('Resumo Financeiro', style: textStyle(context, 'styleTitulo')),
        SizedBox(height: 10),
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
                    'Entrada',
                    style: TextStyle(
                      color: cores('corTextoPadrao'),
                      fontSize: tamanhoFonte.letraPequena(context),
                    ),
                  ),
                  Text(
                    obscureNum == true ? 'R\$ ${numberFormat.format(entradas)}' : '${"⬮" * 4}',
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
                    'Saída',
                    style: TextStyle(
                      color: cores('corTextoPadrao'),
                      fontSize: tamanhoFonte.letraPequena(context),
                    ),
                  ),
                  Text(
                    obscureNum == true ? 'R\$ ${numberFormat.format(saidas)}' : '${"⬮" * 4}',
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
        SizedBox(height: 10),
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
              obscureNum == true ? 'R\$ ${numberFormat.format(saldo)}' : '${"⬮" * 4}',
              style: TextStyle(
                  color: cores('corTextoPadrao'),
                  fontSize: tamanhoFonte.letraMedia(context),
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
        SizedBox(height: 10),
        Container(
          margin: EdgeInsets.all(10),
          decoration: decoracaoContainer('decPadrao'),
          child: Column(
            children: [
              Text('Fluxo de Caixa', style: textStyle(context, 'styleSubtitulo')),
              SizedBox(height: 10),
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
                            style: TextStyle(
                                color: cores('corTextoPadrao'), fontSize: tamanhoFonte.letraPequena(context)),
                          ),
                          Text(
                            obscureNum == true ? 'R\$ ${numberFormat.format(aReceber)}' : '${"⬮" * 4}',
                            style: TextStyle(
                                color: cores('corReceitas'),
                                fontSize: tamanhoFonte.letraMedia(context),
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 5),
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
                                  color: cores('corTextoPadrao'),
                                  fontSize: tamanhoFonte.letraPequena(context)),
                            ),
                            Text(
                              obscureNum == true ? 'R\$ ${numberFormat.format(aPagar)}' : '${"⬮" * 4}',
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
              SizedBox(height: 10),
            ],
          ),
        ),
      ],
    ),
  );
}

prontuariosHome(context, setState, tamanhoWidgets, tamanhoFonte, varAtivo, pacientes) {
  final ScrollController _scrollController = ScrollController();

  return Container(
    width: tamanhoWidgets.getWidth(context),
    height: tamanhoWidgets.getHeight(context),
    decoration: decoracaoContainer('decPadrao'),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text('Prontuários', style: textStyle(context, 'styleTitulo')),
        SizedBox(height: 10),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.85,
          child: StreamBuilder<QuerySnapshot>(
            stream: pacientes != null
                ? pacientes.orderBy('nomePaciente').where('ativoPaciente', isEqualTo: varAtivo).snapshots()
                : null,
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
                  return Scrollbar(
                      controller: _scrollController,
                      trackVisibility: true,
                      thumbVisibility: true,
                      interactive: true,
                      thickness: 20.0,
                      child: ListView.separated(
                        controller: _scrollController,
                        padding: EdgeInsets.all(10),
                        scrollDirection: Axis.vertical,
                        itemBuilder: (context, index) =>
                            listarPaciente(context, dados.docs[index], 'prontuario'),
                        separatorBuilder: (context, _) => SizedBox(
                          width: 1,
                        ),
                        itemCount: dados.size,
                      ));
              }
            },
          ),
        ),
      ],
    ),
  );
}
