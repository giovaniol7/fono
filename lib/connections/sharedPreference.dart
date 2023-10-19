import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

recuperarValor() async {
  final tokenSave = await SharedPreferences.getInstance();
  String? token = tokenSave.getString('token');
  return token;
}

saveValor() async {
  String uid = FirebaseAuth.instance.currentUser!.uid.toString();
  final tokenSave = await SharedPreferences.getInstance();
  await tokenSave.setString('token', uid);
}

deleteValor() async {
  SharedPreferences tokenSave = await SharedPreferences.getInstance();
  await tokenSave.setString('token', '');
}
