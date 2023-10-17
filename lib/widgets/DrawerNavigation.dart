import 'package:flutter/material.dart';
import 'package:fono/view/TelaAgenda.dart';
import 'package:fono/view/TelaContas.dart';
import 'package:fono/view/TelaEditarPerfil.dart';
import 'package:fono/view/TelaPacientes.dart';

import '../view/connections/fireAuth.dart';
import '../view/controllers/coresPrincipais.dart';

class DrawerNavigation extends StatefulWidget {
  final String uidFono;
  final String urlImage;
  final String genero;
  final String nomeUsuario;

  const DrawerNavigation(this.uidFono, this.urlImage, this.genero, this.nomeUsuario, {super.key});

  @override
  State<DrawerNavigation> createState() => _DrawerNavigationState();
}

class _DrawerNavigationState extends State<DrawerNavigation> {
  double tamanhoLetra = 18;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: cores('rosa_fraco'),
      shadowColor: cores('verde'),
      child: ListView(
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: cores('rosa_fraco'),
            ),
            child: menuHeader(),
          ),
          menuItens(),
        ],
      ),
    );
  }

  menuHeader() {
    return Container(
      color: cores('rosa_fraco'),
      padding: EdgeInsets.symmetric(vertical: 45),
      child: Row(
        children: [
          widget.urlImage.isEmpty
              ? Icon(
            Icons.person,
            color: cores('rosa_medio'),
          )
              : CircleAvatar(
            radius: 30,
            backgroundImage: NetworkImage(
              widget.urlImage,
            ),
          ),
          SizedBox(
            width: 20,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  widget.nomeUsuario.toString(),
                  style: TextStyle(color: cores('verde'), fontWeight: FontWeight.bold, fontSize: tamanhoLetra),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                widget.genero == 'Gender.male' ? 'Fonoaudiólogo' : 'Fonoaudióloga',
                style: TextStyle(
                  color: cores('verde'),
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  menuItens() {
    return Container(
      padding: EdgeInsets.all(10),
      child: Wrap(
        runSpacing: 10,
        children: [
          Divider(
            color: cores('verde'),
            height: 10,
          ),
          ListTile(
            leading: Icon(
              Icons.person,
              color: cores('verde'),
            ),
            title: Text(
              'Pacientes',
              style: TextStyle(color: cores('verde'), fontWeight: FontWeight.bold, fontSize: tamanhoLetra),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => TelaPacientes()),
              );
            },
          ),
          ListTile(
            leading: Icon(
              Icons.calendar_month,
              color: cores('verde'),
            ),
            title: Text(
              'Agenda',
              style: TextStyle(color: cores('verde'), fontWeight: FontWeight.bold, fontSize: tamanhoLetra),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => TelaAgenda(widget.uidFono)),
              );
            },
          ),
          ListTile(
            leading: Icon(
              Icons.assignment,
              color: cores('verde'),
            ),
            title: Text(
              'Relatório',
              style: TextStyle(color: cores('verde'), fontWeight: FontWeight.bold, fontSize: tamanhoLetra),
            ),
            onTap: () {
              //Navigator.push(context, MaterialPageRoute(builder: (context) => TelaPacientes()),);
            },
          ),
          ListTile(
            leading: Icon(
              Icons.analytics_outlined,
              color: cores('verde'),
            ),
            title: Text(
              'Dados',
              style: TextStyle(color: cores('verde'), fontWeight: FontWeight.bold, fontSize: tamanhoLetra),
            ),
            onTap: () {
              //Navigator.push(context, MaterialPageRoute(builder: (context) => TelaPacientes()),);
            },
          ),
          ListTile(
            leading: Icon(
              Icons.payments,
              color: cores('verde'),
            ),
            title: Text(
              'Contas',
              style: TextStyle(
                color: cores('verde'),
                fontWeight: FontWeight.bold,
                fontSize: tamanhoLetra,
              ),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => TelaContas()),
              );
            },
          ),
          Divider(
            color: cores('verde'),
            height: 10,
          ),
          ListTile(
            leading: Icon(
              Icons.edit,
              color: cores('verde'),
            ),
            title: Text(
              'Editar Perfil',
              style: TextStyle(color: cores('verde'), fontWeight: FontWeight.bold, fontSize: tamanhoLetra),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => TelaEditarPerfil()),
              );
            },
          ),
          ListTile(
            leading: Icon(
              Icons.logout,
              color: cores('verde'),
            ),
            title: Text(
              'Sair',
              style: TextStyle(color: cores('verde'), fontWeight: FontWeight.bold, fontSize: tamanhoLetra),
            ),
            onTap: () {
              signOut(context);
            },
          ),
        ],
      ),
    );
  }
}
