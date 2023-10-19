calcularIdade(String birthDate) {
  List<String> partesData = birthDate.split('/');
  int dia = int.parse(partesData[0]);
  int mes = int.parse(partesData[1]);
  int ano = int.parse(partesData[2]);
  DateTime dataNascimento = DateTime(ano, mes, dia);
  final now = DateTime.now();
  int age = now.year - dataNascimento.year;
  if (now.month < dataNascimento.month || (now.month == dataNascimento.month && now.day < dataNascimento.day)) {
    age--;
  }
  return age.toString();
}