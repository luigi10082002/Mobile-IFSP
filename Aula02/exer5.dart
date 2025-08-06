import 'package:flutter/material.dart';

void main() {
  runApp(const CotacaoDolarApp());
}

class CotacaoDolarApp extends StatelessWidget {
  const CotacaoDolarApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cotação do Dólar',
      home: Scaffold(
        appBar: AppBar(title: const Text('Cotação do Dólar')),
        body: const Center(child: CotacaoWidget()),
      ),
    );
  }
}

class CotacaoWidget extends StatelessWidget {
  const CotacaoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final double cotacao = 5.25;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          'Cotação do Dólar',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 20),
        Text('Data: 03/07/2025', style: const TextStyle(fontSize: 18)),
        const SizedBox(height: 10),
        Text(
          'R\$ ${cotacao.toStringAsFixed(2)}',
          style: const TextStyle(fontSize: 30, color: Colors.green),
        ),
      ],
    );
  }
}
