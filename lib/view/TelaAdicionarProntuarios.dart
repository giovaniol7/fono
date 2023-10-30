import 'package:flutter/material.dart';

import 'package:brasil_fields/brasil_fields.dart';
import 'package:fono/connections/fireAuth.dart';
import 'package:fono/connections/fireCloudProntuarios.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import '../connections/fireCloudConsultas.dart';
import '../connections/fireCloudPacientes.dart';
import '../controllers/estilos.dart';
import '../widgets/TextFieldSuggestions.dart';
import '../widgets/campoTexto.dart';
import '../widgets/toggleSwitch.dart';

class TelaAdicionarProntuarios extends StatefulWidget {
  final String tipo;
  final Appointment appointments;
  final DateTime dataClicada;

  const TelaAdicionarProntuarios(this.tipo, this.appointments, this.dataClicada, {super.key});

  @override
  State<TelaAdicionarProntuarios> createState() => _TelaAdicionarProntuariosState();
}

class _TelaAdicionarProntuariosState extends State<TelaAdicionarProntuarios> {
  late DateTime selectedDate;
  late TimeOfDay selectedTime;
  DateTime? pickedDate;
  String uidProntuario = '';
  var txtNome = TextEditingController();
  var txtData = TextEditingController();
  var txtTime = TextEditingController();
  var txtObjetivosProntuarios = TextEditingController();
  var txtMateriaisProntuarios = TextEditingController();
  var txtResultadosProntuarios = TextEditingController();
  String labelText = "Nome do Paciente";
  String _paciente = '';
  List<String> listaPaciente = [];
  var appointment;
  var prontuarios;
  int index = 0;
  String selecioneProntuario = 'Presente';

  Future<void> atualizarDados() async {
    await carregarDados();
  }

  carregarDados() async {
    List<String> lista = await fazerListaPacientes();
    appointment = await carregarAppointment(widget.appointments);

    if (widget.tipo == 'adicionar') {
      String nome = widget.appointments.subject;
      var paciente = await recuperarPacientePorNome(context, nome);
      String uidPaciente = paciente['uidPaciente'];
      DateTime dataAtual = DateTime.now();
      DateTime dataSeteDiasAtras = dataAtual.subtract(Duration(days: 7));
      String dataFormatada = DateFormat('dd/MM/yyyy').format(dataSeteDiasAtras);
      prontuarios = await recuperarProntuarioData(context, uidPaciente, dataFormatada);

    } else if (widget.tipo == 'editar') {
      String nome = widget.appointments.subject;
      var paciente = await recuperarPacientePorNome(context, nome);
      String uidPaciente = paciente['uidPaciente'];
      prontuarios = await recuperarProntuarioData(context, uidPaciente, DateFormat('dd/MM/yyyy').format(widget.dataClicada));
    }

    setState(() {
      listaPaciente = lista;
      String dataFormatada = DateFormat('dd/MM/yyyy').format(widget.dataClicada);

      if (widget.tipo == 'adicionar') {
        labelText = appointment['nomeConsulta'];
        _paciente = appointment['nomeConsulta'];
        txtNome.text = appointment['nomeConsulta'];
        txtData.text = dataFormatada;
        txtTime.text = appointment['horarioConsulta'];
        txtObjetivosProntuarios.text = prontuarios['objetivosProntuario'];
        txtMateriaisProntuarios.text = prontuarios['materiaisProntuario'];
        txtResultadosProntuarios.text = '';
      } else if (widget.tipo == 'editar') {
        labelText = prontuarios['nomePaciente'];
        _paciente = prontuarios['nomePaciente'];
        uidProntuario = prontuarios['uidProntuario'];
        txtNome.text = prontuarios['nomePaciente'];
        txtData.text = prontuarios['dataProntuario'];
        txtTime.text = prontuarios['horarioProntuario'];
        txtObjetivosProntuarios.text = prontuarios['objetivosProntuario'];
        txtMateriaisProntuarios.text = prontuarios['materiaisProntuario'];
        txtResultadosProntuarios.text = prontuarios['resultadosProntuario'];
      }
    });
  }

  @override
  void initState() {
    super.initState();
    DateTime now = DateTime.now();
    widget.tipo == 'adicionar'
        ? txtData.text =
            "${now.day.toString().padLeft(2, '0')}/${now.month.toString().padLeft(2, '0')}/${now.year.toString()}"
        : null;
    selectedDate = DateTime.now();
    selectedTime = TimeOfDay.now();
    carregarDados();
  }

  Widget build(BuildContext context) {
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
                    await apagarProntuario(context, uidProntuario);
                  },
                )
              : Container(),
        ],
        iconTheme: IconThemeData(color: cores('corTexto')),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          widget.tipo == 'editar' ? 'Editar Prontuário' : "Adicionar Prontuário",
          style: TextStyle(color: cores('corTexto')),
        ),
        backgroundColor: cores('corFundo'),
      ),
      body: ListView(
        children: [
          Container(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                widget.tipo == 'adicionar'
                    ? toggleSwitch2(
                        index,
                        'Presente',
                        'Faltou',
                        Icons.check_circle,
                        Icons.cancel,
                        (value) {
                          setState(() {
                            selecioneProntuario = value == 0 ? 'Presente' : 'Faltou';
                            selecioneProntuario = value == 0
                                ? txtResultadosProntuarios.text = ''
                                : txtResultadosProntuarios.text = 'Faltou';
                            index = value!;
                          });
                        },
                      )
                    : Container(),
                const SizedBox(height: 20),
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
                        txtNome.text = _paciente;
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
                        txtData,
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
                              txtData.text =
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
                        txtTime,
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
                              txtTime.text = selectedTime.format(context);
                            });
                          }
                        },
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 20),
                campoTexto('Objetivos da Sessão', txtObjetivosProntuarios, Icons.description,
                    maxPalavras: 500, maxLinhas: 5, tamanho: 20.0),
                const SizedBox(height: 20),
                campoTexto('Materiais/Estratégias', txtMateriaisProntuarios, Icons.description,
                    maxPalavras: 500, maxLinhas: 5, tamanho: 20.0),
                const SizedBox(height: 20),
                campoTexto('Resultados', txtResultadosProntuarios, Icons.description,
                    maxPalavras: 500, maxLinhas: 5, tamanho: 20.0),
                const SizedBox(height: 40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 150,
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                            foregroundColor: cores('corTextoBotao'),
                            minimumSize: const Size(200, 45),
                            backgroundColor: cores('corBotao'),
                            elevation: 5,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(32),
                            )),
                        child: Text(
                          widget.tipo == 'editar' ? 'Atualizar' : "Adicionar",
                          style: TextStyle(fontSize: 18),
                        ),
                        onPressed: () async {
                          if (txtNome.text.isNotEmpty &&
                              txtData.text.isNotEmpty &&
                              txtTime.text.isNotEmpty &&
                              txtObjetivosProntuarios.text.isNotEmpty &&
                              txtMateriaisProntuarios.text.isNotEmpty &&
                              txtResultadosProntuarios.text.isNotEmpty) {
                            String uidPaciente = await buscarIdPaciente(context, txtNome.text);
                            widget.tipo == 'adicionar'
                                ? adicionarProntuario(
                                    context,
                                    idUsuario(),
                                    uidPaciente,
                                    txtNome.text,
                                    txtData.text,
                                    txtTime.text,
                                    txtObjetivosProntuarios.text,
                                    txtMateriaisProntuarios.text,
                                    txtResultadosProntuarios.text)
                                : editarProntuario(
                                    context,
                                    idUsuario(),
                                    uidPaciente,
                                    txtNome.text,
                                    txtData.text,
                                    txtTime.text,
                                    txtObjetivosProntuarios.text,
                                    txtMateriaisProntuarios.text,
                                    txtResultadosProntuarios.text);
                          }
                        },
                      ),
                    ),
                    Padding(padding: EdgeInsets.all(20)),
                    SizedBox(
                      width: 150,
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                            foregroundColor: cores('corSecundaria'),
                            minimumSize: const Size(200, 45),
                            backgroundColor: cores('corTexto'),
                            elevation: 5,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(32),
                            )),
                        child: const Text(
                          'Cancelar',
                          style: TextStyle(fontSize: 18),
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
          ),
        ],
      ),
    );
  }
}
