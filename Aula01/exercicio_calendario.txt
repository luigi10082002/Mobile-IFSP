void main() {
  final now = DateTime.now();
  final mes = now.month;
  final ano = now.year;
  final dia = now.day; 

  final primeirodia = DateTime(ano, mes, 1);

  
  final int diasemana = primeirodia.weekday % 7;
  
  print('| D | S | T | Q | Q | S | S |');

  String linha = '|';

  for (int i = 0; i < diasemana; i++) {
    linha += '   |';
  }

  for (int d = 1; d <= dia; d++) {
    final formattedDay = d.toString().padLeft(2);
    linha += ' ${formattedDay}|';

    final int currentGridPosition = (diasemana + d - 1);

    if (currentGridPosition % 7 == 6) {
      print(linha);
      linha = '|';
    }
    else if (d == dia) {
      print(linha);
    }
  }
}