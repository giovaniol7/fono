import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import '../connections/fireAuth.dart';
import '../connections/fireCloudConsultas.dart';
import '../connections/fireCloudPacientes.dart';
import '../models/maps.dart';
import '../widgets/TextFieldSuggestions.dart';
import '../widgets/campoTexto.dart';
import '../widgets/mensagem.dart';
import '/controllers/estilos.dart';

class TelaAdicionarAgenda extends StatefulWidget {
  final String tipo;
  final Appointment appointment;

  const TelaAdicionarAgenda(this.tipo, this.appointment, {super.key});

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
  String labelText = "Nome do Paciente";
  Color selecioneCorConsulta = Colors.red;
  String selecioneFrequenciaConsulta = 'DAILY';
  String selecioneSemanaConsulta = 'SU';
  String _paciente = '';
  List<String> listaPaciente = [];
  var nome;
  var horario;
  var id;
  var uidPaciente;
  var appointment;
  var consulta;
  var varAtivo = '1';

  Future<void> atualizarDados() async {
    await carregarDados();
  }

  carregarDados() async {
    List<String> lista = await fazerListaPacientes(varAtivo);
    widget.tipo == 'editar' ? appointment = await carregarAppointment(widget.appointment) : null;
    nome = widget.appointment.subject;
    horario = widget.appointment.startTime;
    consulta = await buscarPorNomeHoraConsultas(context, nome, horario);
    //String uidPac = await buscarIdPaciente(context, nome);

    setState(() {
      listaPaciente = lista;
      id = consulta['id'];
      uidPaciente = consulta['uidPaciente'];
      selecioneFrequenciaConsulta = 'WEEKLY';
      duracaoConsulta.text = '00:50';

      if (widget.tipo == 'editar') {
        labelText = appointment['nomeConsulta'];
        _paciente = appointment['nomeConsulta'];
        nomeConsulta.text = appointment['nomeConsulta'];
        dataConsulta.text = appointment['dataConsulta'];
        horarioConsulta.text = appointment['horarioConsulta'];
        duracaoConsulta.text = appointment['duracaoConsulta'];
        selecioneCorConsulta = appointment['selecioneCorConsulta'];
        selecioneSemanaConsulta = appointment['selecioneSemanaConsulta'];
        selecioneFrequenciaConsulta = appointment['selecioneFrequenciaConsulta'];
      }
    });
  }

  @override
  void initState() {
    super.initState();
    DateTime now = DateTime.now();
    widget.tipo == 'adicionar'
        ? dataConsulta.text =
            "${now.day.toString().padLeft(2, '0')}/${now.month.toString().padLeft(2, '0')}/${now.year.toString()}"
        : null;
    selectedDate = DateTime.now();
    selectedTime = TimeOfDay.now();
    carregarDados();
  }

  @override
  Widget build(BuildContext context) {
    TamanhoFonte tamanhoFonte = TamanhoFonte();

    return Scaffold(
        appBar: AppBar(
          actions: [
            widget.tipo == 'editar'
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
                                      await apagarConsultas(context, id);
                                    } catch (e) {
                                      erro(context, 'Erro ao deletar Horário: $e');
                                    }
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
              Navigator.pop(context);
            },
          ),
          iconTheme: IconThemeData(color: cores('corSimbolo')),
          title: Text(
            widget.tipo == 'adicionar' ? "Adicionar Horário" : "Atualizar Horário",
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
                    icone: Icons.label,
                    list: listaPaciente,
                    labelText: labelText,
                    textSuggetionsColor: cores('corSimbolo'),
                    suggetionsBackgroundColor: cores('corCaixaPadrao'),
                    outlineInputBorderColor: cores('corSombra'),
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
                          widget.tipo == 'adicionar' ? 'Adicionar' : 'Atualizar',
                          style: TextStyle(fontSize: tamanhoFonte.letraPequena(context)),
                        ),
                        onPressed: () async {
                          String colorHex = selecioneCorConsulta.value.toRadixString(16).padLeft(8, '0');
                          if (widget.tipo == 'adicionar') {
                            adicionarConsultas(
                              context,
                              nomeConsulta.text,
                              dataConsulta.text,
                              horarioConsulta.text,
                              duracaoConsulta.text,
                              selecioneFrequenciaConsulta,
                              selecioneSemanaConsulta,
                              colorHex,
                            );
                          } else {
                            editarConsultas(
                              context,
                              id,
                              idUsuario(),
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
