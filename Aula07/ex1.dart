import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'dart:math' as math;

class CircleCalculator extends ChangeNotifier {
  double? _radius;
  double? _area;
  String? _errorMessage;

  double? get radius => _radius;
  double? get area => _area;
  String? get errorMessage => _errorMessage;

  void setRadius(String radiusText) {
    _errorMessage = null;
    _area = null;
    _radius = null;

    if (radiusText.isEmpty) {
      _errorMessage = 'O raio não pode ser vazio.';
      notifyListeners();
      return;
    }

    final double? parsedRadius = double.tryParse(
      radiusText.replaceAll(',', '.'),
    );

    if (parsedRadius == null) {
      _errorMessage = 'Por favor, insira um número válido para o raio.';
    } else if (parsedRadius < 0) {
      _errorMessage = 'O raio não pode ser negativo.';
    } else {
      _radius = parsedRadius;
      _area = _calculateArea(parsedRadius);
    }
    notifyListeners();
  }

  double _calculateArea(double r) {
    return math.pi * r * r;
  }

  void clear() {
    _radius = null;
    _area = null;
    _errorMessage = null;
    notifyListeners();
  }
}

class RadiusInputScreen extends StatefulWidget {
  const RadiusInputScreen({super.key});

  @override
  State<RadiusInputScreen> createState() => _RadiusInputScreenState();
}

class _RadiusInputScreenState extends State<RadiusInputScreen> {
  late final TextEditingController _radiusController;

  @override
  void initState() {
    super.initState();
    _radiusController = TextEditingController();
    final double? initialRadius = context.read<CircleCalculator>().radius;
    if (initialRadius != null) {
      _radiusController.text = initialRadius.toString();
    }
  }

  @override
  void dispose() {
    _radiusController.dispose();
    super.dispose();
  }

  void _calculateAndNavigate() {
    final CircleCalculator calculator = context.read<CircleCalculator>();
    calculator.setRadius(_radiusController.text);

    if (calculator.errorMessage == null) {
      Navigator.of(context).push<void>(
        MaterialPageRoute<void>(
          builder: (BuildContext context) => const AreaDisplayScreen(),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(calculator.errorMessage!),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final CircleCalculator calculator = context.watch<CircleCalculator>();
    return Scaffold(
      appBar: AppBar(title: const Text('Calculadora de Círculo')),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 48),
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    'Insira o Raio do Círculo',
                    style: GoogleFonts.poppins(
                      fontSize: 26,
                      fontWeight: FontWeight.w700,
                      color: Colors.indigo[800],
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  TextFormField(
                    controller: _radiusController,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    decoration: InputDecoration(
                      labelText: 'Raio do Círculo',
                      hintText: 'Ex: 10.5',
                      prefixIcon: const Icon(Icons.circle_outlined),
                      suffixIcon: _radiusController.text.isNotEmpty
                          ? IconButton(
                              icon: const Icon(
                                Icons.clear,
                                color: Colors.blueGrey,
                              ),
                              onPressed: () {
                                _radiusController.clear();
                                calculator.clear();
                              },
                            )
                          : null,
                      errorText: calculator.errorMessage,
                    ),
                    onChanged: (String value) {
                      setState(() {
                        if (calculator.errorMessage != null) {
                          calculator.clear();
                        }
                      });
                    },
                  ),
                  const SizedBox(height: 32),
                  ElevatedButton.icon(
                    onPressed: _calculateAndNavigate,
                    icon: const Icon(Icons.calculate),
                    label: Text(
                      'Calcular Área',
                      style: GoogleFonts.poppins(fontSize: 18),
                    ),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.indigo,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 30,
                        vertical: 15,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class AreaDisplayScreen extends StatelessWidget {
  const AreaDisplayScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final CircleCalculator calculator = context.watch<CircleCalculator>();
    final NumberFormat formatter = NumberFormat('0.00', 'pt_BR');

    Widget content;

    if (calculator.errorMessage != null) {
      content = Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const Icon(Icons.error_outline, color: Colors.redAccent, size: 48),
          const SizedBox(height: 16),
          Text(
            'Erro: ${calculator.errorMessage!}',
            style: GoogleFonts.poppins(
              color: Colors.redAccent,
              fontSize: 22,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(Icons.arrow_back),
            label: Text('Voltar', style: GoogleFonts.poppins(fontSize: 16)),
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: Colors.indigo,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      );
    } else if (calculator.area != null && calculator.radius != null) {
      content = Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const Icon(Icons.blur_circular, color: Colors.indigo, size: 64),
          const SizedBox(height: 24),
          Text(
            'Raio informado:',
            style: GoogleFonts.poppins(fontSize: 20, color: Colors.indigo[600]),
            textAlign: TextAlign.center,
          ),
          Text(
            formatter.format(calculator.radius!),
            style: GoogleFonts.poppins(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.indigo[800],
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          Text(
            'A Área do Círculo é:',
            style: GoogleFonts.poppins(fontSize: 20, color: Colors.indigo[600]),
            textAlign: TextAlign.center,
          ),
          Text(
            formatter.format(calculator.area!),
            style: GoogleFonts.poppins(
              fontSize: 48,
              fontWeight: FontWeight.bold,
              color: Colors.indigo[900],
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 48),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(Icons.arrow_back),
            label: Text(
              'Voltar para Entrada',
              style: GoogleFonts.poppins(fontSize: 16),
            ),
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: Colors.indigo,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      );
    } else {
      content = Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const Icon(Icons.info_outline, color: Colors.blueGrey, size: 48),
          const SizedBox(height: 16),
          Text(
            'Nenhum raio foi fornecido para calcular a área.',
            style: GoogleFonts.poppins(
              fontSize: 20,
              color: Colors.blueGrey[600],
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(Icons.arrow_back),
            label: Text('Voltar', style: GoogleFonts.poppins(fontSize: 16)),
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: Colors.indigo,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Resultado do Cálculo')),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: Padding(padding: const EdgeInsets.all(32.0), child: content),
        ),
      ),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Calculadora de Círculo',
      theme: ThemeData(
        primaryColor: Colors.indigo,
        primarySwatch: Colors.indigo,
        scaffoldBackgroundColor: Colors.indigo[50],
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.indigo,
          elevation: 4,
          foregroundColor: Colors.white,
          titleTextStyle: GoogleFonts.poppins(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme)
            .apply(
              bodyColor: Colors.indigo[900],
              displayColor: Colors.indigo[900],
            ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.indigo, width: 2),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.redAccent, width: 2),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.redAccent, width: 2),
          ),
          labelStyle: TextStyle(color: Colors.indigo[600]),
          hintStyle: TextStyle(color: Colors.indigo[400]),
          prefixIconColor: Colors.indigo[400],
          suffixIconColor: Colors.blueGrey[400],
          errorStyle: GoogleFonts.poppins(
            color: Colors.redAccent,
            fontSize: 12,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.indigo,
            foregroundColor: Colors.white,
            textStyle: GoogleFonts.poppins(fontWeight: FontWeight.w600),
          ),
        ),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: ChangeNotifierProvider<CircleCalculator>(
        create: (BuildContext context) => CircleCalculator(),
        builder: (context, child) => const RadiusInputScreen(),
      ),
    );
  }
}

void main() {
  runApp(const MyApp());
}
