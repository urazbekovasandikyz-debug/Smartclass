import 'package:flutter/material.dart';

class ChemistryCalculator extends StatefulWidget {
  const ChemistryCalculator({super.key});

  @override
  State<ChemistryCalculator> createState() => _ChemistryCalculatorState();
}

class _ChemistryCalculatorState extends State<ChemistryCalculator> with SingleTickerProviderStateMixin {
  final TextEditingController formulaController = TextEditingController();
  String result = '';
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  final Map<String, double> atomicMasses = {
    'H': 1,
    'C': 12,
    'O': 16,
    'N': 14,
    'S': 32,
    'Cl': 35.5,
    'Na': 23,
    'Mg': 24,
    'P': 31,
  };

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _fadeAnimation = CurvedAnimation(parent: _animationController, curve: Curves.easeIn);
  }

  double? _parseFormula(String formula) {
    if (formula.isEmpty) return null;
    
    final RegExp elementRegex = RegExp(r'([A-Z][a-z]?)(\d*\.?\d+)?');
    final matches = elementRegex.allMatches(formula);
    double totalMass = 0;

    for (final match in matches) {
      final element = match.group(1);
      final countStr = match.group(2);
      
      if (element == null) continue;
      
      final mass = atomicMasses[element];
      if (mass == null) return null; // неизвестный элемент
      
      final count = countStr == null || countStr.isEmpty ? 1 : double.tryParse(countStr) ?? 1;
      totalMass += mass * count;
    }
    return totalMass;
  }

  void _calculate() {
    FocusScope.of(context).unfocus();
    final formula = formulaController.text.trim();
    if (formula.isEmpty) {
      setState(() {
        result = 'Введите формулу';
      });
      _animationController.forward(from: 0);
      return;
    }

    final molarMass = _parseFormula(formula);
    if (molarMass == null) {
      setState(() {
        result = 'Ошибка: неизвестный элемент или неверный формат';
      });
    } else {
      setState(() {
        result = 'Молярная масса: ${molarMass.toStringAsFixed(2)} г/моль';
      });
    }
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
            'Расчёт молярной массы',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          TextField(
            controller: formulaController,
            decoration: const InputDecoration(
              labelText: 'Формула (например, H2O, C6H12O6)',
              hintText: 'H2O',
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _calculate,
            child: const Text('Рассчитать'),
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
                color: Colors.green.shade50,
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
