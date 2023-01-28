import 'package:days21/repositories/fit.repo.dart';
import 'package:flutter/material.dart';

class Temp extends StatefulWidget {
  const Temp({Key? key}) : super(key: key);

  @override
  State<Temp> createState() => _TempState();
}

class _TempState extends State<Temp> {
  int steps = -2;

  @override
  void initState() {
    super.initState();
    getSteps();
  }

  void getSteps() async {
    steps = await FitRepo.getSteps();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(steps.toString()),
      ),
    );
  }
}
