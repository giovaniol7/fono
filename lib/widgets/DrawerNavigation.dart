import 'package:flutter/material.dart';

import '../connections/fireAuth.dart';
import '../controllers/estilos.dart';

class DrawerNavigation extends StatefulWidget {
  final String urlImage;
  final String genero;
  final String nomeUsuario;

  const DrawerNavigation(this.urlImage, this.genero, this.nomeUsuario, {super.key});

  @override
  State<DrawerNavigation> createState() => _DrawerNavigationState();
}

class _DrawerNavigationState extends State<DrawerNavigation> {
  double tamanhoLetra = 18;

  String corTexto = 'corTexto';
  String corSimbolo = 'corSimbolo';
  String corLinha = 'verde';

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: cores('corTerciaria'),
      shadowColor: cores('corDetalhe'),
      surfaceTintColor: cores('corDetalhe'),
      child: ListView(
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: cores('corTerciaria'),
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
      alignment: Alignment.center,
      color: cores('corTerciaria'),
      padding: EdgeInsets.symmetric(vertical: 35),
      child: Row(
        children: [
          widget.urlImage.isEmpty
              ? Icon(
                  Icons.person,
                  color: cores('corSecundaria'),
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
                  style: TextStyle(color: cores(corTexto), fontWeight: FontWeight.bold, fontSize: tamanhoLetra),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                widget.genero == 'Gender.male' ? 'Fonoaudiólogo' : 'Fonoaudióloga',
                style: TextStyle(
                  color: cores(corTexto),
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
            color: cores(corLinha),
            height: 10,
          ),
          ListTile(
            leading: Icon(
              Icons.person,
              color: cores(corSimbolo),
            ),
            title: Text(
              'Pacientes',
              style: TextStyle(color: cores(corTexto), fontWeight: FontWeight.bold, fontSize: tamanhoLetra),
            ),
            onTap: () {
              Navigator.pushNamed(context, '/pacientes');
            },
          ),
          ListTile(
            leading: Icon(
              Icons.calendar_month,
              color: cores(corSimbolo),
            ),
            title: Text(
              'Agenda',
              style: TextStyle(color: cores(corTexto), fontWeight: FontWeight.bold, fontSize: tamanhoLetra),
            ),
            onTap: () {
              Navigator.pushNamed(context, '/agenda');
            },
          ),
          ListTile(
            leading: Icon(
              Icons.assignment,
              color: cores(corSimbolo),
            ),
            title: Text(
              'Relatório',
              style: TextStyle(color: cores(corTexto), fontWeight: FontWeight.bold, fontSize: tamanhoLetra),
            ),
            onTap: () {
              /*Navigator.pushNamed(
                  context,
                  '/pacientes'
              );  */
            },
          ),
          ListTile(
            leading: Icon(
              Icons.analytics_outlined,
              color: cores(corSimbolo),
            ),
            title: Text(
              'Dados',
              style: TextStyle(color: cores(corTexto), fontWeight: FontWeight.bold, fontSize: tamanhoLetra),
            ),
            onTap: () {
              /*Navigator.pushNamed(context, '/pacientes');*/
            },
          ),
          ListTile(
            leading: Icon(
              Icons.payments,
              color: cores(corSimbolo),
            ),
            title: Text(
              'Contas',
              style: TextStyle(
                color: cores(corTexto),
                fontWeight: FontWeight.bold,
                fontSize: tamanhoLetra,
              ),
            ),
            onTap: () {
              Navigator.pushNamed(context, '/contas');
            },
          ),
          Divider(
            color: cores(corLinha),
            height: 10,
          ),
          ListTile(
            leading: Icon(
              Icons.edit,
              color: cores(corSimbolo),
            ),
            title: Text(
              'Editar Perfil',
              style: TextStyle(color: cores(corTexto), fontWeight: FontWeight.bold, fontSize: tamanhoLetra),
            ),
            onTap: () {
              Navigator.pushNamed(context, '/editarPerfil');
            },
          ),
          ListTile(
            leading: Icon(
              Icons.logout,
              color: cores(corSimbolo),
            ),
            title: Text(
              'Sair',
              style: TextStyle(color: cores(corTexto), fontWeight: FontWeight.bold, fontSize: tamanhoLetra),
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
