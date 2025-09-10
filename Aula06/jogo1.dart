import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Pedra, Papel, Tesoura',
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.blue,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue[600],
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.0),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            textStyle:
                const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
      ),
      home: const RockPaperScissorsGame(),
    );
  }
}

class RockPaperScissorsGame extends StatefulWidget {
  const RockPaperScissorsGame({super.key});

  @override
  State<RockPaperScissorsGame> createState() => _RockPaperScissorsGameState();
}

class _RockPaperScissorsGameState extends State<RockPaperScissorsGame> {
  final List<String> _options = ['Pedra', 'Papel', 'Tesoura'];
  final Random _random = Random();

  String _userChoice = '';
  String _computerChoice = '';
  String _result = 'Escolha sua jogada!';

  void _playGame(String userChoice) {
    setState(() {
      _userChoice = userChoice;
      _computerChoice = _options[_random.nextInt(_options.length)];
      _result = _getWinner(_userChoice, _computerChoice);
    });
  }

  String _getWinner(String user, String computer) {
    if (user == computer) {
      return 'Empate!';
    } else if ((user == 'Pedra' && computer == 'Tesoura') ||
        (user == 'Papel' && computer == 'Pedra') ||
        (user == 'Tesoura' && computer == 'Papel')) {
      return 'Você ganhou!';
    } else {
      return 'A máquina ganhou!';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pedra, Papel, Tesoura'),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Escolha da Máquina: $_computerChoice',
                style:
                    const TextStyle(fontSize: 20, fontStyle: FontStyle.italic),
              ),
              const SizedBox(height: 20),
              Text(
                'Sua escolha: $_userChoice',
                style:
                    const TextStyle(fontSize: 20, fontStyle: FontStyle.italic),
              ),
              const SizedBox(height: 40),
              Text(
                _result,
                style:
                    const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: _options.map((choice) {
                  return Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: ElevatedButton(
                        onPressed: () => _playGame(choice),
                        child: Text(choice),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
