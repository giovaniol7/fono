import 'package:flutter/material.dart';

helpDialog(context) {
  return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Ajuda'),
          content: Text(
              'Na tela inicial temos a agenda do dia e dos próximos horários.\n'
              'Ao clicar no horário da agenda irá direcionar para adicionar Prontuário. \n'
              'E abaixo resumo financeiro.',
              style: TextStyle(fontSize: 16)),
          actions: <Widget>[
            TextButton(
              child: Text(
                'Cancelar',
                style: TextStyle(color: Colors.blue, fontSize: 16),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: Icon(Icons.navigate_before)),
            IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: Icon(Icons.navigate_next)),
          ],
        );
      });
}
