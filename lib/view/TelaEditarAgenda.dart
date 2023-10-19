import 'dart:io';

import 'package:brasil_fields/brasil_fields.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fono/view/TelaAgenda.dart';
import 'package:fono/widgets/TextFieldSuggestions.dart';
import 'package:fono/widgets/campoTexto.dart';
import '../controllers/estilos.dart';
import 'package:fono/widgets/mensagem.dart';
import 'package:firedart/firedart.dart' as fd;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class TelaEditarAgenda extends StatefulWidget {
  final String uidFono;
  final Appointment appointment;

  const TelaEditarAgenda(this.uidFono, this.appointment, {super.key});

  @override
  State<TelaEditarAgenda> createState() => _TelaEditarAgendaState();
}

class _TelaEditarAgendaState extends State<TelaEditarAgenda> {
  late DateTime selectedDate;
  late TimeOfDay selectedTime;
  DateTime? pickedDate;
  String uidPaciente = '';
  String id = '';
  var nomeConsulta = TextEditingController();
  var dataConsulta = TextEditingController();
  var horarioConsulta = TextEditingController();
  var duracaoConsulta = TextEditingController();
  Color selecioneCorConsulta = Colors.red;
  String selecioneFrequenciaConsulta = 'DAILY';
  String selecioneSemanaConsulta = 'SU';
  String _paciente = '';
  List<String> _list = [];
  var pacientes;
  var windowsIdFono;
  var uidFono;

  final List<Color> colors = [
    Colors.red,
    Colors.green,
    Colors.blue,
    Colors.yellow,
    Colors.orange,
    Colors.purple,
    Colors.pink,
    Colors.grey,
    Colors.black
  ];

  final List<FrequencyOption> frequencyOptions = [
    FrequencyOption(value: "DAILY", label: "Diariamente"),
    FrequencyOption(value: "WEEKLY", label: "Semanalmente"),
    FrequencyOption(value: "MONTHLY", label: "Mensalmente"),
    FrequencyOption(value: "YEARLY", label: "Anualmente"),
  ];

  final List<FrequencyOption> dayOptions = [
    FrequencyOption(value: "SU", label: "Domingo"),
    FrequencyOption(value: "MO", label: "Segunda-Feira"),
    FrequencyOption(value: "TU", label: "Terça-Feira"),
    FrequencyOption(value: "WE", label: "Quarta-Feira"),
    FrequencyOption(value: "TH", label: "Quinta-Feira"),
    FrequencyOption(value: "FR", label: "Sexta-Feira"),
    FrequencyOption(value: "SA", label: "Sábado"),
  ];

  Color? getColorNameFromHex(String hexString) {
    Map<String, Color> colorMap = {
      "fff44336": Colors.red,
      "ff4caf50": Colors.green,
      "ff2196f3": Colors.blue,
      "ffffeb3b": Colors.yellow,
      "ffff9800": Colors.orange,
      "ff9c27b0": Colors.purple,
      "ffe91e63": Colors.pink,
      "ff9e9e9e": Colors.grey,
      "ff000000": Colors.black
    };

    if (colorMap.containsKey(hexString)) {
      return colorMap[hexString]!;
    }

    return colorMap[hexString];
  }

  String getColorName(Color color) {
    final Map<Color, String> colorNames = {
      Colors.red: 'Vermelho',
      Colors.green: 'Verde',
      Colors.blue: 'Azul',
      Colors.yellow: 'Amarelo',
      Colors.orange: 'Laranja',
      Colors.purple: 'Roxo',
      Colors.pink: 'Rosa',
      Colors.grey: 'Cinza',
      Colors.black: 'Preto'
    };

    if (colorNames.containsKey(color)) {
      return colorNames[color]!;
    }

    return color.toString();
  }

  carregarDados() {
    setState(() {
      nomeConsulta.text = widget.appointment.subject;
      _paciente = nomeConsulta.text;
    });

    String dateTimeStart = widget.appointment.startTime.toString();
    DateTime timeStart = DateTime.parse(dateTimeStart);
    dataConsulta.text = "${timeStart.day.toString().padLeft(2, '0')}/${timeStart.month.toString().padLeft(2, '0')}/${timeStart.year.toString()}";
    horarioConsulta.text = "${timeStart.hour.toString().padLeft(2, '0')}:${timeStart.minute.toString().padLeft(2, '0')}";

    String dateTimeEnd = widget.appointment.endTime.toString();
    DateTime timeEnd = DateTime.parse(dateTimeEnd);
    Duration duracao = timeEnd.difference(timeStart);
    String formattedDuration = duracao.toString().split('.').first;
    List<String> durationParts = formattedDuration.split(':');
    duracaoConsulta.text = '${durationParts[0].padLeft(2, '0')}:${durationParts[1].padLeft(2, '0')}';

    String colorString = widget.appointment.color.toString();
    String colorHex = colorString.substring(colorString.indexOf("0x") + 2, colorString.length - 1);
    Color color = getColorNameFromHex(colorHex)!;
    selecioneCorConsulta = color;

    String? recurrenceRule = widget.appointment.recurrenceRule;
    List<String> parts = recurrenceRule!.split(';');
    String frequencyPart = parts[0];
    String byDayPart = parts[1];
    String frequency = frequencyPart.split('=')[1];
    String byDay = byDayPart.split('=')[1];
    selecioneSemanaConsulta = byDay;
    selecioneFrequenciaConsulta = frequency;
  }

  retornarPacientes() async {
    await carregarDados();
    if (kIsWeb || Platform.isAndroid || Platform.isIOS) {
      uidFono = FirebaseAuth.instance.currentUser!.uid.toString();
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('pacientes').where('uidFono', isEqualTo: uidFono).get();
      for (var doc in querySnapshot.docs) {
        String nome = doc['nomePaciente'];
        _list.add(nome);
      }
      QuerySnapshot querySnapshot2 = await FirebaseFirestore.instance.collection('consulta').where('nomePaciente', isEqualTo: nomeConsulta.text).get();
      setState(() {
        id = querySnapshot2.docs[0].id;
        uidPaciente =  querySnapshot2.docs[0]['uidPaciente'];
      });
    } else {
      var userId = await fd.FirebaseAuth.instance.getUser();
      windowsIdFono = userId.id;
      List<fd.Document> querySnapshot = await fd.Firestore.instance.collection('pacientes').where('uidFono', isEqualTo: uidFono).get();
      for (var doc in querySnapshot) {
        String nome = doc['nomePaciente'];
        _list.add(nome);
      }
      List<fd.Document> querySnapshot2 = await fd.Firestore.instance.collection('consulta').where('nomePaciente', isEqualTo: nomeConsulta.text).get();
      setState(() {
        id = querySnapshot2[0].id;
        uidPaciente = querySnapshot2[0]['uidPaciente'];
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    DateTime now = DateTime.now();
    selectedDate = DateTime.now();
    selectedTime = TimeOfDay.now();
    retornarPacientes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: true,
          iconTheme: IconThemeData(color: cores('verde')),
          actions: [
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () async {
                try {
                  await FirebaseFirestore.instance.collection('consulta').doc(id).delete();
                  sucesso(context, 'Consulta apagada com sucesso!');
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TelaAgenda(uidFono),
                    ),
                  );
                } catch (e) {
                  erro(context, 'Erro ao remover a consulta');
                }
              },
            ),
          ],
          title: Text(
            "Atualizar Horário",
            style: TextStyle(color: cores('verde')),
          ),
          backgroundColor: cores('rosa_fraco'),
        ),
        body: ListView(
          padding: const EdgeInsets.all(10),
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextFieldSuggestions(
                    icone: Icons.label,
                    list: _list,
                    labelText: nomeConsulta.text,
                    textSuggetionsColor: const Color(0xFF37513F),
                    suggetionsBackgroundColor: const Color(0xFFFFFFFF),
                    outlineInputBorderColor: const Color(0xFFF5B2B0),
                    returnedValue: (String value) {
                      setState(() {
                        _paciente = value;
                        nomeConsulta.text = _paciente;
                      });
                    },
                    onTap: () {},
                    height: 200),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: campoTexto(
                        'Data de Início da Consulta',
                        dataConsulta,
                        Icons.calendar_month_outlined,
                        formato: DataInputFormatter(),
                        numeros: true,
                        iconPressed: () async {
                          pickedDate = await showDatePicker(
                            context: context,
                            initialDate: selectedDate,
                            firstDate: DateTime.now(),
                            lastDate: DateTime(2100),
                          );
                          if (pickedDate != null && pickedDate != selectedDate) {
                            setState(() {
                              selectedDate = pickedDate!;
                              dataConsulta.text =
                                  "${selectedDate.day.toString().padLeft(2, '0')}/${selectedDate.month.toString().padLeft(2, '0')}/${selectedDate.year.toString()}";
                            });
                          }
                        },
                      ),
                    ),
                    const Padding(padding: EdgeInsets.only(right: 10)),
                    Expanded(
                      child: campoTexto(
                        'Horário da Consulta',
                        horarioConsulta,
                        Icons.access_time,
                        formato: HoraInputFormatter(),
                        numeros: true,
                        iconPressed: () async {
                          final TimeOfDay? pickedTime = await showTimePicker(
                            context: context,
                            initialTime: selectedTime,
                          );
                          if (pickedTime != null && pickedTime != selectedTime) {
                            setState(() {
                              selectedTime = pickedTime;
                              horarioConsulta.text = selectedTime.format(context);
                            });
                          }
                        },
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: campoTexto(
                        'Duração da Consulta',
                        duracaoConsulta,
                        Icons.hourglass_top_sharp,
                        formato: HoraInputFormatter(),
                        numeros: true,
                        iconPressed: () async {
                          final TimeOfDay? pickedTime = await showTimePicker(
                            context: context,
                            initialTime: selectedTime,
                          );
                          if (pickedTime != null && pickedTime != selectedTime) {
                            setState(() {
                              selectedTime = pickedTime;
                              duracaoConsulta.text = selectedTime.format(context);
                            });
                          }
                        },
                      ),
                    ),
                    const Padding(padding: EdgeInsets.only(right: 10)),
                    Expanded(
                        child: Column(
                      children: [
                        Text(
                          "Frequência",
                          style: TextStyle(color: cores('verde'), fontWeight: FontWeight.bold),
                        ),
                        Container(
                          height: 40,
                          padding: const EdgeInsets.only(left: 10),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8.0),
                              border: Border.all(color: cores('rosa_forte')),
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(offset: const Offset(0, 3), color: cores('rosa_fraco'), blurRadius: 5)
                                // changes position of shadow
                              ]),
                          child: DropdownButton(
                            hint: const Text('Selecione uma Frequência'),
                            icon: const Icon(Icons.arrow_drop_down),
                            iconSize: 30,
                            iconEnabledColor: cores('verde'),
                            style: TextStyle(
                              color: cores('verde'),
                              fontWeight: FontWeight.w400,
                              fontSize: 18,
                            ),
                            underline: Container(
                              height: 0,
                            ),
                            isExpanded: true,
                            value: selecioneFrequenciaConsulta,
                            onChanged: (newValue) {
                              setState(() {
                                selecioneFrequenciaConsulta = newValue!;
                              });
                            },
                            items: frequencyOptions.map((option) {
                              String label = option.label;
                              return DropdownMenuItem<String>(
                                value: option.value,
                                child: Text(label),
                              );
                            }).toList(),
                          ),
                        ),
                      ],
                    ))
                  ],
                ),
                const SizedBox(height: 20),
                Column(
                  children: [
                    Text(
                      "Dia da Semana:",
                      style: TextStyle(color: cores('verde'), fontWeight: FontWeight.bold),
                    ),
                    Container(
                      height: 40,
                      padding: const EdgeInsets.only(left: 10),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.0),
                          border: Border.all(color: cores('rosa_forte')),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(offset: const Offset(0, 3), color: cores('rosa_fraco'), blurRadius: 5)
                            // changes position of shadow
                          ]),
                      child: DropdownButton(
                        hint: const Text('Selecione um Dia da Semana'),
                        icon: const Icon(Icons.arrow_drop_down),
                        iconSize: 30,
                        iconEnabledColor: cores('verde'),
                        style: TextStyle(
                          color: cores('verde'),
                          fontWeight: FontWeight.w400,
                          fontSize: 18,
                        ),
                        underline: Container(
                          height: 0,
                        ),
                        isExpanded: true,
                        value: selecioneSemanaConsulta,
                        onChanged: (newValue) {
                          setState(() {
                            selecioneSemanaConsulta = newValue!;
                          });
                        },
                        items: dayOptions.map((option) {
                          String label = option.label;
                          return DropdownMenuItem<String>(
                            value: option.value,
                            child: Text(label),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Text(
                  "Selecione uma Cor:",
                  style: TextStyle(color: cores('verde'), fontWeight: FontWeight.bold),
                ),
                Container(
                  height: 40,
                  padding: const EdgeInsets.only(left: 10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                      border: Border.all(color: cores('rosa_forte')),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(offset: const Offset(0, 3), color: cores('rosa_fraco'), blurRadius: 5)
                        // changes position of shadow
                      ]),
                  child: DropdownButton(
                    hint: const Text('Selecione uma Cor'),
                    icon: const Icon(Icons.arrow_drop_down),
                    iconSize: 30,
                    iconEnabledColor: cores('verde'),
                    style: TextStyle(
                      color: cores('verde'),
                      fontWeight: FontWeight.w400,
                      fontSize: 18,
                    ),
                    underline: Container(
                      height: 0,
                    ),
                    isExpanded: true,
                    value: selecioneCorConsulta,
                    onChanged: (newValue) {
                      setState(() {
                        selecioneCorConsulta = newValue!;
                      });
                    },
                    items: colors.map((color) {
                      return DropdownMenuItem(
                        value: color,
                        child: Text(
                          getColorName(color),
                          style: TextStyle(color: color),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 150,
                      child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                              primary: cores('rosa_fraco'),
                              minimumSize: const Size(200, 45),
                              backgroundColor: cores('verde'),
                              elevation: 5,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(32),
                              )),
                          child: const Text(
                            'Atualizar',
                            style: TextStyle(fontSize: 16),
                          ),
                          onPressed: () async {
                            String colorHex = selecioneCorConsulta.value.toRadixString(16).padLeft(8, '0');
                            if (nomeConsulta.text.isNotEmpty &&
                                dataConsulta.text.isNotEmpty &&
                                horarioConsulta.text.isNotEmpty &&
                                duracaoConsulta.text.isNotEmpty) {
                              atualizarAgenda(
                                context,
                                id,
                                widget.uidFono,
                                uidPaciente,
                                nomeConsulta.text,
                                dataConsulta.text,
                                horarioConsulta.text,
                                duracaoConsulta.text,
                                selecioneFrequenciaConsulta,
                                selecioneSemanaConsulta,
                                colorHex,
                              );
                            }
                          }),
                    ),
                    const Padding(padding: EdgeInsets.all(20)),
                    SizedBox(
                      width: 150,
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                            primary: cores('rosa_fraco'),
                            minimumSize: const Size(200, 45),
                            backgroundColor: cores('verde'),
                            elevation: 5,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(32),
                            )),
                        child: const Text(
                          'Cancelar',
                          style: TextStyle(fontSize: 16),
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 60),
              ],
            ),
          ],
        ));
  }
}

class FrequencyOption {
  final String value;
  final String label;

  FrequencyOption({required this.value, required this.label});
}

Future<void> atualizarAgenda(context, id, uidFono, uidPaciente, nomePaciente, dataConsulta, horarioConsulta, duracaoConsulta, frequenciaConsulta,
    semanaConsulta, colorConsulta) async {
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
  await FirebaseFirestore.instance.collection('consulta').doc(id).update(data);
  sucesso(context, 'O horário foi alterado com sucesso.');
  Navigator.pop(context);
}
