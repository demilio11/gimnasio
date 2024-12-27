import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

int id = -1;
String? userName;
String clave = "";
String? generoUsuario;
DateTime? fechaNac;
double? peso;
double? altura;
double? pesoObjetivo;
bool claveValida = false;

const Color fondo = Color.fromARGB(255, 0, 0, 0);
const Color appBarColor = Color.fromARGB(255, 82, 82, 82);

TextStyle fuenteChica = GoogleFonts.pirataOne(fontSize: 21, height: 1, color: Colors.white);
TextStyle fuenteMediana = GoogleFonts.pirataOne(fontSize: 26, height: 1, color: Colors.white);
TextStyle fuenteGrande = GoogleFonts.pirataOne(fontSize: 30, height: 1, color: Colors.white);

final databaseRef = FirebaseDatabase.instance.ref();
final usuariosRef = FirebaseDatabase.instance.ref("usuarios");

Function? actualizarEstadoMain;
