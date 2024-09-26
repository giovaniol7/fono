import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:brasil_fields/brasil_fields.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:search_cep/search_cep.dart';
import 'package:path/path.dart' as ph;

import '../connections/fireAuth.dart';
import '../connections/fireCloudEscolas.dart';
import '../connections/fireCloudPacientes.dart';
import '../controllers/uploadDoc.dart';
import '../controllers/uploadImage.dart';
import '../controllers/variaveis.dart';
import '../controllers/estilos.dart';
import '../models/maps.dart';
import '../widgets/TextFieldSuggestions.dart';
import '../widgets/campoTexto.dart';
import '../widgets/mensagem.dart';

class TelaAdicionarPaciente extends StatefulWidget {
  const TelaAdicionarPaciente();

  @override
  State<TelaAdicionarPaciente> createState() => _TelaAdicionarPacienteState();
}

class _TelaAdicionarPacienteState extends State<TelaAdicionarPaciente> {
  late String? tipo;
  late String? uidPaciente;

  bool validarCampos() {
    return (AppVariaveis().keyDataAnamnese.currentState!.validate() &&
        AppVariaveis().keyNomePaciente.currentState!.validate() &&
        AppVariaveis().keyDtNascimentoPaciente.currentState!.validate() &&
        AppVariaveis().keyCPFPaciente.currentState!.validate() &&
        AppVariaveis().keyProfessoraPaciente.currentState!.validate() &&
        AppVariaveis().keyCEPPaciente.currentState!.validate() &&
        AppVariaveis().keyLougradouroPaciente.currentState!.validate() &&
        AppVariaveis().keyNumeroPaciente.currentState!.validate() &&
        AppVariaveis().keyBairroPaciente.currentState!.validate() &&
        AppVariaveis().keyCidadePaciente.currentState!.validate() &&
        AppVariaveis().keyNomeResponsavelPaciente.currentState!.validate() &&
        AppVariaveis().keyIdadeResponsavelPaciente.currentState!.validate() &&
        AppVariaveis().keyTelefoneResponsavelPaciente.currentState!.validate() &&
        AppVariaveis().keyProfissaoResponsavelPaciente.currentState!.validate());
  }

  Future<void> atualizarDados() async {
    await carregarDados();
  }

  carregarDados() async {
    List<String> lista = await fazerListaEscolas();
    AppVariaveis().listaEscolaPaciente = lista;

    tipo == 'editar' ? AppVariaveis().pacienteEdit = await recuperarPaciente(context, uidPaciente) : null;

    setState(() {
      if (tipo == 'editar') {
        AppVariaveis().uidPaciente = AppVariaveis().pacienteEdit['uidPaciente']!;
        AppVariaveis().uidFono = AppVariaveis().pacienteEdit['uidFono']!;
        AppVariaveis().urlImagePaciente = AppVariaveis().pacienteEdit['urlImagePaciente'] ?? '';
        AppVariaveis().txtDataAnamnesePaciente.text = AppVariaveis().pacienteEdit['dataAnamnesePaciente']!;
        AppVariaveis().txtNomePaciente.text = AppVariaveis().pacienteEdit['nomePaciente']!;
        AppVariaveis().txtDataNascimentoPaciente.text = AppVariaveis().pacienteEdit['dtNascimentoPaciente']!;
        AppVariaveis().txtCPFPaciente.text = AppVariaveis().pacienteEdit['CPFPaciente']!;
        AppVariaveis().txtRGPaciente.text = AppVariaveis().pacienteEdit['RGPaciente']!;
        AppVariaveis().selectedGeneroPaciente = AppVariaveis().pacienteEdit['generoPaciente'] as Gender?;
        AppVariaveis().outraEscolaPaciente = AppVariaveis().pacienteEdit['escolaPaciente']!;
        AppVariaveis().txtEscolaPaciente = AppVariaveis().pacienteEdit['escolaPaciente']!;
        AppVariaveis().selecioneEscolaridadePaciente = AppVariaveis().pacienteEdit['escolaridadePaciente']!;
        AppVariaveis().selecionePeriodoEscolaPaciente = AppVariaveis().pacienteEdit['periodoEscolaPaciente']!;
        AppVariaveis().txtProfessoraPaciente.text = AppVariaveis().pacienteEdit['professoraPaciente']!;
        AppVariaveis().txtTelefoneProfessoraPaciente.text =
            AppVariaveis().pacienteEdit['telefoneProfessoraPaciente']!;
        AppVariaveis().txtLogradouroPaciente.text = AppVariaveis().pacienteEdit['lougradouroPaciente']!;
        AppVariaveis().txtNumeroPaciente.text = AppVariaveis().pacienteEdit['numeroPaciente']!;
        AppVariaveis().txtBairroPaciente.text = AppVariaveis().pacienteEdit['bairroPaciente']!;
        AppVariaveis().txtCidadePaciente.text = AppVariaveis().pacienteEdit['cidadePaciente']!;
        AppVariaveis().selecioneEstadoPaciente = AppVariaveis().pacienteEdit['estadoPaciente']!;
        AppVariaveis().txtCEPPaciente.text = AppVariaveis().pacienteEdit['cepPaciente']!;
        AppVariaveis().selecioneTipoConsultaPaciente = AppVariaveis().pacienteEdit['tipoConsultaPaciente']!;
        AppVariaveis().txtDescricaoPaciente.text = AppVariaveis().pacienteEdit['descricaoPaciente']!;
        AppVariaveis().qtdResponsavelPaciente = AppVariaveis().pacienteEdit['qtdResponsavel'];
        AppVariaveis().nomeArquivoPaciente = AppVariaveis().pacienteEdit['urlDocPaciente'] == ''
            ? ''
            : urlToString(AppVariaveis().pacienteEdit['urlDocPaciente']);
        AppVariaveis().varAtivoPaciente = AppVariaveis().pacienteEdit['varAtivo'];
        AppVariaveis().switchValuePaciente = AppVariaveis().varAtivoPaciente == '1';
        AppVariaveis().ListGeneroResponsavelPaciente =
            AppVariaveis().pacienteEdit['listGeneroResponsavel'] as List<Gender?>;
        AppVariaveis().ListNomeResponsavelPaciente =
            (AppVariaveis().pacienteEdit['listNomeResponsavel'] as List<String>)
                .map((nome) => TextEditingController(text: nome))
                .toList();
        AppVariaveis().ListIdadeResponsavelPaciente =
            (AppVariaveis().pacienteEdit['listIdadeResponsavel'] as List<String>)
                .map((nome) => TextEditingController(text: nome))
                .toList();
        AppVariaveis().ListTelefoneResponsavelPaciente =
            (AppVariaveis().pacienteEdit['listTelefoneResponsavel'] as List<String>)
                .map((nome) => TextEditingController(text: nome))
                .toList();
        AppVariaveis().ListRelacaoResponsavelPaciente =
            AppVariaveis().pacienteEdit['listRelacaoResponsavel'] as List<String>;
        AppVariaveis().ListEscolaridadeResponsavelPaciente =
            AppVariaveis().pacienteEdit['listEscolaridadeResponsavel'] as List<String>;
        AppVariaveis().ListProfissaoResponsavelPaciente =
            (AppVariaveis().pacienteEdit['listProfissaoResponsavel'] as List<String>)
                .map((nome) => TextEditingController(text: nome))
                .toList();
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
    if (arguments != null && arguments['uidPaciente'] != null) {
      tipo = arguments['tipo'] as String?;
      uidPaciente = arguments['uidPaciente'] as String?;
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
                            content: const Text('Tem certeza de que deseja apagar este Paciente?'),
                            actions: <Widget>[
                              TextButton(
                                child: const Text(
                                  'Cancelar',
                                  style: TextStyle(color: Colors.blue),
                                ),
                                onPressed: () {
                                  AppVariaveis().resetPaciente();
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
                                    await apagarPaciente(context, uidPaciente);
                                  } catch (e) {
                                    erro(context, 'Erro ao deletar Prontuário: $e');
                                  }
                                  AppVariaveis().resetPaciente();
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
        iconTheme: IconThemeData(color: cores('corTexto')),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            AppVariaveis().resetPaciente();
            Navigator.pop(context);
          },
        ),
        title: Text(
          tipo == 'editar' ? 'Editar Paciente' : "Adicionar Paciente",
          style: TextStyle(color: cores('corTexto')),
        ),
        backgroundColor: cores('corFundo'),
      ),
      body: Container(
          child: ListView(
        children: [
          containerCabecalho(),
          containerDados(),
        ],
      )),
    );
  }

  containerCabecalho() {
    return Column(
      children: [
        Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height * 0.2,
          decoration: BoxDecoration(
              color: cores('corSombra'),
              boxShadow: [
                BoxShadow(offset: const Offset(0, 3), color: cores('corSombra'), blurRadius: 5),
              ],
              borderRadius:
                  const BorderRadius.only(bottomRight: Radius.circular(16), bottomLeft: Radius.circular(16))),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Center(
                child: Container(
                  width: 80.0,
                  height: 80.0,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: cores('corBotao'),
                  ),
                  child: AppVariaveis().urlImagePaciente.isEmpty
                      ? InkWell(
                          onTap: () async {
                            AppVariaveis().fileImagePaciente = await pickedImage();
                            setState(() {
                              AppVariaveis().fileImagePaciente = AppVariaveis().fileImagePaciente!;
                            });
                          },
                          child: AppVariaveis().fileImagePaciente == null
                              ? Icon(Icons.person_add_alt_rounded, color: cores('corTextoBotao'))
                              : CircleAvatar(
                                  maxRadius: 5,
                                  minRadius: 1,
                                  backgroundImage: FileImage(File(AppVariaveis().fileImagePaciente.path)),
                                ),
                        )
                      : Stack(children: [
                          CircleAvatar(
                            radius: 80,
                            backgroundImage: NetworkImage(AppVariaveis().urlImagePaciente),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: cores('branco').withOpacity(0.5),
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: IconButton(
                                icon: Icon(Icons.delete, color: cores('corSimbolo')),
                                onPressed: () {
                                  setState(() {
                                    AppVariaveis().apagarImagemPaciente == true;
                                    AppVariaveis().urlImagePaciente = '';
                                  });
                                },
                              ),
                            ),
                          ),
                        ]),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  containerDados() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          containerDadosPaciente(),
          containerDadosEndereco(),
          Text(
            'Selecione o tipo de Consulta:',
            style: TextStyle(fontSize: 16, color: cores('corTexto'), fontWeight: FontWeight.bold),
          ),
          Container(
            padding: const EdgeInsets.only(left: 10),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
                border: Border.all(color: cores('corBorda')),
                color: cores('branco'),
                boxShadow: [
                  BoxShadow(offset: const Offset(0, 3), color: cores('corSombra'), blurRadius: 5)
                  // changes position of shadow
                ]),
            child: DropdownButton<String>(
              icon: const Icon(Icons.arrow_drop_down),
              iconSize: 30,
              iconEnabledColor: cores('corTexto'),
              style: TextStyle(color: cores('corTexto'), fontWeight: FontWeight.w400, fontSize: 16),
              underline: Container(
                height: 0,
              ),
              isExpanded: true,
              hint: const Text('Selecione uma Opção'),
              value: AppVariaveis().selecioneTipoConsultaPaciente,
              items: consulta.map(buildMenuItem).toList(),
              onChanged: (value) {
                setState(() {
                  AppVariaveis().selecioneTipoConsultaPaciente = value!;
                });
              },
            ),
          ),
          const SizedBox(height: 20),
          campoTexto('Descrição/Queixa', AppVariaveis().txtDescricaoPaciente, Icons.description,
              maxPalavras: 200, maxLinhas: 5, tamanho: 20.0, boardType: 'multiLinhas'),
          containerResponsavel(),
          containerAnexo(),
          containerAtivo(),
          rowBotao(),
          const SizedBox(height: 60),
        ],
      ),
    );
  }

  containerDadosPaciente() {
    return Column(
      children: [
        campoTexto('Data Anamnese', AppVariaveis().txtDataAnamnesePaciente, Icons.calendar_today,
            formato: DataInputFormatter(),
            boardType: 'numeros',
            key: AppVariaveis().keyDataAnamnese,
            validator: true),
        const SizedBox(height: 20),
        campoTexto('Nome', AppVariaveis().txtNomePaciente, Icons.label,
            key: AppVariaveis().keyNomePaciente, validator: true),
        const SizedBox(height: 20),
        campoTexto(
            'Data de Nascimento', AppVariaveis().txtDataNascimentoPaciente, Icons.calendar_month_outlined,
            formato: DataInputFormatter(),
            boardType: 'numeros',
            key: AppVariaveis().keyDtNascimentoPaciente,
            validator: true),
        const SizedBox(height: 20),
        Row(
          children: [
            Expanded(
              child: campoTexto('CPF', AppVariaveis().txtCPFPaciente, Icons.credit_card,
                  formato: CpfInputFormatter(),
                  boardType: 'numeros',
                  key: AppVariaveis().keyCPFPaciente,
                  validator: true),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: campoTexto('RG', AppVariaveis().txtRGPaciente, Icons.credit_card,
                  formato: MaskTextInputFormatter(
                    mask: '##.###.###-#',
                    filter: {"#": RegExp(r'[0-9]')},
                  ),
                  boardType: 'numeros'),
            ),
          ],
        ),
        const SizedBox(height: 20),
        Text(
          'Sexo:',
          style: TextStyle(fontSize: 16, color: cores('corTexto'), fontWeight: FontWeight.bold),
        ),
        Row(
          children: [
            Expanded(
              child: RadioListTile<Gender>(
                title: Text(
                  'Masculino',
                  style: TextStyle(color: cores('corTexto')),
                ),
                value: Gender.male,
                groupValue: AppVariaveis().selectedGeneroPaciente,
                activeColor: cores('corSimbolo'),
                onChanged: (value) {
                  setState(() {
                    AppVariaveis().selectedGeneroPaciente = value;
                  });
                },
              ),
            ),
            Expanded(
              child: RadioListTile<Gender>(
                title: Text(
                  'Feminino',
                  style: TextStyle(color: cores('corTexto')),
                ),
                value: Gender.female,
                groupValue: AppVariaveis().selectedGeneroPaciente,
                activeColor: cores('corSimbolo'),
                onChanged: (value) {
                  setState(() {
                    AppVariaveis().selectedGeneroPaciente = value;
                  });
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        TextFieldSuggestions(
            tipo: 'escola',
            icone: Icons.school,
            margem: EdgeInsets.zero,
            list: AppVariaveis().listaEscolaPaciente,
            labelText: AppVariaveis().outraEscolaPaciente,
            textSuggetionsColor: cores('corTexto'),
            suggetionsBackgroundColor: cores('branco'),
            outlineInputBorderColor: cores('corTexto'),
            returnedValue: (String value) {
              setState(() {
                AppVariaveis().txtEscolaPaciente = value;
              });
            },
            onTap: () {},
            height: 200),
        const SizedBox(height: 20),
        Row(
          children: [
            Expanded(
              child: Column(
                children: [
                  Text(
                    'Escolaridade: ',
                    style: TextStyle(fontSize: 16, color: cores('corTexto'), fontWeight: FontWeight.bold),
                  ),
                  Container(
                    padding: const EdgeInsets.only(left: 10),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.0),
                        border: Border.all(color: cores('corBorda')),
                        color: cores('branco'),
                        boxShadow: [
                          BoxShadow(offset: const Offset(0, 3), color: cores('corSombra'), blurRadius: 5)
                          // changes position of shadow
                        ]),
                    child: DropdownButton(
                      hint: Text('Escolaridade: ', style: TextStyle(color: cores('corTexto'))),
                      icon: Icon(Icons.arrow_drop_down, color: cores('corTexto')),
                      iconSize: 30,
                      iconEnabledColor: cores('corTexto'),
                      style: TextStyle(color: cores('corTexto'), fontWeight: FontWeight.w400, fontSize: 16),
                      underline: Container(height: 0),
                      isExpanded: true,
                      value: AppVariaveis().selecioneEscolaridadePaciente,
                      items: escolaridade.map(buildMenuItem).toList(),
                      onChanged: (newValue) {
                        setState(() {
                          AppVariaveis().selecioneEscolaridadePaciente = newValue!;
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                children: [
                  Text(
                    'Selecione o Período:',
                    style: TextStyle(fontSize: 16, color: cores('corTexto'), fontWeight: FontWeight.bold),
                  ),
                  Container(
                    padding: const EdgeInsets.only(left: 10),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.0),
                        border: Border.all(color: cores('corBorda')),
                        color: cores('branco'),
                        boxShadow: [
                          BoxShadow(offset: const Offset(0, 3), color: cores('corSombra'), blurRadius: 5)
                          // changes position of shadow
                        ]),
                    child: DropdownButton<String>(
                      icon: const Icon(Icons.arrow_drop_down),
                      iconSize: 30,
                      iconEnabledColor: cores('corTexto'),
                      style: TextStyle(
                        color: cores('corTexto'),
                        fontWeight: FontWeight.w400,
                        fontSize: 16,
                      ),
                      underline: Container(
                        height: 0,
                      ),
                      isExpanded: true,
                      hint: const Text('Selecione uma Opção'),
                      value: AppVariaveis().selecionePeriodoEscolaPaciente,
                      items: periodo.map(buildMenuItem).toList(),
                      onChanged: (value) {
                        setState(() {
                          AppVariaveis().selecionePeriodoEscolaPaciente = value!;
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            Expanded(
                child: campoTexto(
                    'Professora', AppVariaveis().txtProfessoraPaciente, FontAwesomeIcons.personChalkboard,
                    key: AppVariaveis().keyProfessoraPaciente, validator: true)),
            const SizedBox(width: 10),
            Expanded(
                child: campoTexto(
                    'Telefone Professora', AppVariaveis().txtTelefoneProfessoraPaciente, Icons.phone,
                    formato: TelefoneInputFormatter(), boardType: 'numeros')),
          ],
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  containerDadosEndereco() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: campoTexto('CEP', AppVariaveis().txtCEPPaciente, Icons.mail,
                  formato: CepInputFormatter(),
                  boardType: 'numeros',
                  key: AppVariaveis().keyCEPPaciente,
                  validator: true, onchaged: (value) async {
                var cepSemFormatacao = value.replaceAll(RegExp(r'[^0-9]'), '');
                var viaCepSearchCep = ViaCepSearchCep();
                var result = await viaCepSearchCep.searchInfoByCep(cep: cepSemFormatacao);
                result.fold(
                  (error) {
                    print('Ocorreu um erro ao buscar as informações do CEP: $error');
                  },
                  (viaCepInfo) {
                    setState(() {
                      String? localidade = viaCepInfo.localidade;
                      String? estado = viaCepInfo.uf;
                      AppVariaveis().txtCidadePaciente.text = localidade!;
                      AppVariaveis().selecioneEstadoPaciente = estado!;
                    });
                  },
                );
              }),
            ),
            const Padding(padding: EdgeInsets.only(right: 10)),
            Expanded(
                child: Column(
              children: [
                Text(
                  'Selecione um Estado:',
                  style: TextStyle(fontSize: 16, color: cores('corTexto'), fontWeight: FontWeight.bold),
                ),
                Container(
                  height: 40,
                  padding: const EdgeInsets.only(left: 10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                      border: Border.all(color: cores('corBorda')),
                      color: cores('branco'),
                      boxShadow: [
                        BoxShadow(offset: const Offset(0, 3), color: cores('corSombra'), blurRadius: 7)
                        // changes position of shadow
                      ]),
                  child: DropdownButton(
                    hint: Text(
                      'Selecione um Estado',
                      style: TextStyle(color: cores('corTexto')),
                    ),
                    icon: Icon(
                      Icons.arrow_drop_down,
                      color: cores('corTexto'),
                    ),
                    iconSize: 30,
                    iconEnabledColor: cores('corTexto'),
                    style: TextStyle(
                      color: cores('corTexto'),
                      fontWeight: FontWeight.w400,
                      fontSize: 16,
                    ),
                    underline: Container(
                      height: 0,
                    ),
                    isExpanded: true,
                    value: AppVariaveis().selecioneEstadoPaciente,
                    onChanged: (newValue) {
                      setState(() {
                        AppVariaveis().selecioneEstadoPaciente = newValue!;
                      });
                    },
                    items: estados.map((state) {
                      return DropdownMenuItem(
                        value: state,
                        child: Text(state),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ))
          ],
        ),
        const SizedBox(height: 20),
        campoTexto('Logradouro', AppVariaveis().txtLogradouroPaciente, Icons.location_on,
            key: AppVariaveis().keyLougradouroPaciente, validator: true),
        const SizedBox(height: 20),
        Row(
          children: [
            Expanded(
                child: campoTexto('Número', AppVariaveis().txtNumeroPaciente, Icons.home,
                    boardType: 'numeros', key: AppVariaveis().keyNumeroPaciente, validator: true)),
            const Padding(padding: EdgeInsets.only(right: 10)),
            Expanded(
                child: campoTexto('Bairro', AppVariaveis().txtBairroPaciente, Icons.maps_home_work,
                    key: AppVariaveis().keyBairroPaciente, validator: true))
          ],
        ),
        const SizedBox(height: 20),
        campoTexto('Cidade', AppVariaveis().txtCidadePaciente, Icons.location_city,
            key: AppVariaveis().keyCidadePaciente, validator: true),
        const SizedBox(height: 20),
      ],
    );
  }

  containerResponsavel() {
    return Column(
      children: [
        Divider(
          thickness: 2,
          height: 50,
          color: cores('corTexto'),
        ),
        Text(
          'Dados dos Responsáveis:',
          style: TextStyle(fontSize: 16, color: cores('corTexto'), fontWeight: FontWeight.bold),
        ),
        //------------------------------------------------------------------------------
        columnResponsavel(),
        const SizedBox(height: 20),
        AppVariaveis().indexResponsavelPaciente < 1
            ? SizedBox(
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                      foregroundColor: cores('corTextoBotao'),
                      minimumSize: const Size(45, 45),
                      backgroundColor: cores('corBotao'),
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(32),
                      )),
                  child: const Icon(Icons.add),
                  onPressed: () {
                    if (AppVariaveis()
                                .ListGeneroResponsavelPaciente[AppVariaveis().indexResponsavelPaciente] !=
                            null &&
                        AppVariaveis()
                            .ListNomeResponsavelPaciente[AppVariaveis().indexResponsavelPaciente]
                            .text
                            .isNotEmpty &&
                        AppVariaveis()
                            .ListIdadeResponsavelPaciente[AppVariaveis().indexResponsavelPaciente]
                            .text
                            .isNotEmpty &&
                        AppVariaveis()
                            .ListTelefoneResponsavelPaciente[AppVariaveis().indexResponsavelPaciente]
                            .text
                            .isNotEmpty &&
                        AppVariaveis()
                            .ListProfissaoResponsavelPaciente[AppVariaveis().indexResponsavelPaciente]
                            .text
                            .isNotEmpty) {
                      tipo == 'adicionar'
                          ? setState(() {
                              AppVariaveis().ListGeneroResponsavelPaciente.add(null);
                              AppVariaveis().ListNomeResponsavelPaciente.add(TextEditingController());
                              AppVariaveis().ListIdadeResponsavelPaciente.add(TextEditingController());
                              AppVariaveis().ListTelefoneResponsavelPaciente.add(TextEditingController());
                              AppVariaveis().ListRelacaoResponsavelPaciente.add('Mãe');
                              AppVariaveis()
                                  .ListEscolaridadeResponsavelPaciente
                                  .add('Ensino Fundamental Incompleto');
                              AppVariaveis().ListProfissaoResponsavelPaciente.add(TextEditingController());
                              AppVariaveis().indexResponsavelPaciente++;
                            })
                          : setState(() {
                              AppVariaveis().indexResponsavelPaciente + 1 <
                                      AppVariaveis().qtdResponsavelPaciente
                                  ? AppVariaveis().indexResponsavelPaciente++
                                  : null;
                            });
                    } else {
                      erro(context, 'Preencha os campos obrigatórios!');
                    }
                  },
                ),
              )
            : SizedBox(
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                      foregroundColor: cores('corTextoBotao'),
                      minimumSize: const Size(45, 45),
                      backgroundColor: Colors.grey,
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(32),
                      )),
                  child: const Icon(Icons.add),
                  onPressed: () {},
                ),
              ),
      ],
    );
  }

  containerAnexo() {
    return Column(
      children: [
        Divider(
          thickness: 2,
          height: 50,
          color: cores('corTexto'),
        ),
        Center(
          child: ElevatedButton(
            style: ButtonStyle(
              shadowColor: WidgetStateProperty.all<Color?>(cores('corSombra')),
              backgroundColor: WidgetStateProperty.all<Color?>(cores('corDetalhe')),
            ),
            onPressed: () async {
              AppVariaveis().fileDocPaciente = await pickDocument();
              setState(() {
                AppVariaveis().nomeArquivoPaciente = ph.basename(AppVariaveis().fileDocPaciente!.path);
              });
            },
            child: Text(
              AppVariaveis().nomeArquivoPaciente.isEmpty
                  ? 'Anexar Documento'
                  : AppVariaveis().nomeArquivoPaciente,
              style: TextStyle(color: cores('corTexto'), fontSize: 16),
            ),
          ),
        ),
      ],
    );
  }

  containerAtivo() {
    return Column(
      children: [
        SizedBox(height: 20),
        Text("Arquivar Paciente?",
            style: TextStyle(fontSize: 16, color: cores('corTexto'), fontWeight: FontWeight.bold)),
        SizedBox(height: 5),
        Center(
          child: FlutterSwitch(
            activeText: "Não Arquivar",
            activeTextColor: cores('branco'),
            activeColor: cores('corTexto'),
            inactiveText: "Arquivar",
            inactiveTextColor: cores('branco'),
            inactiveColor: Colors.red,
            value: AppVariaveis().switchValuePaciente,
            valueFontSize: 10.0,
            width: 110,
            borderRadius: 30.0,
            showOnOff: true,
            onToggle: (value) {
              setState(() {
                AppVariaveis().switchValuePaciente = value;
                if (value == true) {
                  AppVariaveis().varAtivoPaciente = '1';
                } else if (value == false) {
                  AppVariaveis().varAtivoPaciente = '0';
                }
              });
            },
          ),
        ),
        Divider(
          thickness: 2,
          height: 50,
          color: cores('corTexto'),
        ),
      ],
    );
  }

  rowBotao() {
    return Row(
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
              tipo == 'editar' ? 'Atualizar' : 'Criar',
              style: TextStyle(fontSize: 16),
            ),
            onPressed: () async {
              if (validarCampos()) {
                AppVariaveis().fileImagePaciente != null
                    ? AppVariaveis().urlImagePaciente =
                        (await uploadImageUsers(AppVariaveis().fileImagePaciente, 'pacientes'))!
                    : AppVariaveis().urlImagePaciente = AppVariaveis().urlImagePaciente;

                if (AppVariaveis().apagarImagemPaciente == true) {
                  await deletarImagem(AppVariaveis().urlImagePaciente);
                  await apagarImagemUser(uidPaciente!);
                }

                tipo == 'editar'
                    ? (AppVariaveis().txtNomePaciente.text.isNotEmpty &&
                            AppVariaveis().txtDataNascimentoPaciente.text.isNotEmpty &&
                            AppVariaveis().txtCPFPaciente.text.isNotEmpty &&
                            AppVariaveis().selectedGeneroPaciente != null &&
                            AppVariaveis().txtEscolaPaciente.isNotEmpty &&
                            AppVariaveis().selecioneEscolaridadePaciente.isNotEmpty &&
                            AppVariaveis().selecionePeriodoEscolaPaciente.isNotEmpty &&
                            AppVariaveis().txtProfessoraPaciente.text.isNotEmpty &&
                            AppVariaveis().txtLogradouroPaciente.text.isNotEmpty &&
                            AppVariaveis().txtNumeroPaciente.text.isNotEmpty &&
                            AppVariaveis().txtBairroPaciente.text.isNotEmpty &&
                            AppVariaveis().txtCidadePaciente.text.isNotEmpty &&
                            AppVariaveis().selecioneEstadoPaciente.isNotEmpty &&
                            AppVariaveis().txtCEPPaciente.text.isNotEmpty &&
                            AppVariaveis().selecioneTipoConsultaPaciente.isNotEmpty &&
                            AppVariaveis().txtDescricaoPaciente.text.isNotEmpty &&
                            AppVariaveis()
                                    .ListGeneroResponsavelPaciente[AppVariaveis().indexResponsavelPaciente] !=
                                null &&
                            AppVariaveis()
                                .ListNomeResponsavelPaciente[AppVariaveis().indexResponsavelPaciente]
                                .text
                                .isNotEmpty &&
                            AppVariaveis()
                                .ListIdadeResponsavelPaciente[AppVariaveis().indexResponsavelPaciente]
                                .text
                                .isNotEmpty &&
                            AppVariaveis()
                                .ListTelefoneResponsavelPaciente[AppVariaveis().indexResponsavelPaciente]
                                .text
                                .isNotEmpty &&
                            AppVariaveis()
                                .ListProfissaoResponsavelPaciente[AppVariaveis().indexResponsavelPaciente]
                                .text
                                .isNotEmpty)
                        ? editarPaciente(
                            context,
                            idFonoAuth(),
                            uidPaciente,
                            AppVariaveis().urlImagePaciente,
                            AppVariaveis().txtDataAnamnesePaciente.text,
                            AppVariaveis().txtNomePaciente.text,
                            AppVariaveis().txtDataNascimentoPaciente.text,
                            AppVariaveis().txtCPFPaciente.text,
                            AppVariaveis().txtRGPaciente.text,
                            AppVariaveis().selectedGeneroPaciente.toString(),
                            AppVariaveis().txtEscolaPaciente,
                            AppVariaveis().selecioneEscolaridadePaciente,
                            AppVariaveis().selecionePeriodoEscolaPaciente,
                            AppVariaveis().txtProfessoraPaciente.text,
                            AppVariaveis().txtTelefoneProfessoraPaciente.text,
                            AppVariaveis().txtLogradouroPaciente.text,
                            AppVariaveis().txtNumeroPaciente.text,
                            AppVariaveis().txtBairroPaciente.text,
                            AppVariaveis().txtCidadePaciente.text,
                            AppVariaveis().selecioneEstadoPaciente,
                            AppVariaveis().txtCEPPaciente.text,
                            AppVariaveis().selecioneTipoConsultaPaciente,
                            AppVariaveis().txtDescricaoPaciente.text,
                            AppVariaveis().qtdResponsavelPaciente,
                            AppVariaveis().ListGeneroResponsavelPaciente,
                            AppVariaveis().ListNomeResponsavelPaciente,
                            AppVariaveis().ListIdadeResponsavelPaciente,
                            AppVariaveis().ListTelefoneResponsavelPaciente,
                            AppVariaveis().ListRelacaoResponsavelPaciente,
                            AppVariaveis().ListEscolaridadeResponsavelPaciente,
                            AppVariaveis().ListProfissaoResponsavelPaciente,
                            AppVariaveis().fileDocPaciente,
                            AppVariaveis().varAtivoPaciente)
                        : erro(context, 'Preencha os campos obrigatórios!')
                    : (AppVariaveis().txtNomePaciente.text.isNotEmpty &&
                            AppVariaveis().txtDataNascimentoPaciente.text.isNotEmpty &&
                            AppVariaveis().txtCPFPaciente.text.isNotEmpty &&
                            AppVariaveis().selectedGeneroPaciente != null &&
                            AppVariaveis().txtEscolaPaciente.isNotEmpty &&
                            AppVariaveis().selecioneEscolaridadePaciente.isNotEmpty &&
                            AppVariaveis().selecionePeriodoEscolaPaciente.isNotEmpty &&
                            AppVariaveis().txtProfessoraPaciente.text.isNotEmpty &&
                            AppVariaveis().txtLogradouroPaciente.text.isNotEmpty &&
                            AppVariaveis().txtNumeroPaciente.text.isNotEmpty &&
                            AppVariaveis().txtBairroPaciente.text.isNotEmpty &&
                            AppVariaveis().txtCidadePaciente.text.isNotEmpty &&
                            AppVariaveis().selecioneEstadoPaciente.isNotEmpty &&
                            AppVariaveis().txtCEPPaciente.text.isNotEmpty &&
                            AppVariaveis().selecioneTipoConsultaPaciente.isNotEmpty &&
                            AppVariaveis().txtDescricaoPaciente.text.isNotEmpty &&
                            AppVariaveis()
                                    .ListGeneroResponsavelPaciente[AppVariaveis().indexResponsavelPaciente] !=
                                null &&
                            AppVariaveis()
                                .ListNomeResponsavelPaciente[AppVariaveis().indexResponsavelPaciente]
                                .text
                                .isNotEmpty &&
                            AppVariaveis()
                                .ListIdadeResponsavelPaciente[AppVariaveis().indexResponsavelPaciente]
                                .text
                                .isNotEmpty &&
                            AppVariaveis()
                                .ListTelefoneResponsavelPaciente[AppVariaveis().indexResponsavelPaciente]
                                .text
                                .isNotEmpty &&
                            AppVariaveis()
                                .ListProfissaoResponsavelPaciente[AppVariaveis().indexResponsavelPaciente]
                                .text
                                .isNotEmpty)
                        ? adicionarPaciente(
                            context,
                            idFonoAuth(),
                            AppVariaveis().urlImagePaciente,
                            AppVariaveis().txtDataAnamnesePaciente.text,
                            AppVariaveis().txtNomePaciente.text,
                            AppVariaveis().txtDataNascimentoPaciente.text,
                            AppVariaveis().txtCPFPaciente.text,
                            AppVariaveis().txtRGPaciente.text,
                            AppVariaveis().selectedGeneroPaciente.toString(),
                            AppVariaveis().txtEscolaPaciente,
                            AppVariaveis().selecioneEscolaridadePaciente,
                            AppVariaveis().selecionePeriodoEscolaPaciente,
                            AppVariaveis().txtProfessoraPaciente.text,
                            AppVariaveis().txtTelefoneProfessoraPaciente.text,
                            AppVariaveis().txtLogradouroPaciente.text,
                            AppVariaveis().txtNumeroPaciente.text,
                            AppVariaveis().txtBairroPaciente.text,
                            AppVariaveis().txtCidadePaciente.text,
                            AppVariaveis().selecioneEstadoPaciente,
                            AppVariaveis().txtCEPPaciente.text,
                            AppVariaveis().selecioneTipoConsultaPaciente,
                            AppVariaveis().txtDescricaoPaciente.text,
                            AppVariaveis().indexResponsavelPaciente,
                            AppVariaveis().ListGeneroResponsavelPaciente,
                            AppVariaveis().ListNomeResponsavelPaciente,
                            AppVariaveis().ListIdadeResponsavelPaciente,
                            AppVariaveis().ListTelefoneResponsavelPaciente,
                            AppVariaveis().ListRelacaoResponsavelPaciente,
                            AppVariaveis().ListEscolaridadeResponsavelPaciente,
                            AppVariaveis().ListProfissaoResponsavelPaciente,
                            AppVariaveis().fileDocPaciente,
                            AppVariaveis().varAtivoPaciente)
                        : erro(context, 'Preencha os campos obrigatórios!');
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
            style: TextStyle(fontSize: 16),
          ),
          onPressed: () {
            AppVariaveis().resetPaciente();
            Navigator.pop(context);
          },
        ),
      ],
    );
  }

  Widget columnResponsavel() {
    return Column(
      children: [
        Divider(
          thickness: 2,
          height: 50,
          color: cores('corTexto'),
        ),
        Text(
          'Sexo:',
          style: TextStyle(
            fontSize: 16,
            color: cores('corTexto'),
            fontWeight: FontWeight.bold,
          ),
        ),
        Row(
          children: [
            Expanded(
              child: RadioListTile<Gender>(
                title: Text(
                  'Masculino',
                  style: TextStyle(color: cores('corTexto')),
                ),
                value: Gender.male,
                groupValue:
                    AppVariaveis().ListGeneroResponsavelPaciente[AppVariaveis().indexResponsavelPaciente],
                activeColor: cores('corTexto'),
                onChanged: (value) {
                  setState(() {
                    AppVariaveis().ListGeneroResponsavelPaciente[AppVariaveis().indexResponsavelPaciente] =
                        value!;
                  });
                },
              ),
            ),
            Expanded(
              child: RadioListTile<Gender>(
                title: Text(
                  'Feminino',
                  style: TextStyle(color: cores('corTexto')),
                ),
                value: Gender.female,
                groupValue:
                    AppVariaveis().ListGeneroResponsavelPaciente[AppVariaveis().indexResponsavelPaciente],
                activeColor: cores('corTexto'),
                onChanged: (value) {
                  setState(() {
                    AppVariaveis().ListGeneroResponsavelPaciente[AppVariaveis().indexResponsavelPaciente] =
                        value!;
                  });
                },
              ),
            ),
          ],
        ),
        campoTexto('Nome do Responsável ${AppVariaveis().indexResponsavelPaciente + 1}',
            AppVariaveis().ListNomeResponsavelPaciente[AppVariaveis().indexResponsavelPaciente], Icons.label,
            key: AppVariaveis().keyNomeResponsavelPaciente, validator: true),
        const SizedBox(height: 20),
        Row(
          children: [
            Expanded(
              child: campoTexto(
                  'Idade',
                  AppVariaveis().ListIdadeResponsavelPaciente[AppVariaveis().indexResponsavelPaciente],
                  Icons.calendar_month_outlined,
                  boardType: 'numeros',
                  key: AppVariaveis().keyIdadeResponsavelPaciente,
                  validator: true),
            ),
            const Padding(padding: EdgeInsets.only(right: 10)),
            Expanded(
              child: campoTexto(
                  'Telefone',
                  AppVariaveis().ListTelefoneResponsavelPaciente[AppVariaveis().indexResponsavelPaciente],
                  Icons.phone,
                  formato: TelefoneInputFormatter(),
                  boardType: 'numeros',
                  key: AppVariaveis().keyTelefoneResponsavelPaciente,
                  validator: true),
            )
          ],
        ),
        const SizedBox(height: 20),
        Text(
          'Qual a relação do Responsável com Paciente?',
          style: TextStyle(fontSize: 16, color: cores('corTexto'), fontWeight: FontWeight.bold),
        ),
        Container(
          padding: const EdgeInsets.only(left: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.0),
            border: Border.all(color: cores('corBorda')),
            color: cores('branco'),
            boxShadow: [
              BoxShadow(
                offset: const Offset(0, 3),
                color: cores('corSombra'),
                blurRadius: 5,
              ), // changes position of shadow
            ],
          ),
          child: DropdownButton<String>(
            icon: const Icon(Icons.arrow_drop_down),
            iconSize: 30,
            iconEnabledColor: cores('corSimbolo'),
            style: TextStyle(
              color: cores('corTexto'),
              fontWeight: FontWeight.w400,
              fontSize: 16,
            ),
            underline: Container(
              height: 0,
            ),
            isExpanded: true,
            hint: const Text('Selecione uma Opção'),
            value: AppVariaveis().ListRelacaoResponsavelPaciente[AppVariaveis().indexResponsavelPaciente],
            items: responsaveis.map(buildMenuItem).toList(),
            onChanged: (value) {
              setState(() {
                AppVariaveis().ListRelacaoResponsavelPaciente[AppVariaveis().indexResponsavelPaciente] =
                    value!;
              });
            },
          ),
        ),
        const SizedBox(height: 20),
        Container(
          padding: const EdgeInsets.only(left: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.0),
            border: Border.all(color: cores('corBorda')),
            color: cores('branco'),
            boxShadow: [
              BoxShadow(offset: const Offset(0, 3), color: cores('corSombra'), blurRadius: 5),
            ],
          ),
          child: DropdownButton<String>(
            icon: const Icon(Icons.arrow_drop_down),
            iconSize: 30,
            iconEnabledColor: cores('corSimbolo'),
            style: TextStyle(color: cores('corTexto'), fontWeight: FontWeight.w400, fontSize: 16),
            underline: Container(
              height: 0,
            ),
            isExpanded: true,
            hint: const Text('Selecione uma Opção'),
            value:
                AppVariaveis().ListEscolaridadeResponsavelPaciente[AppVariaveis().indexResponsavelPaciente],
            items: escolaridadeResp.map(buildMenuItem).toList(),
            onChanged: (value) {
              setState(() {
                AppVariaveis().ListEscolaridadeResponsavelPaciente[AppVariaveis().indexResponsavelPaciente] =
                    value!;
              });
            },
          ),
        ),
        const SizedBox(height: 20),
        campoTexto(
            'Profissão',
            AppVariaveis().ListProfissaoResponsavelPaciente[AppVariaveis().indexResponsavelPaciente],
            Icons.work,
            key: AppVariaveis().keyProfissaoResponsavelPaciente,
            validator: true),
      ],
    );
  }

  DropdownMenuItem<String> buildMenuItem(String item) => DropdownMenuItem(
        value: item,
        child: Text(item),
      );
}
