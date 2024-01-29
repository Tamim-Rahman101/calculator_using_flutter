import 'package:calculator_app/button_values.dart';
import 'package:flutter/material.dart';

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String num1 = ""; // . 0-9
  String operand = ""; // + - x / %
  String num2 = "";

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Column(children: [
          //output
          Expanded(
            child: SingleChildScrollView(
              reverse: true,
              child: Container(
                alignment: Alignment.bottomRight,
                padding: const EdgeInsets.all(16),
                child: Text(
                  "$num1$operand$num2".isEmpty ? "0" : "$num1$operand$num2",
                  style: const TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.end,
                ),
              ),
            ),
          ),

          //buttons
          Wrap(
            children: Btn.buttonValues
                .map((value) => SizedBox(
                    width: value == Btn.n0
                        ? screenSize.width / 2
                        : screenSize.width / 4,
                    height: screenSize.width / 5,
                    child: buildButton(value)))
                .toList(),
          )
        ]),
      ),
    );
  }

  Widget buildButton(value) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Material(
        color: getBtnColor(value),
        clipBehavior: Clip.hardEdge,
        shape: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.white),
            borderRadius: BorderRadius.circular(100)),
        child: InkWell(
          onTap: () => onBtnTap(value),
          child: Center(
              child: Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
          )),
        ),
      ),
    );
  }

  void onBtnTap(String value) {
    if (value == Btn.del) {
      delete();
      return;
    }

    if(value == Btn.clr){
      clearAll();
      return;
    }

    if(value == Btn.per){
      convertToPer();
      return;
    }

    if(value == Btn.calculate){
      calculate();
      return;
    }
    appendValue(value);
  }

  void calculate(){
    if(num1.isEmpty || operand.isEmpty || num2.isEmpty)
    return;

    final double n1 = double.parse(num1);
    final double n2 = double.parse(num2);
    
    var result = 0.0;
    switch(operand){
      case Btn.add:
      result = n1 + n2;
      break;

      case Btn.subtract:
      result = n1 - n2;
      break;

      case Btn.multiply:
      result = n1 * n2;
      break;

      case Btn.divide:
      result = n1 / n2;
      break;

      default:
    }

    setState(() {
      num1 = "$result";

      if(num1.endsWith(".0")){
        num1 = num1.substring(0, num1.length - 2);
      }

      operand = "";
      num2 = "";
    });
  }

  void convertToPer(){
    if(num1.isNotEmpty && operand.isNotEmpty && num2.isNotEmpty){
      calculate();
    }
    if(operand.isNotEmpty){
      return;
    }

    final number = double.parse(num1);
    setState(() {
      num1 = "${(number/100)}";
      operand = "";
      num2 = "";
    });
  }

  void clearAll(){
    setState(() {
      num1 = "";
      operand = "";
      num2 = "";
    });
  }

  void delete() {
    if (num2.isNotEmpty) {
      num2 = num2.substring(0, num2.length - 1);
    } else if (operand.isNotEmpty) {
      operand = "";
    } else if (num1.isNotEmpty) {
      num1 = num1.substring(0, num1.length - 1);
    }

    setState(() {});
  }

  void appendValue(String value) {
    //tries to convert value into int
    if (value != Btn.dot && int.tryParse(value) == null) {
      if (operand.isNotEmpty && num2.isNotEmpty) {
        calculate();
      }
      operand = value;
    } else if (num1.isEmpty || operand.isEmpty) {
      if (value == Btn.dot && num1.contains(Btn.dot)) return;
      if (value == Btn.dot && (num1.isEmpty || num1 == Btn.n0)) {
        value = "0.";
      }
      num1 += value;
    } else if (num2.isEmpty || operand.isNotEmpty) {
      if (value == Btn.dot && num2.contains(Btn.dot)) return;
      if (value == Btn.dot && (num2.isEmpty || num2 == Btn.n0)) {
        value = "0.";
      }
      num2 += value;
    }
    setState(() {});
  }

  Color getBtnColor(value) {
    return [Btn.del, Btn.clr].contains(value)
        ? Colors.blueGrey
        : [
            Btn.per,
            Btn.multiply,
            Btn.subtract,
            Btn.add,
            Btn.subtract,
            Btn.divide,
            Btn.calculate
          ].contains(value)
            ? Colors.orange
            : Colors.black;
  }
}
