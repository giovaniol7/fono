import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../controllers/estilos.dart';
import 'package:search_cep/search_cep.dart';

campoTexto(texto, controller, icone,
    {senha,
    sufIcon,
    numeros,
    formato,
    maxPalavras,
    maxLinhas,
    tamanho,
    validator,
    onchaged,
    iconPressed}) {
  return Container(
    decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(color: cores('rosa_forte')),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
              offset: Offset(0, 3), color: cores('rosa_fraco'), blurRadius: 5)
          // changes position of shadow
        ]),
    child: TextFormField(
      controller: controller,
      obscureText: senha == true ? true : false,
      style: TextStyle(
        color: cores('verde'),
        fontWeight: FontWeight.w400,
      ),
      decoration: InputDecoration(
        contentPadding:
            EdgeInsets.symmetric(vertical: tamanho ?? 20),
        suffixIcon: sufIcon,
        prefixIcon: GestureDetector(
          onTap: iconPressed,
          child: Icon(icone, color: cores('verde')),
        ),
        prefixIconColor: cores('rosa_forte'),
        labelText: texto,
        labelStyle: TextStyle(color: cores('verde/azul'), fontWeight: FontWeight.w500),
        border: const OutlineInputBorder(),
        focusColor: Colors.grey[100],
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: cores('rosa_forte'),
            width: 2.0,
          ),
        ),
      ),
      keyboardType: numeros == true ? TextInputType.number : TextInputType.text,
      inputFormatters: formato != null
          ? [
              FilteringTextInputFormatter.digitsOnly,
              formato,
            ]
          : [],
      maxLength: maxPalavras,
      maxLines: maxLinhas ?? 1,
      validator: validator,
      onSaved: (val) => controller = val,
      onChanged: onchaged,
    ),
  );
}
