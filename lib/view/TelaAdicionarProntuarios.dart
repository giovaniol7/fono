import 'package:flutter/material.dart';

import 'package:brasil_fields/brasil_fields.dart';
import 'package:fonocare/connections/fireAuth.dart';
import 'package:fonocare/connections/fireCloudProntuarios.dart';
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
  var uidPaciente = '';
  String selecioneProntuario = 'Presente';
  var varAtivo = '1';

  Future<void> atualizarDados() async {
    await carregarDados();
  }

  carregarDados() async {
    print(widget.appointments);
    List<String> lista = await fazerListaPacientes(varAtivo);
    appointment = await carregarAppointment(widget.appointments);

    if (widget.tipo == 'adicionar') {
      String nome = widget.appointments.subject;
      var paciente = await recuperarPacientePorNome(context, nome);
      uidPaciente = paciente['uidPaciente'];
      DateTime dataSeteDiasAtras = widget.dataClicada.subtract(Duration(days: 7));
      prontuarios = await recuperarProntuarioData(context, uidPaciente, DateFormat('dd/MM/yyyy').format(dataSeteDiasAtras));
    } else if (widget.tipo == 'editar') {
      String nome = widget.appointments.subject;
      var paciente = await recuperarPacientePorNome(context, nome);
      String uidPaciente = paciente['uidPaciente'];
      prontuarios = await recuperarProntuarioData(context, uidPaciente, DateFormat('dd/MM/yyyy').format(widget.dataClicada));
    }

    setState(() {
      listaPaciente = lista;
      String dataFormatada = DateFormat('dd/MM/yyyy').format(widget.dataClicada);

      labelText = appointment['nomeConsulta'];
      _paciente = appointment['nomeConsulta'];
      txtNome.text = appointment['nomeConsulta'];
      txtData.text = dataFormatada;
      txtTime.text = appointment['horarioConsulta'];
      uidProntuario = prontuarios['uidProntuario'];
      txtObjetivosProntuarios.text = prontuarios['objetivosProntuario'];
      txtMateriaisProntuarios.text = prontuarios['materiaisProntuario'];
      txtResultadosProntuarios.text = prontuarios['resultadosProntuario'];
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
                            content: const Text('Tem certeza de que deseja apagar este Prontuário?'),
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
                                  await apagarProntuario(context, uidProntuario);
                                },
                              ),
                            ],
                          );
                        });
                  })
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
                        onchaged: (value) async {
                          DateTime data = DateFormat('dd/MM/yyyy').parse(txtData.text);
                          DateTime dataSeteDiasAtras = data.subtract(Duration(days: 7));
                          String dataFormatada = DateFormat('dd/MM/yyyy').format(dataSeteDiasAtras);
                          prontuarios = await recuperarProntuarioData(context, uidPaciente, dataFormatada);
                          setState(() {
                            txtObjetivosProntuarios.text = prontuarios['objetivosProntuario'];
                            txtMateriaisProntuarios.text = prontuarios['materiaisProntuario'];
                          });
                        },
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
                    maxPalavras: 2000, maxLinhas: 5, tamanho: 20.0),
                const SizedBox(height: 20),
                campoTexto('Materiais/Estratégias', txtMateriaisProntuarios, Icons.description,
                    maxPalavras: 2000, maxLinhas: 5, tamanho: 20.0),
                const SizedBox(height: 20),
                campoTexto('Resultados', txtResultadosProntuarios, Icons.description,
                    maxPalavras: 2000, maxLinhas: 5, tamanho: 20.0),
                const SizedBox(height: 40),
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
                        widget.tipo == 'editar' ? 'Atualizar' : "Adicionar",
                        style: TextStyle(fontSize: tamanhoFonte.letraPequena(context)),
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
                                  uidProntuario,
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
                    SizedBox(width: 10),
                    OutlinedButton(
                      style: OutlinedButton.styleFrom(
                          foregroundColor: cores('corSecundaria'),
                          backgroundColor: cores('corTexto'),
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
          ),
        ],
      ),
    );
  }
}
