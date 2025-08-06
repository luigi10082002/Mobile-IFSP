class Aluno {
  String nome;
  String matricula;
  List<double> notas;

  Aluno({required this.nome, required this.matricula, required this.notas});

  void lancaNota(double nota) {
    notas.add(nota);
  }

  double calcularMedia() {
    if (notas.isEmpty) return 0.0;
    double soma = notas.reduce((a, b) => a + b);
    return soma / notas.length;
  }

  void exibirInfo() {
    print('Nome: $nome');
    print('Matrícula: $matricula');
    print('Notas: $notas');
  }
}
