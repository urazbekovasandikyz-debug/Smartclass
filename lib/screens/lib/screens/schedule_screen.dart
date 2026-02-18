import 'package:flutter/material.dart';

const Map<int, List<Map<String, String>>> kesteData = {
  1: [
    {"name": "Қазақ тілі", "time": "8:00-8:45"},
    {"name": "Дж/Тарих", "time": "8:50-9:35"},
    {"name": "Алгебра", "time": "9:40-10:30"},
    {"name": "Құқық негіздері", "time": "10:40-11:25"},
    {"name": "Ағылшын", "time": "11:30-12:15"},
    {"name": "География (ф)", "time": "12:20-13:05"},
    {"name": "Дене шынықтыру", "time": "13:10-13:55"},
    {"name": "Сынып сағаты", "time": "14:00-14:45"}
  ],
  2: [
    {"name": "Қазақ әдебиет", "time": "8:00-8:45"},
    {"name": "Информатика", "time": "8:50-9:35"},
    {"name": "Қазақ т (ф)", "time": "9:40-10:30"},
    {"name": "Геометрия", "time": "10:40-11:25"},
    {"name": "Химия", "time": "11:30-12:15"},
    {"name": "География", "time": "12:20-13:05"},
    {"name": "Орыс т", "time": "13:10-13:55"}
  ],
  3: [
    {"name": "Ағылшын", "time": "8:00-8:45"},
    {"name": "Информатика", "time": "8:50-9:35"},
    {"name": "Биология", "time": "9:40-10:30"},
    {"name": "Алгебра", "time": "10:40-11:25"},
    {"name": "Физика", "time": "11:30-12:15"},
    {"name": "Қазақстан тарих", "time": "12:20-13:05"},
    {"name": "География", "time": "13:10-13:55"}
  ],
  4: [
    {"name": "АӘД", "time": "8:00-8:45"},
    {"name": "Геометрия", "time": "8:50-9:35"},
    {"name": "Алгебра", "time": "9:40-10:30"},
    {"name": "Қазақстан тарих", "time": "10:40-11:25"},
    {"name": "Химия", "time": "11:30-12:15"},
    {"name": "Дене шынықтыру", "time": "12:20-13:05"},
    {"name": "Орыс т", "time": "13:10-13:55"}
  ],
  5: [
    {"name": "Қазақ әдебиет", "time": "8:00-8:45"},
    {"name": "Алгебра", "time": "8:50-9:35"},
    {"name": "Физика", "time": "9:40-10:30"},
    {"name": "Биология", "time": "10:40-11:25"},
    {"name": "Дене шынықтыру", "time": "11:30-12:15"},
    {"name": "Ағылшын", "time": "12:20-13:05"},
    {"name": "Жаһандық құз (ф)", "time": "13:10-13:55"}
  ]
};

final List<String> days = [
  'Дүйсенбі',
  'Сейсенбі',
  'Сәрсенбі',
  'Бейсенбі',
  'Жұма',
];

class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({super.key});

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> with TickerProviderStateMixin {
  int _selectedDay = 1;
  late final AnimationController _slideController;

  @override
  void initState() {
    super.initState();
    _slideController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _slideController.forward();
  }

  @override
  void dispose() {
    _slideController.dispose();
    super.dispose();
  }

  void _changeDay(int day) {
    if (_selectedDay == day) return;
    setState(() => _selectedDay = day);
    _slideController.reset();
    _slideController.forward();
  }

  @override
  Widget build(BuildContext context) {
    final lessons = kesteData[_selectedDay] ?? [];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Расписание уроков'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(5, (index) {
                final dayNumber = index + 1;
                final isSelected = _selectedDay == dayNumber;
                return GestureDetector(
                  onTap: () => _changeDay(dayNumber),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.easeInOut,
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.blue : Colors.transparent,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: isSelected
                          ? [BoxShadow(color: Colors.blue.withOpacity(0.5), blurRadius: 8)]
                          : null,
                    ),
                    child: Text(
                      days[index],
                      style: TextStyle(
                        color: isSelected ? Colors.white : Colors.black87,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
        ),
      ),
      body: AnimatedBuilder(
        animation: _slideController,
        builder: (context, child) {
          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0.1, 0),
              end: Offset.zero,
            ).animate(CurvedAnimation(parent: _slideController, curve: Curves.easeOut)),
            child: FadeTransition(
              opacity: _slideController,
              child: child,
            ),
          );
        },
        child: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: lessons.length,
          itemBuilder: (context, index) {
            final lesson = lessons[index];
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Card(
                child: InkWell(
                  borderRadius: BorderRadius.circular(16),
                  onTap: () {
                    // Можно добавить анимацию нажатия
                  },
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Container(
                          width: 80,
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.blue.shade50,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            lesson['time']!,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.blue,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Text(
                            lesson['name']!,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        const Icon(Icons.chevron_right, color: Colors.grey),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
