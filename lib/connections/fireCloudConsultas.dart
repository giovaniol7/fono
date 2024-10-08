import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import '../controllers/variaveis.dart';
import '../models/maps.dart';
import '../widgets/mensagem.dart';
import 'connectionGoogle.dart';
import 'fireAuth.dart';
import 'fireCloudPacientes.dart';

String nomeColecao = 'consulta';

retornarIDConsultas() async {
  await listarConsultas().get().then((us) {
    return us.docs[0].id;
  });
}

listarConsultas() async {
  return FirebaseFirestore.instance.collection(nomeColecao).where('uidFono', isEqualTo: idFonoAuth());
}

Future<Map<String, String>> buscarPorNomeHoraConsultas(context, nomePaciente, horarioConsulta) async {
  Map<String, String> consultas = {};

  try {
    String uidAgenda = '';
    String uidPaciente = '';

    await FirebaseFirestore.instance
        .collection(nomeColecao)
        .where('nomePaciente', isEqualTo: nomePaciente)
        .where('horarioConsulta', isEqualTo: horarioConsulta)
        .get()
        .then((q) {
      if (q.docs.isNotEmpty) {
        uidAgenda = q.docs[0].id;
        uidPaciente = q.docs[0].data()['uidPaciente'];
      }
    });

    consultas = {
      'uidAgenda': uidAgenda,
      'uidPaciente': uidPaciente,
    };
  } catch (e) {
    erro(context, 'Erro ao procurar consultas.');
  }

  return consultas;
}

adicionarConsultas(context, nomePaciente, dataConsulta, horarioConsulta, duracaoConsulta, frequenciaConsulta,
    semanaConsulta, colorConsulta) async {
  if (nomePaciente.isNotEmpty && dataConsulta.isNotEmpty && horarioConsulta.isNotEmpty && duracaoConsulta.isNotEmpty) {
    try {
      String uidConsulta = '';
      CollectionReference consultas = FirebaseFirestore.instance.collection(nomeColecao);
      String uidPaciente = await buscarIdPaciente(context, nomePaciente);
      Map<String, dynamic> data = {
        'uidFono': idFonoAuth(),
        'uidPaciente': uidPaciente,
        'nomePaciente': nomePaciente,
        'dataConsulta': dataConsulta,
        'horarioConsulta': horarioConsulta,
        'duracaoConsulta': duracaoConsulta,
        'frequenciaConsulta': frequenciaConsulta,
        'semanaConsulta': semanaConsulta,
        'colorConsulta': colorConsulta,
      };
      DocumentReference docRef = await consultas.add(data);
      await FirebaseFirestore.instance
          .collection(nomeColecao)
          .where('nomePaciente', isEqualTo: nomePaciente)
          .where('dataConsulta', isEqualTo: dataConsulta)
          .get()
          .then((us) {
        uidConsulta = us.docs[0].id;
      });
      await docRef.update({'uidConsulta': uidConsulta});
      await handleSignIn;
      await addEventToGoogleCalendar(data);
      sucesso(context, 'O horário foi agendado com sucesso.');
      AppVariaveis().reset();
      Navigator.pop(context);
    } catch (e) {
      erro(context, 'Erro ao adicionar consultas.');
    }
  } else {
    erro(context, 'Preencha os campos obrigatórios.');
  }
}

editarConsultas(context, uidConsulta, uidFono, uidPaciente, nomePaciente, dataConsulta, horarioConsulta,
    duracaoConsulta, frequenciaConsulta, semanaConsulta, colorConsulta) async {
  if (nomePaciente.isNotEmpty && dataConsulta.isNotEmpty && horarioConsulta.isNotEmpty && duracaoConsulta.isNotEmpty) {
    try {
      Map<String, dynamic> data = {
        'uidConsulta': uidConsulta,
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
      await FirebaseFirestore.instance.collection(nomeColecao).doc(uidConsulta).update(data);
      sucesso(context, 'O horário foi alterado com sucesso.');
      AppVariaveis().reset();
      Navigator.pop(context);
    } catch (e) {
      erro(context, 'Erro ao editar consultas.');
    }
  } else {
    erro(context, 'Preencha os campos obrigatórios.');
  }
}

apagarConsultas(context, uidConsulta) async {
  try {
    await FirebaseFirestore.instance.collection('consulta').doc(uidConsulta).delete();
    sucesso(context, 'Consulta apagada com sucesso!');
    AppVariaveis().reset();
    Navigator.pop(context);
  } catch (e) {
    erro(context, 'Erro ao remover a consulta.');
  }
}

Future<Map<String, dynamic>> carregarAppointment(Appointment? appointment) async {
  String nomeConsulta = '';
  String dataConsulta = '';
  String horarioConsulta = '';
  String duracaoConsulta = '';
  Color selecioneCorConsulta = Colors.red;
  String selecioneSemanaConsulta = '';
  String selecioneFrequenciaConsulta = '';
  Map<String, dynamic> consulta = {};

  nomeConsulta = appointment!.subject;

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

  String colorHex = appointment.color.value.toRadixString(16).padLeft(8, '0');
  Color color = getColorNameFromHex(colorHex)!;
  selecioneCorConsulta = color;

  String? recurrenceRule = appointment.recurrenceRule;
  List<String> parts = recurrenceRule!.split(';');
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
        await FirebaseFirestore.instance.collection(nomeColecao).where('uidFono', isEqualTo: idFonoAuth()).get();

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
        await FirebaseFirestore.instance.collection(nomeColecao).where('uidFono', isEqualTo: idFonoAuth()).get();

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
