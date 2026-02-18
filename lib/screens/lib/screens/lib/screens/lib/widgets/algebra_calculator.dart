import 'package:flutter/material.dart';

class AlgebraCalculator extends StatefulWidget {
  const AlgebraCalculator({super.key});

  @override
  State<AlgebraCalculator> createState() => _AlgebraCalculatorState();
}

class _AlgebraCalculatorState extends State<AlgebraCalculator> with SingleTickerProviderStateMixin {
  final TextEditingController aController = TextEditingController();
  final TextEditingController bController = TextEditingController();
  final TextEditingController cController = TextEditingController();

  String result = '';
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _fadeAnimation = CurvedAnimation(parent: _animationController, curve: Curves.easeIn);
  }

  void _solve() {
    FocusScope.of(context).unfocus();
    final a = double.tryParse(aController.text);
    final b = double.tryParse(bController.text);
    final c = double.tryParse(cController.text);

    if (a == null || b == null || c == null) {
      setState(() {
        result = 'Ошибка: введите все коэффициенты';
      });
      _animationController.forward(from: 0);
      return;
    }

    if (a == 0) {
      setState(() {
        result = 'Ошибка: a не может быть 0';
      });
      _animationController.forward(from: 0);
      return;
    }

    final D = b * b - 4 * a * c;
    String solution;

    if (D < 0) {
      solution = 'Дискриминант D = $D < 0\nНет действительных корней';
    } else if (D == 0) {
      final x = -b / (2 * a);
      solution = 'Дискриминант D = 0\nОдин корень: x = ${x.toStringAsFixed(2)}';
    } else {
      final x1 = (-b + D.sqrt()) / (2 * a);
      final x2 = (-b - D.sqrt()) / (2 * a);
      solution = 'Дискриминант D = ${D.toStringAsFixed(2)}\n'
          'x₁ = ${x1.toStringAsFixed(2)}\n'
          'x₂ = ${x2.toStringAsFixed(2)}';
    }

    setState(() {
      result = solution;
    });
    _animationController.forward(from: 0);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'ax² + bx + c = 0',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          TextField(
            controller: aController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: 'a (коэффициент)'),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: bController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: 'b (коэффициент)'),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: cController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: 'c (коэффициент)'),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _solve,
            child: const Text('Решить'),
          ),
          const SizedBox(height: 20),
          AnimatedBuilder(
            animation: _animationController,
            builder: (context, child) {
              return FadeTransition(
                opacity: _fadeAnimation,
                child: child,
              );
            },
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                result,
                style: const TextStyle(fontSize: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
