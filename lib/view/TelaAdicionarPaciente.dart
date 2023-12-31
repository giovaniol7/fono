import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:fonocare/connections/fireAuth.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:brasil_fields/brasil_fields.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:search_cep/search_cep.dart';
import 'package:path/path.dart' as ph;

import '../connections/fireCloudPacientes.dart';
import '../controllers/uploadDoc.dart';
import '../controllers/uploadImage.dart';
import '../models/maps.dart';
import '../widgets/campoTexto.dart';
import '../controllers/estilos.dart';
import '../widgets/mensagem.dart';

class TelaAdicionarPaciente extends StatefulWidget {
  final String tipo;
  final String uid;

  const TelaAdicionarPaciente(this.tipo, this.uid, {super.key});

  @override
  State<TelaAdicionarPaciente> createState() => _TelaAdicionarPacienteState();
}

class _TelaAdicionarPacienteState extends State<TelaAdicionarPaciente> {
  final keyDataAnamnese = GlobalKey<FormState>();
  final keyNomePaciente = GlobalKey<FormState>();
  final keyDtNascimentoPaciente = GlobalKey<FormState>();
  final keyCPFPaciente = GlobalKey<FormState>();
  final keyEscolaPaciente = GlobalKey<FormState>();
  final keyProfessoraPaciente = GlobalKey<FormState>();
  final keyLougradouroPaciente = GlobalKey<FormState>();
  final keyNumeroPaciente = GlobalKey<FormState>();
  final keyBairroPaciente = GlobalKey<FormState>();
  final keyCidadePaciente = GlobalKey<FormState>();
  final keyCEPPaciente = GlobalKey<FormState>();
  final keyDescricaoPaciente = GlobalKey<FormState>();
  final keyNomeResponsavelPaciente = GlobalKey<FormState>();
  final keyIdadeResponsavelPaciente = GlobalKey<FormState>();
  final keyTelefoneResponsavelPaciente = GlobalKey<FormState>();
  final keyEscolaridadeResponsavelPaciente = GlobalKey<FormState>();
  final keyProfissaoResponsavelPaciente = GlobalKey<FormState>();
  var paciente;
  var fileImage;
  File? fileDoc;
  String nomeArquivo = '';
  var apagarImagem;
  var uidPaciente = '';
  var uidFono = '';
  var urlImagePaciente = '';
  var txtDataAnamnesePaciente = TextEditingController();
  var txtNomePaciente = TextEditingController();
  var txtDataNascimentoPaciente = TextEditingController();
  var txtCPFPaciente = TextEditingController();
  var txtRGPaciente = TextEditingController();
  var txtEscolaPaciente = TextEditingController();
  var txtProfessoraPaciente = TextEditingController();
  var txtTelefoneProfessoraPaciente = TextEditingController();
  var txtLogradouroPaciente = TextEditingController();
  var txtNumeroPaciente = TextEditingController();
  var txtBairroPaciente = TextEditingController();
  var txtCidadePaciente = TextEditingController();
  var txtCEPPaciente = TextEditingController();
  var txtDescricaoPaciente = TextEditingController();
  String selecioneEscolaridadePaciente = 'Berçário';
  String selecioneTipoConsultaPaciente = 'Convênio';
  String selecionePeriodoEscolaPaciente = 'Manhã';
  String selecioneEstadoPaciente = 'AC';
  Gender? _selectedGeneroPaciente;
  bool _switchValue = true;
  String varAtivo = '1';

  List<Gender?> ListGeneroResponsavelPaciente = [null];
  List<TextEditingController> ListNomeResponsavelPaciente = [TextEditingController()];
  List<TextEditingController> ListIdadeResponsavelPaciente = [TextEditingController()];
  List<TextEditingController> ListTelefoneResponsavelPaciente = [TextEditingController()];
  List<String> ListRelacaoResponsavelPaciente = ['Mãe'];
  List<TextEditingController> ListEscolaridadeResponsavelPaciente = [TextEditingController()];
  List<TextEditingController> ListProfissaoResponsavelPaciente = [TextEditingController()];
  int indexResponsavel = 0;
  int qtdResponsavel = 0;

  bool validarCampos() {
    return (keyDataAnamnese.currentState!.validate() &&
        keyNomePaciente.currentState!.validate() &&
        keyDtNascimentoPaciente.currentState!.validate() &&
        keyCPFPaciente.currentState!.validate() &&
        keyEscolaPaciente.currentState!.validate() &&
        keyProfessoraPaciente.currentState!.validate() &&
        keyCEPPaciente.currentState!.validate() &&
        keyLougradouroPaciente.currentState!.validate() &&
        keyNumeroPaciente.currentState!.validate() &&
        keyBairroPaciente.currentState!.validate() &&
        keyCidadePaciente.currentState!.validate() &&
        keyNomeResponsavelPaciente.currentState!.validate() &&
        keyIdadeResponsavelPaciente.currentState!.validate() &&
        keyTelefoneResponsavelPaciente.currentState!.validate() &&
        keyEscolaridadeResponsavelPaciente.currentState!.validate() &&
        keyProfissaoResponsavelPaciente.currentState!.validate());
  }

  Future<void> atualizarDados() async {
    await carregarDados();
  }

  carregarDados() async {
    widget.tipo == 'editar' ? paciente = await recuperarPaciente(context, widget.uid) : null;

    setState(() {
      if (widget.tipo == 'editar') {
        uidPaciente = paciente['uidPaciente'];
        uidFono = paciente['uidFono'];
        txtDataAnamnesePaciente.text = paciente['dataAnamnesePaciente'];
        urlImagePaciente = paciente['urlImagePaciente'];
        txtNomePaciente.text = paciente['nomePaciente'];
        txtDataNascimentoPaciente.text = paciente['dtNascimentoPaciente'];
        txtCPFPaciente.text = paciente['CPFPaciente'];
        txtRGPaciente.text = paciente['RGPaciente'];
        _selectedGeneroPaciente = paciente['generoPaciente'];
        txtEscolaPaciente.text = paciente['escolaPaciente'];
        selecioneEscolaridadePaciente = paciente['escolaridadePaciente'];
        selecionePeriodoEscolaPaciente = paciente['periodoEscolaPaciente'];
        txtProfessoraPaciente.text = paciente['professoraPaciente'];
        txtTelefoneProfessoraPaciente.text = paciente['telefoneProfessoraPaciente'];
        txtLogradouroPaciente.text = paciente['lougradouroPaciente'];
        txtNumeroPaciente.text = paciente['numeroPaciente'];
        txtBairroPaciente.text = paciente['bairroPaciente'];
        txtCidadePaciente.text = paciente['cidadePaciente'];
        selecioneEstadoPaciente = paciente['estadoPaciente'];
        txtCEPPaciente.text = paciente['cepPaciente'];
        selecioneTipoConsultaPaciente = paciente['tipoConsultaPaciente'];
        txtDescricaoPaciente.text = paciente['descricaoPaciente'];
        qtdResponsavel = paciente['qtdResponsavel'];
        nomeArquivo = paciente['urlDocPaciente'] == '' ? '' : urlToString(paciente['urlDocPaciente']);
        varAtivo = paciente['varAtivo'];
        _switchValue = varAtivo == '1';
        ListGeneroResponsavelPaciente = paciente['listGeneroResponsavel'];
        ListNomeResponsavelPaciente =
            (paciente['listNomeResponsavel'] as List<String>).map((nome) => TextEditingController(text: nome)).toList();
        ListIdadeResponsavelPaciente = (paciente['listIdadeResponsavel'] as List<String>)
            .map((nome) => TextEditingController(text: nome))
            .toList();
        ListTelefoneResponsavelPaciente = (paciente['listTelefoneResponsavel'] as List<String>)
            .map((nome) => TextEditingController(text: nome))
            .toList();
        ListRelacaoResponsavelPaciente = paciente['listRelacaoResponsavel'];
        ListEscolaridadeResponsavelPaciente = (paciente['listEscolaridadeResponsavel'] as List<String>)
            .map((nome) => TextEditingController(text: nome))
            .toList();
        ListProfissaoResponsavelPaciente = (paciente['listProfissaoResponsavel'] as List<String>)
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
                            content: const Text('Tem certeza de que deseja apagar este Paciente?'),
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
                                    await apagarPaciente(context, widget.uid);
                                  } catch (e) {
                                    erro(context, 'Erro ao deletar Prontuário: $e');
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
        iconTheme: IconThemeData(color: cores('corTexto')),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          widget.tipo == 'editar' ? 'Editar Paciente' : "Adicionar Paciente",
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
    TamanhoFonte tamanhoFonte = TamanhoFonte();

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
              borderRadius: const BorderRadius.only(bottomRight: Radius.circular(16), bottomLeft: Radius.circular(16))),
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
                  child: urlImagePaciente == ''
                      ? InkWell(
                          onTap: () async {
                            fileImage = await pickedImage();
                            setState(() {
                              fileImage = fileImage!;
                            });
                          },
                          child: fileImage == null
                              ? Icon(
                                  Icons.person_add_alt_rounded,
                                  color: cores('corTextoBotao'),
                                  size: tamanhoFonte.iconPequeno(context),
                                )
                              : CircleAvatar(
                                  maxRadius: 5,
                                  minRadius: 1,
                                  backgroundImage: FileImage(
                                    File(fileImage.path),
                                  ),
                                ),
                        )
                      : Stack(children: [
                          CircleAvatar(
                            radius: 80,
                            backgroundImage: NetworkImage(urlImagePaciente),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.5),
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: IconButton(
                                icon: Icon(
                                  Icons.delete,
                                  color: cores('corSimbolo'),
                                  size: tamanhoFonte.iconPequeno(context),
                                ),
                                onPressed: () {
                                  setState(() {
                                    apagarImagem == true;
                                    urlImagePaciente = '';
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
    TamanhoFonte tamanhoFonte = TamanhoFonte();

    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          containerDadosPaciente(),
          containerDadosEndereco(),
          Text(
            'Selecione o tipo de Consulta:',
            style: TextStyle(
                fontSize: tamanhoFonte.letraPequena(context), color: cores('corTexto'), fontWeight: FontWeight.bold),
          ),
          Container(
            padding: const EdgeInsets.only(left: 10),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
                border: Border.all(color: cores('corBorda')),
                color: Colors.white,
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
                fontSize: tamanhoFonte.letraPequena(context),
              ),
              underline: Container(
                height: 0,
              ),
              isExpanded: true,
              hint: const Text('Selecione uma Opção'),
              value: selecioneTipoConsultaPaciente,
              items: [
                DropdownMenuItem(
                  value: 'Convênio',
                  child: Text(
                    'Convênio',
                    style: TextStyle(color: cores('corTexto')),
                  ),
                ),
                DropdownMenuItem(
                  value: 'Particular',
                  child: Text(
                    'Particular',
                    style: TextStyle(color: cores('corTexto')),
                  ),
                ),
              ],
              onChanged: (value) {
                setState(() {
                  selecioneTipoConsultaPaciente = value!;
                });
              },
            ),
          ),
          const SizedBox(height: 20),
          campoTexto('Descrição/Queixa', txtDescricaoPaciente, Icons.description,
              maxPalavras: 200, maxLinhas: 5, tamanho: 20.0),
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
    TamanhoFonte tamanhoFonte = TamanhoFonte();

    return Column(
      children: [
        campoTexto('Data Anamnese', txtDataAnamnesePaciente, Icons.calendar_today,
            formato: DataInputFormatter(), numeros: true, key: keyDataAnamnese, validator: true),
        const SizedBox(height: 20),
        campoTexto('Nome', txtNomePaciente, Icons.label, key: keyNomePaciente, validator: true),
        const SizedBox(height: 20),
        campoTexto('Data de Nascimento', txtDataNascimentoPaciente, Icons.calendar_month_outlined,
            formato: DataInputFormatter(), numeros: true, key: keyDtNascimentoPaciente, validator: true),
        const SizedBox(height: 20),
        Row(
          children: [
            Expanded(
              child: campoTexto('CPF', txtCPFPaciente, Icons.credit_card,
                  formato: CpfInputFormatter(), numeros: true, key: keyCPFPaciente, validator: true),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: campoTexto('RG', txtRGPaciente, Icons.credit_card,
                  formato: MaskTextInputFormatter(
                    mask: '##.###.###-#',
                    filter: {"#": RegExp(r'[0-9]')},
                  ),
                  numeros: true),
            ),
          ],
        ),
        const SizedBox(height: 20),
        Text(
          'Sexo:',
          style: TextStyle(
              fontSize: tamanhoFonte.letraPequena(context), color: cores('corTexto'), fontWeight: FontWeight.bold),
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
                groupValue: _selectedGeneroPaciente,
                activeColor: cores('corSimbolo'),
                onChanged: (value) {
                  setState(() {
                    _selectedGeneroPaciente = value;
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
                groupValue: _selectedGeneroPaciente,
                activeColor: cores('corSimbolo'),
                onChanged: (value) {
                  setState(() {
                    _selectedGeneroPaciente = value;
                  });
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        campoTexto('Escola', txtEscolaPaciente, Icons.school, key: keyEscolaPaciente, validator: true),
        const SizedBox(height: 20),
        Row(
          children: [
            Expanded(
              child: Column(
                children: [
                  Text(
                    'Escolaridade: ',
                    style: TextStyle(
                        fontSize: tamanhoFonte.letraPequena(context),
                        color: cores('corTexto'),
                        fontWeight: FontWeight.bold),
                  ),
                  Container(
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
                      hint: Text(
                        'Escolaridade: ',
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
                        fontSize: tamanhoFonte.letraPequena(context),
                      ),
                      underline: Container(
                        height: 0,
                      ),
                      isExpanded: true,
                      value: selecioneEscolaridadePaciente,
                      onChanged: (newValue) {
                        setState(() {
                          selecioneEscolaridadePaciente = newValue!;
                        });
                      },
                      items: escolaridade.map((state) {
                        return DropdownMenuItem(
                          value: state,
                          child: Text(state),
                        );
                      }).toList(),
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
                    style: TextStyle(
                        fontSize: tamanhoFonte.letraPequena(context),
                        color: cores('corTexto'),
                        fontWeight: FontWeight.bold),
                  ),
                  Container(
                    padding: const EdgeInsets.only(left: 10),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.0),
                        border: Border.all(color: cores('corBorda')),
                        color: Colors.white,
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
                        fontSize: tamanhoFonte.letraPequena(context),
                      ),
                      underline: Container(
                        height: 0,
                      ),
                      isExpanded: true,
                      hint: const Text('Selecione uma Opção'),
                      value: selecionePeriodoEscolaPaciente,
                      items: [
                        DropdownMenuItem(
                          value: 'Manhã',
                          child: Text(
                            'Manhã',
                            style: TextStyle(color: cores('corTexto')),
                          ),
                        ),
                        DropdownMenuItem(
                          value: 'Tarde',
                          child: Text(
                            'Tarde',
                            style: TextStyle(color: cores('corTexto')),
                          ),
                        ),
                        DropdownMenuItem(
                          value: 'Integral',
                          child: Text(
                            'Integral',
                            style: TextStyle(color: cores('corTexto')),
                          ),
                        ),
                      ],
                      onChanged: (value) {
                        setState(() {
                          selecionePeriodoEscolaPaciente = value!;
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
                child: campoTexto('Professora', txtProfessoraPaciente, FontAwesomeIcons.personChalkboard,
                    key: keyProfessoraPaciente, validator: true)),
            const SizedBox(width: 10),
            Expanded(
                child: campoTexto('Telefone Professora', txtTelefoneProfessoraPaciente, Icons.phone,
                    formato: TelefoneInputFormatter(), numeros: true)),
          ],
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  containerDadosEndereco() {
    TamanhoFonte tamanhoFonte = TamanhoFonte();

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: campoTexto('CEP', txtCEPPaciente, Icons.mail,
                  formato: CepInputFormatter(),
                  numeros: true,
                  key: keyCEPPaciente,
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
                      txtCidadePaciente.text = localidade!;
                      selecioneEstadoPaciente = estado!;
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
                  style: TextStyle(
                      fontSize: tamanhoFonte.letraPequena(context),
                      color: cores('corTexto'),
                      fontWeight: FontWeight.bold),
                ),
                Container(
                  height: 40,
                  padding: const EdgeInsets.only(left: 10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                      border: Border.all(color: cores('corBorda')),
                      color: Colors.white,
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
                      fontSize: tamanhoFonte.letraPequena(context),
                    ),
                    underline: Container(
                      height: 0,
                    ),
                    isExpanded: true,
                    value: selecioneEstadoPaciente,
                    onChanged: (newValue) {
                      setState(() {
                        selecioneEstadoPaciente = newValue!;
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
        campoTexto('Logradouro', txtLogradouroPaciente, Icons.location_on,
            key: keyLougradouroPaciente, validator: true),
        const SizedBox(height: 20),
        Row(
          children: [
            Expanded(
                child: campoTexto('Número', txtNumeroPaciente, Icons.home,
                    numeros: true, key: keyNumeroPaciente, validator: true)),
            const Padding(padding: EdgeInsets.only(right: 10)),
            Expanded(
                child: campoTexto('Bairro', txtBairroPaciente, Icons.maps_home_work,
                    key: keyBairroPaciente, validator: true))
          ],
        ),
        const SizedBox(height: 20),
        campoTexto('Cidade', txtCidadePaciente, Icons.location_city, key: keyCidadePaciente, validator: true),
        const SizedBox(height: 20),
      ],
    );
  }

  containerResponsavel() {
    TamanhoFonte tamanhoFonte = TamanhoFonte();

    return Column(
      children: [
        Divider(
          thickness: 2,
          height: 50,
          color: cores('corTexto'),
        ),
        Text(
          'Dados dos Responsáveis:',
          style: TextStyle(
              fontSize: tamanhoFonte.letraPequena(context), color: cores('corTexto'), fontWeight: FontWeight.bold),
        ),
        //------------------------------------------------------------------------------
        columnResponsavel(),
        const SizedBox(height: 20),
        indexResponsavel < 1
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
                    if (ListGeneroResponsavelPaciente[indexResponsavel] != null &&
                        ListNomeResponsavelPaciente[indexResponsavel].text.isNotEmpty &&
                        ListIdadeResponsavelPaciente[indexResponsavel].text.isNotEmpty &&
                        ListTelefoneResponsavelPaciente[indexResponsavel].text.isNotEmpty &&
                        ListEscolaridadeResponsavelPaciente[indexResponsavel].text.isNotEmpty &&
                        ListProfissaoResponsavelPaciente[indexResponsavel].text.isNotEmpty) {
                      widget.tipo == 'adicionar'
                          ? setState(() {
                              ListGeneroResponsavelPaciente.add(null);
                              ListNomeResponsavelPaciente.add(TextEditingController());
                              ListIdadeResponsavelPaciente.add(TextEditingController());
                              ListTelefoneResponsavelPaciente.add(TextEditingController());
                              ListRelacaoResponsavelPaciente.add('Mãe');
                              ListEscolaridadeResponsavelPaciente.add(TextEditingController());
                              ListProfissaoResponsavelPaciente.add(TextEditingController());
                              indexResponsavel++;
                            })
                          : setState(() {
                              indexResponsavel + 1 < qtdResponsavel ? indexResponsavel++ : null;
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
    TamanhoFonte tamanhoFonte = TamanhoFonte();

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
              shadowColor: MaterialStatePropertyAll(cores('corSombra')),
              backgroundColor: MaterialStatePropertyAll(cores('corDetalhe')),
            ),
            onPressed: () async {
              fileDoc = await pickDocument();
              setState(() {
                nomeArquivo = ph.basename(fileDoc!.path);
              });
            },
            child: Text(
              nomeArquivo.isEmpty ? 'Anexar Documento' : nomeArquivo,
              style: TextStyle(color: cores('corTexto'), fontSize: tamanhoFonte.letraPequena(context)),
            ),
          ),
        ),
      ],
    );
  }

  containerAtivo() {
    TamanhoFonte tamanhoFonte = TamanhoFonte();

    return Column(
      children: [
        SizedBox(height: 20),
        Text("Arquivar Paciente?",
            style: TextStyle(
                fontSize: tamanhoFonte.letraPequena(context), color: cores('corTexto'), fontWeight: FontWeight.bold)),
        SizedBox(height: 5),
        Center(
          child: FlutterSwitch(
            activeText: "Não Arquivar",
            activeTextColor: cores('branco'),
            activeColor: cores('corTexto'),
            inactiveText: "Arquivar",
            inactiveTextColor: cores('branco'),
            inactiveColor: Colors.red,
            value: _switchValue,
            valueFontSize: 10.0,
            width: 110,
            borderRadius: 30.0,
            showOnOff: true,
            onToggle: (value) {
              setState(() {
                _switchValue = value;
                if (value == true) {
                  varAtivo = '1';
                } else if (value == false) {
                  varAtivo = '0';
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
    TamanhoFonte tamanhoFonte = TamanhoFonte();

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
              widget.tipo == 'editar' ? 'Atualizar' : 'Criar',
              style: TextStyle(fontSize: tamanhoFonte.letraPequena(context)),
            ),
            onPressed: () async {
              if (validarCampos()) {
                fileImage != null
                    ? urlImagePaciente = (await uploadImageUsers(fileImage, 'pacientes'))!
                    : urlImagePaciente = urlImagePaciente;

                if (apagarImagem == true) {
                  await deletarImagem(urlImagePaciente);
                  await apagarImagemUser(uidPaciente);
                }

                widget.tipo == 'editar'
                    ? (txtNomePaciente.text.isNotEmpty &&
                            txtDataNascimentoPaciente.text.isNotEmpty &&
                            txtCPFPaciente.text.isNotEmpty &&
                            _selectedGeneroPaciente != null &&
                            txtEscolaPaciente.text.isNotEmpty &&
                            selecioneEscolaridadePaciente.isNotEmpty &&
                            selecionePeriodoEscolaPaciente.isNotEmpty &&
                            txtProfessoraPaciente.text.isNotEmpty &&
                            txtLogradouroPaciente.text.isNotEmpty &&
                            txtNumeroPaciente.text.isNotEmpty &&
                            txtBairroPaciente.text.isNotEmpty &&
                            txtCidadePaciente.text.isNotEmpty &&
                            selecioneEstadoPaciente.isNotEmpty &&
                            txtCEPPaciente.text.isNotEmpty &&
                            selecioneTipoConsultaPaciente.isNotEmpty &&
                            txtDescricaoPaciente.text.isNotEmpty &&
                            ListGeneroResponsavelPaciente[indexResponsavel] != null &&
                            ListNomeResponsavelPaciente[indexResponsavel].text.isNotEmpty &&
                            ListIdadeResponsavelPaciente[indexResponsavel].text.isNotEmpty &&
                            ListTelefoneResponsavelPaciente[indexResponsavel].text.isNotEmpty &&
                            ListEscolaridadeResponsavelPaciente[indexResponsavel].text.isNotEmpty &&
                            ListProfissaoResponsavelPaciente[indexResponsavel].text.isNotEmpty)
                        ? editarPaciente(
                            context,
                            idUsuario(),
                            widget.uid,
                            urlImagePaciente,
                            txtDataAnamnesePaciente.text,
                            txtNomePaciente.text,
                            txtDataNascimentoPaciente.text,
                            txtCPFPaciente.text,
                            txtRGPaciente.text,
                            _selectedGeneroPaciente.toString(),
                            txtEscolaPaciente.text,
                            selecioneEscolaridadePaciente,
                            selecionePeriodoEscolaPaciente,
                            txtProfessoraPaciente.text,
                            txtTelefoneProfessoraPaciente.text,
                            txtLogradouroPaciente.text,
                            txtNumeroPaciente.text,
                            txtBairroPaciente.text,
                            txtCidadePaciente.text,
                            selecioneEstadoPaciente,
                            txtCEPPaciente.text,
                            selecioneTipoConsultaPaciente,
                            txtDescricaoPaciente.text,
                            qtdResponsavel,
                            ListGeneroResponsavelPaciente,
                            ListNomeResponsavelPaciente,
                            ListIdadeResponsavelPaciente,
                            ListTelefoneResponsavelPaciente,
                            ListRelacaoResponsavelPaciente,
                            ListEscolaridadeResponsavelPaciente,
                            ListProfissaoResponsavelPaciente,
                            fileDoc,
                            varAtivo)
                        : erro(context, 'Preencha os campos obrigatórios!')
                    : (txtNomePaciente.text.isNotEmpty &&
                            txtDataNascimentoPaciente.text.isNotEmpty &&
                            txtCPFPaciente.text.isNotEmpty &&
                            _selectedGeneroPaciente != null &&
                            txtEscolaPaciente.text.isNotEmpty &&
                            selecioneEscolaridadePaciente.isNotEmpty &&
                            selecionePeriodoEscolaPaciente.isNotEmpty &&
                            txtProfessoraPaciente.text.isNotEmpty &&
                            txtLogradouroPaciente.text.isNotEmpty &&
                            txtNumeroPaciente.text.isNotEmpty &&
                            txtBairroPaciente.text.isNotEmpty &&
                            txtCidadePaciente.text.isNotEmpty &&
                            selecioneEstadoPaciente.isNotEmpty &&
                            txtCEPPaciente.text.isNotEmpty &&
                            selecioneTipoConsultaPaciente.isNotEmpty &&
                            txtDescricaoPaciente.text.isNotEmpty &&
                            ListGeneroResponsavelPaciente[indexResponsavel] != null &&
                            ListNomeResponsavelPaciente[indexResponsavel].text.isNotEmpty &&
                            ListIdadeResponsavelPaciente[indexResponsavel].text.isNotEmpty &&
                            ListTelefoneResponsavelPaciente[indexResponsavel].text.isNotEmpty &&
                            ListEscolaridadeResponsavelPaciente[indexResponsavel].text.isNotEmpty &&
                            ListProfissaoResponsavelPaciente[indexResponsavel].text.isNotEmpty)
                        ? adicionarPaciente(
                            context,
                            idUsuario(),
                            urlImagePaciente,
                            txtDataAnamnesePaciente.text,
                            txtNomePaciente.text,
                            txtDataNascimentoPaciente.text,
                            txtCPFPaciente.text,
                            txtRGPaciente.text,
                            _selectedGeneroPaciente.toString(),
                            txtEscolaPaciente.text,
                            selecioneEscolaridadePaciente,
                            selecionePeriodoEscolaPaciente,
                            txtProfessoraPaciente.text,
                            txtTelefoneProfessoraPaciente.text,
                            txtLogradouroPaciente.text,
                            txtNumeroPaciente.text,
                            txtBairroPaciente.text,
                            txtCidadePaciente.text,
                            selecioneEstadoPaciente,
                            txtCEPPaciente.text,
                            selecioneTipoConsultaPaciente,
                            txtDescricaoPaciente.text,
                            indexResponsavel,
                            ListGeneroResponsavelPaciente,
                            ListNomeResponsavelPaciente,
                            ListIdadeResponsavelPaciente,
                            ListTelefoneResponsavelPaciente,
                            ListRelacaoResponsavelPaciente,
                            ListEscolaridadeResponsavelPaciente,
                            ListProfissaoResponsavelPaciente,
                            fileDoc,
                            varAtivo)
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
            style: TextStyle(fontSize: tamanhoFonte.letraPequena(context)),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ],
    );
  }

  Widget columnResponsavel() {
    TamanhoFonte tamanhoFonte = TamanhoFonte();

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
            fontSize: tamanhoFonte.letraPequena(context),
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
                groupValue: ListGeneroResponsavelPaciente[indexResponsavel],
                activeColor: cores('corTexto'),
                onChanged: (value) {
                  setState(() {
                    ListGeneroResponsavelPaciente[indexResponsavel] = value!;
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
                groupValue: ListGeneroResponsavelPaciente[indexResponsavel],
                activeColor: cores('corTexto'),
                onChanged: (value) {
                  setState(() {
                    ListGeneroResponsavelPaciente[indexResponsavel] = value!;
                  });
                },
              ),
            ),
          ],
        ),
        campoTexto(
            'Nome do Responsável ${indexResponsavel + 1}', ListNomeResponsavelPaciente[indexResponsavel], Icons.label,
            key: keyNomeResponsavelPaciente, validator: true),
        const SizedBox(height: 20),
        Row(
          children: [
            Expanded(
              child: campoTexto('Idade', ListIdadeResponsavelPaciente[indexResponsavel], Icons.calendar_month_outlined,
                  numeros: true, key: keyIdadeResponsavelPaciente, validator: true),
            ),
            const Padding(padding: EdgeInsets.only(right: 10)),
            Expanded(
              child: campoTexto('Telefone', ListTelefoneResponsavelPaciente[indexResponsavel], Icons.phone,
                  formato: TelefoneInputFormatter(),
                  numeros: true,
                  key: keyTelefoneResponsavelPaciente,
                  validator: true),
            )
          ],
        ),
        const SizedBox(height: 20),
        Text(
          'Qual a relação do Responsável com Paciente?',
          style: TextStyle(
              fontSize: tamanhoFonte.letraPequena(context), color: cores('corTexto'), fontWeight: FontWeight.bold),
        ),
        Container(
          padding: const EdgeInsets.only(left: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.0),
            border: Border.all(color: cores('corBorda')),
            color: Colors.white,
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
              fontSize: tamanhoFonte.letraPequena(context),
            ),
            underline: Container(
              height: 0,
            ),
            isExpanded: true,
            hint: const Text('Selecione uma Opção'),
            value: ListRelacaoResponsavelPaciente[indexResponsavel],
            items: [
              DropdownMenuItem(
                value: 'Mãe',
                child: Text('Mãe', style: TextStyle(color: cores('corTexto'))),
              ),
              DropdownMenuItem(
                value: 'Pai',
                child: Text('Pai', style: TextStyle(color: cores('corTexto'))),
              ),
              DropdownMenuItem(
                value: 'Avó',
                child: Text('Avó', style: TextStyle(color: cores('corTexto'))),
              ),
              DropdownMenuItem(
                value: 'Avô',
                child: Text('Avô', style: TextStyle(color: cores('corTexto'))),
              ),
              DropdownMenuItem(
                value: 'Tio',
                child: Text('Tio', style: TextStyle(color: cores('corTexto'))),
              ),
              DropdownMenuItem(
                value: 'Tia',
                child: Text('Tia', style: TextStyle(color: cores('corTexto'))),
              ),
            ],
            onChanged: (value) {
              setState(() {
                ListRelacaoResponsavelPaciente[indexResponsavel] = value!;
              });
            },
          ),
        ),
        const SizedBox(height: 20),
        campoTexto('Grau de Escolaridade', ListEscolaridadeResponsavelPaciente[indexResponsavel], Icons.school,
            key: keyEscolaridadeResponsavelPaciente, validator: true),
        const SizedBox(height: 20),
        campoTexto('Profissão', ListProfissaoResponsavelPaciente[indexResponsavel], Icons.work,
            key: keyProfissaoResponsavelPaciente, validator: true),
      ],
    );
  }
}
