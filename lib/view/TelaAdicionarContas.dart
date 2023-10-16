import 'dart:io';

import 'package:brasil_fields/brasil_fields.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:fono/widgets/TextFieldSuggestions.dart';
import 'package:fono/widgets/campoTexto.dart';
import 'package:fono/view/controllers/coresPrincipais.dart';
import 'package:firedart/firedart.dart' as fd;
import 'package:fono/widgets/mensagem.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toggle_switch/toggle_switch.dart';

class TelaAdicionarContas extends StatefulWidget {
  final String uidFono;

  const TelaAdicionarContas(this.uidFono, {super.key});

  @override
  State<TelaAdicionarContas> createState() => _TelaAdicionarContasState();
}

class _TelaAdicionarContasState extends State<TelaAdicionarContas> {
  var contas;
  var uidFono;
  var windowsIdFono;
  var txtNome = TextEditingController();
  var txtPreco = TextEditingController();
  var txtData = TextEditingController();
  var txtDescricaoConta = TextEditingController();
  String _paciente = '';
  List<String> _listNome = [];
  List<String> _listUid = [];
  late DateTime now;
  late int hour;
  late int minute;
  int index = 0;
  int index2 = 0;
  int index3 = 1;
  int index4 = 0;
  String horaCompra = '';
  bool estadoPago = true;
  String estadoTipo = 'Trabalho';
  String estadoRecebido = 'Outros';
  String selecioneTipoTransacao = 'Recebido';
  String selecioneFormaPagamento = 'Cartão Débito';
  String selecioneQntdParcelas = '1x';
  final List<String> formaPagamento = ["Cartão Débito", "Cartão Crédito", "Pix", "Dinheiro", "Carnê"];
  final List<String> qntdParcelas = ["1x", "2x", "3x", "4x", "5x", "6x", "7x", "8x", "9x", "10x", "11x", "12x"];

  retornarPacientes() async {
    if (kIsWeb || Platform.isAndroid || Platform.isIOS) {
      uidFono = await FirebaseAuth.instance.currentUser!.uid.toString();
      contas = await FirebaseFirestore.instance.collection('contas').where('uidFono', isEqualTo: uidFono);
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('pacientes').where('uidFono', isEqualTo: uidFono).get();
      for (var doc in querySnapshot.docs) {
        String nome = doc['nomePaciente'];
        String uid = doc['uidPaciente'];
        _listNome.add(nome);
        _listUid.add(uid);
      }
    } else {
      await fd.FirebaseAuth.initialize('AIzaSyAlG2glNY3njAvAyJ7eEMeMtLg4Wcfg8rI', fd.VolatileStore());
      await fd.Firestore.initialize('programafono-7be09');
      var auth = fd.FirebaseAuth.instance;
      final emailSave = await SharedPreferences.getInstance();
      var email = emailSave.getString('email');
      final senhaSave = await SharedPreferences.getInstance();
      var senha = senhaSave.getString('senha');
      await auth.signIn(email!, senha!);
      var user = await auth.getUser();
      windowsIdFono = user.id;

      contas = await fd.Firestore.instance.collection('contas').where('uidFono', isEqualTo: windowsIdFono);
      List<fd.Document> querySnapshot =
          await fd.Firestore.instance.collection('pacientes').where('uidFono', isEqualTo: uidFono).get();
      for (var doc in querySnapshot) {
        String nome = doc['nomePaciente'];
        String uid = doc['uidPaciente'];
        _listNome.add(nome);
        _listUid.add(uid);
      }
    }
  }

  @override
  void initState() {
    super.initState();
    now = DateTime.now();
    hour = now.hour;
    minute = now.hour;
    horaCompra = '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';
    txtData.text = "${now.day.toString().padLeft(2, '0')}/${now.month.toString().padLeft(2, '0')}/${now.year.toString()}";
    retornarPacientes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: cores('verde')),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          "Adicionar Contas",
          style: TextStyle(color: cores('verde')),
        ),
        /*actions: <Widget>[
          Padding(
            padding: EdgeInsets.all(10),
            child: Center(
              child: Text(
                horaCompra,
                style: TextStyle(fontSize: 18, color: cores('verde')),
              ),
            ),
          ),
        ],*/
        backgroundColor: cores('rosa_fraco'),
      ),
      body: ListView(
        children: [
          Container(
            padding: EdgeInsets.all(16),
            child: Center(
              child: Column(
                children: [
                  Text(
                    'Selecione Tipo de Transação:',
                    style: TextStyle(fontSize: 16, color: cores('verde'), fontWeight: FontWeight.bold),
                  ),
                  ToggleSwitch(
                    minWidth: 150.0,
                    initialLabelIndex: index,
                    cornerRadius: 20.0,
                    activeFgColor: Colors.white,
                    inactiveBgColor: Colors.grey,
                    inactiveFgColor: Colors.white,
                    totalSwitches: 2,
                    labels: ['Recebido', 'Gasto'],
                    icons: [Icons.attach_money, Icons.money_off],
                    radiusStyle: true,
                    activeBgColors: [
                      [Colors.green.shade400],
                      [Colors.pink.shade400]
                    ],
                    onToggle: (value) {
                      setState(() {
                        selecioneTipoTransacao = value == 0 ? 'Recebido' : 'Gasto';
                        index = value!;
                      });
                    },
                  ),
                  const SizedBox(height: 20),
                  Text(
                    selecioneTipoTransacao == 'Recebido' ? 'Selecione o Tipo de Recebimento:' : 'Selecione se o Gasto foi:',
                    style: TextStyle(fontSize: 16, color: cores('verde'), fontWeight: FontWeight.bold),
                  ),
                  selecioneTipoTransacao == 'Gasto'
                      ? ToggleSwitch(
                          minWidth: 150.0,
                          initialLabelIndex: index2,
                          cornerRadius: 20.0,
                          activeFgColor: Colors.white,
                          inactiveBgColor: Colors.grey,
                          inactiveFgColor: Colors.white,
                          totalSwitches: 2,
                          labels: ['Pago', 'Não Pago'],
                          icons: [Icons.attach_money, Icons.money_off],
                          radiusStyle: true,
                          activeBgColors: [
                            [Colors.green.shade400],
                            [Colors.pink.shade400]
                          ],
                          onToggle: (value) {
                            setState(() {
                              estadoPago = value == 0 ? true : false;
                              index2 = value!;
                            });
                          },
                        )
                      : ToggleSwitch(
                          minWidth: 150.0,
                          initialLabelIndex: index3,
                          cornerRadius: 20.0,
                          activeFgColor: Colors.white,
                          inactiveBgColor: Colors.grey,
                          inactiveFgColor: Colors.white,
                          totalSwitches: 2,
                          labels: ['Pacientes', 'Outros'],
                          icons: [FontAwesomeIcons.child, FontAwesomeIcons.shuffle],
                          radiusStyle: true,
                          activeBgColors: [
                            [Colors.blue],
                            [Colors.pink]
                          ],
                          onToggle: (value) {
                            setState(() {
                              estadoRecebido = value == 0 ? 'Pacientes' : 'Outros';
                              index3 = value!;
                            });
                          },
                        ),
                  const SizedBox(height: 20),
                  Text(
                    'Selecione o Tipo de ${selecioneTipoTransacao}:',
                    style: TextStyle(fontSize: 16, color: cores('verde'), fontWeight: FontWeight.bold),
                  ),
                  ToggleSwitch(
                    minWidth: 150.0,
                    initialLabelIndex: index4,
                    cornerRadius: 20.0,
                    activeFgColor: Colors.white,
                    inactiveBgColor: Colors.grey,
                    inactiveFgColor: Colors.white,
                    totalSwitches: 3,
                    labels: ['Trabalho', 'Pessoal', 'Outros'],
                    icons: [FontAwesomeIcons.briefcase, FontAwesomeIcons.solidUser, FontAwesomeIcons.shuffle],
                    radiusStyle: true,
                    activeBgColors: [
                      [Colors.green],
                      [Colors.blue],
                      [Colors.red]
                    ],
                    onToggle: (value) {
                      setState(() {
                        estadoTipo = value == 0 ? 'Trabalho' : (value == 1 ? 'Pessoal' : 'Outros');
                        index4 = value!;
                      });
                    },
                  ),
                  const SizedBox(height: 20),
                  estadoRecebido == 'Pacientes' && selecioneTipoTransacao == 'Recebido'
                      ? TextFieldSuggestions(
                          icone: Icons.label,
                          list: _listNome,
                          labelText: "Nome do Paciente",
                          textSuggetionsColor: const Color(0xFF37513F),
                          suggetionsBackgroundColor: const Color(0xFFFFFFFF),
                          outlineInputBorderColor: const Color(0xFFF5B2B0),
                          returnedValue: (String value) {
                            setState(() {
                              _paciente = value;
                              txtNome.text = _paciente;
                            });
                          },
                          onTap: () {},
                          height: 200)
                      : campoTexto(
                          'Nome do ${selecioneTipoTransacao}',
                          txtNome,
                          Icons.drive_file_rename_outline,
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Campo obrigatório';
                            }
                            return null;
                          },
                        ),
                  const SizedBox(height: 20),
                  campoTexto(
                    'Valor do ${selecioneTipoTransacao}',
                    txtPreco,
                    Icons.monetization_on_rounded,
                    formato: CentavosInputFormatter(),
                    numeros: true,
                  ),
                  const SizedBox(height: 20),
                  Column(
                    children: [
                      Text(
                        selecioneTipoTransacao == 'Recebido' ? 'Selecione Forma de Recebimento' : 'Selecione Forma de Pagamento:',
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
                          hint: const Text('Selecione Forma de Pagamento'),
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
                          value: selecioneFormaPagamento,
                          onChanged: (newValue) {
                            setState(() {
                              selecioneFormaPagamento = newValue!;
                            });
                          },
                          items: formaPagamento.map((state) {
                            return DropdownMenuItem(
                              value: state,
                              child: Text(state),
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  selecioneFormaPagamento == "Cartão Crédito" || selecioneFormaPagamento == "Carnê"
                      ? Column(
                          children: [
                            Text(
                              'Selecione Quantidade de Parcelas:',
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
                                hint: const Text('Selecione Quantidade de Parcelas'),
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
                                value: selecioneQntdParcelas,
                                onChanged: (newValue) {
                                  setState(() {
                                    selecioneQntdParcelas = newValue!;
                                  });
                                },
                                items: qntdParcelas.map((state) {
                                  return DropdownMenuItem(
                                    value: state,
                                    child: Text(state),
                                  );
                                }).toList(),
                              ),
                            ),
                          ],
                        )
                      : Column(),
                  const SizedBox(height: 20),
                  campoTexto('Data', txtData, Icons.credit_card, formato: DataInputFormatter(), numeros: true),
                  const SizedBox(height: 20),
                  campoTexto('Descrição', txtDescricaoConta, Icons.description, maxPalavras: 200, maxLinhas: 5, tamanho: 20.0),
                  const SizedBox(height: 40),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 150,
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                              foregroundColor: cores('rosa_medio'),
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
                          onPressed: () {
                            if (selecioneTipoTransacao.isNotEmpty &&
                                estadoTipo.isNotEmpty &&
                                txtNome.text.isNotEmpty &&
                                txtPreco.text.isNotEmpty &&
                                selecioneFormaPagamento.isNotEmpty &&
                                selecioneQntdParcelas.isNotEmpty &&
                                txtData.text.isNotEmpty &&
                                horaCompra.isNotEmpty) {
                              adicionarContas(
                                  context,
                                  _listUid,
                                  _listNome,
                                  uidFono,
                                  selecioneTipoTransacao,
                                  estadoTipo,
                                  txtNome.text,
                                  txtPreco.text,
                                  selecioneFormaPagamento,
                                  selecioneQntdParcelas,
                                  txtData.text,
                                  horaCompra,
                                  txtDescricaoConta.text,
                                  estadoPago,
                                  estadoRecebido);
                            } else {
                              erro(context, 'Preencha os campos obrigatórios!');
                            }
                          },
                        ),
                      ),
                      Padding(padding: EdgeInsets.all(20)),
                      SizedBox(
                        width: 150,
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                              foregroundColor: cores('rosa_medio'),
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
            ),
          )
        ],
      ),
    );
  }
}

Future<void> adicionarContas(context, listUid, listNome, uidFono, selecioneTipoTransacao, estadoTipo, nomeConta, preco,
    selecioneFormaPagamento, selecioneQntdParcelas, dataCompra, horaCompra, descricaoConta, estadoPago, estadoRecebido) async {
  if(kIsWeb || Platform.isAndroid || Platform.isIOS){
    CollectionReference contas = FirebaseFirestore.instance.collection('contas');
    NumberFormat numberFormat = NumberFormat('#,##0.00', 'pt_BR');
    DateTime proximoMes;
    String dataFormatada = '';
    String dataHora = '';
    int qntdParcelas = int.parse(selecioneQntdParcelas.split('x')[0]);
    final dataAtual = DateTime.now();

    if (qntdParcelas != 1) {
      preco = preco.replaceAll('.', '');
      preco = preco.replaceAll(',', '.');
      double precoCompra = double.parse(preco);
      precoCompra = precoCompra / qntdParcelas;
      preco = numberFormat.format(precoCompra);
    }

    for (int parcela = 0; parcela < qntdParcelas; parcela++) {
      String uidConta = '';
      if (qntdParcelas == 1) {
        dataFormatada = dataCompra;
        dataHora = '$dataCompra $horaCompra';
      } else {
        proximoMes = DateTime(dataAtual.year, dataAtual.month + parcela, dataAtual.day);
        dataFormatada = DateFormat('dd/MM/yyyy').format(proximoMes);
        dataHora = '$dataFormatada $horaCompra';
      }
      Map<String, dynamic> data = {
        'uidFono': uidFono,
        'tipoTransacao': selecioneTipoTransacao,
        'tipo': estadoTipo,
        'nomeConta': nomeConta,
        'preco': preco,
        'formaPagamento': selecioneFormaPagamento,
        'qntdParcelas': selecioneQntdParcelas,
        'data': dataFormatada,
        'hora': horaCompra,
        'dataHora': dataHora,
        'descricaoConta': descricaoConta,
      };
      if (selecioneTipoTransacao == 'Gasto') {
        data['estadoPago'] = estadoPago;
      }
      if (selecioneTipoTransacao == 'Recebido') {
        data['estadoRecebido'] = estadoRecebido;
      }
      DocumentReference docRef = await contas.add(data);
      await FirebaseFirestore.instance
          .collection('contas')
          .where('nomeConta', isEqualTo: nomeConta)
          .where('data', isEqualTo: dataFormatada)
          .get()
          .then((us) {
        uidConta = us.docs[0].id;
      });

      if (estadoRecebido == 'Pacientes') {
        int indice = listNome.indexOf(nomeConta);

        if (indice != -1 && indice < listUid.length) {
          String uidCorrespondente = listUid[indice];
          await docRef.update({'uidPaciente': uidCorrespondente});
        }
      }

      await docRef.update({'uidConta': uidConta});
    }

    sucesso(context, 'Conta adicionada com sucesso.');
    Navigator.pop(context);
  } else {
    await fd.FirebaseAuth.initialize('AIzaSyAlG2glNY3njAvAyJ7eEMeMtLg4Wcfg8rI', fd.VolatileStore());
    fd.Firestore.initialize('programafono-7be09');
    var auth = fd.FirebaseAuth.instance;
    final emailSave = await SharedPreferences.getInstance();
    var email = emailSave.getString('email');
    final senhaSave = await SharedPreferences.getInstance();
    var senha = senhaSave.getString('senha');
    await auth.signIn(email!, senha!);
    var user = await auth.getUser();
    uidFono = user.id;

    fd.CollectionReference contas = fd.Firestore.instance.collection('contas');
    NumberFormat numberFormat = NumberFormat('#,##0.00', 'pt_BR');
    DateTime proximoMes;
    String dataFormatada = '';
    String dataHora = '';
    int qntdParcelas = int.parse(selecioneQntdParcelas.split('x')[0]);
    final dataAtual = DateTime.now();

    if (qntdParcelas != 1) {
      preco = preco.replaceAll('.', '');
      preco = preco.replaceAll(',', '.');
      double precoCompra = double.parse(preco);
      precoCompra = precoCompra / qntdParcelas;
      preco = numberFormat.format(precoCompra);
    }

    for (int parcela = 0; parcela < qntdParcelas; parcela++) {
      String uidConta = '';
      if (qntdParcelas == 1) {
        dataFormatada = dataCompra;
        dataHora = '$dataCompra $horaCompra';
      } else {
        proximoMes = DateTime(dataAtual.year, dataAtual.month + parcela, dataAtual.day);
        dataFormatada = DateFormat('dd/MM/yyyy').format(proximoMes);
        dataHora = '$dataFormatada $horaCompra';
      }
      Map<String, dynamic> data = {
        'uidFono': uidFono,
        'tipoTransacao': selecioneTipoTransacao,
        'tipo': estadoTipo,
        'nomeConta': nomeConta,
        'preco': preco,
        'formaPagamento': selecioneFormaPagamento,
        'qntdParcelas': selecioneQntdParcelas,
        'data': dataFormatada,
        'hora': horaCompra,
        'dataHora': dataHora,
        'descricaoConta': descricaoConta,
      };
      if (selecioneTipoTransacao == 'Gasto') {
        data['estadoPago'] = estadoPago;
      }
      if (selecioneTipoTransacao == 'Recebido') {
        data['estadoRecebido'] = estadoRecebido;
      }
      fd.Document doc = await contas.add(data);
      fd.DocumentReference docRef = doc.reference;
      await fd.Firestore.instance
          .collection('contas')
          .where('nomeConta', isEqualTo: nomeConta)
          .where('data', isEqualTo: dataFormatada)
          .get()
          .then((us) {
        if (us.isNotEmpty) {
          us.forEach((doc) {
            uidConta = doc['uidConta'];
          });
        }
      });

      if (estadoRecebido == 'Pacientes') {
        int indice = listNome.indexOf(nomeConta);

        if (indice != -1 && indice < listUid.length) {
          String uidCorrespondente = listUid[indice];
          await docRef.update({'uidPaciente': uidCorrespondente});
        }
      }

      await docRef.update({'uidConta': uidConta});
    }

    sucesso(context, 'Conta adicionada com sucesso.');
    Navigator.pop(context);
  }
}
