import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fono/connections/fireAuth.dart';

import 'package:intl/intl.dart';
import 'package:brasil_fields/brasil_fields.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:search_cep/search_cep.dart';

import '../connections/fireCloudPacientes.dart';
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
  var paciente;
  var fileImage;
  var apagarImagem;
  var uidPaciente = '';
  var uidFono = '';
  var dataInicioPaciente = '';
  var urlImagePaciente = '';
  var txtNomePaciente = TextEditingController();
  var txtDataNascimentoPaciente = TextEditingController();
  var txtCPFPaciente = TextEditingController();
  var txtRGPaciente = TextEditingController();
  var txtLogradouroPaciente = TextEditingController();
  var txtNumeroPaciente = TextEditingController();
  var txtBairroPaciente = TextEditingController();
  var txtCidadePaciente = TextEditingController();
  var txtCEPPaciente = TextEditingController();
  var txtDescricaoPaciente = TextEditingController();
  String selecioneTipoConsultaPaciente = 'Convênio';
  String selecioneEstadoPaciente = 'AC';
  Gender? _selectedGeneroPaciente;

  List<Gender?> ListGeneroResponsavelPaciente = [null];
  List<TextEditingController> ListNomeResponsavelPaciente = [TextEditingController()];
  List<TextEditingController> ListIdadeResponsavelPaciente = [TextEditingController()];
  List<TextEditingController> ListTelefoneResponsavelPaciente = [TextEditingController()];
  List<String> ListRelacaoResponsavelPaciente = ['Mãe'];
  List<TextEditingController> ListEscolaridadeResponsavelPaciente = [TextEditingController()];
  List<TextEditingController> ListProfissaoResponsavelPaciente = [TextEditingController()];
  int indexResponsavel = 0;
  int qtdResponsavel = 0;

  DateTime dataAtual = DateTime.now();

  Future<void> atualizarDados() async {
    await carregarDados();
  }

  carregarDados() async {
    widget.tipo == 'editar' ? paciente = await recuperarPaciente(context, widget.uid) : null;

    setState(() {
      dataInicioPaciente = DateFormat('dd/MM/yyyy').format(dataAtual);

      if (widget.tipo == 'editar') {
        uidPaciente = paciente['uidPaciente'];
        uidFono = paciente['uidFono'];
        dataInicioPaciente = paciente['dataInicioPaciente'];
        urlImagePaciente = paciente['urlImagePaciente'];
        txtNomePaciente.text = paciente['nomePaciente'];
        txtDataNascimentoPaciente.text = paciente['dtNascimentoPaciente'];
        txtCPFPaciente.text = paciente['CPFPaciente'];
        txtRGPaciente.text = paciente['RGPaciente'];
        _selectedGeneroPaciente = paciente['generoPaciente'];
        txtLogradouroPaciente.text = paciente['lougradouroPaciente'];
        txtNumeroPaciente.text = paciente['numeroPaciente'];
        txtBairroPaciente.text = paciente['bairroPaciente'];
        txtCidadePaciente.text = paciente['cidadePaciente'];
        selecioneEstadoPaciente = paciente['estadoPaciente'];
        txtCEPPaciente.text = paciente['cepPaciente'];
        selecioneTipoConsultaPaciente = paciente['tipoConsultaPaciente'];
        txtDescricaoPaciente.text = paciente['descricaoPaciente'];
        qtdResponsavel = paciente['qtdResponsavel'];
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

  @override
  Widget build(BuildContext context) {
    TamanhoWidgets tamanhoWidgets = TamanhoWidgets();
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
                    await apagarPaciente(context, widget.uid);
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
          Column(
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
                    const Padding(padding: EdgeInsets.only(top: 10)),
                    Text(
                      'Data: $dataInicioPaciente',
                      style: TextStyle(fontSize: 16, color: cores('corTexto'), fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                campoTexto('Nome', txtNomePaciente, Icons.label),
                const SizedBox(height: 20),
                campoTexto('Data de Nascimento', txtDataNascimentoPaciente, Icons.calendar_month_outlined,
                    formato: DataInputFormatter(), numeros: true),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: campoTexto('CPF', txtCPFPaciente, Icons.credit_card,
                          formato: CpfInputFormatter(), numeros: true),
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
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: campoTexto('CEP', txtCEPPaciente, Icons.mail, formato: CepInputFormatter(), numeros: true,
                          onchaged: (value) async {
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
                          style: TextStyle(fontSize: 16, color: cores('corTexto'), fontWeight: FontWeight.bold),
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
                              fontSize: 18,
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
                campoTexto('Logradouro', txtLogradouroPaciente, Icons.location_on),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: campoTexto('Número', txtNumeroPaciente, Icons.home, numeros: true),
                    ),
                    const Padding(padding: EdgeInsets.only(right: 10)),
                    Expanded(
                      child: campoTexto('Bairro', txtBairroPaciente, Icons.maps_home_work),
                    )
                  ],
                ),
                const SizedBox(height: 20),
                campoTexto(
                  'Cidade',
                  txtCidadePaciente,
                  Icons.location_city,
                ),
                const SizedBox(height: 20),
                Text(
                  'Selecione o tipo de Consulta:',
                  style: TextStyle(fontSize: 16, color: cores('corTexto'), fontWeight: FontWeight.bold),
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
                      fontSize: 15,
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
                campoTexto('Descrição', txtDescricaoPaciente, Icons.description,
                    maxPalavras: 200, maxLinhas: 5, tamanho: 20.0),
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
                //------------------------------------------------------------------------------
                Divider(
                  thickness: 2,
                  height: 50,
                  color: cores('corTexto'),
                ),
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
                            widget.tipo == 'editar' ? 'Atualizar' : 'Criar',
                            style: TextStyle(fontSize: 16),
                          ),
                          onPressed: () async {
                            fileImage != null
                                ? urlImagePaciente = (await uploadImageUsers(fileImage, 'pacientes'))!
                                : urlImagePaciente = '';

                            if (apagarImagem == true) {
                              await deletarImagem(urlImagePaciente);
                              await apagarImagemUser(uidPaciente);
                            }

                            widget.tipo == 'editar'
                                ? (txtNomePaciente.text.isNotEmpty &&
                                        txtDataNascimentoPaciente.text.isNotEmpty &&
                                        txtCPFPaciente.text.isNotEmpty &&
                                        txtRGPaciente.text.isNotEmpty &&
                                        _selectedGeneroPaciente != null &&
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
                                        dataInicioPaciente,
                                        urlImagePaciente,
                                        txtNomePaciente.text,
                                        txtDataNascimentoPaciente.text,
                                        txtCPFPaciente.text,
                                        txtRGPaciente.text,
                                        _selectedGeneroPaciente.toString(),
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
                                      )
                                    : erro(context, 'Preencha os campos obrigatórios!')
                                : (txtNomePaciente.text.isNotEmpty &&
                                        txtDataNascimentoPaciente.text.isNotEmpty &&
                                        txtCPFPaciente.text.isNotEmpty &&
                                        txtRGPaciente.text.isNotEmpty &&
                                        _selectedGeneroPaciente != null &&
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
                                        dataInicioPaciente,
                                        urlImagePaciente,
                                        txtNomePaciente.text,
                                        txtDataNascimentoPaciente.text,
                                        txtCPFPaciente.text,
                                        txtRGPaciente.text,
                                        _selectedGeneroPaciente.toString(),
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
                                      )
                                    : erro(context, 'Preencha os campos obrigatórios!');
                          }),
                    ),
                    const Padding(padding: EdgeInsets.all(20)),
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
          )
        ],
      )),
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
            'Nome do Responsável ${indexResponsavel + 1}', ListNomeResponsavelPaciente[indexResponsavel], Icons.label),
        const SizedBox(height: 20),
        Row(
          children: [
            Expanded(
              child: campoTexto(
                'Idade',
                ListIdadeResponsavelPaciente[indexResponsavel],
                Icons.calendar_month_outlined,
                numeros: true,
              ),
            ),
            const Padding(padding: EdgeInsets.only(right: 10)),
            Expanded(
              child: campoTexto('Telefone', ListTelefoneResponsavelPaciente[indexResponsavel], Icons.phone,
                  formato: TelefoneInputFormatter(), numeros: true),
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
              fontSize: 15,
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
        campoTexto('Grau de Escolaridade', ListEscolaridadeResponsavelPaciente[indexResponsavel], Icons.school),
        const SizedBox(height: 20),
        campoTexto('Profissão', ListProfissaoResponsavelPaciente[indexResponsavel], Icons.work),
      ],
    );
  }
}
