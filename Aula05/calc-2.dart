import 'package:flutter/material.dart';

void main() {
  runApp(const AppCalculadora());
}

class AppCalculadora extends StatefulWidget {
  const AppCalculadora({super.key});

  @override
  State<AppCalculadora> createState() => _EstadoAppCalculadora();
}

class _EstadoAppCalculadora extends State<AppCalculadora> {
  String numero1 = '';
  String numero2 = '';
  bool botaoSomaPressionado = false;
  int? resultado;

  void apertarNumero(String numero) {
    setState(() {
      if (!botaoSomaPressionado) {
        numero1 = (numero1 == '0') ? numero : (numero1 + numero);
      } else {
        numero2 = (numero2 == '0') ? numero : (numero2 + numero);
      }
      resultado = null;
    });
  }

  void apertarSoma() {
    setState(() {
      if (numero1.isNotEmpty && numero2.isNotEmpty) {
        final valor1 = int.tryParse(numero1) ?? 0;
        final valor2 = int.tryParse(numero2) ?? 0;
        final total = valor1 + valor2;
        numero1 = total.toString();
        numero2 = '';
        resultado = total;
      } else if (numero1.isEmpty) {
        numero1 = '0';
      }
      botaoSomaPressionado = true;
    });
  }

  void apertarIgual() {
    setState(() {
      if (resultado != null && numero2.isEmpty && !botaoSomaPressionado) {
        numero1 = '';
        numero2 = '';
        resultado = null;
        botaoSomaPressionado = false;
      } else {
        final valor1 = int.tryParse(numero1) ?? 0;
        final valor2 = int.tryParse(numero2) ?? 0;

        if (botaoSomaPressionado) {
          final total =
              valor1 + (int.tryParse(numero2.isEmpty ? '0' : numero2) ?? 0);
          resultado = total;

          numero1 = total.toString();
          numero2 = '';
          botaoSomaPressionado = false;
        }
      }
    });
  }

  void limparTudo() {
    setState(() {
      numero1 = '';
      numero2 = '';
      botaoSomaPressionado = false;
      resultado = null;
    });
  }

  Widget criarBotao(String texto, VoidCallback funcao, {Color? corFundo}) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.all(6),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: corFundo ?? Colors.blue[200],
            foregroundColor: Colors.black,
            padding: const EdgeInsets.all(16),
          ),
          onPressed: funcao,
          child: Text(
            texto,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
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
                padding: const EdgeInsets.all(20),
                color: Colors.white,
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            botaoSomaPressionado
                                ? '${numero1.isEmpty ? '0' : numero1} + ${numero2.isEmpty ? '' : numero2}'
                                : (numero1.isEmpty ? '0' : numero1),
                            style: const TextStyle(fontSize: 28),
                            textAlign: TextAlign.right,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            resultado != null ? 'Resultado: $resultado' : '',
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue,
                            ),
                            textAlign: TextAlign.right,
                          ),
                        ),
                      ],
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
                        criarBotao('7', () => apertarNumero('7')),
                        criarBotao('8', () => apertarNumero('8')),
                        criarBotao('9', () => apertarNumero('9')),
                        criarBotao('C', limparTudo, corFundo: Colors.red[200]),
                      ],
                    ),
                    Row(
                      children: [
                        criarBotao('4', () => apertarNumero('4')),
                        criarBotao('5', () => apertarNumero('5')),
                        criarBotao('6', () => apertarNumero('6')),
                        criarBotao(
                          '+',
                          apertarSoma,
                          corFundo: Colors.green[200],
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        criarBotao('1', () => apertarNumero('1')),
                        criarBotao('2', () => apertarNumero('2')),
                        criarBotao('3', () => apertarNumero('3')),
                        criarBotao(
                          '=',
                          apertarIgual,
                          corFundo: Colors.orange[200],
                        ),
                      ],
                    ),
                    Row(children: [criarBotao('0', () => apertarNumero('0'))]),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(16),
                color: Colors.blue[100],
                child: const Text(
                  'Calculadora Básica v1.0',
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
