import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../connections/fireCloudBlocoNotas.dart';
import '../controllers/variaveis.dart';
import '../controllers/estilos.dart';
import '../models/maps.dart';

class TelaBlocoDeNotas extends StatefulWidget {
  const TelaBlocoDeNotas({super.key});

  @override
  State<TelaBlocoDeNotas> createState() => _TelaBlocoDeNotasState();
}

class _TelaBlocoDeNotasState extends State<TelaBlocoDeNotas> {
  carregarDados() async {
    var notas = await recuperarBlocosNotas();
    setState(() {
      AppVariaveis().blocoNotas = notas;
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
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          child: StreamBuilder<QuerySnapshot>(
              stream: AppVariaveis().blocoNotas != null
                  ? AppVariaveis().blocoNotas.orderBy('dataBloco').snapshots()
                  : null,
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.none:
                    return const Center(
                      child: Text('Não foi possível conectar'),
                    );
                  case ConnectionState.waiting:
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  default:
                    final dados = snapshot.requireData;
                    return ListView.separated(
                        padding: EdgeInsets.all(10),
                        scrollDirection: Axis.vertical,
                        itemBuilder: (context, index) => cardNotas(context, dados.docs[index]),
                        separatorBuilder: (context, _) => SizedBox(
                              height: 1,
                            ),
                        itemCount: dados.size);
                }
              }),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        shape: CircleBorder(),
        onPressed: () {
          Navigator.pushNamed(context, '/adicionarBlocoNotas', arguments: {'tipo': 'adicionar'});
        },
        child: Icon(
          Icons.add,
          color: cores('corTextoBotao'),
          size: 35,
        ),
        backgroundColor: cores('corBotao'),
      ),
    );
  }
}

Widget cardNotas(context, doc) {
  return Container(
    padding: EdgeInsets.all(5),
    child: Card(
      color: Colors.red.shade50,
      elevation: 7,
      shadowColor: cores('corSombra'),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      margin: EdgeInsets.all(5),
      child: ListTile(
        minLeadingWidth: 5,
        title: Text(doc.data()['nomeBloco'],
            style: TextStyle(color: cores('corTexto'), fontSize: 16, fontWeight: FontWeight.bold)),
        subtitle: Text(doc.data()['dataBloco'], style: TextStyle(color: cores('corTexto'), fontSize: 16)),
        trailing: IconButton(
          icon: Icon(
            Icons.edit,
            color: cores('corSimbolo'),
          ),
          onPressed: () async {
            Navigator.pushNamed(context, '/adicionarBlocoNotas', arguments: {'tipo': 'editar'});
          },
        ),
        onTap: () async {
          String telProfLimp = limparTelefone(doc.data()['telefoneBloco']);
          final Uri url = Uri.parse("https://wa.me/+55$telProfLimp");
          if (!await launchUrl(url)) throw 'Could not launch $url';
        },
      ),
    ),
  );
}
