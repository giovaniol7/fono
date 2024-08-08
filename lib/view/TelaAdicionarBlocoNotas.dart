import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';

import '../connections/fireAuth.dart';
import '../connections/fireCloudBlocoNotas.dart';
import '../controllers/variaveis.dart';
import '../controllers/estilos.dart';
import '../widgets/campoTexto.dart';
import '../widgets/mensagem.dart';

class TelaAdicionarBlocoNotas extends StatefulWidget {
  const TelaAdicionarBlocoNotas({super.key});

  @override
  State<TelaAdicionarBlocoNotas> createState() => _TelaAdicionarBlocoNotasState();
}

class _TelaAdicionarBlocoNotasState extends State<TelaAdicionarBlocoNotas> {
  late String? tipo;
  late String? uidNota;

  carregarDados() async {
    if (tipo == 'editar') {
      AppVariaveis().blNotas = await recuperarNota(context, uidNota);
    }

    setState(() {
      tipo == 'adicionar'
          ? AppVariaveis().txtDataBloco.text =
              "${AppVariaveis().nowTimer.day.toString().padLeft(2, '0')}/${AppVariaveis().nowTimer.month.toString().padLeft(2, '0')}/${AppVariaveis().nowTimer.year.toString()}"
          : null;

      if (tipo == 'editar') {
        AppVariaveis().uidBloco = AppVariaveis().blNotas['AppVariaveis().uidBloco']!;
        AppVariaveis().txtNomeBloco.text = AppVariaveis().blNotas['nomeBloco']!;
        AppVariaveis().txtDataBloco.text = AppVariaveis().blNotas['dataBloco']!;
        AppVariaveis().txtNomeResponsavel.text = AppVariaveis().blNotas['nomeResponsavel']!;
        AppVariaveis().txtTelefoneBloco.text = AppVariaveis().blNotas['telefoneBloco']!;
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
    tipo = arguments?['tipo'] as String?;
    uidNota = arguments?['appointment'] as String?;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: cores('corFundo'),
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
                            content: const Text('Tem certeza de que deseja apagar esta Nota?'),
                            actions: <Widget>[
                              TextButton(
                                child: const Text(
                                  'Cancelar',
                                  style: TextStyle(color: Colors.blue),
                                ),
                                onPressed: () {
                                  AppVariaveis().resetBlocoNotas();
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
                                    await apagarBlocoNota(context, AppVariaveis().uidBloco);
                                  } catch (e) {
                                    erro(context, 'Erro ao deletar Nota: $e');
                                  }
                                  AppVariaveis().resetBlocoNotas();
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
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            AppVariaveis().resetBlocoNotas();
            Navigator.pop(context);
          },
        ),
        iconTheme: IconThemeData(color: cores('corSimbolo')),
        title: Text(
          tipo == 'adicionar' ? "Adicionar Notas" : "Atualizar Notas",
          style: TextStyle(color: cores('corTexto')),
        ),
      ),
      body: ListView(children: [
        Container(
          padding: EdgeInsets.all(10),
          child: Column(
            children: [
              campoTexto(
                'Data de Contato',
                AppVariaveis().txtDataBloco,
                Icons.calendar_month_outlined,
                formato: DataInputFormatter(),
                boardType: 'numeros',
                iconPressed: () async {
                  AppVariaveis().pickedDate = await showDatePicker(
                    context: context,
                    initialDate: AppVariaveis().selectedDate,
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2100),
                  );
                  if (AppVariaveis().pickedDate != null &&
                      AppVariaveis().pickedDate != AppVariaveis().selectedDate) {
                    setState(() {
                      AppVariaveis().selectedDate = AppVariaveis().pickedDate!;
                      AppVariaveis().txtDataBloco.text =
                          "${AppVariaveis().selectedDate.day.toString().padLeft(2, '0')}/${AppVariaveis().selectedDate.month.toString().padLeft(2, '0')}/${AppVariaveis().selectedDate.year.toString()}";
                    });
                  }
                },
              ),
              SizedBox(height: 20),
              campoTexto('Nome Notas', AppVariaveis().txtNomeBloco, Icons.person),
              SizedBox(height: 20),
              campoTexto('Nome Responsável', AppVariaveis().txtNomeResponsavel, Icons.person_2),
              SizedBox(height: 20),
              campoTexto('Telefone Responsável', AppVariaveis().txtTelefoneBloco, Icons.phone,
                  formato: TelefoneInputFormatter(), boardType: 'numeros'),
              SizedBox(height: 20),
              rowBotao(),
            ],
          ),
        ),
      ]),
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
              tipo == 'editar' ? 'Atualizar' : 'Criar',
              style: TextStyle(fontSize: tamanhoFonte.letraPequena(context)),
            ),
            onPressed: () async {
              tipo == 'editar'
                  ? editarBlocoNota(
                      context,
                      uidNota,
                      idFonoAuth(),
                      AppVariaveis().txtNomeResponsavel.text,
                      AppVariaveis().txtDataBloco.text,
                      AppVariaveis().txtNomeResponsavel.text,
                      AppVariaveis().txtTelefoneBloco.text)
                  : adicionarBlocoNota(
                      context,
                      idFonoAuth(),
                      AppVariaveis().txtNomeResponsavel.text,
                      AppVariaveis().txtDataBloco.text,
                      AppVariaveis().txtNomeResponsavel.text,
                      AppVariaveis().txtTelefoneBloco.text);
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
            AppVariaveis().resetBlocoNotas();
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}
