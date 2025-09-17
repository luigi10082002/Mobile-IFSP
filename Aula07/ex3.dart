import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class AgeCalculator extends ChangeNotifier {
  DateTime? _dateOfBirth;
  int? _ageInYears;
  String? _errorMessage;

  DateTime? get dateOfBirth => _dateOfBirth;
  int? get ageInYears => _ageInYears;
  String? get errorMessage => _errorMessage;

  void setDateOfBirth(DateTime? dob) {
    _errorMessage = null;
    _ageInYears = null;
    _dateOfBirth = dob;

    if (dob == null) {
      _errorMessage = 'Por favor, selecione sua data de nascimento.';
    } else if (dob.isAfter(DateTime.now())) {
      _errorMessage = 'A data de nascimento não pode ser no futuro.';
    } else {
      _calculateAge(dob);
    }
    notifyListeners();
  }

  void _calculateAge(DateTime dob) {
    final DateTime now = DateTime.now();
    int age = now.year - dob.year;
    if (now.month < dob.month ||
        (now.month == dob.month && now.day < dob.day)) {
      age--;
    }
    _ageInYears = age;
  }

  void clear() {
    _dateOfBirth = null;
    _ageInYears = null;
    _errorMessage = null;
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AgeCalculator>(
      create: (BuildContext context) => AgeCalculator(),
      builder: (BuildContext context, Widget? child) {
        return MaterialApp(
          title: 'Calculadora de Idade',
          theme: ThemeData(
            primarySwatch: Colors.indigo,
            visualDensity: VisualDensity.adaptivePlatformDensity,
            textTheme: GoogleFonts.poppinsTextTheme(
              Theme.of(context).textTheme,
            ),
            appBarTheme: AppBarTheme(
              titleTextStyle: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
              backgroundColor: Colors.indigo,
              foregroundColor: Colors.white,
            ),
          ),
          home: const AgeCalculatorScreen(),
        );
      },
    );
  }
}

class AgeCalculatorScreen extends StatefulWidget {
  const AgeCalculatorScreen({super.key});

  @override
  State<AgeCalculatorScreen> createState() => _AgeCalculatorScreenState();
}

class _AgeCalculatorScreenState extends State<AgeCalculatorScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    _tabController.addListener(() {
      if (_tabController.index == 0) {
        final AgeCalculator calculator = context.read<AgeCalculator>();
        calculator.clearError();
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _showAge() {
    final AgeCalculator calculator = context.read<AgeCalculator>();
    if (calculator.errorMessage == null && calculator.ageInYears != null) {
      _tabController.animateTo(1);
    } else if (calculator.errorMessage != null) {
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
        title: const Text('Calculadora de Idade'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const <Widget>[
            Tab(text: 'Data de Nascimento', icon: Icon(Icons.calendar_month)),
            Tab(text: 'Idade Calculada', icon: Icon(Icons.cake)),
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
          DateInputTab(onShowAge: _showAge),
          const AgeDisplayTab(),
        ],
      ),
    );
  }
}

class DateInputTab extends StatefulWidget {
  const DateInputTab({super.key, required this.onShowAge});

  final VoidCallback onShowAge;

  @override
  State<DateInputTab> createState() => _DateInputTabState();
}

class _DateInputTabState extends State<DateInputTab> {
  Future<void> _pickDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now().subtract(const Duration(days: 365 * 20)),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      helpText: 'Selecione sua data de nascimento',
      cancelText: 'Cancelar',
      confirmText: 'Confirmar',
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: Colors.indigo,
            colorScheme: const ColorScheme.light(
              primary: Colors.indigo,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
            buttonTheme: const ButtonThemeData(
              textTheme: ButtonTextTheme.primary,
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null) {
      context.read<AgeCalculator>().setDateOfBirth(pickedDate);
      widget.onShowAge();
    }
  }

  @override
  Widget build(BuildContext context) {
    final AgeCalculator calculator = context.watch<AgeCalculator>();
    final String displayedDate = calculator.dateOfBirth == null
        ? 'Nenhuma data selecionada'
        : DateFormat('dd/MM/yyyy').format(calculator.dateOfBirth!);

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
                  'Quando você nasceu?',
                  style: GoogleFonts.poppins(
                    fontSize: 26,
                    fontWeight: FontWeight.w700,
                    color: Colors.indigo[800],
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                Text(
                  displayedDate,
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    color: Colors.grey[700],
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: () => _pickDate(context),
                  icon: const Icon(Icons.calendar_today),
                  label: Text(
                    calculator.dateOfBirth == null
                        ? 'Selecionar Data de Nascimento'
                        : 'Alterar Data de Nascimento',
                    style: GoogleFonts.poppins(fontSize: 18),
                  ),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    backgroundColor: Colors.indigo,
                    foregroundColor: Colors.white,
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

class AgeDisplayTab extends StatelessWidget {
  const AgeDisplayTab({super.key});

  @override
  Widget build(BuildContext context) {
    final AgeCalculator calculator = context.watch<AgeCalculator>();
    final String dobText = calculator.dateOfBirth == null
        ? 'N.A.'
        : DateFormat('dd/MM/yyyy').format(calculator.dateOfBirth!);

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
                  'Sua Idade',
                  style: GoogleFonts.poppins(
                    fontSize: 26,
                    fontWeight: FontWeight.w700,
                    color: Colors.indigo[800],
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                if (calculator.ageInYears == null)
                  Text(
                    'Por favor, selecione sua data de nascimento.',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      color: Colors.redAccent,
                    ),
                    textAlign: TextAlign.center,
                  )
                else
                  Column(
                    children: [
                      Text(
                        'Data de Nascimento:',
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey[700],
                        ),
                      ),
                      Text(
                        dobText,
                        style: GoogleFonts.poppins(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.indigo,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Idade:',
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey[700],
                        ),
                      ),
                      Text(
                        '${calculator.ageInYears} anos',
                        style: GoogleFonts.poppins(
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                          color: Colors.indigo[900],
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

void main() {
  runApp(const MyApp());
}
