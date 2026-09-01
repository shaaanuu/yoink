import 'package:flutter/material.dart';

import 'pages/home.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'yoink',
      theme: ThemeData(
        colorScheme: .fromSeed(seedColor: Color(0xFF3171C6)),
        scaffoldBackgroundColor: Color(0xFFF4F3F1),
        fontFamily: 'NanumPenScript',
        textTheme: const TextTheme(
          displayLarge: TextStyle(color: Color(0xFF2D2D2D)),
          displayMedium: TextStyle(color: Color(0xFF2D2D2D)),
          displaySmall: TextStyle(color: Color(0xFF2D2D2D)),
          headlineLarge: TextStyle(color: Color(0xFF2D2D2D)),
          headlineMedium: TextStyle(color: Color(0xFF2D2D2D)),
          headlineSmall: TextStyle(color: Color(0xFF2D2D2D)),
          titleLarge: TextStyle(color: Color(0xFF2D2D2D)),
          titleMedium: TextStyle(color: Color(0xFF2D2D2D)),
          titleSmall: TextStyle(color: Color(0xFF2D2D2D)),
          bodyLarge: TextStyle(color: Color(0xFF2D2D2D)),
          bodyMedium: TextStyle(color: Color(0xFF2D2D2D)),
          bodySmall: TextStyle(color: Color(0xFF2D2D2D)),
          labelLarge: TextStyle(color: Color(0xFF2D2D2D)),
          labelMedium: TextStyle(color: Color(0xFF2D2D2D)),
          labelSmall: TextStyle(color: Color(0xFF2D2D2D)),
        ),
        inputDecorationTheme: InputDecorationThemeData(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
        ),
        bottomSheetTheme: BottomSheetThemeData(
          showDragHandle: true,
          dragHandleColor: Color(0x282D2D2D),
        ),
      ),
      home: ScreenHome(),
    );
  }
}
