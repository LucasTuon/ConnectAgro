import 'package:flutter/material.dart';
import 'pages/home_page.dart';

// Ponto de entrada da aplicacao
// Aqui definimos o tema global e a tela inicial

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ConnectAgro',
      theme: ThemeData(
        primarySwatch: Colors.green,
        fontFamily: 'SegoeUI',
      ),
      debugShowCheckedModeBanner: false, 
      // Define a HomePage como a tela inicial
      home: const HomePage(),
    );
  }
}