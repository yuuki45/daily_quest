import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(const ProviderScope(child: DailyQuestApp()));
}

class DailyQuestApp extends StatelessWidget {
  const DailyQuestApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Daily Quest',
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Center(
          child: Text('Daily Quest'),
        ),
      ),
    );
  }
}
