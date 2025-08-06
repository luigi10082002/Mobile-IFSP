import 'aluno.dart';

void main() {
  Aluno aluno = Aluno(
    nome: "Fulano de Tal",
    matricula: "123456",
    notas: [6.3, 5.2, 9.4],
  );

  aluno.exibirInfo();
}
