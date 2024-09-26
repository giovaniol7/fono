import 'package:firebase_auth/firebase_auth.dart';
import '../connections/sharedPreference.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/calendar/v3.dart' as calendar;
import 'package:http/http.dart' as http;

import '../../widgets/mensagem.dart';

Future<UserCredential?> signInWithGoogle(context) async {
  final GoogleSignIn googleSignIn = GoogleSignIn();
  await googleSignIn.signOut();
  final GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();
  final GoogleSignInAuthentication? googleSignInAuthentication = await googleSignInAccount?.authentication;
  final AuthCredential credential = GoogleAuthProvider.credential(
    accessToken: googleSignInAuthentication?.accessToken,
    idToken: googleSignInAuthentication?.idToken,
  );
  final List firebaseUser =
      await FirebaseAuth.instance.fetchSignInMethodsForEmail(googleSignInAccount!.email);
  if (firebaseUser.isNotEmpty) {
    final UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
    saveValor();
    return userCredential;
  } else {
    erro(context, "Usuario não esta cadastrado.");
  }
  return null;
}

final GoogleSignIn _googleSignIn = GoogleSignIn(
  scopes: [
    'https://www.googleapis.com/auth/calendar',
  ],
);

Future<void> handleSignIn() async {
  try {
    await _googleSignIn.signIn();
  } catch (error) {
    print(error);
  }
}

Future<void> addEventToGoogleCalendar(data) async {
  final GoogleSignInAccount? user = _googleSignIn.currentUser;
  if (user == null) {
    print('User is not signed in');
    return;
  }

  final authHeaders = await user.authHeaders;

  final http.Client client = http.Client();
  final httpClientWithHeaders = AuthenticatedClient(client, authHeaders);

  final calendar.CalendarApi calendarApi = calendar.CalendarApi(httpClientWithHeaders);

  var event = calendar.Event(
    summary: data['nomePaciente'],
    start: calendar.EventDateTime(
        dateTime: DateTime.parse('${data['dataConsulta']}T${data['horarioConsulta']}'),
        timeZone: 'America/Sao_Paulo'),
    end: calendar.EventDateTime(
        dateTime: DateTime.parse('${data['dataConsulta']}T${data['horarioConsulta']}')
            .add(Duration(minutes: int.parse(data['duracaoConsulta']))),
        timeZone: 'America/Sao_Paulo'),
    recurrence: ['RRULE:FREQ=${data['frequenciaConsulta']};BYDAY=${data['semanaConsulta']}'],
    colorId: '0xFF${data['colorConsulta']}'
  );

  try {
    await calendarApi.events.insert(event, "primary");
    print("Evento adicionado ao Google Calendar com sucesso!");
  } catch (e) {
    print("Erro ao adicionar evento ao Google Calendar: $e");
  }
}

class AuthenticatedClient extends http.BaseClient {
  final http.Client _inner;
  final Map<String, String> _headers;

  AuthenticatedClient(this._inner, this._headers);

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) {
    return _inner.send(request..headers.addAll(_headers));
  }
}
