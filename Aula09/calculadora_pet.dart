import 'package:flutter/material.dart';

void main() {
  runApp(const PetAgeCalculatorApp());
}

const Color corFundoScaffold = Color(0xFF0F0B30);
const Color corFundoCard = Color(0xFF1E164B);
const Color corSelecionada = Color.fromARGB(255, 60, 20, 180);
const Color corBotoes = Color(0xFF4C4F5E);
const Color corTextoSecundario = Color(0xFF8D8E98);
const Color corDestaque = Color(0xFFEB1555);

enum Especie { gato, cachorro }
enum PesoCategoria { pequeno, medio, grande, gigante }

const Map<int, int> _catAgeData = {
  1: 15,
  2: 24,
  3: 28,
  4: 32,
  5: 36,
  6: 40,
  7: 44,
  8: 48,
  9: 52,
  10: 56,
  11: 60,
  12: 64,
  13: 68,
  14: 72,
  15: 76,
  16: 80,
  17: 84,
  18: 88,
  19: 92,
  20: 96,
  21: 100,
};

const Map<int, List<int>> _dogAgeData = {
  1: [15, 15, 15, 15],
  2: [24, 24, 24, 24],
  3: [28, 28, 30, 32],
  4: [32, 33, 35, 37],
  5: [36, 37, 40, 42],
  6: [40, 42, 45, 49],
  7: [44, 47, 50, 56],
  8: [48, 51, 55, 64],
  9: [52, 56, 61, 71],
  10: [56, 60, 66, 78],
  11: [60, 65, 72, 86],
  12: [64, 69, 77, 93],
  13: [68, 74, 82, 101],
  14: [72, 78, 88, 108],
  15: [76, 83, 93, 115],
  16: [80, 87, 99, 123],
  17: [84, 92, 104, 0],
  18: [88, 96, 109, 0],
  19: [92, 101, 115, 0],
  20: [96, 105, 120, 0],
};

class PetAgeCalculatorApp extends StatefulWidget {
  const PetAgeCalculatorApp({super.key});

  @override
  State<PetAgeCalculatorApp> createState() => _PetAgeCalculatorAppState();
}

class _PetAgeCalculatorAppState extends State<PetAgeCalculatorApp> {
  Especie especieSelecionada = Especie.cachorro;
  int idadePet = 3;
  double pesoPet = 15.0;

  String _calculatePhysiologicalAge() {
    int idadeHumana = 0;

    if (especieSelecionada == Especie.gato && idadePet == 0) {
      return '10 anos';
    }

    if (especieSelecionada == Especie.gato) {
      idadeHumana = _catAgeData[idadePet] ?? _catAgeData[21]!;
    } else {
      final int pesoIndex = _getDogWeightIndex(pesoPet);
      final List<int>? ages = _dogAgeData[idadePet];

      if (ages != null && pesoIndex < ages.length) {
        idadeHumana = ages[pesoIndex];
      } else {
        idadeHumana = _dogAgeData[20]![pesoIndex];
      }
      
      if (idadeHumana == 0) return 'Sem dados';
    }

    return '$idadeHumana anos';
  }

  int _getDogWeightIndex(double peso) {
    if (peso <= 9.07) return 0;
    if (peso <= 22.7) return 1;
    if (peso <= 40.8) return 2;
    return 3;
  }
  
  String _getWeightCategoryLabel(double peso) {
    if (peso <= 9.07) return 'Pequeno (≤ 9.07 kg)';
    if (peso <= 22.7) return 'Médio (9.5-22.7 kg)';
    if (peso <= 40.8) return 'Grande (23.1-40.8 kg)';
    return 'Gigante (> 40.8 kg)';
  }

  @override
  void initState() {
    super.initState();
    idadePet = 3;
  }

  @override
  Widget build(BuildContext context) {
    final String resultado = _calculatePhysiologicalAge();
    final String pesoLabel = _getWeightCategoryLabel(pesoPet);

    return MaterialApp(
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: corFundoScaffold,
        appBarTheme: const AppBarTheme(
          backgroundColor: corFundoScaffold,
          centerTitle: true,
        ),
        textTheme: const TextTheme(
          titleLarge: TextStyle(color: Colors.white, fontSize: 25.0, fontWeight: FontWeight.bold),
          bodyMedium: TextStyle(color: corTextoSecundario, fontSize: 18.0),
        ),
        sliderTheme: SliderTheme.of(context).copyWith(
          inactiveTrackColor: corTextoSecundario,
          activeTrackColor: Colors.white,
          thumbColor: corDestaque,
          overlayColor: const Color(0x29EB1555),
          thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 10.0),
          overlayShape: const RoundSliderOverlayShape(overlayRadius: 20.0),
        ),
      ),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('IDADE FISIOLÓGICA PET'),
          elevation: 0,
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            especieSelecionada = Especie.gato;
                            idadePet = 3;
                          });
                        },
                        child: Caixa(
                          cor: especieSelecionada == Especie.gato ? corSelecionada : corFundoCard,
                          filho: const ConteudoIcone(icone: Icons.cruelty_free, texto: 'GATO'),
                        ),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            especieSelecionada = Especie.cachorro;
                            idadePet = 3;
                          });
                        },
                        child: Caixa(
                          cor: especieSelecionada == Especie.cachorro ? corSelecionada : corFundoCard,
                          filho: const ConteudoIcone(icone: Icons.pets, texto: 'CACHORRO'),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              
              Expanded(
                child: Caixa(
                  cor: corFundoCard,
                  filho: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'IDADE DO PET (ANOS)',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        idadePet.toString(),
                        style: const TextStyle(
                          fontSize: 50.0,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          BotaoCircular(
                            icone: Icons.remove,
                            aoPressionar: () {
                              setState(() {
                                if (idadePet > 0) { 
                                  idadePet--;
                                }
                              });
                            },
                          ),
                          const SizedBox(width: 15.0),
                          BotaoCircular(
                            icone: Icons.add,
                            aoPressionar: () {
                              setState(() {
                                if (idadePet < 21) { 
                                  idadePet++;
                                }
                              });
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              Visibility(
                visible: especieSelecionada == Especie.cachorro,
                child: Expanded(
                  child: Caixa(
                    cor: corFundoCard,
                    filho: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'PESO (KG)',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        const SizedBox(height: 5),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.baseline,
                          textBaseline: TextBaseline.alphabetic,
                          children: [
                            Text(
                              pesoPet.toStringAsFixed(1),
                              style: const TextStyle(
                                fontSize: 40.0,
                                fontWeight: FontWeight.w900,
                                color: Colors.white,
                              ),
                            ),
                            const Text(
                              'kg',
                              style: TextStyle(fontSize: 18.0, color: corTextoSecundario),
                            ),
                          ],
                        ),
                        Text(
                          'Categoria: $pesoLabel',
                          style: const TextStyle(fontSize: 14.0, color: corDestaque),
                        ),
                        Slider(
                          min: 1.0,
                          max: 60.0,
                          value: pesoPet,
                          onChanged: (double x) {
                            setState(() {
                              pesoPet = x;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              Expanded(
                child: Caixa(
                  cor: corSelecionada,
                  filho: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'IDADE FISIOLÓGICA',
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                              color: Colors.white,
                              fontSize: 20,
                            ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        resultado,
                        style: const TextStyle(
                          fontSize: 60.0,
                          fontWeight: FontWeight.w900,
                          color: Color(0xFF24D876),
                        ),
                      ),
                      Text(
                        especieSelecionada == Especie.gato
                            ? (idadePet == 0 ? '(6 meses)' : '(Seu Gato de $idadePet anos)')
                            : '(Seu Cachorro de $idadePet anos)',
                        style: const TextStyle(fontSize: 16.0, color: Colors.white70),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ConteudoIcone extends StatelessWidget {
  final IconData icone;
  final String texto;

  const ConteudoIcone({super.key, required this.icone, required this.texto});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          icone,
          color: Colors.white,
          size: 60.0,
        ),
        const SizedBox(height: 15),
        Text(
          texto,
          style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                color: Colors.white,
              ),
        )
      ],
    );
  }
}

class BotaoCircular extends StatelessWidget {
  final IconData icone;
  final VoidCallback aoPressionar;

  const BotaoCircular({super.key, required this.icone, required this.aoPressionar});

  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      elevation: 6.0,
      constraints: const BoxConstraints.tightFor(
        width: 50.0,
        height: 50.0,
      ),
      shape: const CircleBorder(),
      fillColor: corBotoes,
      onPressed: aoPressionar,
      child: Icon(icone, color: Colors.white),
    );
  }
}

class Caixa extends StatelessWidget {
  final Color cor;
  final Widget? filho;

  const Caixa({super.key, required this.cor, this.filho});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.0),
        color: cor,
      ),
      child: filho,
    );
  }
}
