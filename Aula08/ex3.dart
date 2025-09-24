import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const TabuadaApp());
}

class TabuadaApp extends StatelessWidget {
  const TabuadaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'App de Tabuada',
      theme: ThemeData(primarySwatch: Colors.green, useMaterial3: true),
      home: const TabuadaPage(),
    );
  }
}

class TabuadaPage extends StatefulWidget {
  const TabuadaPage({super.key});

  @override
  _TabuadaPageState createState() => _TabuadaPageState();
}

class _TabuadaPageState extends State<TabuadaPage> {
  final TextEditingController _respostaController = TextEditingController();

  int _currentTable = 1;
  int _currentNumber = 1;
  String _message = '';
  final String _prefKeyTable = 'currentTable';
  final String _prefKeyNumber = 'currentNumber';

  @override
  void initState() {
    super.initState();
    _loadProgress();
  }

  Future<void> _loadProgress() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _currentTable = prefs.getInt(_prefKeyTable) ?? 1;
      _currentNumber = prefs.getInt(_prefKeyNumber) ?? 1;
    });
  }

  Future<void> _saveProgress() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_prefKeyTable, _currentTable);
    await prefs.setInt(_prefKeyNumber, _currentNumber);
  }

  Future<void> _resetProgress() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_prefKeyTable);
    await prefs.remove(_prefKeyNumber);
    setState(() {
      _currentTable = 1;
      _currentNumber = 1;
      _message = 'Progresso reiniciado!';
    });
  }

  void _checkAnswer() {
    final int? resposta = int.tryParse(_respostaController.text);
    _respostaController.clear();

    if (resposta == null || resposta != _currentTable * _currentNumber) {
      setState(() {
        _message = 'Resposta incorreta! Tente novamente.';
      });
      return;
    }

    setState(() {
      _message = 'Correto!';
      if (_currentNumber < 10) {
        _currentNumber++;
      } else {
        if (_currentTable < 10) {
          _currentTable++;
          _currentNumber = 1;
        } else {
          _message = 'Parabéns! Você completou todas as tabuadas!';
          _resetProgress();
        }
      }
      _saveProgress();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Treinador de Tabuada'),
        centerTitle: true,
        backgroundColor: Colors.green[700],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Text(
                  'Tabuada do $_currentTable',
                  style: const TextStyle(
                    fontSize: 32.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                Text(
                  '$_currentTable x $_currentNumber = ?',
                  style: TextStyle(
                    fontSize: 48.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.green[800],
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 30),
                TextField(
                  controller: _respostaController,
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 24.0),
                  decoration: InputDecoration(
                    labelText: 'Sua resposta',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                  ),
                  onSubmitted: (value) => _checkAnswer(),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _checkAnswer,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                  ),
                  child: const Text(
                    'Verificar',
                    style: TextStyle(fontSize: 20.0, color: Colors.white),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  _message,
                  style: TextStyle(
                    fontSize: 18.0,
                    color: _message.contains('Correto')
                        ? Colors.green
                        : Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40),
                OutlinedButton(
                  onPressed: _resetProgress,
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    side: const BorderSide(color: Colors.green),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                  ),
                  child: const Text(
                    'Reiniciar Progresso',
                    style: TextStyle(fontSize: 16.0, color: Colors.green),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
