import 'package:flutter/material.dart';

class Pergunta {
  final String texto;
  final String resposta;
  final bool correta;

  Pergunta({
    required this.texto,
    required this.resposta,
    required this.correta,
  });
}

void main() {
  runApp(const PerguntasApp());
}

class PerguntasApp extends StatefulWidget {
  const PerguntasApp({super.key});

  @override
  State<PerguntasApp> createState() => _PerguntasAppState();
}

class _PerguntasAppState extends State<PerguntasApp> {
  List<Widget> resultado = [];

  int numeroPergunta = 0;

  List<Pergunta> perguntas = [
    Pergunta(
      texto: 'Qual é a capital da França?',
      resposta: 'Paris',
      correta: true,
    ),
    Pergunta(
      texto: 'Quem escreveu "Dom Quixote"?',
      resposta: 'Miguel de Cervantes',
      correta: true,
    ),
    Pergunta(
      texto: 'Qual é o maior planeta do sistema solar?',
      resposta: 'Júpiter',
      correta: true,
    ),
    Pergunta(
      texto: 'Em que ano ocorreu a Revolução Francesa?',
      resposta: '1789',
      correta: true,
    ),
    Pergunta(
      texto: 'Quem pintou a Mona Lisa?',
      resposta: 'Leonardo da Vinci',
      correta: true,
    ),
    Pergunta(
      texto: 'Qual é o elemento químico representado pelo símbolo \'O\'?',
      resposta: 'Oxigênio',
      correta: true,
    ),
    Pergunta(
      texto: 'Qual é o rio mais longo do mundo?',
      resposta: 'Rio Nilo',
      correta: false,
    ),
    Pergunta(
      texto: 'Quem foi o primeiro presidente dos Estados Unidos?',
      resposta: 'George Washington',
      correta: true,
    ),
    Pergunta(
      texto: 'Qual é o país mais populoso do mundo?',
      resposta: 'Índia',
      correta: true,
    ),
    Pergunta(
      texto: 'Qual é a fórmula química da água?',
      resposta: 'H2O',
      correta: true,
    ),
  ];

  void verificarResposta(bool respostaDoUsuario) {
    setState(() {
      if (numeroPergunta < perguntas.length) {
        if (perguntas[numeroPergunta].correta == respostaDoUsuario) {
          resultado.add(const Icon(Icons.check, color: Colors.green));
        } else {
          resultado.add(const Icon(Icons.close, color: Colors.red));
        }
        numeroPergunta++;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    bool quizConcluido = numeroPergunta >= perguntas.length;

    return MaterialApp(
      home: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  flex: 3,
                  child: Center(
                    child: quizConcluido
                        ? const Text(
                            'Quiz Concluído!',
                            style: TextStyle(
                              fontFamily: 'Quicksand',
                              fontSize: 32,
                            ),
                            textAlign: TextAlign.center,
                          )
                        : Text(
                            perguntas[numeroPergunta].texto,
                            style: const TextStyle(
                              fontFamily: 'Quicksand',
                              fontSize: 32,
                            ),
                            textAlign: TextAlign.center,
                          ),
                  ),
                ),
                if (!quizConcluido)
                  Expanded(
                    flex: 1,
                    child: Center(
                      child: Text(
                        'Resposta: ${perguntas[numeroPergunta].resposta}',
                        style: const TextStyle(
                          fontFamily: 'Quicksand',
                          fontSize: 28,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                const SizedBox(height: 20),
                if (!quizConcluido)
                  TextButton(
                    onPressed: () {
                      verificarResposta(true);
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 60),
                    ),
                    child: const Text(
                      'SIM',
                      style: TextStyle(fontFamily: 'Quicksand', fontSize: 22),
                    ),
                  ),
                const SizedBox(height: 10),
                if (!quizConcluido)
                  TextButton(
                    onPressed: () {
                      verificarResposta(false);
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 60),
                    ),
                    child: const Text(
                      'NÃO',
                      style: TextStyle(fontFamily: 'Quicksand', fontSize: 22),
                    ),
                  ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: resultado,
                ),
                if (quizConcluido)
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        numeroPergunta = 0;
                        resultado = [];
                      });
                    },
                    child: const Text('Reiniciar Quiz'),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
