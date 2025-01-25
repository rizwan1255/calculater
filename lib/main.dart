import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Calculator',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const Calculator(),
    );
  }
}

class Calculator extends StatefulWidget {
  const Calculator({super.key});

  @override
  _CalculatorState createState() => _CalculatorState();
}

class _CalculatorState extends State<Calculator> {
  String expression = '';
  String result = '0';

  void numClick(String text) {
    setState(() {
      expression += text;
    });
  }

  void clear() {
    setState(() {
      expression = '';
      result = '0';
    });
  }

  void delete() {
    setState(() {
      expression = expression.isNotEmpty ? expression.substring(0, expression.length - 1) : '';
    });
  }

  void evaluate() {
    Parser p = Parser();
    Expression exp = p.parse(expression);
    ContextModel cm = ContextModel();

    setState(() {
      result = exp.evaluate(EvaluationType.REAL, cm).toString();
    });
  }

  Future<bool> _onWillPop() async {
    return (await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Exit App'),
        content: const Text('Do you want to exit the app?'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Yes'),
          ),
        ],
      ),
    )) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop, // Intercept back button press
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text('Calculator'),
        ),
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Container(
                padding: const EdgeInsets.all(20),
                alignment: Alignment.centerRight,
                child: Text(
                  expression,
                  style: const TextStyle(fontSize: 30, color: Colors.black),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(20),
                alignment: Alignment.centerRight,
                child: Text(
                  '= $result',
                  style: const TextStyle(fontSize: 40, color: Colors.black),
                ),
              ),
              const Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  calcButton('C', Colors.red, Colors.white, clear),
                  calcButton('del', Colors.red, Colors.white, delete),
                  calcButton('%', Colors.green, Colors.white, () => numClick('%')),
                  calcButton('/', Colors.green, Colors.white, () => numClick('/')),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  calcButton('7', Colors.black54, Colors.white, () => numClick('7')),
                  calcButton('8', Colors.black54, Colors.white, () => numClick('8')),
                  calcButton('9', Colors.black54, Colors.white, () => numClick('9')),
                  calcButton('*', Colors.green, Colors.white, () => numClick('*')),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  calcButton('4', Colors.black54, Colors.white, () => numClick('4')),
                  calcButton('5', Colors.black54, Colors.white, () => numClick('5')),
                  calcButton('6', Colors.black54, Colors.white, () => numClick('6')),
                  calcButton('-', Colors.green, Colors.white, () => numClick('-')),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  calcButton('1', Colors.black54, Colors.white, () => numClick('1')),
                  calcButton('2', Colors.black54, Colors.white, () => numClick('2')),
                  calcButton('3', Colors.black54, Colors.white, () => numClick('3')),
                  calcButton('+', Colors.green, Colors.white, () => numClick('+')),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  calcButton('0', Colors.black54, Colors.white, () => numClick('0')),
                  calcButton('.', Colors.black54, Colors.white, () => numClick('.')),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      child: ElevatedButton(
                        onPressed: evaluate,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          padding: const EdgeInsets.symmetric(vertical: 20),
                        ),
                        child: const Text(
                          '=',
                          style: TextStyle(
                            fontSize: 25,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget calcButton(String text, Color bgColor, Color textColor, Function() onPressed) {
    return Container(
      margin: const EdgeInsets.all(10),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: bgColor,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          shape: const CircleBorder(),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 22,
            color: textColor,
          ),
        ),
      ),
    );
  }
}