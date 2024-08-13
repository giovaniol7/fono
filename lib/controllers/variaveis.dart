import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

enum Gender { male, female }

class AppVariaveis extends ChangeNotifier {
  static final AppVariaveis _instance = AppVariaveis._internal();

  factory AppVariaveis() {
    return _instance;
  }

  AppVariaveis._internal();

  //USER
  GlobalKey<FormState> keyNome = GlobalKey<FormState>();
  GlobalKey<FormState> keyEmail = GlobalKey<FormState>();
  GlobalKey<FormState> keyDtNascimento = GlobalKey<FormState>();
  GlobalKey<FormState> keyCPF = GlobalKey<FormState>();
  GlobalKey<FormState> keyCRFa = GlobalKey<FormState>();
  GlobalKey<FormState> keyTelefone = GlobalKey<FormState>();
  GlobalKey<FormState> keySenha = GlobalKey<FormState>();
  GlobalKey<FormState> keySenhaConfirmar = GlobalKey<FormState>();
  TextEditingController txtNome = TextEditingController();
  TextEditingController txtEmail = TextEditingController();
  TextEditingController txtSenha = TextEditingController();
  TextEditingController txtDtNascimento = TextEditingController();
  TextEditingController txtCPF = TextEditingController();
  TextEditingController txtCRFa = TextEditingController();
  TextEditingController txtTelefone = TextEditingController();
  TextEditingController txtSenhaConfirmar = TextEditingController();
  String uidAuthFono = '';
  String idFono = '';
  Gender? selectedGeneroFono = null;
  String urlImageFono = '';
  var fileImageFono = null;

  //PACIENTE
  String nomePaciente = '';
  String uidPaciente = '';
  var uidFono = '';
  String pacienteNome = '';
  Map<String, dynamic> pacienteEdit = {};
  String varAtivoPaciente = '1';
  List<String> toggleOptionsPaciente = ['Presente', 'Faltou'];
  TextEditingController txtDataAnamnesePaciente = TextEditingController();
  TextEditingController txtNomePaciente = TextEditingController();
  TextEditingController txtDataNascimentoPaciente = TextEditingController();
  TextEditingController txtCPFPaciente = TextEditingController();
  TextEditingController txtRGPaciente = TextEditingController();
  TextEditingController txtProfessoraPaciente = TextEditingController();
  TextEditingController txtTelefoneProfessoraPaciente = TextEditingController();
  TextEditingController txtLogradouroPaciente = TextEditingController();
  TextEditingController txtNumeroPaciente = TextEditingController();
  TextEditingController txtBairroPaciente = TextEditingController();
  TextEditingController txtCidadePaciente = TextEditingController();
  TextEditingController txtCEPPaciente = TextEditingController();
  TextEditingController txtDescricaoPaciente = TextEditingController();
  GlobalKey<FormState> keyDataAnamnese = GlobalKey<FormState>();
  GlobalKey<FormState> keyNomePaciente = GlobalKey<FormState>();
  GlobalKey<FormState> keyDtNascimentoPaciente = GlobalKey<FormState>();
  GlobalKey<FormState> keyCPFPaciente = GlobalKey<FormState>();
  GlobalKey<FormState> keyProfessoraPaciente = GlobalKey<FormState>();
  GlobalKey<FormState> keyLougradouroPaciente = GlobalKey<FormState>();
  GlobalKey<FormState> keyNumeroPaciente = GlobalKey<FormState>();
  GlobalKey<FormState> keyBairroPaciente = GlobalKey<FormState>();
  GlobalKey<FormState> keyCidadePaciente = GlobalKey<FormState>();
  GlobalKey<FormState> keyCEPPaciente = GlobalKey<FormState>();
  GlobalKey<FormState> keyDescricaoPaciente = GlobalKey<FormState>();
  GlobalKey<FormState> keyNomeResponsavelPaciente = GlobalKey<FormState>();
  GlobalKey<FormState> keyIdadeResponsavelPaciente = GlobalKey<FormState>();
  GlobalKey<FormState> keyTelefoneResponsavelPaciente = GlobalKey<FormState>();
  GlobalKey<FormState> keyProfissaoResponsavelPaciente = GlobalKey<FormState>();
  String txtEscolaPaciente = '';
  String selecioneEscolaridadePaciente = 'Berçário';
  String selecioneTipoConsultaPaciente = 'Convênio';
  String selecionePeriodoEscolaPaciente = 'Manhã';
  String selecioneEstadoPaciente = 'AC';
  Gender? selectedGeneroPaciente;
  var fileImagePaciente;
  File? fileDocPaciente;
  String nomeArquivoPaciente = '';
  var apagarImagemPaciente;
  var urlImagePaciente = '';
  bool switchValuePaciente = true;
  var escolasPaciente;
  String outraEscolaPaciente = "Escola";
  List<String> listaEscolaPaciente = [];
  List<Gender?> ListGeneroResponsavelPaciente = [null];
  List<TextEditingController> ListNomeResponsavelPaciente = [TextEditingController()];
  List<TextEditingController> ListIdadeResponsavelPaciente = [TextEditingController()];
  List<TextEditingController> ListTelefoneResponsavelPaciente = [TextEditingController()];
  List<String> ListRelacaoResponsavelPaciente = ['Mãe'];
  List<String> ListEscolaridadeResponsavelPaciente = ['Ensino Fundamental Incompleto'];
  List<TextEditingController> ListProfissaoResponsavelPaciente = [TextEditingController()];
  int indexResponsavelPaciente = 0;
  int qtdResponsavelPaciente = 0;
  int indexPaciente = 0;
  String nomeArquivo = '';
  String urlDocPaciente = '';
  String dataAnamnesePaciente = '';
  String dtNascimentoPaciente = '';
  String CPFPaciente = '';
  String RGPaciente = '';
  String idadePaciente = '';
  String generoPaciente = '';
  String escolaPaciente = '';
  String escolaridadePaciente = '';
  String periodoEscolaPaciente = '';
  String professoraPaciente = '';
  String telefoneProfessoraPaciente = '';
  String lougradouroPaciente = '';
  String numeroPaciente = '';
  String bairroPaciente = '';
  String cidadePaciente = '';
  String estadoPaciente = '';
  String cepPaciente = '';
  String tipoConsultaPaciente = '';
  String descricaoPaciente = '';
  List<Gender?> ListaGeneroResponsavelPaciente = [];
  List<String> ListaNomeResponsavelPaciente = [];
  List<String> ListaIdadeResponsavelPaciente = [];
  List<String> ListaTelefoneResponsavelPaciente = [];
  List<String> ListaRelacaoResponsavelPaciente = [];
  List<String> ListaEscolaridadeResponsavelPaciente = [];
  List<String> ListaProfissaoResponsavelPaciente = [];

  //PRONTUÁRIOS
  var prontuarios;
  var prontuariosPac;
  var prontuariosAdd;
  var pacientePront;
  String nomePacientePront = '';
  String? selecioneMes;
  int? selecioneAno;
  String uidProntuario = '';
  TextEditingController txtNomeProntuario = TextEditingController();
  TextEditingController txtDataProntuario = TextEditingController();
  TextEditingController txtTimeProntuario = TextEditingController();
  TextEditingController txtObjetivosProntuarios = TextEditingController();
  TextEditingController txtMateriaisProntuarios = TextEditingController();
  TextEditingController txtResultadosProntuarios = TextEditingController();
  GlobalKey<FormState> keyNomeProntuario = GlobalKey<FormState>();
  GlobalKey<FormState> keyDataProntuario = GlobalKey<FormState>();
  GlobalKey<FormState> keyTimeProntuario = GlobalKey<FormState>();
  GlobalKey<FormState> keyObjetivosProntuarios = GlobalKey<FormState>();
  GlobalKey<FormState> keyMateriaisProntuarios = GlobalKey<FormState>();
  GlobalKey<FormState> keyResultadosProntuarios = GlobalKey<FormState>();
  Map<String, dynamic> appointmentProntuario = {};
  int index = 0;
  String selecioneProntuario = 'Presente';
  String nomeProntuario = '';
  String dataProntuario = '';
  String horarioProntuario = '';
  String objetivosProntuario = '';
  String materiaisProntuario = '';
  String resultadosProntuario = '';

  //AGENDA
  CalendarController controller = CalendarController();
  Future<List<Appointment>> futureAppointments = Future.value([]);
  TextEditingController txtNomeConsulta = TextEditingController();
  TextEditingController txtDataConsulta = TextEditingController();
  TextEditingController txtHorarioConsulta = TextEditingController();
  TextEditingController txtDuracaoConsulta = TextEditingController();
  TextEditingController txtColorConsulta = TextEditingController();
  GlobalKey<FormState> keyNomeConsulta = GlobalKey<FormState>();
  GlobalKey<FormState> keydatConsulta = GlobalKey<FormState>();
  GlobalKey<FormState> keyHorarioConsulta = GlobalKey<FormState>();
  GlobalKey<FormState> keyDuracaoConsulta = GlobalKey<FormState>();
  GlobalKey<FormState> keyColorConsulta = GlobalKey<FormState>();
  Color selecioneCorConsulta = Colors.red;
  String selecioneFrequenciaConsulta = 'DAILY';
  String selecioneSemanaConsulta = 'SU';
  String uidAgenda = '';
  Map<String, dynamic> appointmentAgenda = {};
  Map<String, String> consulta = {};

  //CONTABILIDADE
  List<String> toggleOptionsTransacao = ['Recebido', 'Gasto'];
  List<String> toggleOptionsEstadoGasto = ['Pago', 'Não Pago'];
  List<String> toggleOptionsEstadoRecebido = ['Pacientes', 'Outros'];
  List<String> toggleOptionsEstadoTipo = ['Trabalho', 'Pessoal', 'Outros'];
  List<String> toggleOptionsCobranca = ['Uma Cobrança', 'Várias Cobranças'];
  List<String> formaPagamentoDrop = ["Cartão Débito", "Cartão Crédito", "Pix", "Dinheiro", "Carnê"];
  List<String> qntdParcelasDrop = ["1x", "2x", "3x", "4x", "5x", "6x", "7x", "8x", "9x", "10x", "11x", "12x"];
  Map<String, String> conta = {};
  List<String> listaPacientes = [];
  List<String> listaUID = [];
  TextEditingController txtNomeConta = TextEditingController();
  TextEditingController txtPrecoConta = TextEditingController();
  TextEditingController txtDataConta = TextEditingController();
  TextEditingController txtDescricaoConta = TextEditingController();
  String uidConta = '';
  int horaConta = 0;
  int minutoConta = 0;
  String horarioCompra = '';
  int indexTransacao = 0;
  int indexTipoTransacao = 0;
  int indexEstadoRecebido = 0;
  int indexEstadoTipo = 0;
  int indexQtdPagamento = 0;
  String selecioneTipoTransacao = 'Recebido';
  String selecioneEstadoRecebido = 'Pacientes';
  String selecioneEstadoPago = 'Nãp Pago';
  String selecioneEstadoTipo = 'Trabalho';
  bool selecioneQtdPagamentoPaciente = true;
  String selecioneFormaPagamento = 'Cartão Débito';
  String selecioneQntdParcelas = '1x';
  var geralContas;
  var contasDebito;
  var contasCredito;
  var windowsIdFono;
  double somaDespesasConta = 0;
  double somaGanhosConta = 0;
  double saldoConta = 0.0;
  TabController? tabController;
  String selecioneMesConta = 'Todos';
  int selecioneAnoConta = DateTime.now().year;

  //BLOCO DE NOTAS
  var blocoNotas = null;
  String uidBloco = '';
  TextEditingController txtNomeBloco = TextEditingController();
  TextEditingController txtDataBloco = TextEditingController();
  TextEditingController txtNomeResponsavel = TextEditingController();
  TextEditingController txtTelefoneBloco = TextEditingController();
  Map<String, String> blNotas = {};

  //TELAINICIAL
  var pacientes;
  String nome = '';
  String urlImage = '';
  String genero = 'Gender.male';
  double entradas = 0.0;
  double saidas = 0.0;
  double saldo = 0.0;
  double aReceber = 0.0;
  double aPagar = 0.0;

  //OUTRAS VARIÁVEIS
  NumberFormat numberFormat = NumberFormat("#,##0.00", "pt_BR");
  DateTime nowTimer = DateTime.now();
  int mesAtual = DateTime.now().month;
  int anoAtual = DateTime.now().year;
  String labelText = "Nome do Paciente";
  List<String> listaPaciente = [];
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();
  DateTime? pickedDate;
  bool boolApagarImagem = false;
  bool obscureText = true;
  bool obscureText2 = true;
  bool obscureNum = false;

  //FUNÇÃO
  void toggleObscureText() {
    obscureText = !obscureText;
    notifyListeners();
  }

  void toggleObscureText2() {
    obscureText2 = !obscureText2;
    notifyListeners();
  }

  void toggleObscureNum() {
    obscureNum = !obscureNum;
    notifyListeners();
  }

  void resetGeral(){
    reset();
    resetUser();
    resetPaciente();
    resetProntuario();
    resetAgenda();
    resetBlocoNotas();
    resetContabilidade();
  }

  //OUTRAS VARIÁVEIS
  void reset() {
    nome = '';
    urlImage = '';
    genero = 'Gender.male';
    entradas = 0.0;
    saidas = 0.0;
    saldo = 0.0;
    aReceber = 0.0;
    aPagar = 0.0;
    pacienteNome = '';
    listaPaciente = [];
    selectedDate = DateTime.now();
    selectedTime = TimeOfDay.now();
    pickedDate = null;

    boolApagarImagem = false;
    obscureText = true;
    obscureText2 = true;
    notifyListeners();
  }

  //USER
  void resetUser() {
    txtNome.clear();
    txtEmail.clear();
    txtSenha.clear();
    txtDtNascimento.clear();
    txtCPF.clear();
    txtCRFa.clear();
    txtTelefone.clear();
    txtSenha.clear();
    txtSenhaConfirmar.clear();
    selectedGeneroFono = null;
    urlImageFono = '';
    fileImageFono = null;
    notifyListeners();
  }

  //PACIENTE
  void resetPaciente() {
    labelText = "Nome do Paciente";
    uidPaciente = '';
    uidFono = '';
    pacienteNome = '';
    pacienteEdit = {};
    varAtivoPaciente = '1';
    toggleOptionsPaciente = ['Presente', 'Faltou'];
    txtDataAnamnesePaciente.clear();
    txtNomePaciente.clear();
    txtDataNascimentoPaciente.clear();
    txtCPFPaciente.clear();
    txtRGPaciente.clear();
    txtProfessoraPaciente.clear();
    txtTelefoneProfessoraPaciente.clear();
    txtLogradouroPaciente.clear();
    txtNumeroPaciente.clear();
    txtBairroPaciente.clear();
    txtCidadePaciente.clear();
    txtCEPPaciente.clear();
    txtDescricaoPaciente.clear();
    txtEscolaPaciente = '';
    selecioneEscolaridadePaciente = 'Berçário';
    selecioneTipoConsultaPaciente = 'Convênio';
    selecionePeriodoEscolaPaciente = 'Manhã';
    selecioneEstadoPaciente = 'AC';
    selectedGeneroPaciente;
    fileImagePaciente;
    fileDocPaciente;
    nomeArquivoPaciente = '';
    apagarImagemPaciente;
    urlImagePaciente = '';
    switchValuePaciente = true;
    escolasPaciente;
    outraEscolaPaciente = "Escola";
    listaEscolaPaciente = [];
    ListGeneroResponsavelPaciente = [null];
    ListNomeResponsavelPaciente = [TextEditingController()];
    ListIdadeResponsavelPaciente = [TextEditingController()];
    ListTelefoneResponsavelPaciente = [TextEditingController()];
    ListRelacaoResponsavelPaciente = ['Mãe'];
    ListEscolaridadeResponsavelPaciente = ['Ensino Fundamental Incompleto'];
    ListProfissaoResponsavelPaciente = [TextEditingController()];
    indexResponsavelPaciente = 0;
    qtdResponsavelPaciente = 0;

    indexPaciente = 0;
    nomeArquivo = '';
    urlDocPaciente = '';
    dataAnamnesePaciente = '';
    dtNascimentoPaciente = '';
    idadePaciente = '';
    CPFPaciente = '';
    RGPaciente = '';
    generoPaciente = '';
    escolaPaciente = '';
    escolaridadePaciente = '';
    periodoEscolaPaciente = '';
    professoraPaciente = '';
    telefoneProfessoraPaciente = '';
    lougradouroPaciente = '';
    numeroPaciente = '';
    bairroPaciente = '';
    cidadePaciente = '';
    estadoPaciente = '';
    cepPaciente = '';
    tipoConsultaPaciente = '';
    descricaoPaciente = '';
    ListaGeneroResponsavelPaciente = [];
    ListaNomeResponsavelPaciente = [];
    ListaIdadeResponsavelPaciente = [];
    ListaTelefoneResponsavelPaciente = [];
    ListaRelacaoResponsavelPaciente = [];
    ListaEscolaridadeResponsavelPaciente = [];
    ListaProfissaoResponsavelPaciente = [];
    notifyListeners();
  }

  //PRONTUÁRIOS
  void resetProntuario() {
    prontuariosAdd = null;
    labelText = "Nome do Paciente";
    uidProntuario = '';
    txtNomeProntuario.clear();
    txtDataProntuario.clear();
    txtTimeProntuario.clear();
    txtObjetivosProntuarios.clear();
    txtMateriaisProntuarios.clear();
    txtResultadosProntuarios.clear();
    appointmentProntuario = {};
    index = 0;
    selecioneProntuario = 'Presente';
    nomeProntuario = '';
    dataProntuario = '';
    horarioProntuario = '';
    objetivosProntuario = '';
    materiaisProntuario = '';
    resultadosProntuario = '';
    notifyListeners();
  }

  void resetProntuarioPac() {
    prontuarios = null;
    prontuariosPac = null;
    pacientePront = null;
    nomePacientePront = '';
    notifyListeners();
  }

  //AGENDA
  void resetAgenda() {
    labelText = "Nome do Paciente";
    txtNomeConsulta.clear();
    txtDataConsulta.clear();
    txtHorarioConsulta.clear();
    txtDuracaoConsulta.clear();
    txtColorConsulta.clear();
    selecioneCorConsulta = Colors.red;
    selecioneFrequenciaConsulta = 'DAILY';
    selecioneSemanaConsulta = 'SU';
    uidAgenda = '';
    uidPaciente = '';
    appointmentAgenda = {};
    consulta = {};
    pacienteNome = '';
    notifyListeners();
  }

  //CONTABILIDADE
  void resetContabilidade() {
    labelText = "Nome do Paciente";
    conta = {};
    listaPacientes = [];
    listaUID = [];
    txtNomeConta.clear();
    txtPrecoConta.clear();
    txtDataConta.clear();
    txtDescricaoConta.clear();
    horaConta = 0;
    minutoConta = 0;
    horarioCompra = '';
    indexTransacao = 0;
    indexTipoTransacao = 0;
    indexEstadoRecebido = 0;
    indexEstadoTipo = 0;
    indexQtdPagamento = 0;
    selecioneTipoTransacao = 'Recebido';
    selecioneEstadoRecebido = 'Pacientes';
    selecioneEstadoPago = 'Não Pago';
    selecioneEstadoTipo = 'Trabalho';
    selecioneQtdPagamentoPaciente = true;
    selecioneFormaPagamento = 'Cartão Débito';
    selecioneQntdParcelas = '1x';
    notifyListeners();
  }

  void resetContabilidadeConta() {
    contasDebito = null;
    geralContas = null;
    contasCredito = null;
    windowsIdFono = null;
    somaDespesasConta = 0;
    somaGanhosConta = 0;
    saldoConta = 0.0;
    tabController = null;
    selecioneMesConta = 'Todos';
    selecioneAnoConta = DateTime.now().year;
    notifyListeners();
  }

  //BLOCO DE NOTAS
  void resetBlocoNotas() {
    blocoNotas = null;
    uidBloco = '';
    txtNomeBloco.clear();
    txtDataBloco.clear();
    txtNomeResponsavel.clear();
    txtTelefoneBloco.clear();
    blNotas = {};
    notifyListeners();
  }
}
