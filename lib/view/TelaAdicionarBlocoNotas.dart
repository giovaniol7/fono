import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';

import '../connections/fireAuth.dart';
import '../connections/fireCloudBlocoNotas.dart';
import '../controllers/estilos.dart';
import '../widgets/campoTexto.dart';
import '../widgets/mensagem.dart';

class TelaAdicionarBlocoNotas extends StatefulWidget {
  final String tipo;
  final String uid;

  const TelaAdicionarBlocoNotas(this.tipo, this.uid, {super.key});

  @override
  State<TelaAdicionarBlocoNotas> createState() => _TelaAdicionarBlocoNotasState();
}

class _TelaAdicionarBlocoNotasState extends State<TelaAdicionarBlocoNotas> {
  late DateTime selectedDate;
  late TimeOfDay selectedTime;
  DateTime? pickedDate;
  String uidBloco = '';
  var txtNomeBloco = TextEditingController();
  var txtDataBloco = TextEditingController();
  var txtNomeResponsavel = TextEditingController();
  var txtTelefoneBloco = TextEditingController();
  var blNotas;

  carregarDados() async {
    if (widget.tipo == 'editar') {
      blNotas = await recuperarNota(context, widget.uid);
    }

    setState(() {
      DateTime now = DateTime.now();
      widget.tipo == 'adicionar'
          ? txtDataBloco.text =
              "${now.day.toString().padLeft(2, '0')}/${now.month.toString().padLeft(2, '0')}/${now.year.toString()}"
          : null;

      if (widget.tipo == 'editar') {
        uidBloco = blNotas['uidBloco'];
        txtNomeBloco.text = blNotas['nomeBloco'];
        txtDataBloco.text = blNotas['dataBloco'];
        txtNomeResponsavel.text = blNotas['nomeResponsavel'];
        txtTelefoneBloco.text = blNotas['telefoneBloco'];
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
        backgroundColor: cores('corFundo'),
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
                            content: const Text('Tem certeza de que deseja apagar esta Nota?'),
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
                                    await apagarBlocoNota(context, uidBloco);
                                  } catch (e) {
                                    erro(context, 'Erro ao deletar Nota: $e');
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
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        iconTheme: IconThemeData(color: cores('corSimbolo')),
        title: Text(
          widget.tipo == 'adicionar' ? "Adicionar Notas" : "Atualizar Notas",
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
                txtDataBloco,
                Icons.calendar_month_outlined,
                formato: DataInputFormatter(),
                numeros: true,
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
                      txtDataBloco.text =
                          "${selectedDate.day.toString().padLeft(2, '0')}/${selectedDate.month.toString().padLeft(2, '0')}/${selectedDate.year.toString()}";
                    });
                  }
                },
              ),
              SizedBox(height: 20),
              campoTexto('Nome Notas', txtNomeBloco, Icons.person),
              SizedBox(height: 20),
              campoTexto('Nome Responsável', txtNomeResponsavel, Icons.person_2),
              SizedBox(height: 20),
              campoTexto('Telefone Responsável', txtTelefoneBloco, Icons.phone,
                  formato: TelefoneInputFormatter(), numeros: true),
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
              widget.tipo == 'editar' ? 'Atualizar' : 'Criar',
              style: TextStyle(fontSize: tamanhoFonte.letraPequena(context)),
            ),
            onPressed: () async {
              widget.tipo == 'editar'
                  ? editarBlocoNota(context, widget.uid, idUsuario(), txtNomeResponsavel.text, txtDataBloco.text,
                      txtNomeResponsavel.text, txtTelefoneBloco.text)
                  : adicionarBlocoNota(context, idUsuario(), txtNomeResponsavel.text, txtDataBloco.text,
                      txtNomeResponsavel.text, txtTelefoneBloco.text);
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
}
