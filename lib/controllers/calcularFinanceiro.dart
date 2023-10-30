
import '/connections/fireAuth.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

Future<Map<String, double>> calcularFinanceiro() async {
  double totalGanhos = 0;
  double totalDespesas = 0;
  Map<String, double> financias = {};

  //try {
    //if (kIsWeb || Platform.isAndroid || Platform.isIOS) {
      QuerySnapshot usersSnapshot = await FirebaseFirestore.instance
          .collection('contas')
          .where('uidFono', isEqualTo: idUsuario())
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
          .where('uidFono', isEqualTo: idUsuario())
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

    /*} else {
      //await fd.FirebaseAuth.initialize('AIzaSyAlG2glNY3njAvAyJ7eEMeMtLg4Wcfg8rI', fd.VolatileStore());
      //await fd.Firestore.initialize('programafono-7be09');
      var auth = fd.FirebaseAuth.instance;
      final emailSave = await SharedPreferences.getInstance();
      var email = emailSave.getString('email');
      final senhaSave = await SharedPreferences.getInstance();
      var senha = senhaSave.getString('senha');
      await auth.signIn(email!, senha!);
      var user = await auth.getUser();
      String windowsIdFono = user.id;

      var usersSnapshot = await fd.Firestore.instance
          .collection('contas')
          .where('uidFono', isEqualTo: windowsIdFono)
          .where('tipoTransacao', isEqualTo: 'Recebido')
          .where('estadoPago', isEqualTo: true)
          .get();

      if (usersSnapshot.isNotEmpty) {
        usersSnapshot.forEach((doc) {
          Map<String, dynamic> data = doc as Map<String, dynamic>;
          String precoST = data['preco'];
          precoST = precoST.replaceAll('.', '');
          precoST = precoST.replaceAll(',', '.');
          double precoCompra = double.parse(precoST);
          totalGanhos += precoCompra;
        });
      }

      var recebidosSnapshot = await fd.Firestore.instance
          .collection('contas')
          .where('uidFono', isEqualTo: windowsIdFono)
          .where('tipoTransacao', isEqualTo: 'Gasto')
          .where('estadoPago', isEqualTo: false)
          .get();

      if (recebidosSnapshot.isNotEmpty) {
        recebidosSnapshot.forEach((doc) {
          Map<String, dynamic> data = doc as Map<String, dynamic>;
          String precoST = data['preco'];
          precoST = precoST.replaceAll('.', '');
          precoST = precoST.replaceAll(',', '.');
          double precoCompra = double.parse(precoST);
          totalDespesas += precoCompra;
        });
      }
    }
  } catch (e) {
    print('Erro ao calcular somas: $e');
  }*/
  return financias;
}

Future<double> calcularAReceber() async {
  double aReceber = 0;

  //try {
    //if (kIsWeb || Platform.isAndroid || Platform.isIOS) {
      QuerySnapshot usersSnapshot = await FirebaseFirestore.instance
          .collection('contas')
          .where('uidFono', isEqualTo: idUsuario())
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
    /*} else {
      //await fd.FirebaseAuth.initialize('AIzaSyAlG2glNY3njAvAyJ7eEMeMtLg4Wcfg8rI', fd.VolatileStore());
      //await fd.Firestore.initialize('programafono-7be09');
      var auth = fd.FirebaseAuth.instance;
      final emailSave = await SharedPreferences.getInstance();
      var email = emailSave.getString('email');
      final senhaSave = await SharedPreferences.getInstance();
      var senha = senhaSave.getString('senha');
      await auth.signIn(email!, senha!);
      var user = await auth.getUser();
      String windowsIdFono = user.id;

      var usersSnapshot = await fd.Firestore.instance
          .collection('contas')
          .where('uidFono', isEqualTo: windowsIdFono)
          .where('tipoTransacao', isEqualTo: 'Recebido')
          .where('estadoPago', isEqualTo: true)
          .get();

      if (usersSnapshot.isNotEmpty) {
        usersSnapshot.forEach((doc) {
          Map<String, dynamic> data = doc as Map<String, dynamic>;
          String precoST = data['preco'];
          precoST = precoST.replaceAll('.', '');
          precoST = precoST.replaceAll(',', '.');
          double precoCompra = double.parse(precoST);
          aReceber += precoCompra;
        });
      }
    }
  } catch (e) {
    print('Erro ao calcular somas: $e');
  }*/
  return aReceber;
}

Future<double> calcularAPagar () async {
  double aPagar = 0;
  //try {
    //if (kIsWeb || Platform.isAndroid || Platform.isIOS) {
      QuerySnapshot recebidosSnapshot = await FirebaseFirestore.instance
          .collection('contas')
          .where('uidFono', isEqualTo: idUsuario())
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
    /*}else{
      //await fd.FirebaseAuth.initialize('AIzaSyAlG2glNY3njAvAyJ7eEMeMtLg4Wcfg8rI', fd.VolatileStore());
      //await fd.Firestore.initialize('programafono-7be09');
      var auth = fd.FirebaseAuth.instance;
      final emailSave = await SharedPreferences.getInstance();
      var email = emailSave.getString('email');
      final senhaSave = await SharedPreferences.getInstance();
      var senha = senhaSave.getString('senha');
      await auth.signIn(email!, senha!);
      var user = await auth.getUser();
      String windowsIdFono = user.id;

      var recebidosSnapshot = await fd.Firestore.instance
          .collection('contas')
          .where('uidFono', isEqualTo: windowsIdFono)
          .where('tipoTransacao', isEqualTo: 'Gasto')
          .where('estadoPago', isEqualTo: false)
          .get();

      if (recebidosSnapshot.isNotEmpty) {
        recebidosSnapshot.forEach((doc) {
          Map<String, dynamic> data = doc as Map<String, dynamic>;
          String precoST = data['preco'];
          precoST = precoST.replaceAll('.', '');
          precoST = precoST.replaceAll(',', '.');
          double precoCompra = double.parse(precoST);
          aPagar += precoCompra;
        });
      }

    }
  } catch (e) {
    print('Erro ao calcular somas: $e');
  }*/
  return aPagar;
}