import 'package:firebase_auth/firebase_auth.dart';
import '../connections/sharedPreference.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../widgets/mensagem.dart';

Future<UserCredential?> signInWithGoogle(context) async {
  final GoogleSignIn googleSignIn = GoogleSignIn();
  await googleSignIn.signOut();
  // Tente fazer login com uma conta do Google.
  final GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();
  // Obtenha as credenciais de autenticação do Google.
  final GoogleSignInAuthentication? googleSignInAuthentication = await googleSignInAccount?.authentication;
  // Crie as credenciais de autenticação do Firebase.
  final AuthCredential credential = GoogleAuthProvider.credential(
    accessToken: googleSignInAuthentication?.accessToken,
    idToken: googleSignInAuthentication?.idToken,
  );
  // Verifique se o e-mail do usuário já existe no Firebase.
  final List firebaseUser = await FirebaseAuth.instance.fetchSignInMethodsForEmail(googleSignInAccount!.email);
  if (firebaseUser.isNotEmpty) {
    // Faça login no Firebase com as credenciais do Google.
    final UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
    saveValor();
    return userCredential;
  } else {
    erro(context, "Usuario não esta cadastrado.");
  }
  return null;
}
