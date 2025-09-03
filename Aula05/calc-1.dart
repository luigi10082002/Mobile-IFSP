import 'package:flutter/material.dart';

void main() {
  runApp(const CalculadoraApp());
}

class CalculadoraApp extends StatefulWidget {
  const CalculadoraApp({super.key});

  @override
  State<CalculadoraApp> createState() => _CalculadoraAppState();
}

class _CalculadoraAppState extends State<CalculadoraApp> {
  String num1 = '';
  String num2 = '';
  bool somando = false;
  int? resultado;

  void apertarDigito(String digito) {
    setState(() {
      if (!somando) {
        num1 = (num1 == '0') ? digito : (num1 + digito);
      } else {
        num2 = (num2 == '0') ? digito : (num2 + digito);
      }
      resultado = null;
    });
  }

  void apertarSoma() {
    setState(() {
      if (num1.isNotEmpty && num2.isNotEmpty) {
        final a = int.tryParse(num1) ?? 0;
        final b = int.tryParse(num2) ?? 0;
        final r = a + b;
        num1 = r.toString();
        num2 = '';
        resultado = r;
      } else if (num1.isEmpty) {
        num1 = '0';
      }
      somando = true;
    });
  }

  void apertarIgual() {
    setState(() {
      final a = int.tryParse(num1) ?? 0;
      final b = int.tryParse(num2) ?? 0;

      if (somando) {
        final r = a + (int.tryParse(num2.isEmpty ? '0' : num2) ?? 0);
        resultado = r;

        num1 = r.toString();
        num2 = '';
        somando = false;
      }
    });
  }

  void limparTudo() {
    setState(() {
      num1 = '';
      num2 = '';
      somando = false;
      resultado = null;
    });
  }

  Widget criarBotao(String texto, VoidCallback funcao, {Color? cor}) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.all(4),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: cor ?? Colors.blue[100],
            foregroundColor: Colors.black,
            padding: const EdgeInsets.all(16),
          ),
          onPressed: funcao,
          child: Text(
            texto,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Calculadora Simples'),
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
        ),
        body: Container(
          color: Colors.grey[200],
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                color: Colors.white,
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        resultado?.toString() ??
                            (somando
                                ? '${num1.isEmpty ? '0' : num1} + ${num2.isEmpty ? '' : num2}'
                                : (num1.isEmpty ? '0' : num1)),
                        style: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.right,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: Column(
                  children: [
                    Row(
                      children: [
                        criarBotao('7', () => apertarDigito('7')),
                        criarBotao('8', () => apertarDigito('8')),
                        criarBotao('9', () => apertarDigito('9')),
                        criarBotao('C', limparTudo, cor: Colors.red[200]),
                      ],
                    ),
                    Row(
                      children: [
                        criarBotao('4', () => apertarDigito('4')),
                        criarBotao('5', () => apertarDigito('5')),
                        criarBotao('6', () => apertarDigito('6')),
                        criarBotao('+', apertarSoma, cor: Colors.green[200]),
                      ],
                    ),
                    Row(
                      children: [
                        criarBotao('1', () => apertarDigito('1')),
                        criarBotao('2', () => apertarDigito('2')),
                        criarBotao('3', () => apertarDigito('3')),
                        criarBotao('=', apertarIgual, cor: Colors.orange[200]),
                      ],
                    ),
                    Row(children: [criarBotao('0', () => apertarDigito('0'))]),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(16),
                color: Colors.blue[100],
                child: const Text(
                  'Calculadora Simples v1.0',
                  style: TextStyle(fontSize: 14),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
