import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project/auxiliares.dart';
import 'package:project/globales.dart';

//checkear errores en los campos de texto

class Pantalla0 extends StatefulWidget {
  const Pantalla0({super.key});

  @override
  State<Pantalla0> createState() => _Pantalla0State();
}

class _Pantalla0State extends State<Pantalla0> {
  bool newUser = false;
  TextEditingController usuario = TextEditingController();
  TextEditingController clave = TextEditingController();
  TextEditingController repetirClave = TextEditingController();
  String errorUser = "";
  String errorClave = "";
  String errorConfirmarClave = "";

  Future<bool> hayError() async {
    bool result = false;
    errorClave = "";
    errorConfirmarClave = "";
    errorUser = "";
    if (usuario.text.isEmpty) {
      errorUser = "Debe elegir un nombre de usuario";
      result = true;
    }
    if (clave.text.isEmpty) {
      errorClave = "Debe ingresar una contraseña";
      result = true;
    }
    if (repetirClave.text.isEmpty && newUser) {
      errorConfirmarClave = "Debe ingresar nuevamente la clave";
      result = true;
    }
    if (repetirClave.text != clave.text && newUser) {
      errorConfirmarClave = "Las claves deben coincidir";
      result = true;
    }
    bool usuarioExiste = false;
    bool claveCorrecta = false;
    final snapUsuarios = await usuariosRef.get();
    if (snapUsuarios.exists) {
      for (var user in snapUsuarios.children) {
        if (user.child("usuario").value.toString() == usuario.text) {
          usuarioExiste = true;
        }
        if (user.child("clave").value.toString() == clave.text) {
          claveCorrecta = true;
        }
      }
    }
    if (!usuarioExiste && !newUser && errorUser == "") {
      errorUser = "Usuario inexistente";
      result = true;
    }
    if (!claveCorrecta && !newUser && errorClave == "") {
      errorClave = "Clave incorrecta";
      result = true;
    }
    setState(() {});
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appBarColor,
      body: Column(
        children: [
          const SizedBox(height: 15),
          //hacer este boton
          Text("Ingresar con google", style: fuenteMediana),
          const SizedBox(height: 15),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: TextField(
              style: fuenteChica,
              controller: usuario,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[0-9a-zA-Z]')), // Permitir números y letras
              ],
              decoration: InputDecoration(
                  hintText: 'Usuario',
                  errorText: errorUser,
                  hintStyle: fuenteChica,
                  errorStyle: fuenteError,
                  border: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  )),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: TextField(
              style: fuenteChica,
              controller: clave,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[0-9a-zA-Z]')),
              ],
              decoration: InputDecoration(
                hintText: 'Clave',
                errorText: errorClave,
                hintStyle: fuenteChica,
                errorStyle: fuenteError,
                border: const OutlineInputBorder(),
              ),
            ),
          ),
          if (newUser) ...[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: TextField(
                style: fuenteChica,
                controller: repetirClave,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9a-zA-Z]')),
                ],
                decoration: InputDecoration(
                  hintText: 'repetirClave',
                  errorText: errorConfirmarClave,
                  hintStyle: fuenteChica,
                  errorStyle: fuenteError,
                  border: const OutlineInputBorder(),
                ),
              ),
            ),
          ],
          if (!newUser) ...[
            ElevatedButton(
              onPressed: () async {
                bool error = await hayError();
                if (!error) {
                  setState(() {
                    //aca iria la app
                  });
                } else {
                  if (context.mounted) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const Pantalla5(),
                      ),
                    );
                  }
                }
              },
              style: ButtonStyle(backgroundColor: WidgetStateProperty.all<Color>(Colors.blue)),
              child: Text("Iniciar Sesion", style: GoogleFonts.pirataOne(fontSize: 21, height: 1, color: Colors.white)),
            )
          ],
          if (newUser) ...[
            ElevatedButton(
                onPressed: () async {
                  bool error = await hayError();
                  if (!error) {
                    setState(() {
                      userName = usuario.text;
                      pass = clave.text;
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const Pantalla1(),
                        ),
                      );
                    });
                  }
                },
                style: ButtonStyle(backgroundColor: WidgetStateProperty.all<Color>(Colors.blue)),
                child: Text("Crear Usuario", style: GoogleFonts.pirataOne(fontSize: 21, height: 1, color: Colors.white)))
          ],
          const SizedBox(height: 15),
          ElevatedButton(
              onPressed: () {
                setState(() {
                  newUser = !newUser;
                });
              },
              style: ButtonStyle(backgroundColor: WidgetStateProperty.all<Color>(Colors.blue)),
              child: !newUser
                  ? Text("Crear nueva cuenta", style: GoogleFonts.pirataOne(fontSize: 21, height: 1, color: Colors.white))
                  : Text("¿Ya tienes una cuenta?", style: GoogleFonts.pirataOne(fontSize: 21, height: 1, color: Colors.white))),
        ],
      ),
    );
  }
}

class Pantalla1 extends StatefulWidget {
  const Pantalla1({super.key});

  @override
  State<Pantalla1> createState() => _Pantalla1State();
}

class _Pantalla1State extends State<Pantalla1> {
  List<String> generos = ["Masculino", "Femenino", "Otro"];
  String generoSelected = "Otro";
  String errorPeso = "";
  String errorAltura = "";
  String errorPesoObj = "";
  TextEditingController pesoController = TextEditingController();
  TextEditingController alturaController = TextEditingController();
  TextEditingController pesoObjController = TextEditingController();

  bool hayErrorIMC() {
    int peso = int.tryParse(pesoController.text) ?? 0;
    int pesoObj = int.tryParse(pesoObjController.text) ?? 0;
    double altura = double.tryParse(alturaController.text) ?? 0;
    errorPeso = "";
    errorAltura = "";
    errorPesoObj = "";
    bool result = false;
    if ((peso < 1 || peso > 999) && pesoController.text != "") {
      errorPeso = "Ingrese un peso válido";
      result = true;
    }
    if ((pesoObj < 1 || pesoObj > 999) && pesoObjController.text != "") {
      errorPesoObj = "Ingrese un peso válido";
      result = true;
    }
    if ((altura < 1 || altura > 2.5) && alturaController.text != "") {
      errorAltura = "Ingrese una altura válida";
      result = true;
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appBarColor,
      appBar: AppBar(
        toolbarHeight: 100,
        backgroundColor: appBarColor,
        title: Text(
          "Mi perfil",
          style: fuenteGrande,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
        child: Column(
          children: [
            Row(
              children: [
                Text(
                  "Género:",
                  style: fuenteChica,
                ),
                const SizedBox(width: 15),
                DropdownButton<String>(
                  value: generoSelected,
                  dropdownColor: const Color.fromARGB(255, 82, 82, 82),
                  style: fuenteChica,
                  onChanged: (String? newValue) {
                    setState(() {
                      generoUsuario = newValue;
                      generoSelected = newValue!;
                    });
                  },
                  items: generos.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Container(
                        color: const Color.fromARGB(255, 82, 82, 82), // Fondo personalizado
                        child: Text(
                          value,
                          style: fuenteChica.copyWith(color: Colors.white), // Texto blanco
                        ),
                      ),
                    );
                  }).toList(),
                )
              ],
            ),
            const SizedBox(height: 15),
            Row(
              children: [
                Text(
                  "Fecha de Nacimiento:",
                  style: fuenteChica,
                ),
                const SizedBox(width: 15),
                if (fechaNac != null) ...[
                  Text("${fechaNac!.day}-${fechaNac!.month}-${fechaNac!.year}", style: fuenteChica),
                ],
                const SizedBox(width: 15),
                ElevatedButton(
                  onPressed: () async {
                    DateTime? pickedDate = await showDatePicker(context: context, firstDate: DateTime(1900), lastDate: DateTime.now());
                    setState(() {
                      fechaNac = pickedDate;
                    });
                  },
                  child: const Text('Fecha de nacimiento'),
                ),
              ],
            ),
            const SizedBox(height: 15),
            Container(alignment: Alignment.centerLeft, child: Text("Tu peso", style: fuenteChica)),
            const SizedBox(height: 15),
            TextField(
                controller: pesoController,
                style: fuenteChica,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                ],
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: 'Tu peso',
                  errorText: errorPeso,
                  hintStyle: fuenteChica,
                  errorStyle: fuenteError,
                  border: const OutlineInputBorder(),
                )),
            const SizedBox(height: 15),
            Container(alignment: Alignment.centerLeft, child: Text("Tu altura", style: fuenteChica)),
            const SizedBox(height: 15),
            TextField(
              controller: alturaController,
              style: fuenteChica,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
              ],
              decoration: InputDecoration(
                hintText: 'Tu altura',
                errorText: errorAltura,
                hintStyle: fuenteChica,
                errorStyle: fuenteError,
                border: const OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 15),
            Container(alignment: Alignment.centerLeft, child: Text("¿Cuál es tu meta de peso?", style: fuenteChica)),
            const SizedBox(height: 15),
            TextField(
              style: fuenteChica,
              controller: pesoObjController,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
              ],
              decoration: InputDecoration(
                hintText: 'Peso objetivo',
                errorText: errorPesoObj,
                hintStyle: fuenteChica,
                errorStyle: fuenteError,
                border: const OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            ElevatedButton(
              onPressed: () {
                //genera problema de concurrencia, revisar a futuro
                if (!hayErrorIMC()) {
                  peso = double.tryParse(pesoController.text) ?? -1;
                  altura = double.tryParse(alturaController.text) ?? -1;
                  pesoObjetivo = double.tryParse(pesoObjController.text) ?? -1;

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Pantalla2(),
                    ),
                  );
                } else {
                  //alejo, acá pone que hubo un error con el peso del user
                  setState(() {});
                }
              },
              child: const Text("Continuar"),
            )
          ],
        ),
      ),
    );
  }
}

class Pantalla2 extends StatefulWidget {
  const Pantalla2({super.key});

  @override
  State<Pantalla2> createState() => _Pantalla2State();
}

class _Pantalla2State extends State<Pantalla2> {
  bool isButtonSelected = false;
  int intButton = -1;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appBarColor,
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back),
          )
        ],
        toolbarHeight: 100,
        backgroundColor: appBarColor,
        title: Text(
          "Mi perfil",
          style: fuenteGrande,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
        child: Column(
          children: [
            Text(
              "¿Cuál es tu objetivo?",
              style: fuenteMediana,
            ),
            const SizedBox(height: 15),
            ElevatedButton(
              onPressed: () async {
                setState(() {
                  isButtonSelected = true;
                  intButton = 1;
                });
              },
              style: intButton == 1
                  ? ButtonStyle(backgroundColor: WidgetStateProperty.all<Color>(Colors.lightBlue))
                  : ButtonStyle(backgroundColor: WidgetStateProperty.all<Color>(Colors.grey)),
              child: Text("Hipertrofia \n Gana masa muscular y músculos voluminosos.", style: fuenteMediana),
            ),
            const SizedBox(height: 15),
            ElevatedButton(
              onPressed: () async {
                setState(() {
                  isButtonSelected = true;
                  intButton = 2;
                });
              },
              style: intButton == 2
                  ? ButtonStyle(backgroundColor: WidgetStateProperty.all<Color>(Colors.lightBlue))
                  : ButtonStyle(backgroundColor: WidgetStateProperty.all<Color>(Colors.grey)),
              child: Text(
                "Definición Muscular \n Músculos más fuertes, más rígidos y más visibles.",
                style: fuenteMediana,
              ),
            ),
            const SizedBox(height: 15),
            ElevatedButton(
              onPressed: () async {
                setState(() {
                  isButtonSelected = true;
                  intButton = 3;
                });
              },
              style: intButton == 3
                  ? ButtonStyle(backgroundColor: WidgetStateProperty.all<Color>(Colors.lightBlue))
                  : ButtonStyle(backgroundColor: WidgetStateProperty.all<Color>(Colors.grey)),
              child: Text(
                "Perder peso \n Perder grasa corporal.",
                style: fuenteMediana,
              ),
            ),
            const SizedBox(height: 15),
            ElevatedButton(
              onPressed: () async {
                if (isButtonSelected) {
                  objetivo = allObjetives[intButton - 1];
                  setState(() {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const Pantalla3(),
                      ),
                    );
                  });
                }
              },
              style: isButtonSelected
                  ? ButtonStyle(backgroundColor: WidgetStateProperty.all<Color>(Colors.lightBlue))
                  : ButtonStyle(backgroundColor: WidgetStateProperty.all<Color>(Colors.grey)),
              child: const Text("Continuar"),
            ),
          ],
        ),
      ),
    );
  }
}

class Pantalla3 extends StatefulWidget {
  const Pantalla3({super.key});

  @override
  State<Pantalla3> createState() => _Pantalla3State();
}

class _Pantalla3State extends State<Pantalla3> {
  bool isBalanced = true;
  Set selectedButtons = {};
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appBarColor,
      appBar: AppBar(
        toolbarHeight: 100,
        backgroundColor: appBarColor,
        title: Text(
          "Mi perfil",
          style: fuenteGrande,
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 40, right: 40),
        child: Column(
          children: [
            Text(
              "¿En qué grupo muscular quieres enfocarte?",
              style: fuenteMediana,
            ),
            const SizedBox(height: 40),
            Row(
              children: [
                ElevatedButton(
                  onPressed: () async {
                    setState(() {
                      isBalanced = true;
                      selectedButtons.clear();
                    });
                  },
                  style: isBalanced
                      ? ButtonStyle(backgroundColor: WidgetStateProperty.all<Color>(Colors.lightBlue))
                      : ButtonStyle(backgroundColor: WidgetStateProperty.all<Color>(Colors.grey)),
                  child: Text("Balanceado \nRecomendado", style: fuenteMediana),
                ),
                const SizedBox(width: 15),
                ElevatedButton(
                  onPressed: () async {
                    setState(() {
                      isBalanced = false;
                      if (selectedButtons.contains("Pecho")) {
                        selectedButtons.remove("Pecho");
                      } else {
                        selectedButtons.add("Pecho");
                      }
                    });
                  },
                  style: selectedButtons.contains("Pecho")
                      ? ButtonStyle(backgroundColor: WidgetStateProperty.all<Color>(Colors.lightBlue))
                      : ButtonStyle(backgroundColor: WidgetStateProperty.all<Color>(Colors.grey)),
                  child: Text("Pecho", style: fuenteMediana),
                ),
              ],
            ),
            const SizedBox(height: 15),
            buildButtonRow("Espalda", "Bíceps"),
            const SizedBox(height: 15),
            buildButtonRow("Triceps", "Piernas"),
            const SizedBox(height: 15),
            buildButtonRow("Abdomen", "Gluteos"),
            const SizedBox(height: 15),
            buildButtonRow("Hombros", "Trapecios"),
            const SizedBox(height: 15),
            ElevatedButton(
                onPressed: () {
                  enfoque = selectedButtons;
                  if (enfoque.isEmpty) {
                    enfoque = allMuscles;
                  }
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Pantalla4(),
                    ),
                  );
                },
                style: ButtonStyle(backgroundColor: WidgetStateProperty.all<Color>(Colors.lightBlue)),
                child: Text(
                  "Continuar",
                  style: fuenteMediana,
                ))
          ],
        ),
      ),
    );
  }

  Widget buildButtonRow(String firstButtonText, String secondButtonText) {
    return Row(
      children: [
        ElevatedButton(
          onPressed: () async {
            setState(() {
              isBalanced = false;
              if (selectedButtons.contains(firstButtonText)) {
                selectedButtons.remove(firstButtonText);
              } else {
                selectedButtons.add(firstButtonText);
              }
            });
          },
          style: selectedButtons.contains(firstButtonText)
              ? ButtonStyle(backgroundColor: WidgetStateProperty.all<Color>(Colors.lightBlue))
              : ButtonStyle(backgroundColor: WidgetStateProperty.all<Color>(Colors.grey)),
          child: Text(firstButtonText, style: fuenteMediana), // Segundo fragmento de texto
        ),
        const SizedBox(width: 15),
        ElevatedButton(
          onPressed: () async {
            setState(() {
              isBalanced = false;
              if (selectedButtons.contains(secondButtonText)) {
                selectedButtons.remove(secondButtonText);
              } else {
                selectedButtons.add(secondButtonText);
              }
            });
          },
          style: selectedButtons.contains(secondButtonText)
              ? ButtonStyle(backgroundColor: WidgetStateProperty.all<Color>(Colors.lightBlue))
              : ButtonStyle(backgroundColor: WidgetStateProperty.all<Color>(Colors.grey)),
          child: Text(secondButtonText, style: fuenteMediana), // Segundo fragmento de texto
        ),
      ],
    );
  }
}

class Pantalla4 extends StatefulWidget {
  const Pantalla4({super.key});

  @override
  State<Pantalla4> createState() => _Pantalla4State();
}

class _Pantalla4State extends State<Pantalla4> {
  String selected = "Principiante";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appBarColor,
      appBar: AppBar(
        toolbarHeight: 100,
        backgroundColor: appBarColor,
        title: Text(
          "Mi perfil",
          style: fuenteGrande,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
        child: Column(
          children: [
            Text(
              "¿Cúal es tu experiencia?",
              style: fuenteMediana,
            ),
            const SizedBox(height: 15),
            boton("Principiante \nMenos de 6 meses de experiencia."),
            const SizedBox(height: 15),
            boton("Intermedio \nMás de 6 meses y menos de 2 años."),
            const SizedBox(height: 15),
            boton("Avanzado \nMás de 2 años."),
            const SizedBox(height: 15),
            ElevatedButton(
                onPressed: () {
                  experiencia = selected;
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Pantalla5(),
                    ),
                  );
                },
                style: ButtonStyle(backgroundColor: WidgetStateProperty.all<Color>(Colors.lightBlue)),
                child: Text(
                  "Continuar",
                  style: fuenteMediana,
                ))
          ],
        ),
      ),
    );
  }

  Widget boton(String texto) {
    return ElevatedButton(
        onPressed: () {
          setState(() {
            selected = texto.split(' ')[0];
          });
        },
        style: selected == texto.split(' ')[0]
            ? ButtonStyle(backgroundColor: WidgetStateProperty.all<Color>(Colors.lightBlue))
            : ButtonStyle(backgroundColor: WidgetStateProperty.all<Color>(Colors.grey)),
        child: Text(
          texto,
          style: fuenteMediana,
        ));
  }
}

class Pantalla5 extends StatefulWidget {
  const Pantalla5({super.key});
  @override
  State<Pantalla5> createState() => _Pantalla5State();
}

class _Pantalla5State extends State<Pantalla5> {
  int cantidadDias = 1;
  bool wasSelected = false;
  List<int> dias = [1, 2, 3, 4, 5, 6, 7];
  List<Set> musculosPorDia = List.generate(7, (index) => {});
  bool valorSwitch = true;
  void mostrarDialogo() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            "¿Activar notificaciones?",
            style: GoogleFonts.pirataOne(fontSize: 21, height: 1, color: Colors.black),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "¿Desea habilitar las notificaciones?",
                style: GoogleFonts.pirataOne(fontSize: 24, height: 1, color: Colors.black),
              ),
              const SizedBox(height: 20),
              Switch(
                value: valorSwitch,
                onChanged: (bool nuevoValor) {
                  setState(() {
                    valorSwitch = nuevoValor;
                  });
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              child: Text("Aceptar", style: GoogleFonts.pirataOne(fontSize: 21, height: 1, color: Colors.green)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appBarColor,
      appBar: AppBar(
        toolbarHeight: 100,
        backgroundColor: appBarColor,
        title: Text(
          "Mi cuenta",
          style: fuenteGrande,
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 15, right: 15, top: 15),
        child: Column(
          children: [
            Text(
              "¿Cuántos dias a la semana desea entrenar?",
              style: fuenteMediana,
            ),
            DropdownButton<int>(
              value: cantidadDias,
              dropdownColor: const Color.fromARGB(255, 82, 82, 82),
              style: fuenteChica,
              onChanged: (int? newValue) {
                setState(() {
                  cantidadDias = newValue!;
                  wasSelected = true;
                });
              },
              items: dias.map<DropdownMenuItem<int>>((int value) {
                return DropdownMenuItem<int>(
                  value: value,
                  child: Container(
                    color: const Color.fromARGB(255, 82, 82, 82), // Fondo personalizado
                    child: Text(
                      "$value",
                      style: fuenteChica.copyWith(color: Colors.white), // Texto blanco
                    ),
                  ),
                );
              }).toList(),
            ),
            if (wasSelected) ...[
              Text("Asigne los grupos musculares a cada día de entrenamiento", style: fuenteMediana),
              const SizedBox(height: 15),
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Row(
                  children: [
                    Column(
                      children: List.generate(cantidadDias, (i) => botonDia(i, musculosPorDia[i])),
                    ),
                    const SizedBox(width: 15),
                    Column(children: enfoque.map((musc) => botonMusculo(musc)).toList())
                  ],
                ),
              ),
              const SizedBox(height: 15),
              ElevatedButton(
                onPressed: () async {
                  mostrarDialogo();
                  //ojo con la concurrencia
                  if (areAllAsigned(musculosPorDia)) {
                    List trainingDays = assignTrainingDays(musculosPorDia);
                    final snapUsuarios = await usuariosRef.get();
                    Map<String, dynamic> datosUser = {
                      "usuario": userName,
                      "clave": pass,
                      "genero": generoUsuario,
                      "fechaNac": dateToString(fechaNac),
                      "peso": peso,
                      "altura": altura,
                      "pesoObjetivo": pesoObjetivo,
                      "objetivo": objetivo,
                      "enfoque": enfoque,
                      "nivel de experiencia": experiencia,
                      "dias de entrenamiento": trainingDays,
                      "notificaciones": valorSwitch
                    };
                    if (snapUsuarios.exists) {
                      //usar pivots y hacer busqueda binaria
                      int maxId = 0;
                      for (var user in snapUsuarios.children) {
                        maxId = max(maxId, int.tryParse(user.key ?? "") ?? -1);
                      }
                      maxId += 1;

                      await usuariosRef.child("$maxId").update(datosUser);
                      id = maxId;
                    } else {
                      await databaseRef.child("usuarios/1").update(datosUser);
                    }
                    setState(() {
                      //redirigir a la aplicación
                    });
                  } else {
                    //alejo, pone un mensaje de que te falta seleccionar musculos
                  }
                },
                style: ButtonStyle(backgroundColor: WidgetStateProperty.all<Color>(Colors.blue)),
                child: Text("Continuar", style: GoogleFonts.pirataOne(fontSize: 21, height: 1, color: Colors.white)),
              )
            ]
          ],
        ),
      ),
    );
  }

// Botón de músculo que puede arrastrarse
  Widget botonMusculo(String musc) {
    return Draggable<String>(
      data: musc, // El dato que será arrastrado
      feedback: ElevatedButton(
        onPressed: () {},
        style: ButtonStyle(backgroundColor: WidgetStateProperty.all<Color>(Colors.lightBlue)),
        child: Text(musc, style: fuenteChica),
      ),
      childWhenDragging: ElevatedButton(
        onPressed: () {},
        style: ButtonStyle(backgroundColor: WidgetStateProperty.all<Color>(Colors.grey)), // Color cambiado mientras se arrastra
        child: Text(musc, style: fuenteChica),
      ),
      child: ElevatedButton(
        onPressed: () {},
        style: ButtonStyle(backgroundColor: WidgetStateProperty.all<Color>(Colors.lightBlue)),
        child: Text(musc, style: fuenteChica),
      ),
    );
  }

// Botón del día que actúa como un "target" de los músculos arrastrados
  Widget botonDia(int i, Set musculos) {
    return GestureDetector(
      onLongPress: () {
        setState(() {
          musculos.clear(); // Vacía el conjunto de músculos del día al hacer long press
        });
      },
      child: DragTarget<String>(
        onAcceptWithDetails: (DragTargetDetails<String> details) {
          setState(() {
            musculos.add(details.data); // Añadir el músculo cuando se suelta sobre el día
          });
        },
        builder: (context, candidateData, rejectedData) {
          return ElevatedButton(
            onPressed: () {},
            style: ButtonStyle(backgroundColor: WidgetStateProperty.all<Color>(Colors.lightBlue)),
            child: Text(
              "Día ${i + 1} (${musculos.isNotEmpty ? musculos.join(', ') : 'Vacio'})",
              style: fuenteChica,
            ),
          );
        },
      ),
    );
  }
}
