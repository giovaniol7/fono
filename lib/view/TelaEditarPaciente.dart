import 'dart:io';
import 'package:intl/intl.dart';
import 'package:brasil_fields/brasil_fields.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:fono/view/TelaPacientes.dart';
import 'package:search_cep/search_cep.dart';
import 'package:uuid/uuid.dart';
import 'package:firedart/firedart.dart' as fd;

import '../widgets/campoTexto.dart';
import 'controllers/coresPrincipais.dart';
import '../widgets/mensagem.dart';

enum Gender { male, female }

class TelaEditarPaciente extends StatefulWidget {
  final String uidFono;

  const TelaEditarPaciente(this.uidFono, {super.key});

  @override
  State<TelaEditarPaciente> createState() => _TelaEditarPacienteState();
}

class _TelaEditarPacienteState extends State<TelaEditarPaciente> {
  var urlImagePaciente = '';
  var txtNomePaciente = TextEditingController();
  var txtDataNascimentoPaciente = TextEditingController();
  var txtTelefonePaciente = TextEditingController();
  var txtLogradouroPaciente = TextEditingController();
  var txtNumeroPaciente = TextEditingController();
  var txtBairroPaciente = TextEditingController();
  var txtCidadePaciente = TextEditingController();
  var txtCEPPaciente = TextEditingController();
  var txtDescricaoPaciente = TextEditingController();
  String selecioneTipoConsultaPaciente = 'Convênio';
  String selecioneEstadoPaciente = 'AC';
  Gender? _selectedGeneroPaciente;

  List<TextEditingController> ListNomeResponsavelPaciente = [TextEditingController()];
  List<TextEditingController> ListDataNascimentoResponsavelPaciente = [TextEditingController()];
  List<TextEditingController> ListEscolaridadeResponsavelPaciente = [TextEditingController()];
  List<TextEditingController> ListProfissaoResponsavelPaciente = [TextEditingController()];
  List<Gender?> ListGeneroResponsavelPaciente = [null];
  List<String> ListRelacaoResponsavelPaciente = ['Mãe'];

  int index = 0;

  DateTime dataAtual = DateTime.now();

  final List<String> states = [
    "AC",
    "AL",
    "AP",
    "AM",
    "BA",
    "CE",
    "DF",
    "ES",
    "GO",
    "MA",
    "MT",
    "MS",
    "MG",
    "PA",
    "PB",
    "PR",
    "PE",
    "PI",
    "RJ",
    "RN",
    "RS",
    "RO",
    "RR",
    "SC",
    "SP",
    "SE",
    "TO"
  ];

  @override
  Widget build(BuildContext context) {
    String dataInicioPaciente = DateFormat('dd/MM/yyyy').format(dataAtual);
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        iconTheme: IconThemeData(color: cores('verde')),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          "Adicionar Paciente",
          style: TextStyle(color: cores('verde')),
        ),
        backgroundColor: cores('rosa_fraco'),
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
                    color: cores('rosa_medio'),
                    boxShadow: [
                      BoxShadow(offset: const Offset(0, 3), color: cores('verde/azul'), blurRadius: 5),
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
                          color: cores('verde'),
                        ),
                        child: InkWell(
                          onTap: () async {
                            urlImagePaciente = (await _uploadImage())!;
                            setState(() {
                              urlImagePaciente = urlImagePaciente!;
                            });
                          },
                          child: urlImagePaciente.isEmpty
                              ? Icon(
                                  Icons.person_add_alt_rounded,
                                  color: cores('rosa_fraco'),
                                  size: 40.0,
                                )
                              : CircleAvatar(
                                  maxRadius: 5,
                                  minRadius: 1,
                                  backgroundImage: NetworkImage(urlImagePaciente),
                                ),
                        ),
                      ),
                    ),
                    const Padding(padding: EdgeInsets.only(top: 10)),
                    Text(
                      'Data: $dataInicioPaciente',
                      style: TextStyle(fontSize: 16, color: cores('verde'), fontWeight: FontWeight.bold),
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
                Row(
                  children: [
                    Expanded(
                      child: campoTexto('Data de Nascimento', txtDataNascimentoPaciente, Icons.calendar_month_outlined,
                          formato: DataInputFormatter(), numeros: true),
                    ),
                    const Padding(padding: EdgeInsets.only(right: 10)),
                    Expanded(
                      child: campoTexto('Telefone', txtTelefonePaciente, Icons.phone, formato: TelefoneInputFormatter(), numeros: true),
                    )
                  ],
                ),

                const SizedBox(height: 20),
                Text(
                  'Sexo:',
                  style: TextStyle(fontSize: 16, color: cores('verde'), fontWeight: FontWeight.bold),
                ),
                Row(
                  children: [
                    Expanded(
                      child: RadioListTile<Gender>(
                        title: Text(
                          'Masculino',
                          style: TextStyle(color: cores('verde')),
                        ),
                        value: Gender.male,
                        groupValue: _selectedGeneroPaciente,
                        activeColor: cores('verde'),
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
                          style: TextStyle(color: cores('verde')),
                        ),
                        value: Gender.female,
                        groupValue: _selectedGeneroPaciente,
                        activeColor: cores('verde'),
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
                      child: campoTexto('CEP', txtCEPPaciente, Icons.mail, formato: CepInputFormatter(), numeros: true, onchaged: (value) async {
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
                          style: TextStyle(fontSize: 16, color: cores('verde'), fontWeight: FontWeight.bold),
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
                            hint: const Text('Selecione um Estado'),
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
                            value: selecioneEstadoPaciente,
                            onChanged: (newValue) {
                              setState(() {
                                selecioneEstadoPaciente = newValue!;
                              });
                            },
                            items: states.map((state) {
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
                  style: TextStyle(fontSize: 16, color: cores('verde'), fontWeight: FontWeight.bold),
                ),
                Container(
                  padding: const EdgeInsets.only(left: 10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                      border: Border.all(color: cores('rosa_forte')),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(offset: const Offset(0, 3), color: cores('rosa_fraco'), blurRadius: 5) // changes position of shadow
                      ]),
                  child: DropdownButton<String>(
                    icon: const Icon(Icons.arrow_drop_down),
                    iconSize: 30,
                    iconEnabledColor: cores('verde'),
                    style: TextStyle(
                      color: cores('verde'),
                      fontWeight: FontWeight.w400,
                      fontSize: 15,
                    ),
                    underline: Container(
                      height: 0,
                    ),
                    isExpanded: true,
                    hint: const Text('Selecione uma Opção'),
                    value: selecioneTipoConsultaPaciente,
                    items: const [
                      DropdownMenuItem(
                        value: 'Convênio',
                        child: Text('Convênio'),
                      ),
                      DropdownMenuItem(
                        value: 'Particular',
                        child: Text('Particular'),
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
                campoTexto('Descrição', txtDescricaoPaciente, Icons.description, maxPalavras: 200, maxLinhas: 5, tamanho: 20.0),
                Divider(
                  thickness: 2,
                  height: 50,
                  color: cores('verde'),
                ),
                Text(
                  'Dados dos Responsáveis:',
                  style: TextStyle(fontSize: 16, color: cores('verde'), fontWeight: FontWeight.bold),
                ),
                //------------------------------------------------------------------------------
                columnResponsavel(),
                const SizedBox(height: 20),
                index < 1
                    ? SizedBox(
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                              primary: cores('rosa_fraco'),
                              minimumSize: const Size(45, 45),
                              backgroundColor: cores('verde'),
                              elevation: 5,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(32),
                              )),
                          child: const Icon(Icons.add),
                          onPressed: () {
                            if (ListGeneroResponsavelPaciente[index] != null &&
                                ListNomeResponsavelPaciente[index].text.isNotEmpty &&
                                ListDataNascimentoResponsavelPaciente[index].text.isNotEmpty &&
                                ListEscolaridadeResponsavelPaciente[index].text.isNotEmpty &&
                                ListProfissaoResponsavelPaciente[index].text.isNotEmpty) {
                              setState(() {
                                ListGeneroResponsavelPaciente.add(null);
                                ListNomeResponsavelPaciente.add(TextEditingController());
                                ListDataNascimentoResponsavelPaciente.add(TextEditingController());
                                ListRelacaoResponsavelPaciente.add('Mãe');
                                ListEscolaridadeResponsavelPaciente.add(TextEditingController());
                                ListProfissaoResponsavelPaciente.add(TextEditingController());
                                index++;
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
                              primary: cores('rosa_fraco'),
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
                  color: cores('verde'),
                ),
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
                            'Criar',
                            style: TextStyle(fontSize: 16),
                          ),
                          onPressed: () async {
                            if (txtNomePaciente.text.isNotEmpty &&
                                txtDataNascimentoPaciente.text.isNotEmpty &&
                                txtTelefonePaciente.text.isNotEmpty &&
                                _selectedGeneroPaciente != null &&
                                txtLogradouroPaciente.text.isNotEmpty &&
                                txtNumeroPaciente.text.isNotEmpty &&
                                txtBairroPaciente.text.isNotEmpty &&
                                txtCidadePaciente.text.isNotEmpty &&
                                selecioneEstadoPaciente.isNotEmpty &&
                                txtCEPPaciente.text.isNotEmpty &&
                                selecioneTipoConsultaPaciente.isNotEmpty &&
                                txtDescricaoPaciente.text.isNotEmpty &&
                                ListGeneroResponsavelPaciente[index] != null &&
                                ListNomeResponsavelPaciente[index].text.isNotEmpty &&
                                ListDataNascimentoResponsavelPaciente[index].text.isNotEmpty &&
                                ListEscolaridadeResponsavelPaciente[index].text.isNotEmpty &&
                                ListProfissaoResponsavelPaciente[index].text.isNotEmpty) {
                              adicionarPaciente(
                                context,
                                widget.uidFono,
                                dataInicioPaciente,
                                urlImagePaciente,
                                txtNomePaciente.text,
                                txtDataNascimentoPaciente.text,
                                txtTelefonePaciente.text,
                                _selectedGeneroPaciente.toString(),
                                txtLogradouroPaciente.text,
                                txtNumeroPaciente.text,
                                txtBairroPaciente.text,
                                txtCidadePaciente.text,
                                selecioneEstadoPaciente,
                                txtCEPPaciente.text,
                                selecioneTipoConsultaPaciente,
                                txtDescricaoPaciente.text,
                                ListGeneroResponsavelPaciente,
                                ListNomeResponsavelPaciente,
                                ListDataNascimentoResponsavelPaciente,
                                ListRelacaoResponsavelPaciente,
                                ListEscolaridadeResponsavelPaciente,
                                ListProfissaoResponsavelPaciente,
                              );
                            } else {
                              erro(context, 'Preencha os campos obrigatórios!');
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
          )
        ],
      )),
    );
  }

  Future<String?> _uploadImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      // Crie uma referência única para a imagem no Firebase Storage
      final ref = FirebaseStorage.instance.ref().child('users/${DateTime.now().toString()}');

      // Faça o upload da imagem para o Firebase Storage
      final uploadTask = ref.putFile(File(pickedFile.path));
      final snapshot = await uploadTask.whenComplete(() => null);

      // Recupere a URL da imagem no Firebase Storage
      final url = await snapshot.ref.getDownloadURL();

      return url;
    } else {
      return null;
    }
  }

  Widget columnResponsavel() {
    return Column(
      children: [
        Divider(
          thickness: 2,
          height: 50,
          color: cores('verde'),
        ),
        Text(
          'Sexo:',
          style: TextStyle(
            fontSize: 16,
            color: cores('verde'),
            fontWeight: FontWeight.bold,
          ),
        ),
        Row(
          children: [
            Expanded(
              child: RadioListTile<Gender>(
                title: Text(
                  'Masculino',
                  style: TextStyle(color: cores('verde')),
                ),
                value: Gender.male,
                groupValue: ListGeneroResponsavelPaciente[index],
                activeColor: cores('verde'),
                onChanged: (value) {
                  setState(() {
                    ListGeneroResponsavelPaciente[index] = value!;
                  });
                },
              ),
            ),
            Expanded(
              child: RadioListTile<Gender>(
                title: Text(
                  'Feminino',
                  style: TextStyle(color: cores('verde')),
                ),
                value: Gender.female,
                groupValue: ListGeneroResponsavelPaciente[index],
                activeColor: cores('verde'),
                onChanged: (value) {
                  setState(() {
                    ListGeneroResponsavelPaciente[index] = value!;
                  });
                },
              ),
            ),
          ],
        ),
        campoTexto('Nome do Responsável ${index + 1}', ListNomeResponsavelPaciente[index], Icons.label),
        const SizedBox(height: 20),
        campoTexto('Data de Nascimento', ListDataNascimentoResponsavelPaciente[index], Icons.calendar_month_outlined,
            numeros: true, formato: DataInputFormatter()),
        const SizedBox(height: 20),
        Text(
          'Qual a relação do Responsável com Paciente?',
          style: TextStyle(fontSize: 16, color: cores('verde'), fontWeight: FontWeight.bold),
        ),
        Container(
          padding: const EdgeInsets.only(left: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.0),
            border: Border.all(color: cores('rosa_forte')),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                offset: const Offset(0, 3),
                color: cores('rosa_fraco'),
                blurRadius: 5,
              ), // changes position of shadow
            ],
          ),
          child: DropdownButton<String>(
            icon: const Icon(Icons.arrow_drop_down),
            iconSize: 30,
            iconEnabledColor: cores('verde'),
            style: TextStyle(
              color: cores('verde'),
              fontWeight: FontWeight.w400,
              fontSize: 15,
            ),
            underline: Container(
              height: 0,
            ),
            isExpanded: true,
            hint: const Text('Selecione uma Opção'),
            value: ListRelacaoResponsavelPaciente[index],
            items: const [
              DropdownMenuItem(
                value: 'Mãe',
                child: Text('Mãe'),
              ),
              DropdownMenuItem(
                value: 'Pai',
                child: Text('Pai'),
              ),
              DropdownMenuItem(
                value: 'Avó',
                child: Text('Avó'),
              ),
              DropdownMenuItem(
                value: 'Avô',
                child: Text('Avô'),
              ),
              DropdownMenuItem(
                value: 'Tio',
                child: Text('Tio'),
              ),
              DropdownMenuItem(
                value: 'Tia',
                child: Text('Tia'),
              ),
            ],
            onChanged: (value) {
              setState(() {
                ListRelacaoResponsavelPaciente[index] = value!;
              });
            },
          ),
        ),
        const SizedBox(height: 20),
        campoTexto('Grau de Escolaridade', ListEscolaridadeResponsavelPaciente[index], Icons.school),
        const SizedBox(height: 20),
        campoTexto('Profissão', ListProfissaoResponsavelPaciente[index], Icons.work),
      ],
    );
  }
}

Future<void> adicionarPaciente(
    context,
    uidFono,
    dataInicio,
    urlImage,
    nomePaciente,
    dataNascimento,
    telefone,
    genero,
    lougradouro,
    numero,
    bairro,
    cidade,
    estado,
    cep,
    tipoConsulta,
    descricao,
    generoResponsavel,
    nomeResponsavel,
    dataNascimentoResponsavel,
    relacaoResponsavel,
    escolaridadeResponsavel,
    profissaoResponsavel) async {
  CollectionReference pacientes = FirebaseFirestore.instance.collection('pacientes');
  String uidPaciente = '';
  Map<String, dynamic> data = {
    'uidFono': uidFono,
    'dataInicioPaciente': dataInicio,
    'urlImagePaciente': urlImage,
    'nomePaciente': nomePaciente,
    'dtNascimentoPaciente': dataNascimento,
    'telefonePaciente': telefone,
    'generoPaciente': genero,
    'lougradouroPaciente': lougradouro,
    'numeroPaciente': numero,
    'bairroPaciente': bairro,
    'cidadePaciente': cidade,
    'estadoPaciente': estado,
    'cepPaciente': cep,
    'tipoConsultaPaciente': tipoConsulta,
    'descricaoPaciente': descricao,
  };
  for (int i = 0; i < generoResponsavel.length; i++) {
    data['generoResponsavel$i'] = generoResponsavel[i].toString();
    data['nomeResponsavel$i'] = nomeResponsavel[i].text;
    data['dataNascimentoResponsavel$i'] = dataNascimentoResponsavel[i].text;
    data['relacaoResponsavel$i'] = relacaoResponsavel[i];
    data['escolaridadeResponsavel$i'] = escolaridadeResponsavel[i].text;
    data['profissaoResponsavel$i'] = profissaoResponsavel[i].text;
  }
  DocumentReference docRef = await pacientes.add(data);
  await FirebaseFirestore.instance.collection('pacientes').where('nomePaciente', isEqualTo: nomePaciente).get().then((us) {
    uidPaciente = us.docs[0].id;
  });
  await docRef.update({'uidPaciente': uidPaciente});
  sucesso(context, 'O paciente foi adicionado com sucesso.');
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(
      builder: (context) => const TelaPacientes(),
    ),
  );
}
