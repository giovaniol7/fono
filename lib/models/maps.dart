import 'package:flutter/material.dart';

import '../connections/fireCloudConsultas.dart';

enum Gender { male, female }

String limparTelefone(String telefone) {
  RegExp regex = RegExp(r'\d+');
  Iterable<Match> matches = regex.allMatches(telefone);

  String resultado = matches.map((match) => match.group(0)!).join();

  return resultado;
}

Gender? stringToGender(String genderString) {
  if (genderString == 'Gender.male') {
    return Gender.male;
  } else if (genderString == 'Gender.female') {
    return Gender.female;
  }
  return null;
}

String genderToString(Gender gender) {
  switch (gender) {
    case Gender.male:
      return 'Masc.';
    case Gender.female:
      return 'Fem.';
    default:
      return '';
  }
}

Map<int, String> nomeMeses = {
  1: 'Janeiro',
  2: 'Fevereiro',
  3: 'Março',
  4: 'Abril',
  5: 'Maio',
  6: 'Junho',
  7: 'Julho',
  8: 'Agosto',
  9: 'Setembro',
  10: 'Outubro',
  11: 'Novembro',
  12: 'Dezembro'
};

Map<int, String> intMesToAbrev = {
  1: 'Jan.',
  2: 'Fev.',
  3: 'Mar.',
  4: 'Abr.',
  5: 'Maio',
  6: 'Jun.',
  7: 'Jul.',
  8: 'Ago.',
  9: 'Set.',
  10: 'Out.',
  11: 'Nov.',
  12: 'Dez.'
};

final List<String> nomeMesesAbrev = [
  'Jan.',
  'Fev.',
  'Mar.',
  'Abr.',
  'Maio',
  'Jun.',
  'Jul.',
  'Ago.',
  'Set.',
  'Out.',
  'Nov.',
  'Dez.',
  'Todos'
];

final List<String> estados = [
  "AC",
  "AL",
  "AP",
  "AM",
  "BA",
  "CE",
  "DF",
  "ES",
  "GO",
  "MA",
  "MT",
  "MS",
  "MG",
  "PA",
  "PB",
  "PR",
  "PE",
  "PI",
  "RJ",
  "RN",
  "RS",
  "RO",
  "RR",
  "SC",
  "SP",
  "SE",
  "TO"
];

final List<String> escolaridade = [
  'Berçário',
  'Maternal I',
  'Maternal II',
  'Jardim I',
  'Jardim II',
  'Ensino Fundamental I',
  'Ensino Fundamental II',
  'Ensino Médio'
];

final List<String> escolaridadeResp = [
  "Ensino Fundamental - Incompleto",
  "Ensino Fundamental - Completo",
  "Ensino Médio - Incompleto",
  "Ensino Médio - Completo",
  "Ensino Superior - Incompleto",
  "Ensino Superior - Completo",
  "Pós-graduação - Incompleto",
  "Pós-graduação - Completo",
  "Pós-graduação - Incompleto",
  "Pós-graduação - Completo",
  "Pós-graduação - Incompleto",
  "Pós-graduação - Completo"
];

final List<Color> colors = [
  Colors.red,
  Colors.green,
  Colors.blue,
  Colors.yellow,
  Colors.orange,
  Colors.purple,
  Colors.pink,
  Colors.grey,
  Colors.black
];

final List<FrequencyOption> frequencyOptions = [
  FrequencyOption(value: "DAILY", label: "Diariamente"),
  FrequencyOption(value: "WEEKLY", label: "Semanalmente"),
  FrequencyOption(value: "MONTHLY", label: "Mensalmente"),
  FrequencyOption(value: "YEARLY", label: "Anualmente"),
];

final List<FrequencyOption> dayOptions = [
  FrequencyOption(value: "SU", label: "Domingo"),
  FrequencyOption(value: "MO", label: "Segunda-Feira"),
  FrequencyOption(value: "TU", label: "Terça-Feira"),
  FrequencyOption(value: "WE", label: "Quarta-Feira"),
  FrequencyOption(value: "TH", label: "Quinta-Feira"),
  FrequencyOption(value: "FR", label: "Sexta-Feira"),
  FrequencyOption(value: "SA", label: "Sábado"),
];

Color? getColorNameFromHex(String hexString) {
  Map<String, Color> colorMap = {
    "fff44336": Colors.red,
    "ff4caf50": Colors.green,
    "ff2196f3": Colors.blue,
    "ffffeb3b": Colors.yellow,
    "ffff9800": Colors.orange,
    "ff9c27b0": Colors.purple,
    "ffe91e63": Colors.pink,
    "ff9e9e9e": Colors.grey,
    "ff000000": Colors.black
  };

  if (colorMap.containsKey(hexString)) {
    return colorMap[hexString]!;
  }

  return colorMap[hexString];
}

String getColorName(Color color) {
  final Map<Color, String> colorNames = {
    Colors.red: 'Vermelho',
    Colors.green: 'Verde',
    Colors.blue: 'Azul',
    Colors.yellow: 'Amarelo',
    Colors.orange: 'Laranja',
    Colors.purple: 'Roxo',
    Colors.pink: 'Rosa',
    Colors.grey: 'Cinza',
    Colors.black: 'Preto'
  };

  if (colorNames.containsKey(color)) {
    return colorNames[color]!;
  }

  return color.toString();
}

final List<String> formaPagamento = ["Cartão Débito", "Cartão Crédito", "Pix", "Dinheiro", "Carnê"];

final List<String> qntdParcelas = ["1x", "2x", "3x", "4x", "5x", "6x", "7x", "8x", "9x", "10x", "11x", "12x"];
