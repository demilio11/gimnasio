import 'dart:ffi';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

int id = -1;
String? userName;
String clave = "";
String? generoUsuario;
DateTime? fechaNac;
Double? peso;
Double? altura;
Double? pesoObjetivo;

const Color fondo = Color.fromARGB(255, 0, 0, 0);
const Color appBarColor = Color.fromARGB(255, 82, 82, 82);

TextStyle fuenteChica = GoogleFonts.pirataOne(fontSize: 14, height: 1, color: Colors.white);
TextStyle fuenteMediana = GoogleFonts.pirataOne(fontSize: 21, height: 1, color: Colors.white);
TextStyle fuenteGrande = GoogleFonts.pirataOne(fontSize: 28, height: 1, color: Colors.white);
