import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'dart:math' as math;

class CircleCalculator extends ChangeNotifier {
  double? _radius;
  double? _diameter;
  double? _circumference;
  double? _area;
  String? _errorMessage;

  double? get radius => _radius;
  double? get diameter => _diameter;
  double? get circumference => _circumference;
  double? get area => _area;
  String? get errorMessage => _errorMessage;

  void setRadius(String radiusText) {
    _errorMessage = null;
    _radius = null;
    _diameter = null;
    _circumference = null;
    _area = null;

    if (radiusText.isEmpty) {
      _errorMessage = 'O raio não pode ser vazio.';
      notifyListeners();
      return;
    }

    final double? parsedRadius =
        double.tryParse(radiusText.replaceAll(',', '.'));

    if (parsedRadius == null) {
      _errorMessage = 'Por favor, insira um número válido para o raio.';
    } else if (parsedRadius < 0) {
      _errorMessage = 'O raio não pode ser negativo.';
    } else {
      _radius = parsedRadius;
      _diameter = 2 * _radius!;
      _circumference = 2 * math.pi * _radius!;
      _area = math.pi * _radius! * _radius!;
    }
    notifyListeners();
  }

  void clear() {
    _radius = null;
    _diameter = null;
    _circumference = null;
    _area = null;
    _errorMessage = null;
    notifyListeners();
  }
}

class CircleCalculatorScreen extends StatefulWidget {
  const CircleCalculatorScreen({super.key});

  @override
  State<CircleCalculatorScreen> createState() => _CircleCalculatorScreenState();
}

class _CircleCalculatorScreenState extends State<CircleCalculatorScreen>
    with SingleTickerProviderStateMixin {
  late final TextEditingController _radiusController;
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _radiusController = TextEditingController();
    _tabController = TabController(length: 4, vsync: this);

    // Set initial radius if available from the model
    final double? initialRadius = context.read<CircleCalculator>().radius;
    if (initialRadius != null) {
      _radiusController.text = initialRadius.toString();
    }

    // Listener for tab changes, can be used to clear errors if needed
    _tabController.addListener(() {
      if (_tabController.index == 0) {
        // If navigating back to Radius tab, clear error if any to allow re-entry
        final CircleCalculator calculator = context.read<CircleCalculator>();
        if (calculator.errorMessage != null) {
          calculator.clear(); // Clear only the error, not the radius
        }
      }
    });
  }

  @override
  void dispose() {
    _radiusController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  void _calculateAndSwitchTab() {
    final CircleCalculator calculator = context.read<CircleCalculator>();
    calculator.setRadius(_radiusController.text);

    if (calculator.errorMessage == null) {
      _tabController.animateTo(1); // Switch to Diameter tab
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calculadora de Círculo'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const <Widget>[
            Tab(text: 'Raio', icon: Icon(Icons.circle_outlined)),
            Tab(text: 'Diâmetro', icon: Icon(Icons.line_axis)),
            Tab(text: 'Circunferência', icon: Icon(Icons.settings_overscan)),
            Tab(text: 'Área', icon: Icon(Icons.blur_circular)),
          ],
          labelStyle: GoogleFonts.poppins(fontWeight: FontWeight.w600),
          unselectedLabelStyle: GoogleFonts.poppins(),
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: <Widget>[
          RadiusInputTab(
            radiusController: _radiusController,
            onCalculate: _calculateAndSwitchTab,
            tabController: _tabController,
          ),
          DiameterDisplayTab(tabController: _tabController),
          CircumferenceDisplayTab(tabController: _tabController),
          AreaDisplayTab(tabController: _tabController),
        ],
      ),
    );
  }
}

class RadiusInputTab extends StatefulWidget {
  const RadiusInputTab({
    super.key,
    required this.radiusController,
    required this.onCalculate,
    required this.tabController,
  });

  final TextEditingController radiusController;
  final VoidCallback onCalculate;
  final TabController tabController;

  @override
  State<RadiusInputTab> createState() => _RadiusInputTabState();
}

class _RadiusInputTabState extends State<RadiusInputTab> {
  @override
  Widget build(BuildContext context) {
    final CircleCalculator calculator = context.watch<CircleCalculator>();
    return Center(
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
                  controller: widget.radiusController,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  decoration: InputDecoration(
                    labelText: 'Raio do Círculo',
                    hintText: 'Ex: 10.5',
                    prefixIcon: const