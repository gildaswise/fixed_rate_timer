import 'package:flutter/material.dart';
import 'package:fixed_rate_timer/fixed_rate_timer.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _fixedRateTimer = FixedRateTimer.instance;

  int _timesRan = 0;

  @override
  void initState() {
    super.initState();
    _fixedRateTimer.start(Duration(seconds: 30), () {
      print("Hey, it is ${DateTime.now()} now!");
      if (mounted) setState(() => _timesRan = _timesRan + 1);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('fixed_rate_timer'),
          actions: <Widget>[],
        ),
        body: Center(
          child: Text(
              'Scheduled timer to print every 30s, times it ran: $_timesRan'),
        ),
      ),
    );
  }
}
