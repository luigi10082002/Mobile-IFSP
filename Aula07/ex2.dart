import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:math' as math; // Import dart:math for pi

/// DATA_MODEL
class CircleCalculatorModel extends ChangeNotifier {
  double? _radius;

  double? get radius => _radius;

  bool get hasRadius => _radius != null && _radius! > 0;

  void setRadius(double? newRadius) {
    if (_radius != newRadius) {
      _radius = newRadius;
      notifyListeners();
    }
  }

  double? get diameter {
    if (_radius == null) return null;
    return 2 * _radius!;
  }

  double? get circumference {
    if (_radius == null) return null;
    return 2 * math.pi * _radius!;
  }

  double? get area {
    if (_radius == null) return null;
    return math.pi * _radius! * _radius!;
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<CircleCalculatorModel>(
      create: (BuildContext context) => CircleCalculatorModel(),
      builder: (BuildContext context, Widget? child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Calculadora de Círculo',
          theme: ThemeData(
            primarySwatch: Colors.blue,
            visualDensity: VisualDensity.adaptivePlatformDensity,
            appBarTheme: const AppBarTheme(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
            ),
            elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.blue,
              ),
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(foregroundColor: Colors.blue),
            ),
            outlinedButtonTheme: OutlinedButtonThemeData(
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.blue,
                side: const BorderSide(color: Colors.blue),
              ),
            ),
            inputDecorationTheme: InputDecorationTheme(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: const BorderSide(color: Colors.blue, width: 2.0),
              ),
              contentPadding: const EdgeInsets.symmetric(
                vertical: 16.0,
                horizontal: 12.0,
              ),
            ),
          ),
          home: const CirclePropertiesScreen(),
        );
      },
    );
  }
}

class CirclePropertiesScreen extends StatefulWidget {
  const CirclePropertiesScreen({super.key});

  @override
  State<CirclePropertiesScreen> createState() => _CirclePropertiesScreenState();
}

class _CirclePropertiesScreenState extends State<CirclePropertiesScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Propriedades do Círculo'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const <Tab>[
            Tab(text: 'Raio', icon: Icon(Icons.radio_button_checked)),
            Tab(text: 'Diâmetro', icon: Icon(Icons.circle_outlined)),
            Tab(text: 'Circunferência', icon: Icon(Icons.loop)),
            Tab(text: 'Área', icon: Icon(Icons.square_foot)),
          ],
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          indicatorColor: Colors.white,
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const <Widget>[
          RadiusInputTab(),
          DiameterDisplayTab(),
          CircumferenceDisplayTab(),
          AreaDisplayTab(),
        ],
      ),
    );
  }
}

class RadiusInputTab extends StatefulWidget {
  const RadiusInputTab({super.key});

  @override
  State<RadiusInputTab> createState() => _RadiusInputTabState();
}

class _RadiusInputTabState extends State<RadiusInputTab> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _radiusController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Initialize controller with current radius if available
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final double? currentRadius = Provider.of<CircleCalculatorModel>(
        context,
        listen: false,
      ).radius;
      if (currentRadius != null) {
        _radiusController.text = currentRadius.toStringAsFixed(2);
      }
    });
  }

  @override
  void dispose() {
    _radiusController.dispose();
    super.dispose();
  }

  void _updateRadius() {
    if (_formKey.currentState!.validate()) {
      final double radius = double.parse(
        _radiusController.text.replaceAll(',', '.'),
      );
      Provider.of<CircleCalculatorModel>(
        context,
        listen: false,
      ).setRadius(radius);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Raio atualizado com sucesso!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            const Icon(
              Icons.radio_button_checked,
              size: 80,
              color: Colors.blue,
            ),
            const SizedBox(height: 32),
            TextFormField(
              controller: _radiusController,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              decoration: const InputDecoration(
                labelText: 'Raio do Círculo',
                hintText: 'Ex: 5.0',
                prefixIcon: Icon(Icons.linear_scale),
              ),
              validator: (String? value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor, digite o raio';
                }
                final double? parsedValue = double.tryParse(
                  value.replaceAll(',', '.'),
                );
                if (parsedValue == null) {
                  return 'Valor inválido. Digite um número.';
                }
                if (parsedValue <= 0) {
                  return 'O raio deve ser um número positivo.';
                }
                return null;
              },
              onFieldSubmitted: (_) => _updateRadius(),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              icon: const Icon(Icons.calculate),
              label: const Text(
                'Calcular Propriedades',
                style: TextStyle(fontSize: 18),
              ),
              onPressed: _updateRadius,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 16),
            OutlinedButton.icon(
              icon: const Icon(Icons.clear_all),
              label: const Text('Limpar Raio', style: TextStyle(fontSize: 18)),
              onPressed: () {
                _radiusController.clear();
                Provider.of<CircleCalculatorModel>(
                  context,
                  listen: false,
                ).setRadius(null);
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(const SnackBar(content: Text('Raio limpo.')));
              },
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DiameterDisplayTab extends StatelessWidget {
  const DiameterDisplayTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<CircleCalculatorModel>(
      builder: (BuildContext context, CircleCalculatorModel model, Widget? child) {
        return Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Icon(
                  Icons.circle_outlined,
                  size: 80,
                  color: Colors.blueAccent,
                ),
                const SizedBox(height: 24),
                Text(
                  'Diâmetro',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                if (model.hasRadius)
                  Text(
                    'Raio: ${model.radius!.toStringAsFixed(2)}',
                    style: Theme.of(
                      context,
                    ).textTheme.titleLarge?.copyWith(color: Colors.grey[700]),
                  )
                else
                  const SizedBox.shrink(),
                const SizedBox(height: 16),
                if (model.hasRadius && model.diameter != null)
                  Text(
                    '${model.diameter!.toStringAsFixed(2)} unidades',
                    textAlign: TextAlign.center,
                    style: Theme.of(
                      context,
                    ).textTheme.displaySmall?.copyWith(color: Colors.blue),
                  )
                else
                  const Text(
                    'Por favor, insira um raio positivo na aba "Raio" para calcular o diâmetro.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class CircumferenceDisplayTab extends StatelessWidget {
  const CircumferenceDisplayTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<CircleCalculatorModel>(
      builder: (BuildContext context, CircleCalculatorModel model, Widget? child) {
        return Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Icon(Icons.loop, size: 80, color: Colors.green),
                const SizedBox(height: 24),
                Text(
                  'Circunferência',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                if (model.hasRadius)
                  Text(
                    'Raio: ${model.radius!.toStringAsFixed(2)}',
                    style: Theme.of(
                      context,
                    ).textTheme.titleLarge?.copyWith(color: Colors.grey[700]),
                  )
                else
                  const SizedBox.shrink(),
                const SizedBox(height: 16),
                if (model.hasRadius && model.circumference != null)
                  Text(
                    '${model.circumference!.toStringAsFixed(2)} unidades',
                    textAlign: TextAlign.center,
                    style: Theme.of(
                      context,
                    ).textTheme.displaySmall?.copyWith(color: Colors.green),
                  )
                else
                  const Text(
                    'Por favor, insira um raio positivo na aba "Raio" para calcular a circunferência.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class AreaDisplayTab extends StatelessWidget {
  const AreaDisplayTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<CircleCalculatorModel>(
      builder: (BuildContext context, CircleCalculatorModel model, Widget? child) {
        return Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Icon(Icons.square_foot, size: 80, color: Colors.orange),
                const SizedBox(height: 24),
                Text(
                  'Área',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                if (model.hasRadius)
                  Text(
                    'Raio: ${model.radius!.toStringAsFixed(2)}',
                    style: Theme.of(
                      context,
                    ).textTheme.titleLarge?.copyWith(color: Colors.grey[700]),
                  )
                else
                  const SizedBox.shrink(),
                const SizedBox(height: 16),
                if (model.hasRadius && model.area != null)
                  Text(
                    '${model.area!.toStringAsFixed(2)} unidades²',
                    textAlign: TextAlign.center,
                    style: Theme.of(
                      context,
                    ).textTheme.displaySmall?.copyWith(color: Colors.orange),
                  )
                else
                  const Text(
                    'Por favor, insira um raio positivo na aba "Raio" para calcular a área.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}

void main() {
  runApp(const MyApp());
}
