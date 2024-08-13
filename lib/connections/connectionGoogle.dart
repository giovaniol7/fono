import 'package:firebase_auth/firebase_auth.dart';
import '../connections/sharedPreference.dart';
import 'package:google_sign_in/google_sign_in.dart';

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
  final List firebaseUser = await FirebaseAuth.instance.fetchSignInMethodsForEmail(googleSignInAccount!.email);
  if (firebaseUser.isNotEmpty) {
    final UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
    saveValor();
    return userCredential;
  } else {
    erro(context, "Usuario não esta cadastrado.");
  }
  return null;
}
