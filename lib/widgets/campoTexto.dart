import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../controllers/estilos.dart';

campoTexto(texto, controller, icone,
    {key,
    senha,
    sufIcon,
    boardType,
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
        border: Border.all(color: cores('corPrimaria')),
        color: Colors.white,
        boxShadow: [
          BoxShadow(offset: Offset(0, 3), color: cores('corSombra'), blurRadius: 5)
          // changes position of shadow
        ]),
    child: Form(
      key: key,
      child: TextFormField(
        controller: controller,
        obscureText: senha == true ? true : false,
        style: TextStyle(
          color: cores('corTexto'),
          fontSize: 18,
          fontWeight: FontWeight.w400,
        ),
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(vertical: tamanho ?? 20),
          suffixIcon: sufIcon,
          prefixIcon: GestureDetector(
            onTap: iconPressed,
            child: Icon(icone, color: cores('corSimbolo')),
          ),
          prefixIconColor: cores('corSimbolo'),
          labelText: texto,
          labelStyle: TextStyle(color: cores('corDetalhe'), fontSize: 18, fontWeight: FontWeight.w500),
          border: OutlineInputBorder(
            borderSide: BorderSide(
              color: cores('corBorda'),
              width: 5.0,
            ),
            gapPadding: 5.0,
          ),
          focusColor: Colors.grey[100],
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: cores('corBorda'),
              width: 3.0,
            ),
          ),
        ),
        keyboardType: boardType == 'numeros'
            ? TextInputType.number
            : (boardType == 'multiLinhas' ? TextInputType.multiline : TextInputType.text),
        textInputAction: TextInputAction.newline,
        inputFormatters: formato != null
            ? [
                FilteringTextInputFormatter.digitsOnly,
                formato,
              ]
            : [],
        maxLength: maxPalavras,
        maxLines: maxLinhas ?? 1,
        validator: validator == true
            ? ((value) {
                if (value == null || value.isEmpty) {
                  return 'Este campo é obrigatório.';
                }
                return null;
              })
            : null,
        onSaved: (val) => controller = val,
        onChanged: onchaged,
      ),
    ),
  );
}
