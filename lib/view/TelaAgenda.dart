import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fono/view/TelaAdicionarAgenda.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import '../connections/fireCloudConsultas.dart';
import '../controllers/estilos.dart';

class TelaAgenda extends StatefulWidget {
  const TelaAgenda({super.key});

  @override
  State<TelaAgenda> createState() => _TelaAgendaState();
}

class _TelaAgendaState extends State<TelaAgenda> {
  CalendarController _controller = CalendarController();
  late Future<List<Appointment>> _futureAppointments;
  List<Appointment> appointments = [];
  var consultas;

  Future<void> atualizarDados() async {
    setState(() {
      _futureAppointments = getAppointmentsFromFirestore();
    });
  }

  @override
  void initState() {
    super.initState();
    atualizarDados();
  }

  @override
  Widget build(BuildContext context) {
    TamanhoWidgets tamanhoWidgets = TamanhoWidgets();
    TamanhoFonte tamanhoFonte = TamanhoFonte();

    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: Icon(
              Icons.refresh,
              color: cores('corSimbolo'),
            ),
            onPressed: () async {
              await atualizarDados();
            },
          ),
        ],
        iconTheme: IconThemeData(color: cores('corSimbolo')),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: cores('corSimbolo'),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          "Agenda",
          style: TextStyle(color: cores('corTexto')),
        ),
        backgroundColor: cores('corFundo'),
      ),
      body: FutureBuilder<List<Appointment>>(
        future: _futureAppointments,
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
              return SfCalendar(
                showTodayButton: true,
                viewHeaderHeight: 75,
                headerHeight: 50,
                showDatePickerButton: true,
                showNavigationArrow: true,
                headerStyle: CalendarHeaderStyle(
                    textStyle: TextStyle(color: cores('corTexto'), fontSize: 20),
                    textAlign: TextAlign.center,
                    backgroundColor: cores('corFundo')),
                headerDateFormat: 'MMMM y',
                todayHighlightColor: cores('corTexto'),
                view: CalendarView.week,
                allowedViews: [
                  CalendarView.day,
                  CalendarView.week,
                  CalendarView.month,
                ],
                selectionDecoration: BoxDecoration(
                    color: Colors.transparent,
                    border: Border.all(color: Colors.purpleAccent, width: 2),
                    borderRadius: const BorderRadius.all(Radius.circular(4)),
                    shape: BoxShape.rectangle),
                controller: _controller,
                firstDayOfWeek: 7,
                onTap: (CalendarTapDetails details) async {
                  if (details.appointments != null &&
                      details.appointments!.isNotEmpty &&
                      _controller.view != CalendarView.month) {
                    Appointment tappedAppointment = details.appointments!.first;
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TelaAdicionarAgenda(
                          'editar',
                          tappedAppointment,
                        ),
                      ),
                    );
                  } /*else if (details.targetElement == CalendarElement.agenda) {
                    Appointment tappedAppointment = details.appointments!.first;
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            TelaEditarAgenda(
                              idUsuario(),
                              tappedAppointment,
                            ),
                      ),
                    );
                    setState(() {
                      _futureAppointments = getAppointmentsFromFirestore();
                    });
                  }*/
                },
                dataSource: MeetingDataSource(_futureAppointments),
                monthViewSettings: MonthViewSettings(showAgenda: true),
              );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        shape: CircleBorder(),
        onPressed: () async {
          Appointment tappedAppointment = Appointment(
            startTime: DateTime.now(),
            endTime: DateTime.now(),
          );
          String adicionar = 'adicionar';
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => TelaAdicionarAgenda(adicionar, tappedAppointment),
              ));
          //atualizarDados();
        },
        child: Icon(
          Icons.add,
          size: tamanhoFonte.iconPequeno(context),
          color: cores('corTextoBotao'),
        ),
        backgroundColor: cores('corBotao'),
      ),
    );
  }
}
