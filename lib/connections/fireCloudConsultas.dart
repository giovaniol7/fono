import 'dart:io';
import 'package:flutter/foundation.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firedart/firedart.dart' as fd;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import '../widgets/mensagem.dart';
import 'fireAuth.dart';

String nomeColecao = 'consulta';

retornarIDConsultas() async {
  if (kIsWeb || Platform.isAndroid || Platform.isIOS) {
    await listarConsultas().get().then((us) {
      return us.docs[0].id;
    });
  } else {
    await listarConsultas().get().then((us) {
      if (us.isNotEmpty) {
        us.forEach((doc) {
          return doc.id;
        });
      }
    });
  }
}

listarConsultas() async {
  if (kIsWeb || Platform.isAndroid || Platform.isIOS) {
    return FirebaseFirestore.instance.collection(nomeColecao).where('uidFono', isEqualTo: idUsuario());
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
    String uidFono = user.id;

    return fd.Firestore.instance.collection(nomeColecao).where('uidFono', isEqualTo: uidFono);
  }
}

editarConsultas(context, id, uidFono, uidPaciente, nomePaciente, dataConsulta, horarioConsulta, duracaoConsulta,
    frequenciaConsulta, semanaConsulta, colorConsulta) async {
  Map<String, dynamic> data = {
    'uidFono': uidFono,
    'nomePaciente': nomePaciente,
    'uidPaciente': uidPaciente,
    'dataConsulta': dataConsulta,
    'horarioConsulta': horarioConsulta,
    'duracaoConsulta': duracaoConsulta,
    'frequenciaConsulta': frequenciaConsulta,
    'semanaConsulta': semanaConsulta,
    'colorConsulta': colorConsulta,
  };
  await FirebaseFirestore.instance.collection('consulta').doc(retornarIDConsultas()).update(data);
  sucesso(context, 'O horário foi alterado com sucesso.');
  Navigator.pop(context);
}

adicionarConsultas(context, uidFono, nomePaciente, dataConsulta, horarioConsulta, duracaoConsulta, frequenciaConsulta,
    semanaConsulta, colorConsulta) async {
  QuerySnapshot querySnapshot =
      await FirebaseFirestore.instance.collection('pacientes').where('nomePaciente', isEqualTo: nomePaciente).get();
  String uidPaciente = querySnapshot.docs[0].id;
  Map<String, dynamic> data = {
    'uidFono': uidFono,
    'uidPaciente': uidPaciente,
    'nomePaciente': nomePaciente,
    'dataConsulta': dataConsulta,
    'horarioConsulta': horarioConsulta,
    'duracaoConsulta': duracaoConsulta,
    'frequenciaConsulta': frequenciaConsulta,
    'semanaConsulta': semanaConsulta,
    'colorConsulta': colorConsulta,
  };
  FirebaseFirestore.instance.collection('consulta').add(data);
  sucesso(context, 'O horário foi agendado com sucesso.');
  Navigator.pop(context);
}

//Calendario
Future<List<Appointment>> getAppointmentsFromFirestore() async {
  List<Appointment> appointments = [];

  try {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection(nomeColecao).where('uidFono', isEqualTo: idUsuario()).get();

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

class MeetingDataSource extends CalendarDataSource {
  MeetingDataSource(Future<List<Appointment>> futureAppointments) {
    futureAppointments.then((appointments) {
      this.appointments = appointments;
    });
  }
}

Future<DataSource> getDataSource() async {
  List<Appointment> appointments = [];

  try {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection(nomeColecao).where('uidFono', isEqualTo: idUsuario()).get();

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
  return DataSource(appointments);
}

class DataSource extends CalendarDataSource {
  DataSource(List<Appointment> source) {
    appointments = source;
  }
}