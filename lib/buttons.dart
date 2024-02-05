/*
Author: Plamedi Diakubama 
Start date: Jan 2024

Description: 
This class is for the calculator's buttons

*/
import 'package:flutter/material.dart';


class MyButton extends StatelessWidget{

  final color;
  final textColor;
  final String buttonText;
  final buttonTaped;

  MyButton({this.color, this.textColor, this.buttonText='', this.buttonTaped});

  @override
  Widget build( BuildContext context){
    return GestureDetector(
      onTap: buttonTaped,
      child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Container(
              color:color,
              child: Center(child: Text(buttonText, style: TextStyle(color: textColor),),),

            ),

          ),
        ),

    );
  }
}
