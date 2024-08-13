import 'package:flutter/material.dart';
import 'package:brasil_fields/brasil_fields.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import '../connections/fireAuth.dart';
import '../connections/fireCloudConsultas.dart';
import '../connections/fireCloudPacientes.dart';
import '../models/maps.dart';
import '../widgets/TextFieldSuggestions.dart';
import '../widgets/campoTexto.dart';
import '../widgets/mensagem.dart';
import '../controllers/estilos.dart';
import '../controllers/variaveis.dart';

class TelaAdicionarAgenda extends StatefulWidget {
  const TelaAdicionarAgenda();

  @override
  State<TelaAdicionarAgenda> createState() => _TelaAdicionarAgendaState();
}

class _TelaAdicionarAgendaState extends State<TelaAdicionarAgenda> {
  int verificar = 0;
  late String? tipo;
  late Appointment? tappedAppointment;

  carregarDados() async {
    AppVariaveis().varAtivoPaciente = '1';
    List<String> lista = await fazerListaPacientes(AppVariaveis().varAtivoPaciente);

    if (tipo == 'editar') {
      AppVariaveis().listaPaciente = lista;
      AppVariaveis().appointmentAgenda = await carregarAppointment(tappedAppointment!);
      AppVariaveis().consulta = await buscarPorNomeHoraConsultas(
          context, AppVariaveis().appointmentAgenda['nomeConsulta'], AppVariaveis().appointmentAgenda['horarioConsulta']);
    }
    setState(() {
      if (tipo == 'adicionar') {
        AppVariaveis().listaPaciente = lista;
        AppVariaveis().txtDataConsulta.text =
            "${AppVariaveis().nowTimer.day.toString().padLeft(2, '0')}/${AppVariaveis().nowTimer.month.toString().padLeft(2, '0')}/${AppVariaveis().nowTimer.year.toString()}";
        AppVariaveis().selecioneFrequenciaConsulta = 'WEEKLY';
        AppVariaveis().txtDuracaoConsulta.text = '00:50';
      } else if (tipo == 'editar') {
        AppVariaveis().txtNomeConsulta.text = AppVariaveis().appointmentAgenda['nomeConsulta']!;
        AppVariaveis().txtDataConsulta.text = AppVariaveis().appointmentAgenda['dataConsulta']!;
        AppVariaveis().txtHorarioConsulta.text = AppVariaveis().appointmentAgenda['horarioConsulta']!;
        AppVariaveis().txtDuracaoConsulta.text = AppVariaveis().appointmentAgenda['duracaoConsulta']!;
        AppVariaveis().selecioneCorConsulta = AppVariaveis().appointmentAgenda['selecioneCorConsulta']!;
        AppVariaveis().selecioneSemanaConsulta = AppVariaveis().appointmentAgenda['selecioneSemanaConsulta']!;
        AppVariaveis().selecioneFrequenciaConsulta =
            AppVariaveis().appointmentAgenda['selecioneFrequenciaConsulta']!;
        AppVariaveis().uidAgenda = AppVariaveis().consulta['uidAgenda'] ?? '';
        AppVariaveis().uidPaciente = AppVariaveis().consulta['uidPaciente'] ?? '';
        AppVariaveis().labelText = AppVariaveis().appointmentAgenda['nomeConsulta']!;
        AppVariaveis().pacienteNome = AppVariaveis().appointmentAgenda['nomeConsulta']!;
      }
    });
  }

  @override
  void initState() {
    super.initState();
    carregarDados();
  }

  Widget build(BuildContext context) {
    final arguments = ModalRoute.of(context)?.settings.arguments as Map?;
    if (arguments != null && verificar == 0) {
      tipo = arguments['tipo'] as String?;
      tappedAppointment = arguments['tappedAppointment'] as Appointment?;
      verificar = 1;
    }
    TamanhoFonte tamanhoFonte = TamanhoFonte();

    return Scaffold(
        appBar: AppBar(
          actions: [
            tipo == 'editar'
                ? IconButton(
                    icon: Icon(
                      Icons.delete,
                      color: cores('corSimbolo'),
                    ),
                    onPressed: () async {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('Confirmar exclusão'),
                              content: const Text('Tem certeza de que deseja apagar este Horário?'),
                              actions: <Widget>[
                                TextButton(
                                  child: const Text(
                                    'Cancelar',
                                    style: TextStyle(color: Colors.blue),
                                  ),
                                  onPressed: () {
                                    AppVariaveis().resetAgenda();
                                    Navigator.of(context).pop();
                                  },
                                ),
                                TextButton(
                                  child: const Text(
                                    'Apagar',
                                    style: TextStyle(color: Colors.red),
                                  ),
                                  onPressed: () async {
                                    try {
                                      await apagarConsultas(context, AppVariaveis().uidAgenda);
                                    } catch (e) {
                                      erro(context, 'Erro ao deletar Horário: $e');
                                    }
                                    AppVariaveis().resetAgenda();
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            );
                          });
                    },
                  )
                : Container(),
          ],
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              AppVariaveis().resetAgenda();
              Navigator.pop(context);
            },
          ),
          iconTheme: IconThemeData(color: cores('corSimbolo')),
          title: Text(
            tipo == 'adicionar' ? "Adicionar Horário" : "Atualizar Horário",
            style: TextStyle(color: cores('corTexto')),
          ),
          backgroundColor: cores('corFundo'),
        ),
        body: ListView(
          padding: const EdgeInsets.all(10),
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextFieldSuggestions(
                    tipo: 'paciente',
                    icone: Icons.label,
                    list: AppVariaveis().listaPaciente,
                    labelText: AppVariaveis().labelText,
                    textSuggetionsColor: cores('corSimbolo'),
                    suggetionsBackgroundColor: cores('corCaixaPadrao'),
                    outlineInputBorderColor: cores('corSombra'),
                    returnedValue: (String value) {
                      setState(() {
                        AppVariaveis().pacienteNome = value;
                        AppVariaveis().txtNomeConsulta.text = AppVariaveis().pacienteNome;
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
                        AppVariaveis().txtDataConsulta,
                        Icons.calendar_month_outlined,
                        formato: DataInputFormatter(),
                        boardType: 'numeros',
                        iconPressed: () async {
                          AppVariaveis().pickedDate = await showDatePicker(
                            context: context,
                            initialDate: AppVariaveis().selectedDate,
                            firstDate: DateTime.now(),
                            lastDate: DateTime(2100),
                          );
                          if (AppVariaveis().pickedDate != null &&
                              AppVariaveis().pickedDate != AppVariaveis().selectedDate) {
                            setState(() {
                              AppVariaveis().selectedDate = AppVariaveis().pickedDate!;
                              AppVariaveis().txtDataConsulta.text =
                                  "${AppVariaveis().selectedDate.day.toString().padLeft(2, '0')}/${AppVariaveis().selectedDate.month.toString().padLeft(2, '0')}/${AppVariaveis().selectedDate.year.toString()}";
                            });
                          }
                        },
                      ),
                    ),
                    const Padding(padding: EdgeInsets.only(right: 10)),
                    Expanded(
                      child: campoTexto(
                        'Horário da Consulta',
                        AppVariaveis().txtHorarioConsulta,
                        Icons.access_time,
                        formato: HoraInputFormatter(),
                        boardType: 'numeros',
                        iconPressed: () async {
                          final TimeOfDay? pickedTime = await showTimePicker(
                            context: context,
                            initialTime: AppVariaveis().selectedTime,
                          );
                          if (pickedTime != null && pickedTime != AppVariaveis().selectedTime) {
                            setState(() {
                              AppVariaveis().selectedTime = pickedTime;
                              AppVariaveis().txtHorarioConsulta.text =
                                  AppVariaveis().selectedTime.format(context);
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
                        AppVariaveis().txtDuracaoConsulta,
                        Icons.hourglass_top_sharp,
                        formato: HoraInputFormatter(),
                        boardType: 'numeros',
                        iconPressed: () async {
                          final TimeOfDay? pickedTime = await showTimePicker(
                            context: context,
                            initialTime: AppVariaveis().selectedTime,
                          );
                          if (pickedTime != null && pickedTime != AppVariaveis().selectedTime) {
                            setState(() {
                              AppVariaveis().selectedTime = pickedTime;
                              AppVariaveis().txtDuracaoConsulta.text =
                                  AppVariaveis().selectedTime.format(context);
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
                          style: TextStyle(color: cores('corTexto'), fontWeight: FontWeight.bold),
                        ),
                        Container(
                          height: 40,
                          padding: const EdgeInsets.only(left: 10),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8.0),
                              border: Border.all(color: cores('corBorda')),
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                    offset: const Offset(0, 3), color: cores('corSombra'), blurRadius: 5)
                                // changes position of shadow
                              ]),
                          child: DropdownButton(
                            hint: const Text('Selecione uma Frequência'),
                            icon: const Icon(Icons.arrow_drop_down),
                            iconSize: 30,
                            iconEnabledColor: cores('corTexto'),
                            style: TextStyle(
                              color: cores('corTexto'),
                              fontWeight: FontWeight.w400,
                              fontSize: 18,
                            ),
                            underline: Container(
                              height: 0,
                            ),
                            isExpanded: true,
                            value: AppVariaveis().selecioneFrequenciaConsulta,
                            onChanged: (newValue) {
                              setState(() {
                                AppVariaveis().selecioneFrequenciaConsulta = newValue!;
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
                      style: TextStyle(color: cores('corTexto'), fontWeight: FontWeight.bold),
                    ),
                    Container(
                      height: 40,
                      padding: const EdgeInsets.only(left: 10),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.0),
                          border: Border.all(color: cores('corBorda')),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(offset: const Offset(0, 3), color: cores('corSombra'), blurRadius: 5)
                            // changes position of shadow
                          ]),
                      child: DropdownButton(
                        hint: const Text('Selecione um Dia da Semana'),
                        icon: const Icon(Icons.arrow_drop_down),
                        iconSize: 30,
                        iconEnabledColor: cores('corTexto'),
                        style: TextStyle(
                          color: cores('corTexto'),
                          fontWeight: FontWeight.w400,
                          fontSize: 18,
                        ),
                        underline: Container(
                          height: 0,
                        ),
                        isExpanded: true,
                        value: AppVariaveis().selecioneSemanaConsulta,
                        onChanged: (newValue) {
                          setState(() {
                            AppVariaveis().selecioneSemanaConsulta = newValue!;
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
                  style: TextStyle(color: cores('corTexto'), fontWeight: FontWeight.bold),
                ),
                Container(
                  height: 40,
                  padding: const EdgeInsets.only(left: 10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                      border: Border.all(color: cores('corBorda')),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(offset: const Offset(0, 3), color: cores('corSombra'), blurRadius: 5)
                        // changes position of shadow
                      ]),
                  child: DropdownButton(
                    hint: const Text('Selecione uma Cor'),
                    icon: const Icon(Icons.arrow_drop_down),
                    iconSize: 30,
                    iconEnabledColor: cores('corTexto'),
                    style: TextStyle(
                      color: cores('corTexto'),
                      fontWeight: FontWeight.w400,
                      fontSize: 18,
                    ),
                    underline: Container(
                      height: 0,
                    ),
                    isExpanded: true,
                    value: AppVariaveis().selecioneCorConsulta,
                    onChanged: (newValue) {
                      setState(() {
                        AppVariaveis().selecioneCorConsulta = newValue!;
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
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    OutlinedButton(
                        style: OutlinedButton.styleFrom(
                            foregroundColor: cores('corTextoBotao'),
                            backgroundColor: cores('corBotao'),
                            elevation: 5,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(32),
                            )),
                        child: Text(
                          tipo == 'adicionar' ? 'Adicionar' : 'Atualizar',
                          style: TextStyle(fontSize: tamanhoFonte.letraPequena(context)),
                        ),
                        onPressed: () async {
                          String colorHex =
                              AppVariaveis().selecioneCorConsulta.value.toRadixString(16).padLeft(8, '0');
                          if (tipo == 'adicionar') {
                            adicionarConsultas(
                              context,
                              AppVariaveis().txtNomeConsulta.text,
                              AppVariaveis().txtDataConsulta.text,
                              AppVariaveis().txtHorarioConsulta.text,
                              AppVariaveis().txtDuracaoConsulta.text,
                              AppVariaveis().selecioneFrequenciaConsulta,
                              AppVariaveis().selecioneSemanaConsulta,
                              colorHex,
                            );
                          } else {
                            editarConsultas(
                              context,
                              AppVariaveis().uidAgenda,
                              idFonoAuth(),
                              AppVariaveis().uidPaciente,
                              AppVariaveis().txtNomeConsulta.text,
                              AppVariaveis().txtDataConsulta.text,
                              AppVariaveis().txtHorarioConsulta.text,
                              AppVariaveis().txtDuracaoConsulta.text,
                              AppVariaveis().selecioneFrequenciaConsulta,
                              AppVariaveis().selecioneSemanaConsulta,
                              colorHex,
                            );
                          }
                        }),
                    SizedBox(width: 10),
                    OutlinedButton(
                      style: OutlinedButton.styleFrom(
                          foregroundColor: cores('corTextoBotao'),
                          backgroundColor: cores('corBotao'),
                          elevation: 5,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(32),
                          )),
                      child: Text(
                        'Cancelar',
                        style: TextStyle(fontSize: tamanhoFonte.letraPequena(context)),
                      ),
                      onPressed: () {
                        AppVariaveis().resetAgenda();
                        Navigator.pop(context);
                      },
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
