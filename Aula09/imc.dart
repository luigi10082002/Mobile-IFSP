import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:math';

const double kBottomContainerHeight = 80.0;
const Color kActiveCardColor = Color(0xFF638ED6);
const Color kInactiveCardColor = Color(0xFF1E164B);
const Color kBottomContainerColor = Color(0xFF638ED6);
const Color kBackgroundColor = Color(0xFF0A0E21);

const TextStyle kLabelTextStyle = TextStyle(
  fontSize: 18.0,
  color: Colors.grey,
);

const TextStyle kNumberTextStyle = TextStyle(
  fontSize: 50.0,
  fontWeight: FontWeight.w900,
  color: Colors.white,
);

const TextStyle kLargeButtonTextStyle = TextStyle(
  fontSize: 25.0,
  fontWeight: FontWeight.bold,
  color: Colors.white,
);

const TextStyle kResultTextStyle = TextStyle(
  fontSize: 28.0,
  fontWeight: FontWeight.bold,
  color: Colors.white,
);

enum Gender {
  male,
  female,
}

class BMIModel extends ChangeNotifier {
  Gender _selectedGender;
  double _height;
  int _weight;
  double _bmiResult;

  BMIModel()
      : _selectedGender = Gender.male,
        _height = 170.0,
        _weight = 70,
        _bmiResult = 0.0 {
    calculateBMI();
  }

  Gender get selectedGender => _selectedGender;
  double get height => _height;
  int get weight => _weight;
  double get bmiResult => _bmiResult;

  void setGender(Gender gender) {
    if (_selectedGender != gender) {
      _selectedGender = gender;
      notifyListeners();
    }
  }

  void setHeight(double newHeight) {
    if (_height != newHeight) {
      _height = newHeight;
      calculateBMI();
      notifyListeners();
    }
  }

  void incrementWeight() {
    if (_weight < 200) {
      _weight++;
      calculateBMI();
      notifyListeners();
    }
  }

  void decrementWeight() {
    if (_weight > 20) {
      _weight--;
      calculateBMI();
      notifyListeners();
    }
  }

  void calculateBMI() {
    if (_height > 0 && _weight > 0) {
      double heightInMeters = _height / 100.0;
      _bmiResult = _weight / pow(heightInMeters, 2);
    } else {
      _bmiResult = 0.0;
    }
  }
}

void main() {
  runApp(const BMIApp());
}

class BMIApp extends StatelessWidget {
  const BMIApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<BMIModel>(
      create: (BuildContext context) => BMIModel(),
      builder: (BuildContext context, Widget? child) {
        return MaterialApp(
          theme: ThemeData.dark().copyWith(
            primaryColor: kBackgroundColor,
            scaffoldBackgroundColor: kBackgroundColor,
            appBarTheme: const AppBarTheme(
              backgroundColor: kBackgroundColor,
            ),
          ),
          debugShowCheckedModeBanner: false,
          home: const HomePage(),
        );
      },
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final BMIModel bmiModel = Provider.of<BMIModel>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('CALCULADORA IMC')),
      body: Column(
        children: <Widget>[
          Expanded(
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Caixa(
                    onTap: () {
                      bmiModel.setGender(Gender.male);
                    },
                    cor: bmiModel.selectedGender == Gender.male ? kActiveCardColor : kInactiveCardColor,
                    filho: IconContent(
                      icon: Icons.male,
                      label: 'MASCULINO',
                    ),
                  ),
                ),
                Expanded(
                  child: Caixa(
                    onTap: () {
                      bmiModel.setGender(Gender.female);
                    },
                    cor: bmiModel.selectedGender == Gender.female ? kActiveCardColor : kInactiveCardColor,
                    filho: IconContent(
                      icon: Icons.female,
                      label: 'FEMININO',
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Caixa(
              cor: kInactiveCardColor,
              filho: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Text('ALTURA', style: kLabelTextStyle),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: <Widget>[
                      Text(
                        bmiModel.height.round().toString(),
                        style: kNumberTextStyle,
                      ),
                      const Text(
                        'cm',
                        style: kLabelTextStyle,
                      ),
                    ],
                  ),
                  SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      inactiveTrackColor: const Color(0xFF8D8E98),
                      activeTrackColor: Colors.white,
                      thumbColor: kBottomContainerColor,
                      overlayColor: const Color(0x29EB1555),
                      thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 15.0),
                      overlayShape: const RoundSliderOverlayShape(overlayRadius: 30.0),
                    ),
                    child: Slider(
                      value: bmiModel.height,
                      min: 100.0,
                      max: 220.0,
                      onChanged: (double newValue) {
                        bmiModel.setHeight(newValue);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Caixa(
                    cor: kInactiveCardColor,
                    filho: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        const Text('PESO', style: kLabelTextStyle),
                        Text(
                          bmiModel.weight.toString(),
                          style: kNumberTextStyle,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            RoundIconButton(
                              icon: Icons.remove,
                              onPressed: () {
                                bmiModel.decrementWeight();
                              },
                            ),
                            const SizedBox(width: 10.0),
                            RoundIconButton(
                              icon: Icons.add,
                              onPressed: () {
                                bmiModel.incrementWeight();
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Caixa(
                    cor: kInactiveCardColor,
                    filho: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        const Text('RESULTADO IMC', style: kLabelTextStyle),
                        Text(
                          bmiModel.bmiResult.toStringAsFixed(1),
                          style: kResultTextStyle,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              bmiModel.calculateBMI();
            },
            child: Container(
              color: kBottomContainerColor,
              width: double.infinity,
              height: kBottomContainerHeight,
              margin: const EdgeInsets.only(top: 10.0),
              padding: const EdgeInsets.only(bottom: 10.0),
              child: const Center(
                child: Text(
                  'CALCULAR',
                  style: kLargeButtonTextStyle,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class Caixa extends StatelessWidget {
  final Color cor;
  final Widget? filho;
  final VoidCallback? onTap;

  const Caixa({super.key, required this.cor, this.filho, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          color: cor,
        ),
        child: filho,
      ),
    );
  }
}

class IconContent extends StatelessWidget {
  final IconData icon;
  final String label;

  const IconContent({super.key, required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Icon(
          icon,
          size: 80.0,
          color: Colors.white,
        ),
        const SizedBox(height: 15.0),
        Text(
          label,
          style: kLabelTextStyle,
        ),
      ],
    );
  }
}

class RoundIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;

  const RoundIconButton({super.key, required this.icon, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      elevation: 6.0,
      constraints: const BoxConstraints.tightFor(
        width: 56.0,
        height: 56.0,
      ),
      onPressed: onPressed,
      shape: const CircleBorder(),
      fillColor: const Color(0xFF4C4F5E),
      child: Icon(icon, color: Colors.white),
    );
  }
}
