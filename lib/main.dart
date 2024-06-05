import 'package:allen/home_page.dart';
import 'package:allen/pallate.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      title: 'Allen',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(useMaterial3: true).copyWith(
      scaffoldBackgroundColor: Pallete.whiteColor,
      appBarTheme: const AppBarTheme(
      backgroundColor: Pallete.whiteColor
      ),

      ),
      
      home: const HomePage(),
    );
  }
}

