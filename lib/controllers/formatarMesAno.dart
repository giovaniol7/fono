import '../models/mapMeses.dart';

String formatarMesAno(String data) {
  List<String> partes = data.split('/');
  int numeroMes = int.parse(partes[0]);
  String nomeMes = nomeMeses[numeroMes] ?? '';
  String ano = partes[1];
  int anoAtual = DateTime.now().year;

  if (ano == anoAtual.toString()) {
    return '$nomeMes';
  } else {
    return '$nomeMes $ano';
  }
}