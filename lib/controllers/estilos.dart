import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

cores(cor) {
  switch (cor) {
    case 'corPrimaria':
      //rosa_forte
      return Color(0xFFF5B2B0);
    case 'corSecundaria':
      //rosa_medio
      return Color(0xFFF8CAC7);
    case 'corTerciaria':
      //rosa_fraco
      return Color(0xFFF9D5D2);
    case 'corDetalhe':
      //verde/azulado
      return Color(0xFFB4CABB);

    case 'corSombra':
      //rosa_fraco
      return Color(0xFFF9D5D2);
    case 'corSimbolo':
      //verde_musgo
      return Color(0xFF37513F);
    case 'corReceitas':
      //azul
      return Color(0xFF2196F3);
    case 'corReceitasCard':
      //azul_fraco
      return Color(0xFFBBDEFB);
    case 'corDespesas':
      //vermelho
      return Color(0xFFF44336);
    case 'corDespesasCard':
      //vermelho_fraco
      return Color(0xFFFFCDD2);
    case 'corTexto':
      //verde
      return Color(0xFF37513F);
    case 'corTitulo':
      //cinza
      return Color(0xFF757575);

    case 'corCaixaPadrao':
      //branco
      return Color(0xFFFFFFFF);
    case 'branco':
    //branco
      return Color(0xFFFFFFFF);
    case 'corTextoPadrao':
      //preto
      return Color(0xFF000000);
    case 'corSimboloPadrao':
      //preto
      return Color(0xFF000000);
    default:
      //preto
      return Color(0xFF000000);
  }
}

textStyle(style) {
  switch (style) {
    case 'styleTitulo':
      return TextStyle(color: cores('corTitulo'), fontSize: 40, fontWeight: FontWeight.bold);
    case 'styleSubtitulo':
      return TextStyle(color: cores('corTitulo'), fontSize: 24, fontWeight: FontWeight.bold);
    default:
      return;
  }
}

decoracaoContainer(dec) {
  switch (dec) {
    case 'decPadrao':
      return BoxDecoration(
        color: cores('corCaixaPadrao'),
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: sombra('sombraContainer'),
      );
    case 'decDraw':
      return BoxDecoration(
        color: cores('corDetalhe'),
        borderRadius: BorderRadius.circular(25.0),
        boxShadow: sombra('sombraContainer'),
      );
    default:
      return;
  }
}

sombra(somb) {
  switch (somb) {
    case 'sombraPadrao':
      return [BoxShadow(color: cores('corSombra'), offset: Offset(0, 3), blurRadius: 8)];
    case 'sombraContainer':
      return [
        BoxShadow(
          color: cores('corSombra'),
          offset: Offset(0, 2),
          blurRadius: 10.0,
          spreadRadius: 5.0,
        ),
      ];
    default:
      return;
  }
}
