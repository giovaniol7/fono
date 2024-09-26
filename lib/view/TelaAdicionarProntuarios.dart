import 'package:flutter/material.dart';

import 'package:brasil_fields/brasil_fields.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import '../connections/fireAuth.dart';
import '../connections/fireCloudProntuarios.dart';
import '../connections/fireCloudConsultas.dart';
import '../connections/fireCloudPacientes.dart';
import '../controllers/variaveis.dart';
import '../controllers/estilos.dart';
import '../widgets/TextFieldSuggestions.dart';
import '../widgets/campoTexto.dart';
import '../widgets/toggleSwitch.dart';

class TelaAdicionarProntuarios extends StatefulWidget {
  const TelaAdicionarProntuarios();

  @override
  State<TelaAdicionarProntuarios> createState() => _TelaAdicionarProntuariosState();
}

class _TelaAdicionarProntuariosState extends State<TelaAdicionarProntuarios> {
  int verificar = 0;
  late String? tipo;
  late Appointment? tappedAppointment;
  late DateTime? dataClicada;

  carregarDados() async {
    List<String> lista = await fazerListaPacientes(AppVariaveis().varAtivoPaciente);
    AppVariaveis().appointmentProntuario = await carregarAppointment(tappedAppointment);

    if (tipo == 'adicionar') {
      String nome = tappedAppointment!.subject;
      var paciente = await recuperarPacientePorNome(context, nome);
      AppVariaveis().uidPaciente = paciente['uidPaciente'];
      DateTime dataSeteDiasAtras = dataClicada!.subtract(Duration(days: 7));
      AppVariaveis().prontuariosAdd = await recuperarProntuarioData(
          context, AppVariaveis().uidPaciente, DateFormat('dd/MM/yyyy').format(dataSeteDiasAtras));
    } else if (tipo == 'editar') {
      String nome = tappedAppointment!.subject;
      var paciente = await recuperarPacientePorNome(context, nome);
      AppVariaveis().uidPaciente = paciente['uidPaciente'];
      AppVariaveis().prontuariosAdd = await recuperarProntuarioData(
          context, AppVariaveis().uidPaciente, DateFormat('dd/MM/yyyy').format(dataClicada!));
    }

    setState(() {
      tipo == 'adicionar'
          ? AppVariaveis().txtDataProntuario.text =
              "${AppVariaveis().nowTimer.day.toString().padLeft(2, '0')}/${AppVariaveis().nowTimer.month.toString().padLeft(2, '0')}/${AppVariaveis().nowTimer.year.toString()}"
          : null;

      AppVariaveis().listaPaciente = lista;
      String dataFormatada = DateFormat('dd/MM/yyyy').format(dataClicada!);
      AppVariaveis().labelText = AppVariaveis().appointmentProntuario['nomeConsulta'];
      AppVariaveis().pacienteNome = AppVariaveis().appointmentProntuario['nomeConsulta'];
      AppVariaveis().txtNomePaciente.text = AppVariaveis().appointmentProntuario['nomeConsulta'];
      AppVariaveis().txtDataProntuario.text = dataFormatada;
      AppVariaveis().txtTimeProntuario.text = AppVariaveis().appointmentProntuario['horarioConsulta'];
      AppVariaveis().uidProntuario = AppVariaveis().prontuariosAdd['uidProntuario'];
      AppVariaveis().txtObjetivosProntuarios.text = AppVariaveis().prontuariosAdd['objetivosProntuario'];
      AppVariaveis().txtMateriaisProntuarios.text = AppVariaveis().prontuariosAdd['materiaisProntuario'];
      AppVariaveis().txtResultadosProntuarios.text = AppVariaveis().prontuariosAdd['resultadosProntuario'];
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
      dataClicada = arguments['dataClicada'] as DateTime?;
      verificar = 1;
      carregarDados();
    }

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
                            content: const Text('Tem certeza de que deseja apagar este Prontuário?'),
                            actions: <Widget>[
                              TextButton(
                                child: const Text(
                                  'Cancelar',
                                  style: TextStyle(color: Colors.blue),
                                ),
                                onPressed: () {
                                  AppVariaveis().resetProntuario();
                                  Navigator.of(context).pop();
                                },
                              ),
                              TextButton(
                                child: const Text(
                                  'Apagar',
                                  style: TextStyle(color: Colors.red),
                                ),
                                onPressed: () async {
                                  await apagarProntuario(context, AppVariaveis().uidProntuario);
                                  AppVariaveis().resetProntuario();
                                  Navigator.pop(context);
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
            AppVariaveis().resetProntuario();
            Navigator.pop(context);
          },
        ),
        title: Text(
          tipo == 'editar' ? 'Editar Prontuário' : "Adicionar Prontuário",
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
                tipo == 'adicionar'
                    ? toggleSwitch2(
                        AppVariaveis().index,
                        AppVariaveis().toggleOptionsPaciente,
                        Icons.check_circle,
                        Icons.cancel,
                        (value) {
                          setState(() {
                            AppVariaveis().selecioneProntuario = value == 0 ? 'Presente' : 'Faltou';
                            AppVariaveis().selecioneProntuario = value == 0
                                ? AppVariaveis().txtResultadosProntuarios.text = ''
                                : AppVariaveis().txtResultadosProntuarios.text = 'Faltou';
                            AppVariaveis().index = value!;
                          });
                        },
                      )
                    : Container(),
                const SizedBox(height: 20),
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
                        AppVariaveis().txtNomePaciente.text = AppVariaveis().pacienteNome;
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
                        AppVariaveis().txtDataProntuario,
                        Icons.calendar_month_outlined,
                        formato: DataInputFormatter(),
                        boardType: 'numeros',
                        onchaged: (value) async {
                          DateTime data =
                              DateFormat('dd/MM/yyyy').parse(AppVariaveis().txtDataProntuario.text);
                          DateTime dataSeteDiasAtras = data.subtract(Duration(days: 7));
                          String dataFormatada = DateFormat('dd/MM/yyyy').format(dataSeteDiasAtras);
                          AppVariaveis().prontuariosAdd = await recuperarProntuarioData(
                              context, AppVariaveis().uidPaciente, dataFormatada);
                          setState(() {
                            AppVariaveis().txtObjetivosProntuarios.text =
                                AppVariaveis().prontuariosAdd['objetivosProntuario'];
                            AppVariaveis().txtMateriaisProntuarios.text =
                                AppVariaveis().prontuariosAdd['materiaisProntuario'];
                            AppVariaveis().txtResultadosProntuarios.text =
                                AppVariaveis().prontuariosAdd['resultadosProntuario'];
                          });
                        },
                        iconPressed: () async {
                          AppVariaveis().pickedDate = await showDatePicker(
                            context: context,
                            initialDate: AppVariaveis().selectedDate,
                            firstDate: DateTime.now().subtract(Duration(days: 90)),
                            lastDate: DateTime(2100),
                          );
                          if (AppVariaveis().pickedDate != null &&
                              AppVariaveis().pickedDate != AppVariaveis().selectedDate) {
                            AppVariaveis().selectedDate = AppVariaveis().pickedDate!;
                            AppVariaveis().txtDataProntuario.text =
                                "${AppVariaveis().selectedDate.day.toString().padLeft(2, '0')}/${AppVariaveis().selectedDate.month.toString().padLeft(2, '0')}/${AppVariaveis().selectedDate.year.toString()}";

                            DateTime data =
                                DateFormat('dd/MM/yyyy').parse(AppVariaveis().txtDataProntuario.text);
                            DateTime dataSeteDiasAtras = data.subtract(Duration(days: 7));
                            String dataFormatada = DateFormat('dd/MM/yyyy').format(dataSeteDiasAtras);
                            AppVariaveis().prontuariosAdd = await recuperarProntuarioData(
                                context, AppVariaveis().uidPaciente, dataFormatada);
                            setState(() {
                              AppVariaveis().txtObjetivosProntuarios.text =
                                  AppVariaveis().prontuariosAdd['objetivosProntuario'];
                              AppVariaveis().txtMateriaisProntuarios.text =
                                  AppVariaveis().prontuariosAdd['materiaisProntuario'];
                              AppVariaveis().txtResultadosProntuarios.text =
                                  AppVariaveis().prontuariosAdd['resultadosProntuario'];
                            });
                          }
                        },
                      ),
                    ),
                    const Padding(padding: EdgeInsets.only(right: 10)),
                    Expanded(
                      child: campoTexto(
                        'Horário da Consulta',
                        AppVariaveis().txtTimeProntuario,
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
                              AppVariaveis().txtTimeProntuario.text =
                                  AppVariaveis().selectedTime.format(context);
                            });
                          }
                        },
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 20),
                campoTexto('Objetivos da Sessão', AppVariaveis().txtObjetivosProntuarios, Icons.description,
                    maxPalavras: 2000, maxLinhas: 5, tamanho: 20.0, boardType: 'multiLinhas'),
                const SizedBox(height: 20),
                campoTexto('Materiais/Estratégias', AppVariaveis().txtMateriaisProntuarios, Icons.description,
                    maxPalavras: 2000, maxLinhas: 5, tamanho: 20.0, boardType: 'multiLinhas'),
                const SizedBox(height: 20),
                campoTexto('Resultados', AppVariaveis().txtResultadosProntuarios, Icons.description,
                    maxPalavras: 5000, maxLinhas: 5, tamanho: 20.0, boardType: 'multiLinhas'),
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
                      child:
                          Text(tipo == 'editar' ? 'Atualizar' : "Adicionar", style: TextStyle(fontSize: 16)),
                      onPressed: () async {
                        if (AppVariaveis().txtNomePaciente.text.isNotEmpty &&
                            AppVariaveis().txtDataProntuario.text.isNotEmpty &&
                            AppVariaveis().txtTimeProntuario.text.isNotEmpty &&
                            AppVariaveis().txtObjetivosProntuarios.text.isNotEmpty &&
                            AppVariaveis().txtMateriaisProntuarios.text.isNotEmpty &&
                            AppVariaveis().txtResultadosProntuarios.text.isNotEmpty) {
                          AppVariaveis().uidPaciente =
                              await buscarIdPaciente(context, AppVariaveis().txtNomePaciente.text);
                          tipo == 'adicionar'
                              ? adicionarProntuario(
                                  context,
                                  idFonoAuth(),
                                  AppVariaveis().uidPaciente,
                                  AppVariaveis().txtNomePaciente.text,
                                  AppVariaveis().txtDataProntuario.text,
                                  AppVariaveis().txtTimeProntuario.text,
                                  AppVariaveis().txtObjetivosProntuarios.text,
                                  AppVariaveis().txtMateriaisProntuarios.text,
                                  AppVariaveis().txtResultadosProntuarios.text)
                              : editarProntuario(
                                  context,
                                  AppVariaveis().uidProntuario,
                                  idFonoAuth(),
                                  AppVariaveis().uidPaciente,
                                  AppVariaveis().txtNomePaciente.text,
                                  AppVariaveis().txtDataProntuario.text,
                                  AppVariaveis().txtTimeProntuario.text,
                                  AppVariaveis().txtObjetivosProntuarios.text,
                                  AppVariaveis().txtMateriaisProntuarios.text,
                                  AppVariaveis().txtResultadosProntuarios.text);
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
                      child: Text('Cancelar', style: TextStyle(fontSize: 16)),
                      onPressed: () {
                        AppVariaveis().resetProntuario();
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
