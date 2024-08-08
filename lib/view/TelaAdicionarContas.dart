import 'package:flutter/material.dart';

import 'package:brasil_fields/brasil_fields.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../widgets/toggleSwitch.dart';
import '../widgets/TextFieldSuggestions.dart';
import '../widgets/campoTexto.dart';
import '../connections/fireAuth.dart';
import '../connections/fireCloudContas.dart';
import '../connections/fireCloudPacientes.dart';
import '../controllers/variaveis.dart';
import '../controllers/estilos.dart';

class TelaAdicionarContas extends StatefulWidget {
  const TelaAdicionarContas({super.key});

  @override
  State<TelaAdicionarContas> createState() => _TelaAdicionarContasState();
}

class _TelaAdicionarContasState extends State<TelaAdicionarContas> {
  late String? tipo;
  late String? nomeContaProc;

  Future<void> atualizarDados() async {
    await carregarDados();
  }

  carregarDados() async {
    AppVariaveis().horaConta = AppVariaveis().nowTimer.hour;
    AppVariaveis().minutoConta = AppVariaveis().nowTimer.hour;
    AppVariaveis().horarioCompra =
        '${AppVariaveis().nowTimer.hour.toString().padLeft(2, '0')}:${AppVariaveis().nowTimer.minute.toString().padLeft(2, '0')}';
    AppVariaveis().txtDataConta.text =
        "${AppVariaveis().nowTimer.day.toString().padLeft(2, '0')}/${AppVariaveis().nowTimer.month.toString().padLeft(2, '0')}/${AppVariaveis().nowTimer.year.toString()}";
    AppVariaveis().listaPacientes = await fazerListaPacientes(AppVariaveis().varAtivoPaciente);
    AppVariaveis().listaUID = await fazerListaUIDPacientes();
    tipo == 'editar' ? AppVariaveis().conta = await recuperarConta(context, nomeContaProc) : null;

    if (tipo == 'editar') {
      setState(() {
        AppVariaveis().labelText = AppVariaveis().conta['nomeConta']!;
        AppVariaveis().paciente = AppVariaveis().conta['nomeConta']!;
        AppVariaveis().uidConta = AppVariaveis().conta['uidConta']!;
        AppVariaveis().txtNomeConta.text = AppVariaveis().conta['nomeConta']!;
        AppVariaveis().txtPrecoConta.text = AppVariaveis().conta['preco']!;
        AppVariaveis().txtDataConta.text = AppVariaveis().conta['data']!;
        AppVariaveis().txtDescricaoConta.text = AppVariaveis().conta['descricaoConta']!;
        AppVariaveis().horaConta = int.tryParse(AppVariaveis().conta['hora'] ?? '0') ?? 0;
        AppVariaveis().minutoConta = int.tryParse(AppVariaveis().conta['minuto'] ?? '0') ?? 0;
        AppVariaveis().horarioCompra = AppVariaveis().conta['dataHora']!;
        AppVariaveis().selecioneFormaPagamento = AppVariaveis().conta['formaPagamento']!;
        AppVariaveis().selecioneQntdParcelas = AppVariaveis().conta['qntdParcelas']!;

        AppVariaveis().indexTransacao =
            AppVariaveis().toggleOptionsTransacao.indexOf(AppVariaveis().conta['tipoTransacao']!);
        AppVariaveis().selecioneTipoTransacao = AppVariaveis().conta['tipoTransacao']!;
        AppVariaveis().selecioneTipoTransacao == 'Recebido'
            ? (AppVariaveis().indexEstadoRecebido = 0, AppVariaveis().selecioneEstadoRecebido = 'Pacientes')
            : AppVariaveis().selecioneEstadoRecebido = 'Outros';

        if (AppVariaveis().selecioneTipoTransacao == 'Recebido') {
          AppVariaveis().indexEstadoRecebido =
              AppVariaveis().toggleOptionsEstadoRecebido.indexOf(AppVariaveis().conta['estadoRecebido']!);
          AppVariaveis().selecioneEstadoRecebido = AppVariaveis().conta['estadoRecebido']!;
        } else if (AppVariaveis().selecioneTipoTransacao == 'Gasto') {
          AppVariaveis().indexTipoTransacao =
              AppVariaveis().toggleOptionsEstadoGasto.indexOf(AppVariaveis().conta['estadoPago']!);
          AppVariaveis().selecioneEstadoPago = AppVariaveis().conta['estadoPago']!;
        }

        AppVariaveis().indexEstadoTipo =
            AppVariaveis().toggleOptionsEstadoTipo.indexOf(AppVariaveis().conta['tipo']!);
        AppVariaveis().selecioneEstadoTipo = AppVariaveis().conta['tipo']!;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    carregarDados();
  }

  @override
  Widget build(BuildContext context) {
    final arguments = ModalRoute.of(context)?.settings.arguments as Map?;
    tipo = arguments?['tipo'] as String?;
    nomeContaProc = arguments?['nomeConta'] as String?;

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
            AppVariaveis().resetContabilidade();
            Navigator.pop(context);
          },
        ),
        title: Text(
          tipo == 'adicionar' ? "Adicionar Contas" : "Editar Conta",
          style: TextStyle(color: cores('corTexto')),
        ),
        /*actions: <Widget>[
          Padding(
            padding: EdgeInsets.all(10),
            child: Center(
              child: Text(
                AppVariaveis().horarioCompra,
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
                  toggleSwitch2(AppVariaveis().indexTransacao, AppVariaveis().toggleOptionsTransacao,
                      Icons.attach_money, Icons.money_off, (value) {
                    setState(() {
                      AppVariaveis().selecioneTipoTransacao = value == 0 ? 'Recebido' : 'Gasto';
                      AppVariaveis().selecioneTipoTransacao == 'Recebido'
                          ? (
                              AppVariaveis().indexEstadoRecebido = 0,
                              AppVariaveis().selecioneEstadoRecebido = 'Pacientes'
                            )
                          : AppVariaveis().selecioneEstadoRecebido = 'Outros';
                      AppVariaveis().indexTransacao = value!;
                    });
                  }),
                  const SizedBox(height: 20),
                  Text(
                    AppVariaveis().selecioneTipoTransacao == 'Recebido'
                        ? 'Selecione o Tipo de Recebimento:'
                        : 'Selecione se o Gasto foi:',
                    style: TextStyle(fontSize: 16, color: cores('corTexto'), fontWeight: FontWeight.bold),
                  ),
                  AppVariaveis().selecioneTipoTransacao == 'Gasto'
                      ? toggleSwitch2(
                          AppVariaveis().indexTipoTransacao,
                          AppVariaveis().toggleOptionsEstadoGasto,
                          Icons.attach_money,
                          Icons.money_off, (value) {
                          setState(() {
                            AppVariaveis().selecioneEstadoPago = value == 0 ? "Pago" : "Não Pago";
                            AppVariaveis().indexTipoTransacao = value!;
                          });
                        })
                      : toggleSwitch2(
                          AppVariaveis().indexEstadoRecebido,
                          AppVariaveis().toggleOptionsEstadoRecebido,
                          FontAwesomeIcons.child,
                          FontAwesomeIcons.shuffle, (value) {
                          setState(() {
                            AppVariaveis().selecioneEstadoRecebido = value == 0 ? 'Pacientes' : 'Outros';
                            AppVariaveis().indexEstadoRecebido = value!;
                          });
                        }),
                  AppVariaveis().selecioneEstadoRecebido == 'Outros'
                      ? const SizedBox(height: 20)
                      : Container(),
                  AppVariaveis().selecioneEstadoRecebido == 'Outros'
                      ? Text(
                          'Selecione o Tipo de ${AppVariaveis().selecioneTipoTransacao}:',
                          style:
                              TextStyle(fontSize: 16, color: cores('corTexto'), fontWeight: FontWeight.bold),
                        )
                      : Container(),
                  AppVariaveis().selecioneEstadoRecebido == 'Outros'
                      ? toggleSwitch3(
                          AppVariaveis().indexEstadoTipo,
                          AppVariaveis().toggleOptionsEstadoTipo,
                          FontAwesomeIcons.briefcase,
                          FontAwesomeIcons.solidUser,
                          FontAwesomeIcons.shuffle, (value) {
                          setState(() {
                            AppVariaveis().selecioneEstadoTipo =
                                value == 0 ? 'Trabalho' : (value == 1 ? 'Pessoal' : 'Outros');
                            AppVariaveis().indexEstadoTipo = value!;
                          });
                        })
                      : Container(),
                  const SizedBox(height: 20),
                  AppVariaveis().selecioneEstadoRecebido == 'Pacientes' &&
                          AppVariaveis().selecioneTipoTransacao == 'Recebido'
                      ? TextFieldSuggestions(
                          tipo: 'paciente',
                          icone: Icons.label,
                          list: AppVariaveis().listaPacientes,
                          labelText: AppVariaveis().labelText,
                          textSuggetionsColor: cores('corTexto'),
                          suggetionsBackgroundColor: cores('branco'),
                          outlineInputBorderColor: cores('corTexto'),
                          returnedValue: (String value) {
                            setState(() {
                              AppVariaveis().paciente = value;
                              AppVariaveis().txtNomeConta.text = AppVariaveis().paciente;
                            });
                          },
                          onTap: () {},
                          height: 200)
                      : campoTexto(
                          'Nome do ${AppVariaveis().selecioneTipoTransacao}',
                          AppVariaveis().txtNomeConta,
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
                    'Valor do ${AppVariaveis().selecioneTipoTransacao}',
                    AppVariaveis().txtPrecoConta,
                    Icons.monetization_on_rounded,
                    formato: CentavosInputFormatter(),
                    boardType: 'numeros',
                  ),
                  const SizedBox(height: 20),
                  Column(
                    children: [
                      Text(
                        AppVariaveis().selecioneTipoTransacao == 'Recebido'
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
                          value: AppVariaveis().selecioneFormaPagamento,
                          onChanged: (newValue) {
                            setState(() {
                              AppVariaveis().selecioneFormaPagamento = newValue!;
                            });
                          },
                          items: AppVariaveis().formaPagamentoDrop.map((state) {
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
                  AppVariaveis().selecioneEstadoRecebido == 'Pacientes'
                      ? Column(children: [
                          Text(
                            'Quantas vezes adicionar Pag. do Paciente?',
                            style: TextStyle(
                                fontSize: 16, color: cores('corTexto'), fontWeight: FontWeight.bold),
                          ),
                          toggleSwitch2(
                              AppVariaveis().indexQtdPagamento,
                              AppVariaveis().toggleOptionsCobranca,
                              Icons.one_x_mobiledata,
                              Icons.repeat, (value) {
                            setState(() {
                              AppVariaveis().selecioneQtdPagamentoPaciente = value == 0 ? true : false;
                              AppVariaveis().indexQtdPagamento = value!;
                            });
                          })
                        ])
                      : Container(),
                  AppVariaveis().selecioneFormaPagamento == "Cartão Crédito" ||
                          AppVariaveis().selecioneFormaPagamento == "Carnê"
                      ? Column(
                          children: [
                            Text(
                              'Selecione Quantidade de Parcelas:',
                              style: TextStyle(
                                  fontSize: 16, color: cores('corTexto'), fontWeight: FontWeight.bold),
                            ),
                            Container(
                              height: 40,
                              padding: const EdgeInsets.only(left: 10),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8.0),
                                  border: Border.all(color: cores('corBorda')),
                                  color: cores('corCaixaPadrao'),
                                  boxShadow: [
                                    BoxShadow(
                                        offset: const Offset(0, 3), color: cores('corSombra'), blurRadius: 5)
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
                                value: AppVariaveis().selecioneQntdParcelas,
                                onChanged: (newValue) {
                                  setState(() {
                                    AppVariaveis().selecioneQntdParcelas = newValue!;
                                  });
                                },
                                items: AppVariaveis().qntdParcelasDrop.map((state) {
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
                  campoTexto('Data', AppVariaveis().txtDataConta, Icons.credit_card,
                      formato: DataInputFormatter(), boardType: 'numeros'),
                  const SizedBox(height: 20),
                  campoTexto('Descrição', AppVariaveis().txtDescricaoConta, Icons.description,
                      maxPalavras: 200, maxLinhas: 5, tamanho: 20.0, boardType: 'multiLinhas'),
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
                          tipo == 'adicionar' ? 'Adicionar' : 'Editar',
                          style: TextStyle(fontSize: tamanhoFonte.letraPequena(context)),
                        ),
                        onPressed: () {
                          AppVariaveis().selecioneEstadoRecebido == 'Pacientes'
                              ? AppVariaveis().selecioneEstadoTipo = 'Trabalho'
                              : null;
                          tipo == 'adicionar'
                              ? adicionarContas(
                                  context,
                                  AppVariaveis().listaUID,
                                  AppVariaveis().listaPacientes,
                                  idFonoAuth(),
                                  AppVariaveis().selecioneTipoTransacao,
                                  AppVariaveis().selecioneEstadoRecebido,
                                  AppVariaveis().selecioneEstadoPago,
                                  AppVariaveis().selecioneEstadoTipo,
                                  AppVariaveis().selecioneQtdPagamentoPaciente,
                                  AppVariaveis().txtNomeConta.text,
                                  AppVariaveis().txtPrecoConta.text,
                                  AppVariaveis().selecioneFormaPagamento,
                                  AppVariaveis().selecioneQntdParcelas,
                                  AppVariaveis().txtDataConta.text,
                                  AppVariaveis().horarioCompra,
                                  AppVariaveis().txtDescricaoConta.text)
                              : editarContas(
                                  context,
                                  AppVariaveis().uidConta,
                                  idFonoAuth(),
                                  AppVariaveis().selecioneTipoTransacao,
                                  AppVariaveis().selecioneEstadoRecebido,
                                  AppVariaveis().selecioneEstadoPago,
                                  AppVariaveis().selecioneEstadoTipo,
                                  AppVariaveis().selecioneQtdPagamentoPaciente,
                                  AppVariaveis().txtNomeConta.text,
                                  AppVariaveis().txtPrecoConta.text,
                                  AppVariaveis().selecioneFormaPagamento,
                                  AppVariaveis().selecioneQntdParcelas,
                                  AppVariaveis().txtDataConta.text,
                                  AppVariaveis().horarioCompra,
                                  AppVariaveis().txtDescricaoConta.text);
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
                          AppVariaveis().resetContabilidade();
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
