import 'package:flutter/material.dart';

enum OhmMode { findU, findI, findR }

class OhmCalculator extends StatefulWidget {
  const OhmCalculator({super.key});

  @override
  State<OhmCalculator> createState() => _OhmCalculatorState();
}

class _OhmCalculatorState extends State<OhmCalculator> with SingleTickerProviderStateMixin {
  final TextEditingController uController = TextEditingController();
  final TextEditingController iController = TextEditingController();
  final TextEditingController rController = TextEditingController();

  OhmMode _mode = OhmMode.findU;
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

  void _calculate() {
    FocusScope.of(context).unfocus();
    final u = double.tryParse(uController.text);
    final i = double.tryParse(iController.text);
    final r = double.tryParse(rController.text);

    if (_mode == OhmMode.findU) {
      if (i == null || r == null) {
        setState(() {
          result = 'Введите ток и сопротивление';
        });
      } else {
        final calculatedU = i * r;
        setState(() {
          result = 'U = I * R = ${calculatedU.toStringAsFixed(2)} В';
        });
      }
    } else if (_mode == OhmMode.findI) {
      if (u == null || r == null) {
        setState(() {
          result = 'Введите напряжение и сопротивление';
        });
      } else {
        final calculatedI = u / r;
        setState(() {
          result = 'I = U / R = ${calculatedI.toStringAsFixed(2)} А';
        });
      }
    } else if (_mode == OhmMode.findR) {
      if (u == null || i == null) {
        setState(() {
          result = 'Введите напряжение и ток';
        });
      } else {
        final calculatedR = u / i;
        setState(() {
          result = 'R = U / I = ${calculatedR.toStringAsFixed(2)} Ом';
        });
      }
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
            'Закон Ома: U = I * R',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ChoiceChip(
                label: const Text('Найти U'),
                selected: _mode == OhmMode.findU,
                onSelected: (selected) {
                  if (selected) setState(() => _mode = OhmMode.findU);
                },
              ),
              ChoiceChip(
                label: const Text('Найти I'),
                selected: _mode == OhmMode.findI,
                onSelected: (selected) {
                  if (selected) setState(() => _mode = OhmMode.findI);
                },
              ),
              ChoiceChip(
                label: const Text('Найти R'),
                selected: _mode == OhmMode.findR,
                onSelected: (selected) {
                  if (selected) setState(() => _mode = OhmMode.findR);
                },
              ),
            ],
          ),
          const SizedBox(height: 20),
          TextField(
            controller: uController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: 'Напряжение U (В)'),
            enabled: _mode != OhmMode.findU,
          ),
          const SizedBox(height: 12),
          TextField(
            controller: iController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: 'Ток I (А)'),
            enabled: _mode != OhmMode.findI,
          ),
          const SizedBox(height: 12),
          TextField(
            controller: rController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: 'Сопротивление R (Ом)'),
            enabled: _mode != OhmMode.findR,
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
                color: Colors.orange.shade50,
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
