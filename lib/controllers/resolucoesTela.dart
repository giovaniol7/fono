import 'package:flutter/material.dart';

class ratioScreen {
  String screen(context) {
    double width = MediaQuery.of(context).size.width;
    switch (width) {
      case < 534:
        return "pequeno";
      case < 800:
        return "medio";
      default:
        return "grande";
    }
  }
}
