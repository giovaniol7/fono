import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:fono/view/TelaPacientes.dart';
import 'package:fono/view/controllers/coresPrincipais.dart';
import 'package:firedart/firedart.dart' as fd;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';

class TelaEspecificoPaciente extends StatefulWidget {
  final String uidPaciente;

  const TelaEspecificoPaciente(this.uidPaciente, {super.key});

  @override
  State<TelaEspecificoPaciente> createState() => _TelaEspecificoPacienteState();
}

class _TelaEspecificoPacienteState extends State<TelaEspecificoPaciente> {
  int index = 0;
  var urlImage;
  late String uidFono = '';
  late String dataInicioPaciente = '';
  late String urlImagePaciente = '';
  late String nomePaciente = '';
  late String dtNascimentoPaciente = '';
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

  List<String> ListNomeResponsavelPaciente = [];
  List<String> ListDataNascimentoResponsavelPaciente = [];
  List<String> ListEscolaridadeResponsavelPaciente = [];
  List<String> ListProfissaoResponsavelPaciente = [];
  List<String> ListGeneroResponsavelPaciente = [];
  List<String> ListRelacaoResponsavelPaciente = [];

  String genderToString(String gender) {
    switch (gender) {
      case 'Gender.male':
        return 'Masc.';
      case 'Gender.female':
        return 'Fem.';
      default:
        return '';
    }
  }

  calculateAge(DateTime birthDate) {
    final now = DateTime.now();
    int age = now.year - birthDate.year;
    if (now.month < birthDate.month ||
        (now.month == birthDate.month && now.day < birthDate.day)) {
      age--;
    }
    setState(() {
      idadePaciente = age.toString();
    });
  }

  retornarNomeUsuario() async {
    if (kIsWeb || Platform.isAndroid || Platform.isIOS) {
      await FirebaseFirestore.instance
          .collection('pacientes')
          .where('uidPaciente', isEqualTo: widget.uidPaciente)
          .get()
          .then((q) {
        if (q.docs.isNotEmpty) {
          setState(() {
            uidFono = q.docs[0].data()['uidFono'];
            dataInicioPaciente = q.docs[0].data()['dataInicioPaciente'];
            urlImagePaciente = q.docs[0].data()['urlImagePaciente'];
            nomePaciente = q.docs[0].data()['nomePaciente'];
            dtNascimentoPaciente = q.docs[0].data()['dtNascimentoPaciente'];
            List<String> partesData = dtNascimentoPaciente.split('/');
            int dia = int.parse(partesData[0]);
            int mes = int.parse(partesData[1]);
            int ano = int.parse(partesData[2]);
            DateTime dataNascimento = DateTime(ano, mes, dia);
            calculateAge(dataNascimento);
            telefonePaciente = q.docs[0].data()['telefonePaciente'];
            generoPaciente = q.docs[0].data()['generoPaciente'];
            lougradouroPaciente = q.docs[0].data()['lougradouroPaciente'];
            numeroPaciente = q.docs[0].data()['numeroPaciente'];
            bairroPaciente = q.docs[0].data()['bairroPaciente'];
            cidadePaciente = q.docs[0].data()['cidadePaciente'];
            estadoPaciente = q.docs[0].data()['estadoPaciente'];
            cepPaciente = q.docs[0].data()['cepPaciente'];
            tipoConsultaPaciente = q.docs[0].data()['tipoConsultaPaciente'];
            descricaoPaciente = q.docs[0].data()['descricaoPaciente'];
            for (int i = 0; i < q.docs[0].data().length; i++) {
              ListGeneroResponsavelPaciente.add(
                  q.docs[0].data()['generoResponsavel$i']);
              ListNomeResponsavelPaciente.add(
                  q.docs[0].data()['nomeResponsavel$i']);
              ListDataNascimentoResponsavelPaciente.add(
                  q.docs[0].data()['dataNascimentoResponsavel$i']);
              ListRelacaoResponsavelPaciente.add(
                  q.docs[0].data()['relacaoResponsavel$i']);
              ListEscolaridadeResponsavelPaciente.add(
                  q.docs[0].data()['escolaridadeResponsavel$i']);
              ListProfissaoResponsavelPaciente.add(
                  q.docs[0].data()['profissaoResponsavel$i']);
              //index++;
            }
          });
        }
      });
    } else {
      await fd.Firestore.instance
          .collection('pacientes')
          .where('uidPaciente', isEqualTo: widget.uidPaciente)
          .get()
          .then((q) {
        if (q.isNotEmpty) {
          q.forEach((doc) {
            setState(() {
              uidFono = doc['uidFono'];
              dataInicioPaciente = doc['dataInicioPaciente'];
              urlImagePaciente = doc['urlImagePaciente'];
              nomePaciente = doc['nomePaciente'];
              dtNascimentoPaciente = doc['dtNascimentoPaciente'];
              telefonePaciente = doc['telefonePaciente'];
              generoPaciente = doc['generoPaciente'];
              lougradouroPaciente = doc['lougradouroPaciente'];
              numeroPaciente = doc['numeroPaciente'];
              bairroPaciente = doc['bairroPaciente'];
              cidadePaciente = doc['cidadePaciente'];
              estadoPaciente = doc['estadoPaciente'];
              cepPaciente = doc['cepPaciente'];
              tipoConsultaPaciente = doc['tipoConsultaPaciente'];
              descricaoPaciente = doc['descricaoPaciente'];
              for (int i = 0; i < q.length; i++) {
                ListGeneroResponsavelPaciente.add(doc['generoResponsavel$i']);
                ListNomeResponsavelPaciente.add(doc['nomeResponsavel$i']);
                ListDataNascimentoResponsavelPaciente.add(
                    doc['dataNascimentoResponsavel$i']);
                ListRelacaoResponsavelPaciente.add(doc['relacaoResponsavel$i']);
                ListEscolaridadeResponsavelPaciente.add(
                    doc['escolaridadeResponsavel$i']);
                ListProfissaoResponsavelPaciente.add(
                    doc['profissaoResponsavel$i']);
              }
            });
          });
        }
      });
    }
  }

  @override
  void initState() {
    super.initState();
    retornarNomeUsuario();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: cores('rosa_fraco'),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_outlined,
            color: cores('verde'),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.edit,
              color: cores('verde'),
            ),
            onPressed: () {},
          )
        ],
      ),
      body: Container(
        child: ListView(
          children: [
            Column(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(top: 16),
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * 0.35,
                  decoration: BoxDecoration(
                    color: cores('rosa_fraco'),
                    borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(32),
                        bottomLeft: Radius.circular(32)),
                  ),
                  child: Column(
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: Column(
                              children: <Widget>[
                                Text(
                                  'Gênero',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: cores('verde'),
                                  ),
                                ),
                                Text(
                                  genderToString(generoPaciente),
                                  style: TextStyle(
                                    color: cores('verde'),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width * 0.30,
                            height: MediaQuery.of(context).size.height * 0.13,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: cores('verde'),
                            ),
                            child: urlImage == null
                                ? Icon(
                                    Icons.person,
                                    color: cores('rosa_medio'),
                                    size: MediaQuery.of(context).size.height *
                                        0.07,
                                  )
                                : CircleAvatar(
                                    backgroundImage: NetworkImage(
                                      urlImage!,
                                      scale:
                                          MediaQuery.of(context).size.height *
                                              0.06,
                                    ),
                                  ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 10),
                            child: Column(
                              children: <Widget>[
                                Text(
                                  'Idade',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: cores('verde'),
                                  ),
                                ),
                                Text(
                                  idadePaciente,
                                  style: TextStyle(
                                    color: cores('verde'),
                                  ),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.only(
                              top: 16, bottom: 32, left: 10),
                          child: Text(
                            nomePaciente.toString(),
                            style: TextStyle(
                                color: cores('verde'),
                                fontSize:
                                    MediaQuery.of(context).size.width * 0.05,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 16, right: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Expanded(
                              child: Column(
                                children: <Widget>[
                                  Text(
                                    ListRelacaoResponsavelPaciente[index]
                                        .toString(),
                                    softWrap: true,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      color: cores('verde'),
                                    ),
                                  ),
                                  Text(
                                    ListNomeResponsavelPaciente[index]
                                        .toString(),
                                    softWrap: true,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    style: TextStyle(
                                      color: cores('verde'),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Column(
                                children: <Widget>[
                                  Text(
                                    'Consulta',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      color: cores('verde'),
                                    ),
                                  ),
                                  Text(
                                    tipoConsultaPaciente,
                                    style: TextStyle(
                                      color: cores('verde'),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            GestureDetector(
                              onTap: () async {
                                final Uri url = Uri.parse(
                                    "whatsapp://send?phone=$telefonePaciente");
                                if (!await launchUrl(url))
                                  throw 'Could not launch $url';
                              },
                              child: Column(
                                children: <Widget>[
                                  Icon(
                                    Icons.phone,
                                    color: cores('verde'),
                                  ),
                                  Text(
                                    telefonePaciente,
                                    style: TextStyle(
                                      color: cores('verde'),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Column(
                                children: <Widget>[
                                  Icon(
                                    Icons.favorite,
                                    color: cores('verde'),
                                  ),
                                  Text(
                                    'Likes',
                                    style: TextStyle(
                                      color: cores('verde'),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(left: 10, right: 10),
                  height: MediaQuery.of(context).size.height * 0.5,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.30,
                            height: MediaQuery.of(context).size.height * 0.10,
                            child: ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStatePropertyAll<Color>(
                                        cores('verde/azul')),
                                elevation: MaterialStateProperty.all<double>(5),
                                shadowColor: MaterialStatePropertyAll<Color>(
                                    cores('rosa_fraco')),
                              ),
                              onPressed: () {},
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.edit,
                                    color: cores('verde'),
                                  ),
                                  SizedBox(height: 5),
                                  Text(
                                    'Editar Perfil',
                                    style: TextStyle(
                                      color: cores('verde'),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.30,
                            height: MediaQuery.of(context).size.height * 0.10,
                            child: ElevatedButton(
                                style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStatePropertyAll<Color>(
                                          cores('verde/azul')),
                                  elevation:
                                      MaterialStateProperty.all<double>(5),
                                  shadowColor: MaterialStatePropertyAll<Color>(
                                      cores('rosa_fraco')),
                                ),
                                onPressed: () {},
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.person,
                                      color: cores('verde'),
                                    ),
                                    Text(
                                      'Pacientes',
                                      style: TextStyle(
                                          color: cores('verde'),
                                          fontWeight: FontWeight.bold),
                                    )
                                  ],
                                )),
                          ),
                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.30,
                            height: MediaQuery.of(context).size.height * 0.10,
                            child: ElevatedButton(
                                style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStatePropertyAll<Color>(
                                          cores('verde/azul')),
                                  elevation:
                                      MaterialStateProperty.all<double>(5),
                                  shadowColor: MaterialStatePropertyAll<Color>(
                                      cores('rosa_fraco')),
                                ),
                                onPressed: () {},
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.calendar_month,
                                      color: cores('verde'),
                                    ),
                                    Text(
                                      'Agenda',
                                      style: TextStyle(
                                          color: cores('verde'),
                                          fontWeight: FontWeight.bold),
                                    )
                                  ],
                                )),
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.30,
                            height: MediaQuery.of(context).size.height * 0.10,
                            child: ElevatedButton(
                                style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStatePropertyAll<Color>(
                                          cores('verde/azul')),
                                  elevation:
                                      MaterialStateProperty.all<double>(5),
                                  shadowColor: MaterialStatePropertyAll<Color>(
                                      cores('rosa_fraco')),
                                ),
                                onPressed: () {},
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.assignment,
                                      color: cores('verde'),
                                    ),
                                    Text(
                                      'Relatório',
                                      style: TextStyle(
                                          color: cores('verde'),
                                          fontWeight: FontWeight.bold),
                                    )
                                  ],
                                )),
                          ),
                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.30,
                            height: MediaQuery.of(context).size.height * 0.10,
                            child: ElevatedButton(
                                style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStatePropertyAll<Color>(
                                          cores('verde/azul')),
                                  elevation:
                                      MaterialStateProperty.all<double>(5),
                                  shadowColor: MaterialStatePropertyAll<Color>(
                                      cores('rosa_fraco')),
                                ),
                                onPressed: () {},
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.analytics_outlined,
                                      color: cores('verde'),
                                    ),
                                    Text(
                                      'Dados',
                                      style: TextStyle(
                                          color: cores('verde'),
                                          fontWeight: FontWeight.bold),
                                    )
                                  ],
                                )),
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.30,
                            height: MediaQuery.of(context).size.height * 0.10,
                            child: ElevatedButton(
                                style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStatePropertyAll<Color>(
                                          cores('verde/azul')),
                                  elevation:
                                      MaterialStateProperty.all<double>(5),
                                  shadowColor: MaterialStatePropertyAll<Color>(
                                      cores('rosa_fraco')),
                                ),
                                onPressed: () {},
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.logout,
                                      color: cores('verde'),
                                    ),
                                    Text(
                                      'Sair',
                                      style: TextStyle(
                                          color: cores('verde'),
                                          fontWeight: FontWeight.bold),
                                    )
                                  ],
                                )),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
