import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firedart/firedart.dart' as fd;
import 'package:flutter/material.dart';
import 'package:fono/view/TelaAdicionarAgenda.dart';
import 'package:fono/view/TelaEditarAgenda.dart';
import 'package:fono/view/TelaInicial.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import '../controllers/estilos.dart';

class TelaAgenda extends StatefulWidget {
  final String uidFono;

  const TelaAgenda(this.uidFono, {super.key});

  @override
  State<TelaAgenda> createState() => _TelaAgendaState();
}

class _TelaAgendaState extends State<TelaAgenda> {
  CalendarController _controller = CalendarController();
  List<String> itensMenu = ["Dia", "Semana", "Mês"];
  late Future<List<Appointment>> _futureAppointments;
  List<Appointment> appointments = [];
  var windowsIdFono;
  var consultas;
  var uidFono;

  Future<void> buscarId() async {
    var userId = await fd.FirebaseAuth.instance.getUser();
    windowsIdFono = userId.id;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _futureAppointments = getAppointmentsFromFirestore();
    if (kIsWeb || Platform.isAndroid || Platform.isIOS) {
      uidFono = FirebaseAuth.instance.currentUser!.uid.toString();
    } else {
      buscarId();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: cores('corSimbolo')),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: cores('corSimbolo'),),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          "Agenda",
          style: TextStyle(color: cores('corTexto')),
        ),
        backgroundColor: cores('corTerciaria'),
      ),
      body: FutureBuilder<List<Appointment>>(
        future: _futureAppointments,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return SfCalendar(
              viewHeaderHeight: 75,
              headerHeight: 50,
              showDatePickerButton: true,
              showNavigationArrow: true,
              headerStyle: CalendarHeaderStyle(
                  textStyle: TextStyle(color: cores('corTexto'), fontSize: 20),
                  textAlign: TextAlign.center,
                  backgroundColor: cores('corTerciaria')),
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
                if (details.appointments != null && details.appointments!.isNotEmpty && _controller.view != CalendarView.month) {
                  Appointment tappedAppointment = details.appointments!.first;
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TelaEditarAgenda(
                        widget.uidFono,
                        tappedAppointment,
                      ),
                    ),
                  );
                  setState(() async {
                    appointments = await getAppointmentsFromFirestore();
                    _futureAppointments = Future<List<Appointment>>.value(appointments);
                  });
                } else if (details.targetElement == CalendarElement.agenda) {
                  Appointment tappedAppointment = details.appointments!.first;
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TelaEditarAgenda(
                        widget.uidFono,
                        tappedAppointment,
                      ),
                    ),
                  );
                  setState(() {
                    _futureAppointments = getAppointmentsFromFirestore();
                  });
                }
              },
              dataSource: MeetingDataSource(_futureAppointments),
              monthViewSettings: MonthViewSettings(showAgenda: true),
            );
          } else if (snapshot.hasError) {
            return Text(snapshot.error.toString());
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => TelaAdicionarAgenda(widget.uidFono),
              ));
          setState(() {
            _futureAppointments = getAppointmentsFromFirestore();
          });
        },
        child: Icon(
          Icons.add,
          color: cores('rosa_fraco'),
        ),
        backgroundColor: cores('verde'),
      ),
    );
  }

  Future<List<Appointment>> getAppointmentsFromFirestore() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('consulta').where('uidFono', isEqualTo: uidFono).get();

      querySnapshot.docs.forEach((doc) {
        var colorConsulta = doc['colorConsulta'];
        var dataConsulta = doc['dataConsulta'];
        var duracaoConsulta = doc['duracaoConsulta'];
        var frequenciaConsulta = doc['frequenciaConsulta'];
        var horarioConsulta = doc['horarioConsulta'];
        var nomePaciente = doc['nomePaciente'];
        var semanaConsulta = doc['semanaConsulta'];

        DateFormat dateFormat = DateFormat('dd/MM/yyyy');
        DateTime dateTime = dateFormat.parseStrict(dataConsulta);

        List<String> timeConsulta = horarioConsulta.split(':');
        int horasConsulta = int.parse(timeConsulta[0]);
        int minutesConsulta = int.parse(timeConsulta[1]);

        List<String> durConsulta = duracaoConsulta.split(':');
        int horasDuracaoConsulta = int.parse(durConsulta[0]);
        int minutesDuracaoConsulta = int.parse(durConsulta[1]);

        final DateTime startTime = DateTime(dateTime.year, dateTime.month, dateTime.day, horasConsulta, minutesConsulta);
        final DateTime endTime = startTime.add(Duration(hours: horasDuracaoConsulta, minutes: minutesDuracaoConsulta));

        appointments.add(Appointment(
          startTime: startTime,
          endTime: endTime,
          subject: nomePaciente,
          color: Color(int.parse('0xFF$colorConsulta')),
          recurrenceRule: 'FREQ=$frequenciaConsulta;BYDAY=$semanaConsulta',
          isAllDay: false,
        ));
      });
    } catch (e) {
      print('Erro ao buscar dados do Firestore: $e');
    }
    return appointments;
  }
}

class MeetingDataSource extends CalendarDataSource {
  MeetingDataSource(Future<List<Appointment>> futureAppointments) {
    futureAppointments.then((appointments) {
      this.appointments = appointments;
    });
  }
}
