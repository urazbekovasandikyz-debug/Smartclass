import 'package:flutter/material.dart';
import '../widgets/algebra_calculator.dart';
import '../widgets/chemistry_calculator.dart';
import '../widgets/ohm_calculator.dart';

class CalculatorsScreen extends StatefulWidget {
  const CalculatorsScreen({super.key});

  @override
  State<CalculatorsScreen> createState() => _CalculatorsScreenState();
}

class _CalculatorsScreenState extends State<CalculatorsScreen> with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
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
        title: const Text('Калькуляторы'),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.blue,
          labelColor: Colors.blue,
          unselectedLabelColor: Colors.grey,
          tabs: const [
            Tab(icon: Icon(Icons.functions), text: 'Алгебра'),
            Tab(icon: Icon(Icons.science), text: 'Химия'),
            Tab(icon: Icon(Icons.electric_bolt), text: 'Физика'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          AlgebraCalculator(),
          ChemistryCalculator(),
          OhmCalculator(),
        ],
      ),
    );
  }
}
