import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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
    DateTime dataCotacao = DateTime.now().subtract(const Duration(days: 1));

    if (dataCotacao.weekday == DateTime.sunday) {
      dataCotacao = dataCotacao.subtract(const Duration(days: 2));
    }

    String dataFormatada = DateFormat('dd/MM/yyyy').format(dataCotacao);

    double cotacao = _simularCotacao(dataCotacao);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          'Cotação do Dólar',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 20),
        Text('Data: $dataFormatada', style: const TextStyle(fontSize: 18)),
        const SizedBox(height: 10),
        Text(
          'R\$ ${cotacao.toStringAsFixed(2)}',
          style: const TextStyle(fontSize: 30, color: Colors.green),
        ),
      ],
    );
  }

  double _simularCotacao(DateTime data) {
    return 5.00 + (data.day % 10) * 0.05;
  }
}
