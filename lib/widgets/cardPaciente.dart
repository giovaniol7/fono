import 'package:flutter/material.dart';
import 'package:fonocare/view/TelaAdicionarPaciente.dart';
import 'package:fonocare/view/TelaDadosPacientes.dart';
import '../controllers/estilos.dart';
import '../view/TelaProntuariosPaciente.dart';

Widget listarPaciente(context, doc, tipoTela) {
  return Container(
    child: Card(
      color: Colors.red.shade50,
      elevation: 7,
      shadowColor: cores('corSombra'),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      margin: EdgeInsets.all(5),
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: doc.data()['urlImagePaciente'].toString().isNotEmpty
              ? NetworkImage(doc.data()['urlImagePaciente'])
              : (doc.data()['generoPaciente'] == 'Gender.male'
              ? AssetImage('images/icons/profileBoy.png')
              : AssetImage('images/icons/profileGirl.png') as ImageProvider),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              doc.data()['nomePaciente'],
              style: TextStyle(color: cores('corTexto'), fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Text(
              doc.data()['tipoConsultaPaciente'],
              style: TextStyle(color: cores('corTexto'), fontSize: 16, fontWeight: FontWeight.normal),
            ),
          ],
        ),
        trailing: tipoTela == 'pacientes' ? IconButton(
          icon: Icon(
            Icons.edit,
            color: cores('corSimbolo'),
          ),
          onPressed: () {
            String tipo = 'editar';
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TelaAdicionarPaciente(tipo, doc.data()['uidPaciente']),
                ));
          },
        ) : null,
        onTap: () {
          tipoTela == 'pacientes' ? Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TelaDadosPacientes(doc.data()['uidPaciente']),
                )) : Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => TelaProntuariosPaciente(doc.data()['uidPaciente']),
              ));
        },
      ),
    ),
  );
}
