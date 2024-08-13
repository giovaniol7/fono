import 'package:flutter/material.dart';

import 'package:url_launcher/url_launcher.dart';

import '../connections/fireCloudPacientes.dart';
import '../controllers/calcularIdade.dart';
import '../controllers/uploadDoc.dart';
import '../controllers/estilos.dart';
import '../controllers/variaveis.dart';
import '../models/maps.dart';

class TelaDadosPacientes extends StatefulWidget {
  const TelaDadosPacientes({super.key});

  @override
  State<TelaDadosPacientes> createState() => _TelaDadosPacientesState();
}

class _TelaDadosPacientesState extends State<TelaDadosPacientes> {
  String uidPaciente = '';

  Future<void> atualizarDados() async {
    await carregarDados();
  }

  carregarDados() async {
    AppVariaveis().pacienteEdit = await recuperarPaciente(context, uidPaciente);

    setState(() {
      AppVariaveis().dataAnamnesePaciente = AppVariaveis().pacienteEdit['dataAnamnesePaciente'];
      AppVariaveis().urlImagePaciente = AppVariaveis().pacienteEdit['urlImagePaciente'];
      AppVariaveis().nomePaciente = AppVariaveis().pacienteEdit['nomePaciente'];
      AppVariaveis().dtNascimentoPaciente = AppVariaveis().pacienteEdit['dtNascimentoPaciente'];
      AppVariaveis().idadePaciente = calcularIdadeMeses(AppVariaveis().pacienteEdit['dtNascimentoPaciente']);
      AppVariaveis().CPFPaciente = AppVariaveis().pacienteEdit['CPFPaciente'];
      AppVariaveis().RGPaciente = AppVariaveis().pacienteEdit['RGPaciente'];
      AppVariaveis().generoPaciente = genderToString(AppVariaveis().pacienteEdit['generoPaciente']);
      AppVariaveis().escolaPaciente = AppVariaveis().pacienteEdit['escolaPaciente'];
      AppVariaveis().escolaridadePaciente = AppVariaveis().pacienteEdit['escolaridadePaciente'];
      AppVariaveis().periodoEscolaPaciente = AppVariaveis().pacienteEdit['periodoEscolaPaciente'];
      AppVariaveis().professoraPaciente = AppVariaveis().pacienteEdit['professoraPaciente'];
      AppVariaveis().telefoneProfessoraPaciente = AppVariaveis().pacienteEdit['telefoneProfessoraPaciente'];
      AppVariaveis().lougradouroPaciente = AppVariaveis().pacienteEdit['lougradouroPaciente'];
      AppVariaveis().numeroPaciente = AppVariaveis().pacienteEdit['numeroPaciente'];
      AppVariaveis().bairroPaciente = AppVariaveis().pacienteEdit['bairroPaciente'];
      AppVariaveis().cidadePaciente = AppVariaveis().pacienteEdit['cidadePaciente'];
      AppVariaveis().estadoPaciente = AppVariaveis().pacienteEdit['estadoPaciente'];
      AppVariaveis().cepPaciente = AppVariaveis().pacienteEdit['cepPaciente'];
      AppVariaveis().tipoConsultaPaciente = AppVariaveis().pacienteEdit['tipoConsultaPaciente'];
      AppVariaveis().descricaoPaciente = AppVariaveis().pacienteEdit['descricaoPaciente'];
      AppVariaveis().qtdResponsavelPaciente = AppVariaveis().pacienteEdit['qtdResponsavel'];
      AppVariaveis().nomeArquivo = AppVariaveis().pacienteEdit['urlDocPaciente'] == ''
          ? ''
          : urlToString(AppVariaveis().pacienteEdit['urlDocPaciente']);
      AppVariaveis().urlDocPaciente = AppVariaveis().pacienteEdit['urlDocPaciente'];
      AppVariaveis().ListaGeneroResponsavelPaciente = AppVariaveis().pacienteEdit['listGeneroResponsavel'];
      AppVariaveis().ListaNomeResponsavelPaciente = AppVariaveis().pacienteEdit['listNomeResponsavel'];
      AppVariaveis().ListaIdadeResponsavelPaciente = AppVariaveis().pacienteEdit['listIdadeResponsavel'];
      AppVariaveis().ListaTelefoneResponsavelPaciente =
          AppVariaveis().pacienteEdit['listTelefoneResponsavel'];
      AppVariaveis().ListRelacaoResponsavelPaciente = AppVariaveis().pacienteEdit['listRelacaoResponsavel'];
      AppVariaveis().ListaEscolaridadeResponsavelPaciente =
          AppVariaveis().pacienteEdit['listEscolaridadeResponsavel'];
      AppVariaveis().ListaProfissaoResponsavelPaciente =
          AppVariaveis().pacienteEdit['listProfissaoResponsavel'];
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final arguments = ModalRoute.of(context)?.settings.arguments as Map?;
    if (arguments != null && arguments['uidPaciente'] != null) {
      uidPaciente = arguments['uidPaciente'] as String;
      carregarDados();
    }
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
            AppVariaveis().resetPaciente();
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
          Center(
            child: Text(
              'Data de Anamnese: ${AppVariaveis().dataAnamnesePaciente}',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: cores('corTexto'),
                  fontSize: tamanhoFonte.letraPequena(context)),
            ),
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'Idade',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: cores('corTexto'),
                        fontSize: tamanhoFonte.letraPequena(context)),
                  ),
                  Text(
                    AppVariaveis().idadePaciente,
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
                  backgroundImage: AppVariaveis().urlImagePaciente.isNotEmpty
                      ? NetworkImage(AppVariaveis().urlImagePaciente)
                      : (AppVariaveis().generoPaciente == 'Masc.'
                          ? AssetImage('images/icons/profileBoy.png')
                          : AssetImage('images/icons/profileGirl.png') as ImageProvider),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'Data Nasc.',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: cores('corTexto'),
                        fontSize: tamanhoFonte.letraPequena(context)),
                  ),
                  Text(
                    AppVariaveis().dtNascimentoPaciente,
                    style: TextStyle(color: cores('corTexto'), fontSize: tamanhoFonte.letraPequena(context)),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 20),
          Container(
            alignment: Alignment.center,
            child: Text(
              AppVariaveis().nomePaciente.toString(),
              softWrap: true,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              style: TextStyle(
                  color: cores('corTexto'),
                  fontSize: tamanhoFonte.letraMedia(context),
                  fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(height: 20),
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Expanded(
                  child: Column(
                    children: <Widget>[
                      Text(
                        AppVariaveis().ListaGeneroResponsavelPaciente.isEmpty
                            ? ''
                            : AppVariaveis().ListRelacaoResponsavelPaciente[AppVariaveis().indexPaciente],
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
                        AppVariaveis().ListaNomeResponsavelPaciente.isEmpty
                            ? ''
                            : AppVariaveis().ListaNomeResponsavelPaciente[AppVariaveis().indexPaciente],
                        softWrap: true,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style:
                            TextStyle(color: cores('corTexto'), fontSize: tamanhoFonte.letraPequena(context)),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () async {
                      String telRespLimp = limparTelefone(
                          AppVariaveis().ListaTelefoneResponsavelPaciente[AppVariaveis().indexPaciente]);
                      final Uri url = Uri.parse("https://wa.me/+55$telRespLimp");
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
                          AppVariaveis().ListaTelefoneResponsavelPaciente.isEmpty
                              ? ''
                              : AppVariaveis().ListaTelefoneResponsavelPaciente[AppVariaveis().indexPaciente],
                          softWrap: true,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: TextStyle(
                              color: cores('corTexto'), fontSize: tamanhoFonte.letraPequena(context)),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
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
                    fontWeight: FontWeight.bold,
                    color: cores('corTexto'),
                    fontSize: tamanhoFonte.letraMedia(context)),
              ),
            ),
            SizedBox(height: 5),
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
                  AppVariaveis().generoPaciente,
                  style: TextStyle(color: cores('corTexto'), fontSize: tamanhoFonte.letraPequena(context)),
                ),
              ],
            ),
            SizedBox(height: 5),
            Row(
              //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Text(
                  'CPF: ',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: cores('corTexto'),
                      fontSize: tamanhoFonte.letraPequena(context)),
                ),
                Text(
                  AppVariaveis().CPFPaciente,
                  style: TextStyle(color: cores('corTexto'), fontSize: tamanhoFonte.letraPequena(context)),
                ),
              ],
            ),
            SizedBox(height: 5),
            Row(
              //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Text(
                  'RG: ',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: cores('corTexto'),
                      fontSize: tamanhoFonte.letraPequena(context)),
                ),
                Text(
                  AppVariaveis().RGPaciente,
                  style: TextStyle(color: cores('corTexto'), fontSize: tamanhoFonte.letraPequena(context)),
                ),
              ],
            ),
            SizedBox(height: 5),
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
                  AppVariaveis().tipoConsultaPaciente,
                  style: TextStyle(color: cores('corTexto'), fontSize: tamanhoFonte.letraPequena(context)),
                ),
              ],
            ),
            SizedBox(height: 5),
            Row(
              //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Text(
                  'Escola: ',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: cores('corTexto'),
                      fontSize: tamanhoFonte.letraPequena(context)),
                ),
                Expanded(
                  child: Text(
                    AppVariaveis().escolaPaciente,
                    style: TextStyle(color: cores('corTexto'), fontSize: tamanhoFonte.letraPequena(context)),
                  ),
                ),
              ],
            ),
            SizedBox(height: 5),
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
                  AppVariaveis().escolaridadePaciente,
                  style: TextStyle(color: cores('corTexto'), fontSize: tamanhoFonte.letraPequena(context)),
                ),
              ],
            ),
            SizedBox(height: 5),
            Row(
              //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Text(
                  'Período: ',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: cores('corTexto'),
                      fontSize: tamanhoFonte.letraPequena(context)),
                ),
                Text(
                  AppVariaveis().periodoEscolaPaciente,
                  style: TextStyle(color: cores('corTexto'), fontSize: tamanhoFonte.letraPequena(context)),
                ),
              ],
            ),
            SizedBox(height: 5),
            Row(
              //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Text(
                  'Professor(a): ',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: cores('corTexto'),
                      fontSize: tamanhoFonte.letraPequena(context)),
                ),
                Text(
                  AppVariaveis().professoraPaciente,
                  style: TextStyle(color: cores('corTexto'), fontSize: tamanhoFonte.letraPequena(context)),
                ),
              ],
            ),
            SizedBox(height: 5),
            Row(
              //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Text(
                  'Telefone Prof(a): ',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: cores('corTexto'),
                      fontSize: tamanhoFonte.letraPequena(context)),
                ),
                InkWell(
                  onTap: () async {
                    String telProfLimp = limparTelefone(AppVariaveis().telefoneProfessoraPaciente);
                    final Uri url = Uri.parse("https://wa.me/+55$telProfLimp");
                    if (!await launchUrl(url)) throw 'Could not launch $url';
                  },
                  child: Text(
                    AppVariaveis().telefoneProfessoraPaciente,
                    style: TextStyle(color: cores('corTexto'), fontSize: tamanhoFonte.letraPequena(context)),
                  ),
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
                    fontWeight: FontWeight.bold,
                    color: cores('corTexto'),
                    fontSize: tamanhoFonte.letraMedia(context)),
              ),
            ),
            SizedBox(height: 5),
            Text(
              AppVariaveis().descricaoPaciente,
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
                    fontWeight: FontWeight.bold,
                    color: cores('corTexto'),
                    fontSize: tamanhoFonte.letraMedia(context)),
              ),
            ),
            SizedBox(height: 5),
            ...gerarResponsaveis(),
          ],
        ));
  }

  List<Widget> gerarResponsaveis() {
    TamanhoFonte tamanhoFonte = TamanhoFonte();
    List<Widget> responsaveisWidgets = [];

    for (int indexResp = 0; indexResp < AppVariaveis().qtdResponsavelPaciente; indexResp++) {
      responsaveisWidgets.add(
        Column(
          children: [
            Row(
              //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Text(
                  'Grau Responsável: ',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: cores('corTexto'),
                      fontSize: tamanhoFonte.letraPequena(context)),
                ),
                Expanded(
                  child: Text(
                    AppVariaveis().ListRelacaoResponsavelPaciente.isEmpty
                        ? ''
                        : AppVariaveis().ListRelacaoResponsavelPaciente[indexResp],
                    softWrap: true,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: TextStyle(color: cores('corTexto'), fontSize: tamanhoFonte.letraPequena(context)),
                  ),
                ),
              ],
            ),
            SizedBox(height: 5),
            Row(
              //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Text(
                  'Nome Responsável ${indexResp + 1}: ',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: cores('corTexto'),
                      fontSize: tamanhoFonte.letraPequena(context)),
                ),
                Expanded(
                  child: Text(
                    AppVariaveis().ListaNomeResponsavelPaciente.isEmpty
                        ? ''
                        : AppVariaveis().ListaNomeResponsavelPaciente[indexResp],
                    softWrap: true,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: TextStyle(color: cores('corTexto'), fontSize: tamanhoFonte.letraPequena(context)),
                  ),
                ),
              ],
            ),
            SizedBox(height: 5),
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
                  AppVariaveis().ListaGeneroResponsavelPaciente.isEmpty
                      ? ''
                      : genderToString(AppVariaveis().ListaGeneroResponsavelPaciente[indexResp]!),
                  softWrap: true,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: TextStyle(color: cores('corTexto'), fontSize: tamanhoFonte.letraPequena(context)),
                ),
              ],
            ),
            SizedBox(height: 5),
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
                  AppVariaveis().ListaIdadeResponsavelPaciente.isEmpty
                      ? ''
                      : AppVariaveis().ListaIdadeResponsavelPaciente[indexResp],
                  softWrap: true,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: TextStyle(color: cores('corTexto'), fontSize: tamanhoFonte.letraPequena(context)),
                ),
              ],
            ),
            SizedBox(height: 5),
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
                    AppVariaveis().ListaTelefoneResponsavelPaciente.isEmpty
                        ? ''
                        : AppVariaveis().ListaTelefoneResponsavelPaciente[indexResp],
                    softWrap: true,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: TextStyle(color: cores('corTexto'), fontSize: tamanhoFonte.letraPequena(context)),
                  ),
                ),
              ],
            ),
            SizedBox(height: 5),
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
                    AppVariaveis().ListaEscolaridadeResponsavelPaciente.isEmpty
                        ? ''
                        : AppVariaveis().ListaEscolaridadeResponsavelPaciente[indexResp],
                    softWrap: true,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: TextStyle(color: cores('corTexto'), fontSize: tamanhoFonte.letraPequena(context)),
                  ),
                ),
              ],
            ),
            SizedBox(height: 5),
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
                    AppVariaveis().ListaProfissaoResponsavelPaciente.isEmpty
                        ? ''
                        : AppVariaveis().ListaProfissaoResponsavelPaciente[indexResp],
                    softWrap: true,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: TextStyle(color: cores('corTexto'), fontSize: tamanhoFonte.letraPequena(context)),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
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
                    fontWeight: FontWeight.bold,
                    color: cores('corTexto'),
                    fontSize: tamanhoFonte.letraMedia(context)),
              ),
            ),
            SizedBox(height: 5),
            Text(
              "${AppVariaveis().lougradouroPaciente}, ${AppVariaveis().numeroPaciente} - ${AppVariaveis().bairroPaciente}, ${AppVariaveis().cidadePaciente} - ${AppVariaveis().estadoPaciente}, ${AppVariaveis().cepPaciente}",
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
                    fontWeight: FontWeight.bold,
                    color: cores('corTexto'),
                    fontSize: tamanhoFonte.letraMedia(context)),
              ),
            ),
            SizedBox(height: 5),
            Center(
              child: ElevatedButton(
                style: ButtonStyle(
                  shadowColor: WidgetStateProperty.all<Color?>(cores('corSombra')),
                  backgroundColor: WidgetStateProperty.all<Color?>(cores('corDetalhe')),
                ),
                onPressed: () async {
                  if (AppVariaveis().nomeArquivo.isNotEmpty) {
                    //await downloadDoc(context, AppVariaveis().nomeArquivo);
                    await launchUrl(Uri.parse(AppVariaveis().urlDocPaciente));
                  }
                },
                child: Text(
                  AppVariaveis().nomeArquivo.isEmpty ? 'Anexar Documento' : AppVariaveis().nomeArquivo,
                  style: TextStyle(color: cores('corTexto'), fontSize: tamanhoFonte.letraPequena(context)),
                ),
              ),
            ),
          ],
        ));
  }
}
