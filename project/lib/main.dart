import 'package:flutter/material.dart';
import 'package:project/auxiliares.dart';
import 'package:project/globales.dart';
import 'package:project/newUser.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
    actualizarEstadoMain = () {
      setState(() {});
    };
    leerShared();
  }

  @override
  void dispose() {
    actualizarEstadoMain = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (claveValida) {
      return const Scaffold();
    } else {
      return const Pantalla1();
    }
  }
}
