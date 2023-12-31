import 'package:flutter/material.dart';
import 'package:quizzer/screens/home_screen.dart';

import 'constants/color.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: bgColor,
        appBarTheme: const AppBarTheme(
          color: appBarColor,
          elevation: 1.0,
          centerTitle: true,
          iconTheme: IconThemeData(color: Colors.white),
          titleTextStyle: TextStyle(
            fontSize: 22.0,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.8,
            color: Colors.white,
          ),
        ),
      ),
      home: const HomeScreen(),
    );
  }
}
