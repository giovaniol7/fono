import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/*
Palhetas de cores
0xFFF5B2B0 -> rosa forte
0xFFF8CAC7 -> rosa médio
0xFFF9D5D2 -> rosa fraco
0xFF37513F -> verde
0xFFB4CABB -> verde/azul
*/

rosa_forte(){
  return Color(0xFFF5B2B0);
}

cores(cor){
  switch(cor){
    case 'rosa_forte':
      return Color(0xFFF5B2B0);
    case 'rosa_medio':
      return Color(0xFFF8CAC7);
    case 'rosa_fraco':
      return Color(0xFFF9D5D2);
    case 'verde':
      return Color(0xFF37513F);
    case 'verde/azul':
      return Color(0xFFB4CABB);
    default:
      return Color(0xFF000000);
  }
}