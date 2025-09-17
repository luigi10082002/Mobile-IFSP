import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Student {
  String name;
  String enrollmentNumber;
  List<double> grades;

  Student({
    required this.name,
    required this.enrollmentNumber,
    this.grades = const <double>[],
  });

  Student copyWith({
    String? name,
    String? enrollmentNumber,
    List<double>? grades,
  }) {
    return Student(
      name: name ?? this.name,
      enrollmentNumber: enrollmentNumber ?? this.enrollmentNumber,
      grades: grades ?? List<double>.from(this.grades),
    );
  }
}

class StudentModel extends ChangeNotifier {
  Student? _currentStudent;

  Student? get currentStudent => _currentStudent;

  bool get hasStudent => _currentStudent != null;

  void registerStudent(String name, String enrollmentNumber) {
    _currentStudent = Student(
      name: name,
      enrollmentNumber: enrollmentNumber,
      grades: <double>[],
    );
    notifyListeners();
  }

  void addGrade(double grade) {
    if (_currentStudent != null) {
      _currentStudent = _currentStudent!.copyWith(
        grades: List<double>.from(_currentStudent!.grades)..add(grade),
      );
      notifyListeners();
    }
  }

  void clearStudent() {
    _currentStudent = null;
    notifyListeners();
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<StudentModel>(
      create: (BuildContext context) => StudentModel(),
      builder: (BuildContext context, Widget? child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Gerenciador de Alunos',
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
          home: const StudentRegistrationScreen(),
        );
      },
    );
  }
}

class StudentRegistrationScreen extends StatefulWidget {
  const StudentRegistrationScreen({super.key});

  @override
  State<StudentRegistrationScreen> createState() =>
      _StudentRegistrationScreenState();
}

class _StudentRegistrationScreenState extends State<StudentRegistrationScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _enrollmentController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _enrollmentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cadastrar Aluno')),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Icon(Icons.person_add, size: 80, color: Colors.blue),
                const SizedBox(height: 32),
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Nome do Aluno',
                    hintText: 'Digite o nome completo',
                    prefixIcon: Icon(Icons.person),
                  ),
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, digite o nome do aluno';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _enrollmentController,
                  decoration: const InputDecoration(
                    labelText: 'Matrícula',
                    hintText: 'Digite o número da matrícula',
                    prefixIcon: Icon(Icons.badge),
                  ),
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, digite a matrícula';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        Provider.of<StudentModel>(
                          context,
                          listen: false,
                        ).registerStudent(
                          _nameController.text,
                          _enrollmentController.text,
                        );
                        Navigator.pushReplacement<void, void>(
                          context,
                          MaterialPageRoute<void>(
                            builder: (BuildContext context) =>
                                const GradeEntryScreen(),
                          ),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      'Cadastrar Aluno',
                      style: TextStyle(fontSize: 18),
                    ),
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

class GradeEntryScreen extends StatefulWidget {
  const GradeEntryScreen({super.key});

  @override
  State<GradeEntryScreen> createState() => _GradeEntryScreenState();
}

class _GradeEntryScreenState extends State<GradeEntryScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _gradeController = TextEditingController();

  @override
  void dispose() {
    _gradeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Lançar Notas')),
      body: Consumer<StudentModel>(
        builder: (BuildContext context, StudentModel model, Widget? child) {
          if (!model.hasStudent) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const Icon(
                      Icons.error_outline,
                      size: 60,
                      color: Colors.red,
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Nenhum aluno cadastrado.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 18, color: Colors.red),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Por favor, volte e cadastre um aluno primeiro.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                    const SizedBox(height: 30),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pushReplacement<void, void>(
                          context,
                          MaterialPageRoute<void>(
                            builder: (BuildContext context) =>
                                const StudentRegistrationScreen(),
                          ),
                        );
                      },
                      child: const Text('Cadastrar Novo Aluno'),
                    ),
                  ],
                ),
              ),
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Card(
                    elevation: 4,
                    margin: const EdgeInsets.only(bottom: 24.0),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'Aluno: ${model.currentStudent!.name}',
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Matrícula: ${model.currentStudent!.enrollmentNumber}',
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(color: Colors.grey[700]),
                          ),
                        ],
                      ),
                    ),
                  ),
                  TextFormField(
                    controller: _gradeController,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    decoration: const InputDecoration(
                      labelText: 'Nota',
                      hintText: 'Digite a nota (ex: 8.5)',
                      prefixIcon: Icon(Icons.score),
                    ),
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, digite uma nota';
                      }
                      final double? grade = double.tryParse(
                        value.replaceAll(',', '.'),
                      );
                      if (grade == null) {
                        return 'Nota inválida. Digite um número.';
                      }
                      if (grade < 0 || grade > 10) {
                        return 'A nota deve ser entre 0 e 10';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.add_task),
                    label: const Text(
                      'Adicionar Nota',
                      style: TextStyle(fontSize: 18),
                    ),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        final double grade = double.parse(
                          _gradeController.text.replaceAll(',', '.'),
                        );
                        model.addGrade(grade);
                        _gradeController.clear();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Nota adicionada com sucesso!'),
                          ),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  OutlinedButton.icon(
                    icon: const Icon(Icons.visibility),
                    label: const Text(
                      'Ver Detalhes do Aluno',
                      style: TextStyle(fontSize: 18),
                    ),
                    onPressed: () {
                      Navigator.push<void>(
                        context,
                        MaterialPageRoute<void>(
                          builder: (BuildContext context) =>
                              const StudentDetailsScreen(),
                        ),
                      );
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
        },
      ),
    );
  }
}

class StudentDetailsScreen extends StatelessWidget {
  const StudentDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detalhes do Aluno')),
      body: Consumer<StudentModel>(
        builder: (BuildContext context, StudentModel model, Widget? child) {
          if (!model.hasStudent) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const Icon(
                      Icons.info_outline,
                      size: 60,
                      color: Colors.blueGrey,
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Nenhum aluno cadastrado para exibir detalhes.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 18, color: Colors.blueGrey),
                    ),
                    const SizedBox(height: 30),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute<void>(
                            builder: (BuildContext context) =>
                                const StudentRegistrationScreen(),
                          ),
                          (Route<void> route) => false,
                        );
                      },
                      child: const Text('Cadastrar Novo Aluno'),
                    ),
                  ],
                ),
              ),
            );
          }

          final Student student = model.currentStudent!;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Card(
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            const Icon(
                              Icons.person,
                              color: Colors.blue,
                              size: 30,
                            ),
                            const SizedBox(width: 10),
                            Flexible(
                              child: Text(
                                'Nome: ${student.name}',
                                style: Theme.of(context).textTheme.headlineSmall
                                    ?.copyWith(fontWeight: FontWeight.bold),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: <Widget>[
                            const Icon(
                              Icons.badge,
                              color: Colors.blue,
                              size: 30,
                            ),
                            const SizedBox(width: 10),
                            Flexible(
                              child: Text(
                                'Matrícula: ${student.enrollmentNumber}',
                                style: Theme.of(context).textTheme.titleLarge,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24.0,
                  vertical: 8.0,
                ),
                child: Text(
                  'Notas Lançadas:',
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
              ),
              Expanded(
                child: student.grades.isEmpty
                    ? const Center(
                        child: Text(
                          'Nenhuma nota lançada ainda.',
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24.0,
                          vertical: 8.0,
                        ),
                        itemCount: student.grades.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Card(
                            margin: const EdgeInsets.symmetric(vertical: 4.0),
                            elevation: 2,
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundColor: Colors.blue,
                                foregroundColor: Colors.white,
                                child: Text('${index + 1}'),
                              ),
                              title: Text(
                                'Nota ${index + 1}: ${student.grades[index].toStringAsFixed(1)}',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              trailing: const Icon(
                                Icons.check_circle_outline,
                                color: Colors.green,
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
    );
  }
}

void main() {
  runApp(const MyApp());
}
