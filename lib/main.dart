import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'data/local/gpa_local_data_source.dart';
import 'presentation/bloc/gpa_bloc.dart';
import 'presentation/pages/gpa_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final dataSource = GpaLocalDataSource(prefs);
  runApp(GpaCalculatorApp(dataSource: dataSource));
}

class GpaCalculatorApp extends StatelessWidget {
  final GpaLocalDataSource dataSource;

  const GpaCalculatorApp({super.key, required this.dataSource});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GPA Calculator',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      home: BlocProvider(
        create: (_) => GpaBloc(dataSource: dataSource),
        child: const GpaPage(),
      ),
    );
  }
}
