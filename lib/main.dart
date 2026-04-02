import 'package:flutter/material.dart';
import 'package:kids_app/Const/progress_service.dart';
import 'package:kids_app/Screens/Deshboard.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ProgressService().init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Kids App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const AdvancedKidsDashboard(),
    );
  }
}
