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
        trailing: IconButton(
          icon: Icon(
            Icons.edit,
            color: cores('corSimbolo'),
          ),
          onPressed: () {
            print('Botão pressionado!');
          },
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
