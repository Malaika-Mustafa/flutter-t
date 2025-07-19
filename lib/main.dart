import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'todo_provider.dart';
import 'home_page.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ToDoProvider()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  final Color backgroundColor = const Color(0xFFF5F7FA);
  final Color textColor = const Color.fromARGB(255, 41, 8, 131);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Todo App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: backgroundColor,
        appBarTheme: AppBarTheme(
          backgroundColor: backgroundColor,
          foregroundColor: textColor,
          elevation: 0,
        ),
      
       
        useMaterial3: true,
      ),
      home: ListPage(),
    );
  }
}
