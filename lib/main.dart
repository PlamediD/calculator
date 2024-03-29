import 'package:flutter/material.dart';
import 'package:calculator/buttons.dart';
import 'package:math_expressions/math_expressions.dart';

/*
Author: Plamedi Diakubama
Start date: Jan 2024
Description: Simple calculator app to perform fundamental operations( addition, multiplication, division, subtraction).
It checks for user input to make sure that the user doesn't enter bad decimals such as 0.9.0.0

 */
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  var userQuestion='';
  var userAnswer='';
  final myTextStyle= TextStyle( fontSize: 30, color: Colors.deepPurple[900]);

  final List<String> buttons= [
    'C', 'DEL','%', '/',
    '9', '8','7', 'x',
    '6', '5','4', '-',
    '3', '2','1', '+',
    '8', '.','0', '=',
  ];



  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
        backgroundColor: Colors.deepPurple[100],
        body: Column(
          children: <Widget>[
            Expanded(

                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      SizedBox(height: 50,),
                      Container(
                          padding: EdgeInsets.all(25),
                          alignment: Alignment.centerLeft,
                          child: Text(userQuestion, style:TextStyle( fontSize: 20),),
                      ),
                      Container(
                        padding: EdgeInsets.all(25),
                        alignment: Alignment.centerRight,
                        child: Text(
                          userAnswer,
                          style: TextStyle(fontSize: 20, color: userAnswer == 'Error' ? Colors.red : Colors.black),
                        ),
                      )

                    ],
                  )
                ),
            ),
            Expanded(
              flex:2,
              child: Container(
                child: GridView.builder(
                  itemCount: buttons.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4),
                  itemBuilder:(BuildContext context, int index){

                    //clear button
                    if( index==0){
                      return MyButton(
                        buttonTaped: (){
                          setState(() {
                            userQuestion='';
                          });

                        },
                        buttonText: buttons[index],
                        color: Colors.green,
                        textColor: Colors.white,
                      );
                    }

                    /*

                     */
                    //Equal button

                    else if(index==buttons.length-1){
                      return MyButton(
                        buttonTaped: (){
                          setState(() {
                            equalPressed();

                          });
                        },
                        buttonText: buttons[index],
                        color: Colors.red,
                        textColor: Colors.white,
                      );
                    }
// Allow the user to input a decimal point only if the last character is not an operator
                    else if (index == buttons.length - 3) {
                      return MyButton(
                        buttonTaped: () {
                          setState(() {
                            // Check if the last character is not an operator
                            if (userQuestion.isEmpty || !isOperator(userQuestion[userQuestion.length - 1])) {
                              // Check if the last number in the expression already contains a decimal point
                              List<String> parts = userQuestion.split(RegExp(r'[+\-*/]'));
                              String lastNumber = parts.last;
                              if (!lastNumber.contains('.')) {
                                userQuestion += buttons[index];
                              }
                            }
                          });
                        },
                        buttonText: buttons[index],
                        color: Colors.deepPurple[50],
                        textColor: Colors.deepPurple,
                      );
                    }





                    //Delete button
                    else if(index==1){
                      return MyButton(
                        buttonTaped: (){
                          setState(() {
                            userQuestion=userQuestion.substring(0,userQuestion.length-1);
                          });
                        },
                        buttonText: buttons[index],
                        color: Colors.orange,
                        textColor: Colors.white,
                      );
                    }
                    else{
                      return MyButton(
                        buttonTaped: (){
                          setState(() {
                            userQuestion+=buttons[index];
                          });
                        },
                        buttonText: buttons[index],
                        color: isOperator(buttons[index])?Colors.deepPurple:Colors.deepPurple[50],
                        textColor: isOperator(buttons[index])?Colors.white: Colors.deepPurple,

                      );
                    }
                  }
                )

              ),
            )
          ],
        )
    );
  }
  bool isOperator( String x){
    if(x=='%'|| x=='/'|| x=='x'|| x=='-'|| x=='+'|| x=='='){
      return true;
    }
    return false;
  }

  void equalPressed() {
    String finalQuestion = userQuestion;

    // Handle cases where there are multiple decimal points
    finalQuestion = finalQuestion.replaceAll(RegExp(r'\.\.'), '.');

    finalQuestion = finalQuestion.replaceAll('x', '*');

    // Check for division by zero
    if (!finalQuestion.contains('/0')) {
      Parser p = Parser();
      Expression exp = p.parse(finalQuestion);
      ContextModel cm = ContextModel();
      double eval = exp.evaluate(EvaluationType.REAL, cm);
      userAnswer = eval.toString();
    } else {
      userAnswer = 'Error';
    }
  }


/*
  void equalPressed(){
  String finalQuestion=userQuestion;
  finalQuestion =finalQuestion.replaceAll('x', '*');

  // Check for division by zero
  if (!finalQuestion.contains('/0')) {
    Parser p = Parser();
    Expression exp = p.parse(finalQuestion);
    ContextModel cm=ContextModel();
    double eval= exp.evaluate(EvaluationType.REAL, cm);
    userAnswer= eval.toString();
  } else {
    userAnswer = 'Error';
  }
}

   */
}
