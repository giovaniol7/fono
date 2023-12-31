import 'package:flutter/material.dart';
import 'package:fonocare/view/TelaAgenda.dart';
import 'package:fonocare/view/TelaBlocoDeNotas.dart';
import 'package:fonocare/view/TelaContas.dart';
import 'package:fonocare/view/TelaEditarPerfil.dart';
import 'package:fonocare/view/TelaPacientes.dart';
import 'package:fonocare/view/TelaProntuarios.dart';

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
  String corTexto = 'corTexto';
  String corSimbolo = 'corSimbolo';
  String corLinha = 'verde';

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: cores('corFundo'),
      shadowColor: cores('corDetalhe'),
      surfaceTintColor: cores('corDetalhe'),
      child: ListView(
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: cores('corFundo'),
            ),
            child: menuHeader(),
          ),
          menuItens(),
        ],
      ),
    );
  }

  menuHeader() {
    TamanhoFonte tamanhoFonte = TamanhoFonte();
    double tamanhoLetra = tamanhoFonte.letraPequena(context);

    return Container(
      alignment: Alignment.center,
      color: cores('corFundo'),
      padding: EdgeInsets.symmetric(vertical: 20),
      child: Row(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundImage: widget.urlImage.isNotEmpty
                ? NetworkImage(widget.urlImage)
                : (widget.genero == 'Gender.male'
                    ? AssetImage('images/icons/profileBoy.png')
                    : AssetImage('images/icons/profileGirl.png') as ImageProvider),
          ),
          SizedBox(
            width: 20,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                  widget.nomeUsuario.toString(),
                  style: TextStyle(color: cores(corTexto), fontWeight: FontWeight.bold, fontSize: tamanhoLetra),
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
          ),
        ],
      ),
    );
  }

  menuItens() {
    TamanhoFonte tamanhoFonte = TamanhoFonte();
    double tamanhoLetra = tamanhoFonte.letraPequena(context);

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
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TelaPacientes(),
                  ));
              //Navigator.pushNamed(context, '/pacientes');
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
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TelaAgenda(),
                  ));
              //Navigator.pushNamed(context, '/agenda');
            },
          ),
          ListTile(
            leading: Icon(
              Icons.assignment,
              color: cores(corSimbolo),
            ),
            title: Text(
              'Prontuários',
              style: TextStyle(color: cores(corTexto), fontWeight: FontWeight.bold, fontSize: tamanhoLetra),
            ),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TelaProntuarios(),
                  ));
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
              Icons.note_alt_sharp,
              color: cores(corSimbolo),
            ),
            title: Text(
              'Bloco de Notas',
              style: TextStyle(color: cores(corTexto), fontWeight: FontWeight.bold, fontSize: tamanhoLetra),
            ),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TelaBlocoDeNotas(),
                  ));
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
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TelaContas(),
                  ));
              //Navigator.pushNamed(context, '/contas');
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
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TelaEditarPerfil(),
                  ));
              //Navigator.pushNamed(context, '/editarPerfil');
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
