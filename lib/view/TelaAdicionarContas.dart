import 'package:flutter/material.dart';

import 'package:brasil_fields/brasil_fields.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../models/maps.dart';
import '../widgets/toggleSwitch.dart';
import '../widgets/TextFieldSuggestions.dart';
import '../widgets/campoTexto.dart';
import '../connections/fireAuth.dart';
import '../connections/fireCloudContas.dart';
import '../connections/fireCloudPacientes.dart';
import '../controllers/estilos.dart';

class TelaAdicionarContas extends StatefulWidget {
  final String tipo;

  const TelaAdicionarContas(this.tipo, {super.key});

  @override
  State<TelaAdicionarContas> createState() => _TelaAdicionarContasState();
}

class _TelaAdicionarContasState extends State<TelaAdicionarContas> {
  String _paciente = '';
  List<String> listPacientes = [];
  List<String> listUID = [];
  late DateTime now;
  late int hour;
  late int minute;
  String horaCompra = '';
  int indexTransacao = 0;
  int indexTipoTransacao = 0;
  int indexEstadoRecebido = 0;
  int indexEstadoTipo = 0;
  int indexQtdPagamento = 0;
  String selecioneTipoTransacao = 'Recebido';
  String selecioneEstadoRecebido = 'Pacientes';
  bool selecioneEstadoPago = true;
  String selecioneEstadoTipo = 'Trabalho';
  bool selecioneQtdPagamentoPaciente = true;
  var txtNome = TextEditingController();
  var txtPreco = TextEditingController();
  String selecioneFormaPagamento = 'Cartão Débito';
  String selecioneQntdParcelas = '1x';
  var txtData = TextEditingController();
  var txtDescricaoConta = TextEditingController();
  var varAtivo = '1';

  Future<void> atualizarDados() async {
    await carregarDados();
  }

  carregarDados() async {
    listPacientes = await fazerListaPacientes(varAtivo);
    listUID = await fazerListaUIDPacientes();

    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    now = DateTime.now();
    hour = now.hour;
    minute = now.hour;
    horaCompra = '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';
    txtData.text =
        "${now.day.toString().padLeft(2, '0')}/${now.month.toString().padLeft(2, '0')}/${now.year.toString()}";
    carregarDados();
  }

  @override
  Widget build(BuildContext context) {
    TamanhoFonte tamanhoFonte = TamanhoFonte();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: cores('corFundo'),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: cores('corSimbolo'),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          "Adicionar Contas",
          style: TextStyle(color: cores('corTexto')),
        ),
        /*actions: <Widget>[
          Padding(
            padding: EdgeInsets.all(10),
            child: Center(
              child: Text(
                horaCompra,
                style: TextStyle(fontSize: 18, color: cores('corTexto')),
              ),
            ),
          ),
        ],*/
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
                    style: TextStyle(fontSize: 16, color: cores('corTexto'), fontWeight: FontWeight.bold),
                  ),
                  toggleSwitch2(indexTransacao, 'Recebido', 'Gasto', Icons.attach_money, Icons.money_off, (value) {
                    setState(() {
                      selecioneTipoTransacao = value == 0 ? 'Recebido' : 'Gasto';
                      selecioneTipoTransacao == 'Recebido'
                          ? (indexEstadoRecebido = 0, selecioneEstadoRecebido = 'Pacientes')
                          : selecioneEstadoRecebido = 'Outros';
                      indexTransacao = value!;
                    });
                  }),
                  const SizedBox(height: 20),
                  Text(
                    selecioneTipoTransacao == 'Recebido'
                        ? 'Selecione o Tipo de Recebimento:'
                        : 'Selecione se o Gasto foi:',
                    style: TextStyle(fontSize: 16, color: cores('corTexto'), fontWeight: FontWeight.bold),
                  ),
                  selecioneTipoTransacao == 'Gasto'
                      ? toggleSwitch2(indexTipoTransacao, 'Pago', 'Não Pago', Icons.attach_money, Icons.money_off,
                          (value) {
                          setState(() {
                            selecioneEstadoPago = value == 0 ? true : false;
                            indexTipoTransacao = value!;
                          });
                        })
                      : toggleSwitch2(
                          indexEstadoRecebido, 'Pacientes', 'Outros', FontAwesomeIcons.child, FontAwesomeIcons.shuffle,
                          (value) {
                          setState(() {
                            selecioneEstadoRecebido = value == 0 ? 'Pacientes' : 'Outros';
                            indexEstadoRecebido = value!;
                          });
                        }),
                  selecioneEstadoRecebido == 'Outros' ? const SizedBox(height: 20) : Container(),
                  selecioneEstadoRecebido == 'Outros'
                      ? Text(
                          'Selecione o Tipo de ${selecioneTipoTransacao}:',
                          style: TextStyle(fontSize: 16, color: cores('corTexto'), fontWeight: FontWeight.bold),
                        )
                      : Container(),
                  selecioneEstadoRecebido == 'Outros'
                      ? toggleSwitch3(indexEstadoTipo, 'Trabalho', 'Pessoal', 'Outros', FontAwesomeIcons.briefcase,
                          FontAwesomeIcons.solidUser, FontAwesomeIcons.shuffle, (value) {
                          setState(() {
                            selecioneEstadoTipo = value == 0 ? 'Trabalho' : (value == 1 ? 'Pessoal' : 'Outros');
                            indexEstadoTipo = value!;
                          });
                        })
                      : Container(),
                  const SizedBox(height: 20),
                  selecioneEstadoRecebido == 'Pacientes' && selecioneTipoTransacao == 'Recebido'
                      ? TextFieldSuggestions(
                          icone: Icons.label,
                          list: listPacientes,
                          labelText: "Nome do Paciente",
                          textSuggetionsColor: cores('corTexto'),
                          suggetionsBackgroundColor: cores('branco'),
                          outlineInputBorderColor: cores('corTexto'),
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
                        selecioneTipoTransacao == 'Recebido'
                            ? 'Selecione Forma de Recebimento'
                            : 'Selecione Forma de Pagamento:',
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
                              BoxShadow(offset: const Offset(0, 3), color: cores('corSombra'), blurRadius: 5)
                              // changes position of shadow
                            ]),
                        child: DropdownButton(
                          hint: const Text('Selecione Forma de Pagamento'),
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
                  selecioneEstadoRecebido == 'Pacientes'
                      ? Column(children: [
                          Text(
                            'Quantas vezes adicionar Pag. do Paciente?',
                            style: TextStyle(fontSize: 16, color: cores('corTexto'), fontWeight: FontWeight.bold),
                          ),
                          toggleSwitch2(indexQtdPagamento, 'Uma Cobrança', 'Várias Cobranças', Icons.one_x_mobiledata,
                              Icons.repeat, (value) {
                            setState(() {
                              selecioneQtdPagamentoPaciente = value == 0 ? true : false;
                              indexQtdPagamento = value!;
                            });
                          })
                        ])
                      : Container(),
                  selecioneFormaPagamento == "Cartão Crédito" || selecioneFormaPagamento == "Carnê"
                      ? Column(
                          children: [
                            Text(
                              'Selecione Quantidade de Parcelas:',
                              style: TextStyle(fontSize: 16, color: cores('corTexto'), fontWeight: FontWeight.bold),
                            ),
                            Container(
                              height: 40,
                              padding: const EdgeInsets.only(left: 10),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8.0),
                                  border: Border.all(color: cores('corBorda')),
                                  color: cores('corCaixaPadrao'),
                                  boxShadow: [
                                    BoxShadow(offset: const Offset(0, 3), color: cores('corSombra'), blurRadius: 5)
                                  ]),
                              child: DropdownButton(
                                hint: const Text('Selecione Quantidade de Parcelas'),
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
                  campoTexto('Descrição', txtDescricaoConta, Icons.description,
                      maxPalavras: 200, maxLinhas: 5, tamanho: 20.0),
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
                          'Adicionar',
                          style: TextStyle(fontSize: tamanhoFonte.letraPequena(context)),
                        ),
                        onPressed: () {
                          selecioneEstadoRecebido == 'Pacientes' ? selecioneEstadoTipo = 'Trabalho' : null;
                          adicionarContas(
                            context,
                            listUID,
                            listPacientes,
                            idUsuario(),
                            selecioneTipoTransacao,
                            selecioneEstadoRecebido,
                            selecioneEstadoPago,
                            selecioneEstadoTipo,
                            selecioneQtdPagamentoPaciente,
                            txtNome.text,
                            txtPreco.text,
                            selecioneFormaPagamento,
                            selecioneQntdParcelas,
                            txtData.text,
                            horaCompra,
                            txtDescricaoConta.text,
                          );
                        },
                      ),
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
            ),
          )
        ],
      ),
    );
  }
}
