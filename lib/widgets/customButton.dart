import 'package:flutter/material.dart';


class customButton extends StatelessWidget {
  const customButton({
    super.key,
    required this.buttonColor,
    required this.onPressed, 
    required this.text, 
    required this.padding, required this.textStyle, required this.margin,
  });

  final Color buttonColor;
  final TextStyle textStyle;
  final Function onPressed;
  final String text;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry margin;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin ,
      child: ElevatedButton(
        style: ButtonStyle(
          elevation: MaterialStateProperty.all<double>(5),
          backgroundColor: MaterialStateProperty.all<Color>(buttonColor), //cores('cor_2')
          padding: MaterialStateProperty.all<EdgeInsetsGeometry>(padding),
          shape: MaterialStateProperty.all<OutlinedBorder>(RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)))
        ),
        onPressed: onPressed(),
        child: Center(
          child: Text(
            text,
            style: textStyle,
          ),
        )),
    );
  }
}
