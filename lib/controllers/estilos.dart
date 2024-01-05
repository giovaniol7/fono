import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

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

    case 'corBorda':
    //rosa_forte
      return Color(0xFFF5B2B0);
    case 'corFundo':
    //rosa_fraco
      return Color(0xFFF9D5D2);
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
      //verde_musgo
      return Color(0xFF37513F);
    case 'corBotao':
      //verde_musgo
      return Color(0xFF37513F);
    case 'corTextoBotao':
      //rosa_fraco
      return Color(0xFFF9D5D2);
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

textStyle(context, style) {
  TamanhoFonte tamanhoFonte = TamanhoFonte();
  switch (style) {
    case 'styleTitulo':
      return TextStyle(
          color: cores('corTitulo'), fontSize: tamanhoFonte.letraGrande(context), fontWeight: FontWeight.bold);
    case 'styleSubtitulo':
      return TextStyle(
          color: cores('corTitulo'), fontSize: tamanhoFonte.letraMedia(context), fontWeight: FontWeight.bold);
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

class TamanhoFonte {
  double iconGrande(BuildContext context) {
    if (kIsWeb || Platform.isWindows || Platform.isMacOS) {
      return MediaQuery.of(context).size.height * 0.1;
    } else {
      return MediaQuery.of(context).size.width * 0.3;
    }
  }

  double iconMedio(BuildContext context) {
    if (kIsWeb || Platform.isWindows || Platform.isMacOS) {
      return MediaQuery.of(context).size.height * 0.07;
    } else {
      return MediaQuery.of(context).size.width * 0.2;
    }
  }

  double iconPequeno(BuildContext context) {
    if (kIsWeb || Platform.isWindows || Platform.isMacOS) {
      return MediaQuery.of(context).size.height * 0.05;
    } else {
      return MediaQuery.of(context).size.width * 0.1;
    }
  }

  double letraGrande(BuildContext context) {
    if (kIsWeb || Platform.isWindows || Platform.isMacOS) {
      return MediaQuery.of(context).size.height * 0.05;
    } else {
      return MediaQuery.of(context).size.width * 0.08;
    }
  }

  double letraMedia(BuildContext context) {
    if (kIsWeb || Platform.isWindows || Platform.isMacOS) {
      return MediaQuery.of(context).size.height * 0.04;
    } else {
      return MediaQuery.of(context).size.width * 0.05;
    }
  }

  double letraPequena(BuildContext context) {
    if (kIsWeb || Platform.isWindows || Platform.isMacOS) {
      return MediaQuery.of(context).size.height * 0.02;
    } else {
      return MediaQuery.of(context).size.width * 0.04;
    }
  }

  double outroTamanho(BuildContext context, double tamanho) {
    if (kIsWeb || Platform.isWindows || Platform.isMacOS) {
      return MediaQuery.of(context).size.height * tamanho;
    } else {
      return MediaQuery.of(context).size.width * tamanho;
    }
  }
}

class TamanhoWidgets {
  double getWidth(BuildContext context) {
    if (kIsWeb || Platform.isWindows || Platform.isMacOS) {
      return MediaQuery.of(context).size.width * 0.48;
    } else {
      return MediaQuery.of(context).size.width * 0.9;
    }
  }

  double getHeight(BuildContext context) {
    if (kIsWeb || Platform.isWindows || Platform.isMacOS) {
      return MediaQuery.of(context).size.height * 0.97;
    } else {
      return MediaQuery.of(context).size.height * 0.7;
    }
  }

  double outroWidth(BuildContext context, double size) {
    return MediaQuery.of(context).size.width * size;
  }

  double outroHeight(BuildContext context, double size) {
    return MediaQuery.of(context).size.height * size;
  }
}
