import '/connections/fireAuth.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

Future<Map<String, double>> calcularFinanceiro() async {
  double totalGanhos = 0;
  double totalDespesas = 0;
  Map<String, double> financias = {};

  QuerySnapshot usersSnapshot = await FirebaseFirestore.instance
      .collection('contas')
      .where('uidFono', isEqualTo: idFonoAuth())
      .where('tipoTransacao', isEqualTo: 'Recebido')
      .where('estadoPago', isEqualTo: true)
      .get();

  if (usersSnapshot.docs.isNotEmpty) {
    usersSnapshot.docs.forEach((doc) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      String precoST = data['preco'];
      precoST = precoST.replaceAll('.', '');
      precoST = precoST.replaceAll(',', '.');
      double precoCompra = double.parse(precoST);
      totalGanhos += precoCompra;
    });
  }

  QuerySnapshot recebidosSnapshot = await FirebaseFirestore.instance
      .collection('contas')
      .where('uidFono', isEqualTo: idFonoAuth())
      .where('tipoTransacao', isEqualTo: 'Gasto')
      .where('estadoPago', isEqualTo: true)
      .get();

  if (recebidosSnapshot.docs.isNotEmpty) {
    recebidosSnapshot.docs.forEach((doc) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      String precoST = data['preco'];
      precoST = precoST.replaceAll('.', '');
      precoST = precoST.replaceAll(',', '.');
      double precoCompra = double.parse(precoST);
      totalDespesas += precoCompra;
    });
  }

  double somaGanhos = totalGanhos;
  double somaDespesas = totalDespesas;
  double somaRenda = somaGanhos - somaDespesas;
  financias = {
    'somaGanhos': totalGanhos,
    'somaDespesas': totalDespesas,
    'somaRenda': somaRenda,
  };

  return financias;
}

Future<double> calcularAReceber() async {
  double aReceber = 0;

  QuerySnapshot usersSnapshot = await FirebaseFirestore.instance
      .collection('contas')
      .where('uidFono', isEqualTo: idFonoAuth())
      .where('tipoTransacao', isEqualTo: 'Recebido')
      .where('estadoPago', isEqualTo: false)
      .get();

  if (usersSnapshot.docs.isNotEmpty) {
    usersSnapshot.docs.forEach((doc) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      String precoST = data['preco'];
      precoST = precoST.replaceAll('.', '');
      precoST = precoST.replaceAll(',', '.');
      double precoCompra = double.parse(precoST);
      aReceber += precoCompra;
    });
  }

  return aReceber;
}

Future<double> calcularAPagar() async {
  double aPagar = 0;

  QuerySnapshot recebidosSnapshot = await FirebaseFirestore.instance
      .collection('contas')
      .where('uidFono', isEqualTo: idFonoAuth())
      .where('tipoTransacao', isEqualTo: 'Gasto')
      .where('estadoPago', isEqualTo: false)
      .get();

  if (recebidosSnapshot.docs.isNotEmpty) {
    recebidosSnapshot.docs.forEach((doc) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      String precoST = data['preco'];
      precoST = precoST.replaceAll('.', '');
      precoST = precoST.replaceAll(',', '.');
      double precoCompra = double.parse(precoST);
      aPagar += precoCompra;
    });
  }

  return aPagar;
}
