import 'package:flutter/material.dart';
import '../controllers/estilos.dart';

Widget listarPaciente(doc) {
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
        /*leading: CircleAvatar(
            backgroundImage: NetworkImage(
              doc.data()['urlImagePaciente'],
            ),
          ),*/
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
        onTap: () {
          /* Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TelaEspecificoPaciente(doc.data()['uidPaciente']),
                ));*/
        },
      ),
    ),
  );
}