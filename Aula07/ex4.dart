import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calendário Flutter',
      theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('pt', 'BR')],
      home: const CalendarPage(),
    );
  }
}

class CalendarPage extends StatefulWidget {
  const CalendarPage({Key? key}) : super(key: key);

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  final DateTime _now = DateTime.now();
  late DateTime _firstDayOfMonth;
  late int _daysInMonth;
  late int _firstDayOfWeek;
  String _selectedDayDetails = '';

  @override
  void initState() {
    super.initState();
    _firstDayOfMonth = DateTime(_now.year, _now.month, 1);
    _daysInMonth = _getDaysInMonth(_now.year, _now.month);
    _firstDayOfWeek = _firstDayOfMonth.weekday % 7;
  }

  int _getDaysInMonth(int year, int month) {
    if (month == DateTime.february) {
      if (year % 4 == 0 && (year % 100 != 0 || year % 400 == 0)) {
        return 29;
      }
      return 28;
    }
    return [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31][month - 1];
  }

  void _onDayPressed(int day) {
    final selectedDate = DateTime(_now.year, _now.month, day);
    final dayOfWeek = DateFormat('EEEE', 'pt_BR').format(selectedDate);

    setState(() {
      _selectedDayDetails = 'Dia $day, $dayOfWeek';
    });
  }

  @override
  Widget build(BuildContext context) {
    final monthName = DateFormat.MMMM('pt_BR').format(_now);

    return Scaffold(
      appBar: AppBar(title: const Text('Calendário')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              '${monthName.capitalize()} ${_now.year}',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            GridView.builder(
              shrinkWrap: true,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 7,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
              ),
              itemCount: _firstDayOfWeek + _daysInMonth,
              itemBuilder: (context, index) {
                if (index < _firstDayOfWeek) {
                  return const SizedBox.shrink();
                }

                final day = index - _firstDayOfWeek + 1;

                return TextButton(
                  onPressed: () => _onDayPressed(day),
                  child: Text('$day', style: const TextStyle(fontSize: 18)),
                );
              },
            ),
            const SizedBox(height: 40),
            if (_selectedDayDetails.isNotEmpty)
              Text(
                _selectedDayDetails,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
          ],
        ),
      ),
    );
  }
}

extension StringExtension on String {
  String capitalize() {
    return '${this[0].toUpperCase()}${substring(1)}';
  }
}
