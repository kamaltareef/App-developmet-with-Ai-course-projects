import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ציונים',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      builder: (context, child) =>
          Directionality(textDirection: TextDirection.rtl, child: child!),
      home: const GradesPage(),
    );
  }
}

class Student {
  Student(this.name, this.grade);

  final String name;
  int grade;

  bool get passed => grade >= passingGrade;

  static const int passingGrade = 60;
}

enum GradeFilter { all, passed, failed }

class GradesPage extends StatefulWidget {
  const GradesPage({super.key});

  @override
  State<GradesPage> createState() => _GradesPageState();
}

class _GradesPageState extends State<GradesPage> {
  final List<Student> _students = [
    Student('נועה', 92),
    Student('דנה', 71),
    Student('יוסף', 54),
    Student('עומר', 48),
  ];

  GradeFilter _filter = GradeFilter.all;

  double get _average => _students.isEmpty
      ? 0
      : _students.fold<int>(0, (sum, s) => sum + s.grade) / _students.length;

  List<Student> get _visible => switch (_filter) {
        GradeFilter.all => _students,
        GradeFilter.passed => _students.where((s) => s.passed).toList(),
        GradeFilter.failed => _students.where((s) => !s.passed).toList(),
      };

  void _change(Student s, int delta) {
    setState(() => s.grade = (s.grade + delta).clamp(0, 100));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ממוצע: ${_average.toStringAsFixed(1)}'),
        actions: [
          PopupMenuButton<GradeFilter>(
            icon: const Icon(Icons.filter_list),
            tooltip: 'סינון',
            initialValue: _filter,
            onSelected: (f) => setState(() => _filter = f),
            itemBuilder: (_) => const [
              PopupMenuItem(value: GradeFilter.all, child: Text('הכל')),
              PopupMenuItem(value: GradeFilter.passed, child: Text('עברו')),
              PopupMenuItem(value: GradeFilter.failed, child: Text('נכשלו')),
            ],
          ),
        ],
      ),
      body: ListView(
        children: [
          for (final s in _visible)
            ListTile(
              key: ObjectKey(s),
              leading: Icon(
                s.passed ? Icons.check_circle : Icons.cancel,
                color: s.passed ? Colors.green : Colors.red,
              ),
              title: Text(s.name),
              subtitle: Text('ציון: ${s.grade}'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.remove),
                    tooltip: 'הפחת',
                    onPressed: () => _change(s, -1),
                  ),
                  IconButton(
                    icon: const Icon(Icons.add),
                    tooltip: 'הוסף',
                    onPressed: () => _change(s, 1),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
