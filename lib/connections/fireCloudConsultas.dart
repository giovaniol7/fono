import 'dart:io';
import 'package:flutter/foundation.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import '../models/maps.dart';
import '../widgets/mensagem.dart';
import 'fireAuth.dart';
import 'fireCloudPacientes.dart';

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
  return FirebaseFirestore.instance.collection(nomeColecao).where('uidFono', isEqualTo: idUsuario());
}

/*  //if (kIsWeb || Platform.isAndroid || Platform.isIOS) {
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
  }*/

Future<Map<String, String>> buscarPorNomeConsultas(context, nome) async {
  String id = '';
  String uidPaciente = '';
  Map<String, String> consultas = {};

  await FirebaseFirestore.instance.collection(nomeColecao).where('nomePaciente', isEqualTo: nome).get().then((q) {
    if (q.docs.isNotEmpty) {
      id = q.docs[0].id;
      uidPaciente = q.docs[0].data()['uidPaciente'];
    }
  });

  consultas = {
    'id': id,
    'uidPaciente': uidPaciente,
  };

  return consultas;
}

adicionarConsultas(context, nomePaciente, dataConsulta, horarioConsulta, duracaoConsulta, frequenciaConsulta,
    semanaConsulta, colorConsulta) async {
  QuerySnapshot querySnapshot =
      await FirebaseFirestore.instance.collection(nomeColecao).where('nomePaciente', isEqualTo: nomePaciente).get();
  String uidPaciente = await buscarIdPaciente(context, nomePaciente);
  Map<String, dynamic> data = {
    'uidFono': idUsuario(),
    'uidPaciente': uidPaciente,
    'nomePaciente': nomePaciente,
    'dataConsulta': dataConsulta,
    'horarioConsulta': horarioConsulta,
    'duracaoConsulta': duracaoConsulta,
    'frequenciaConsulta': frequenciaConsulta,
    'semanaConsulta': semanaConsulta,
    'colorConsulta': colorConsulta,
  };
  FirebaseFirestore.instance.collection(nomeColecao).add(data);
  sucesso(context, 'O horário foi agendado com sucesso.');
  Navigator.pop(context);
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
  await FirebaseFirestore.instance.collection(nomeColecao).doc(id).update(data);
  sucesso(context, 'O horário foi alterado com sucesso.');
  Navigator.pop(context);
}

apagarConsultas(context, id) async {
  try {
    await FirebaseFirestore.instance.collection('consulta').doc(id).delete();
    sucesso(context, 'Consulta apagada com sucesso!');
    Navigator.pop(context);
  } catch (e) {
    erro(context, 'Erro ao remover a consulta');
  }
}

Future<Map<String, dynamic>> carregarAppointment(appointment) async {
  String nomeConsulta = '';
  String dataConsulta = '';
  String horarioConsulta = '';
  String duracaoConsulta = '';
  Color? selecioneCorConsulta = Colors.red;
  String selecioneSemanaConsulta = '';
  String selecioneFrequenciaConsulta = '';
  Map<String, dynamic> consulta = {};

  nomeConsulta = appointment.subject;

  String dateTimeStart = appointment.startTime.toString();
  DateTime timeStart = DateTime.parse(dateTimeStart);
  dataConsulta =
      "${timeStart.day.toString().padLeft(2, '0')}/${timeStart.month.toString().padLeft(2, '0')}/${timeStart.year.toString()}";
  horarioConsulta = "${timeStart.hour.toString().padLeft(2, '0')}:${timeStart.minute.toString().padLeft(2, '0')}";

  String dateTimeEnd = appointment.endTime.toString();
  DateTime timeEnd = DateTime.parse(dateTimeEnd);
  Duration duracao = timeEnd.difference(timeStart);
  String formattedDuration = duracao.toString().split('.').first;
  List<String> durationParts = formattedDuration.split(':');
  duracaoConsulta = '${durationParts[0].padLeft(2, '0')}:${durationParts[1].padLeft(2, '0')}';

  String colorString = appointment.color.toString();
  String colorHex = colorString.substring(colorString.indexOf("0x") + 2, colorString.length - 1);
  Color? color = getColorNameFromHex(colorHex);
  selecioneCorConsulta = color;

  String recurrenceRule = appointment.recurrenceRule;
  List<String> parts = recurrenceRule.split(';');
  String frequencyPart = parts[0];
  String byDayPart = parts[1];
  String frequency = frequencyPart.split('=')[1];
  String byDay = byDayPart.split('=')[1];
  selecioneSemanaConsulta = byDay;
  selecioneFrequenciaConsulta = frequency;

  consulta = {
    'nomeConsulta': nomeConsulta,
    'dataConsulta': dataConsulta,
    'horarioConsulta': horarioConsulta,
    'duracaoConsulta': duracaoConsulta,
    'selecioneCorConsulta': selecioneCorConsulta,
    'selecioneSemanaConsulta': selecioneSemanaConsulta,
    'selecioneFrequenciaConsulta': selecioneFrequenciaConsulta,
  };

  return consulta;
}

Future<Appointment> appointmentsPorUIDPaciente(uidPaciente) async {
  Appointment appointments = Appointment(startTime: DateTime.now(), endTime: DateTime.now());

  try {
    QuerySnapshot querySnapshot =
    await FirebaseFirestore.instance.collection(nomeColecao).where('uidPaciente', isEqualTo: uidPaciente).get();

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

      appointments = Appointment(
        startTime: startTime,
        endTime: endTime,
        subject: nomePaciente,
        color: Color(int.parse('0xFF$colorConsulta')),
        recurrenceRule: 'FREQ=$frequenciaConsulta;BYDAY=$semanaConsulta',
        isAllDay: false,
      );
    });
  } catch (e) {
    print('Erro ao buscar dados do Firestore: $e');
  }
  return appointments;
}

//Carregar Calendario
Future<List<Appointment>> getAppointmentsFromFirestore() async {
  List<Appointment> appointments = [];

  try {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection(nomeColecao).where('uidFono', isEqualTo: idUsuario()).get();

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
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection(nomeColecao).where('uidFono', isEqualTo: idUsuario()).get();

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

class FrequencyOption {
  final String value;
  final String label;

  FrequencyOption({required this.value, required this.label});
}
