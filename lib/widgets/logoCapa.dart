import 'package:flutter/material.dart';
import '../controllers/resolucoesTela.dart';



class logoCapa extends StatefulWidget {
  const logoCapa({
    super.key,
  });

  @override
  State<logoCapa> createState() => _logoCapaState();
}

class _logoCapaState extends State<logoCapa> {
  
  
  double containerHeight = 0.0;
  double containerWidth = 0.0;
  ratioScreen ratio = ratioScreen(); 


  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width= MediaQuery.of(context).size.width;

    if(ratio.screen(context) == 'pequeno'){
      containerWidth = double.infinity; // Altura desejada
    }else{
      containerHeight = double.infinity;
    }

    Future.delayed(const Duration(milliseconds: 300), () {
      // Atualiza a altura do container para iniciar a animação
      setState(() {
        if(ratio.screen(context) == 'pequeno'){
          containerHeight = height * 0.45;
        }else{
          containerWidth = width * 0.5;
        }
      });
    });

    return AnimatedContainer(
      duration: const Duration(seconds: 1), // Duração da animação
      curve: Curves.easeInOut, // Curva da animação
      constraints: BoxConstraints.expand(height: containerHeight, width: containerWidth),
      decoration: BoxDecoration(
          image: const DecorationImage(
                image: AssetImage("images/logo.png"),
                fit: BoxFit.fitWidth,
          ),
      borderRadius: BorderRadius.only(
                    bottomLeft: ratio.screen(context) == 'pequeno'? const Radius.circular(50) : Radius.zero,
                    bottomRight: const Radius.circular(50),
                    topRight: ratio.screen(context) == 'pequeno'? Radius.zero : const Radius.circular(50),
                  ),
      ),
    );
  }
}