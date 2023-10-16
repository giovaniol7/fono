import 'dart:io';

import 'package:brasil_fields/brasil_fields.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../view/TelaAgenda.dart';
import '../widgets/TextFieldSuggestions.dart';
import '../widgets/campoTexto.dart';
import 'controllers/coresPrincipais.dart';
import '../widgets/mensagem.dart';
import 'package:firedart/firedart.dart' as fd;
import 'package:firebase_auth/firebase_auth.dart';

class TelaAdicionarAgenda extends StatefulWidget {
  final String uidFono;

  const TelaAdicionarAgenda(this.uidFono, {super.key});

  @override
  State<TelaAdicionarAgenda> createState() => _TelaAdicionarAgendaState();
}

class _TelaAdicionarAgendaState extends State<TelaAdicionarAgenda> {
  late DateTime selectedDate;
  late TimeOfDay selectedTime;
  DateTime? pickedDate;
  var nomeConsulta = TextEditingController();
  var dataConsulta = TextEditingController();
  var horarioConsulta = TextEditingController();
  var duracaoConsulta = TextEditingController();
  var colorConsulta = TextEditingController();
  var frequenciaConsulta = TextEditingController();
  Color selecioneCorConsulta = Colors.red;
  String selecioneFrequenciaConsulta = 'DAILY';
  String selecioneSemanaConsulta = 'SU';
  String _paciente = '';
  List<String> _list = [];
  var windowsIdFono;
  var pacientes;
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

  retornarPacientes() async {
    if (kIsWeb || Platform.isAndroid || Platform.isIOS) {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('pacientes').where('uidFono', isEqualTo: uidFono).get();
      for (var doc in querySnapshot.docs) {
        String nome = doc['nomePaciente'];
        _list.add(nome);
      }
    } else {
      List<fd.Document> querySnapshot = await fd.Firestore.instance.collection('pacientes').where('uidFono', isEqualTo: uidFono).get();
      for (var doc in querySnapshot) {
        String nome = doc['nomePaciente'];
        _list.add(nome);
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    DateTime now = DateTime.now();
    dataConsulta.text = "${now.day.toString().padLeft(2, '0')}/${now.month.toString().padLeft(2, '0')}/${now.year.toString()}";
    selectedDate = DateTime.now();
    selectedTime = TimeOfDay.now();
    if (kIsWeb || Platform.isAndroid || Platform.isIOS) {
      uidFono = FirebaseAuth.instance.currentUser!.uid.toString();
      retornarPacientes();
      duracaoConsulta.text = "00:50";
    } else {
      buscarId();
      retornarPacientes();
    }
  }

  Future<void> buscarId() async {
    var userId = await fd.FirebaseAuth.instance.getUser();
    windowsIdFono = userId.id;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          iconTheme: IconThemeData(color: cores('verde')),
          title: Text(
            "Adicionar Horário",
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
                    labelText: "Nome do Paciente",
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
                            'Adicionar',
                            style: TextStyle(fontSize: 16),
                          ),
                          onPressed: () async {
                            String colorHex = selecioneCorConsulta.value.toRadixString(16).padLeft(8, '0');
                            if (nomeConsulta.text.isNotEmpty &&
                                dataConsulta.text.isNotEmpty &&
                                horarioConsulta.text.isNotEmpty &&
                                duracaoConsulta.text.isNotEmpty) {
                              adicionarAgenda(
                                context,
                                widget.uidFono,
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

Future<void> adicionarAgenda(
    context, uidFono, nomePaciente, dataConsulta, horarioConsulta, duracaoConsulta, frequenciaConsulta, semanaConsulta, colorConsulta) async {
  QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('pacientes').where('nomePaciente', isEqualTo: nomePaciente).get();
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