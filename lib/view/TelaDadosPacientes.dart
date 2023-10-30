import 'package:flutter/material.dart';

import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../connections/fireCloudPacientes.dart';
import '../controllers/calcularIdade.dart';
import '../controllers/estilos.dart';
import '../models/maps.dart';

class TelaDadosPacientes extends StatefulWidget {
  final String uidPaciente;

  const TelaDadosPacientes(this.uidPaciente, {super.key});

  @override
  State<TelaDadosPacientes> createState() => _TelaDadosPacientesState();
}

class _TelaDadosPacientesState extends State<TelaDadosPacientes> {
  var paciente;
  late String uidPaciente = '';
  late String uidFono = '';
  late String dataInicioPaciente = '';
  late String urlImagePaciente = '';
  late String nomePaciente = '';
  late String dtNascimentoPaciente = '';
  late String CPFPaciente = '';
  late String RGPaciente = '';
  late String idadePaciente = '';
  late String telefonePaciente = '';
  late String generoPaciente = '';
  late String lougradouroPaciente = '';
  late String numeroPaciente = '';
  late String bairroPaciente = '';
  late String cidadePaciente = '';
  late String estadoPaciente = '';
  late String cepPaciente = '';
  late String tipoConsultaPaciente = '';
  late String descricaoPaciente = '';

  late List<Gender?> ListGeneroResponsavelPaciente = [];
  late List<String> ListNomeResponsavelPaciente = [];
  late List<String> ListIdadeResponsavelPaciente = [];
  late List<String> ListTelefoneResponsavelPaciente = [];
  late List<String> ListRelacaoResponsavelPaciente = [];
  late List<String> ListEscolaridadeResponsavelPaciente = [];
  late List<String> ListProfissaoResponsavelPaciente = [];
  late int qtdResponsavel = 0;

  int index = 0;

  DateTime dataAtual = DateTime.now();

  Future<void> atualizarDados() async {
    await carregarDados();
  }

  carregarDados() async {
    paciente = await recuperarPaciente(context, widget.uidPaciente);

    setState(() {
      dataInicioPaciente = DateFormat('dd/MM/yyyy').format(dataAtual);

      uidPaciente = paciente['uidPaciente'];
      uidFono = paciente['uidFono'];
      dataInicioPaciente = paciente['dataInicioPaciente'];
      urlImagePaciente = paciente['urlImagePaciente'];
      nomePaciente = paciente['nomePaciente'];
      dtNascimentoPaciente = paciente['dtNascimentoPaciente'];
      CPFPaciente = paciente['CPFPaciente'];
      RGPaciente = paciente['RGPaciente'];
      idadePaciente = calcularIdadeMeses(dtNascimentoPaciente);
      generoPaciente = genderToString(paciente['generoPaciente']);
      lougradouroPaciente = paciente['lougradouroPaciente'];
      numeroPaciente = paciente['numeroPaciente'];
      bairroPaciente = paciente['bairroPaciente'];
      cidadePaciente = paciente['cidadePaciente'];
      estadoPaciente = paciente['estadoPaciente'];
      cepPaciente = paciente['cepPaciente'];
      tipoConsultaPaciente = paciente['tipoConsultaPaciente'];
      descricaoPaciente = paciente['descricaoPaciente'];
      qtdResponsavel = paciente['qtdResponsavel'];
      ListGeneroResponsavelPaciente = paciente['listGeneroResponsavel'];
      ListNomeResponsavelPaciente = paciente['listNomeResponsavel'];
      ListIdadeResponsavelPaciente = paciente['listIdadeResponsavel'];
      ListTelefoneResponsavelPaciente = paciente['listTelefoneResponsavel'];
      ListRelacaoResponsavelPaciente = paciente['listRelacaoResponsavel'];
      ListEscolaridadeResponsavelPaciente = paciente['listEscolaridadeResponsavel'];
      ListProfissaoResponsavelPaciente = paciente['listProfissaoResponsavel'];
    });
  }

  @override
  void initState() {
    super.initState();
    carregarDados();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: cores('corFundo'),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_outlined,
            color: cores('corSimbolo'),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Container(
        child: ListView(
          children: [
            Column(
              children: <Widget>[
                containerCabecalho(),
                containerPaciente(),
                Divider(
                  thickness: 2,
                  height: 1,
                  color: cores('corTexto'),
                ),
                containerDescricao(),
                Divider(
                  thickness: 2,
                  height: 1,
                  color: cores('corTexto'),
                ),
                containerResponsaveis(),
                Divider(
                  thickness: 2,
                  height: 1,
                  color: cores('corTexto'),
                ),
                containerEndereco(),
                Divider(
                  thickness: 2,
                  height: 1,
                  color: cores('corTexto'),
                ),
                containerAnexo(),
              ],
            ),
          ],
        ),
      ),
    );
  }

  containerCabecalho() {
    TamanhoFonte tamanhoFonte = TamanhoFonte();

    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: cores('corFundo'),
        borderRadius: BorderRadius.only(bottomRight: Radius.circular(32), bottomLeft: Radius.circular(32)),
      ),
      child: Column(
        children: <Widget>[
          Text(
            'Data de Início: $dataInicioPaciente',
            style: TextStyle(
                fontWeight: FontWeight.bold, color: cores('corTexto'), fontSize: tamanhoFonte.letraPequena(context)),
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Column(
                children: <Widget>[
                  Text(
                    'Idade',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: cores('corTexto'),
                        fontSize: tamanhoFonte.letraPequena(context)),
                  ),
                  Text(
                    idadePaciente,
                    style: TextStyle(color: cores('corTexto'), fontSize: tamanhoFonte.letraPequena(context)),
                  ),
                ],
              ),
              Container(
                width: 80.0,
                height: 80.0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: cores('corBotao'),
                ),
                child: CircleAvatar(
                  backgroundImage: urlImagePaciente.isNotEmpty
                      ? NetworkImage(urlImagePaciente)
                      : (generoPaciente == 'Masc.'
                          ? AssetImage('images/icons/profileBoy.png')
                          : AssetImage('images/icons/profileGirl.png') as ImageProvider),
                ),
              ),
              Column(
                children: <Widget>[
                  Text(
                    'Data Nasc.',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: cores('corTexto'),
                        fontSize: tamanhoFonte.letraPequena(context)),
                  ),
                  Text(
                    dtNascimentoPaciente,
                    style: TextStyle(color: cores('corTexto'), fontSize: tamanhoFonte.letraPequena(context)),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Center(
            child: Expanded(
              child: Text(
                nomePaciente.toString(),
                softWrap: true,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: TextStyle(
                    color: cores('corTexto'), fontSize: tamanhoFonte.letraMedia(context), fontWeight: FontWeight.bold),
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Expanded(
                child: Column(
                  children: <Widget>[
                    Text(
                      ListGeneroResponsavelPaciente.isEmpty ? '' : ListRelacaoResponsavelPaciente[index],
                      softWrap: true,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: tamanhoFonte.letraPequena(context),
                        color: cores('corTexto'),
                      ),
                    ),
                    Text(
                      ListNomeResponsavelPaciente.isEmpty ? '' : ListNomeResponsavelPaciente[index],
                      softWrap: true,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: TextStyle(color: cores('corTexto'), fontSize: tamanhoFonte.letraPequena(context)),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () async {
                    final Uri url = Uri.parse("whatsapp://send?phone=+55$ListTelefoneResponsavelPaciente[index]");
                    if (!await launchUrl(url)) throw 'Could not launch $url';
                  },
                  child: Column(
                    children: <Widget>[
                      Icon(
                        Icons.phone,
                        color: cores('corSimbolo'),
                        size: tamanhoFonte.outroTamanho(context, 0.07),
                      ),
                      Text(
                        ListTelefoneResponsavelPaciente.isEmpty ? '' : ListTelefoneResponsavelPaciente[index],
                        softWrap: true,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: TextStyle(color: cores('corTexto'), fontSize: tamanhoFonte.letraPequena(context)),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  containerPaciente() {
    TamanhoFonte tamanhoFonte = TamanhoFonte();

    return Container(
        padding: EdgeInsets.all(20),
        //height: tamanhoWidgets.getHeight(context),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          //mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Center(
              child: Text(
                'Dados Paciente:',
                style: TextStyle(
                    fontWeight: FontWeight.bold, color: cores('corTexto'), fontSize: tamanhoFonte.letraMedia(context)),
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Row(
              //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Text(
                  'Gênero: ',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: cores('corTexto'),
                      fontSize: tamanhoFonte.letraPequena(context)),
                ),
                Text(
                  generoPaciente,
                  style: TextStyle(color: cores('corTexto'), fontSize: tamanhoFonte.letraPequena(context)),
                ),
              ],
            ),
            SizedBox(
              height: 5,
            ),
            Row(
              //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Text(
                  'Escolaridade: ',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: cores('corTexto'),
                      fontSize: tamanhoFonte.letraPequena(context)),
                ),
                Text(
                  generoPaciente,
                  style: TextStyle(color: cores('corTexto'), fontSize: tamanhoFonte.letraPequena(context)),
                ),
              ],
            ),
            SizedBox(
              height: 5,
            ),
            Row(
              //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Text(
                  'Tipo da Consulta: ',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: cores('corTexto'),
                      fontSize: tamanhoFonte.letraPequena(context)),
                ),
                Text(
                  tipoConsultaPaciente,
                  style: TextStyle(color: cores('corTexto'), fontSize: tamanhoFonte.letraPequena(context)),
                ),
              ],
            ),
          ],
        ));
  }

  containerDescricao() {
    TamanhoFonte tamanhoFonte = TamanhoFonte();

    return Container(
        padding: EdgeInsets.all(20),
        //height: tamanhoWidgets.getHeight(context),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          //mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Center(
              child: Text(
                'Descrição/Queixa:',
                style: TextStyle(
                    fontWeight: FontWeight.bold, color: cores('corTexto'), fontSize: tamanhoFonte.letraMedia(context)),
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Text(
              descricaoPaciente,
              style: TextStyle(color: cores('corTexto'), fontSize: tamanhoFonte.letraPequena(context)),
            ),
          ],
        ));
  }

  containerResponsaveis() {
    TamanhoFonte tamanhoFonte = TamanhoFonte();

    return Container(
        padding: EdgeInsets.all(20),
        //height: tamanhoWidgets.getHeight(context),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          //mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Center(
              child: Text(
                'Dados Responsáveis:',
                style: TextStyle(
                    fontWeight: FontWeight.bold, color: cores('corTexto'), fontSize: tamanhoFonte.letraMedia(context)),
              ),
            ),
            SizedBox(
              height: 5,
            ),
            ...gerarResponsaveis(),
          ],
        ));
  }

  List<Widget> gerarResponsaveis() {
    TamanhoFonte tamanhoFonte = TamanhoFonte();
    List<Widget> responsaveisWidgets = [];

    for (int index = 0; index < qtdResponsavel; index++) {
      responsaveisWidgets.add(
        Column(
          children: [
            Row(
              //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Text(
                  'Nome Responsável ${index + 1}: ',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: cores('corTexto'),
                      fontSize: tamanhoFonte.letraPequena(context)),
                ),
                Expanded(
                  child: Text(
                    ListNomeResponsavelPaciente.isEmpty ? '' : ListNomeResponsavelPaciente[index],
                    softWrap: true,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: TextStyle(color: cores('corTexto'), fontSize: tamanhoFonte.letraPequena(context)),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 5,
            ),
            Row(
              //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Text(
                  'Gênero: ',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: cores('corTexto'),
                      fontSize: tamanhoFonte.letraPequena(context)),
                ),
                Text(
                  ListGeneroResponsavelPaciente.isEmpty ? '' : genderToString(ListGeneroResponsavelPaciente[index]!),
                  softWrap: true,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: TextStyle(color: cores('corTexto'), fontSize: tamanhoFonte.letraPequena(context)),
                ),
              ],
            ),
            SizedBox(
              height: 5,
            ),
            Row(
              //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Text(
                  'Idade: ',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: cores('corTexto'),
                      fontSize: tamanhoFonte.letraPequena(context)),
                ),
                Text(
                  ListIdadeResponsavelPaciente.isEmpty ? '' : ListIdadeResponsavelPaciente[index],
                  softWrap: true,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: TextStyle(color: cores('corTexto'), fontSize: tamanhoFonte.letraPequena(context)),
                ),
              ],
            ),
            SizedBox(
              height: 5,
            ),
            Row(
              //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Text(
                  'Telefone: ',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: cores('corTexto'),
                      fontSize: tamanhoFonte.letraPequena(context)),
                ),
                Expanded(
                  child: Text(
                    ListTelefoneResponsavelPaciente.isEmpty ? '' : ListTelefoneResponsavelPaciente[index],
                    softWrap: true,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: TextStyle(color: cores('corTexto'), fontSize: tamanhoFonte.letraPequena(context)),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 5,
            ),
            Row(
              //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Text(
                  'Escolaridade: ',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: cores('corTexto'),
                      fontSize: tamanhoFonte.letraPequena(context)),
                ),
                Expanded(
                  child: Text(
                    ListEscolaridadeResponsavelPaciente.isEmpty ? '' : ListEscolaridadeResponsavelPaciente[index],
                    softWrap: true,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: TextStyle(color: cores('corTexto'), fontSize: tamanhoFonte.letraPequena(context)),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 5,
            ),
            Row(
              //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Text(
                  'Profissão: ',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: cores('corTexto'),
                      fontSize: tamanhoFonte.letraPequena(context)),
                ),
                Expanded(
                  child: Text(
                    ListProfissaoResponsavelPaciente.isEmpty ? '' : ListProfissaoResponsavelPaciente[index],
                    softWrap: true,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: TextStyle(color: cores('corTexto'), fontSize: tamanhoFonte.letraPequena(context)),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
          ],
        ),
      );
    }

    return responsaveisWidgets;
  }

  containerEndereco() {
    TamanhoFonte tamanhoFonte = TamanhoFonte();

    return Container(
        padding: EdgeInsets.all(20),
        //height: tamanhoWidgets.getHeight(context),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          //mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Center(
              child: Text(
                'Endereço: ',
                style: TextStyle(
                    fontWeight: FontWeight.bold, color: cores('corTexto'), fontSize: tamanhoFonte.letraMedia(context)),
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Text(
              "$lougradouroPaciente, $numeroPaciente - $bairroPaciente, $cidadePaciente - $estadoPaciente, $cepPaciente",
              style: TextStyle(color: cores('corTexto'), fontSize: tamanhoFonte.letraPequena(context)),
            ),
          ],
        ));
  }

  containerAnexo() {
    TamanhoFonte tamanhoFonte = TamanhoFonte();

    return Container(
        padding: EdgeInsets.all(20),
        //height: tamanhoWidgets.getHeight(context),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          //mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Center(
              child: Text(
                'Anexo:',
                style: TextStyle(
                    fontWeight: FontWeight.bold, color: cores('corTexto'), fontSize: tamanhoFonte.letraMedia(context)),
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Text(
              descricaoPaciente,
              style: TextStyle(color: cores('corTexto'), fontSize: tamanhoFonte.letraPequena(context)),
            ),
          ],
        ));
  }
}
