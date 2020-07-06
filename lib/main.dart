import 'package:flutter/material.dart';
import 'features/number_trivia/presentation/pages/number_trivia_page.dart';
import 'injection_container.dart' as dependencyInjections;

void main() async {
  
  WidgetsFlutterBinding.ensureInitialized();
  
  // проверяем зависимости
  await dependencyInjections.init();

  // если все зависимости прошли проверку, 
  // то запускаем приложение
  runApp(MyApp());
}

 
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Number Trivia App',
      theme: ThemeData(
        primaryColor: Colors.green.shade800,
        accentColor: Colors.green[600]
      ),
      home: NumberTriviaPage(),
    );
  }
}