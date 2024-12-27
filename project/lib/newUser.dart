import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
    if (!usuarioExiste && !newUser) {
      errorUser = "Usuario inexistente";
      result = true;
    }
    if (!claveCorrecta && !newUser) {
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
          //hacer este boton
          const Text("Ingresar con google"),
          TextField(
            controller: usuario,
            inputFormatters: [
              FilteringTextInputFormatter.deny(RegExp(r'["|!/()?$#%&°*+-:;]')),
            ],
            decoration: InputDecoration(
                hintText: 'Usuario',
                errorText: errorUser,
                filled: true,
                fillColor: Colors.white,
                border: const OutlineInputBorder(),
                labelStyle: fuenteChica),
          ),
          TextField(
            controller: clave,
            inputFormatters: [
              FilteringTextInputFormatter.deny(RegExp(r'["|!/()?$#%&°*+-:;]')),
            ],
            decoration: InputDecoration(labelText: 'clave', labelStyle: fuenteChica),
          ),
          if (newUser) ...[
            TextField(
              controller: repetirClave,
              inputFormatters: [
                FilteringTextInputFormatter.deny(RegExp(r'["|!/()?$#%&°*+-:;]')),
              ],
              decoration: InputDecoration(labelText: 'repetirClave', labelStyle: fuenteChica),
            ),
          ],

          ElevatedButton(
              onPressed: () {
                setState(() {
                  newUser = !newUser;
                });
              },
              child: !newUser ? const Text("Crear nueva cuenta") : const Text("Ingresar usuario")),
          if (newUser) ...[
            ElevatedButton(
                onPressed: () async {
                  bool error = await hayError();
                  if (!error) {
                    setState(() {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const Pantalla1(),
                        ),
                      );
                    });
                  }
                },
                child: const Text("Crear Usuario"))
          ],
          if (!newUser) ...[
            ElevatedButton(
                onPressed: () async {
                  bool error = await hayError();
                  if (!error) {
                    setState(() {
                      //acá iria la app
                    });
                  }
                },
                child: const Text("Ingresar"))
          ]
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
  TextEditingController pesoController = TextEditingController();
  TextEditingController alturaController = TextEditingController();
  TextEditingController pesoObjController = TextEditingController();
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
                    onChanged: (String? newValue) {
                      setState(() {
                        generoUsuario = newValue;
                      });
                    },
                    items: generos.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList())
              ],
            ),
            const SizedBox(height: 15),
            Row(
              children: [
                Text(
                  "Fecha de Nacimiento",
                  style: fuenteChica,
                ),
                const SizedBox(width: 15),
                ElevatedButton(
                  onPressed: () async {
                    DateTime? pickedDate = await showDatePicker(context: context, firstDate: DateTime(1900), lastDate: DateTime.now());
                    if (pickedDate != null) {
                      setState(() {
                        fechaNac = pickedDate;
                      });
                    }
                  },
                  child: const Text('Seleccionar fecha de nacimiento'),
                ),
              ],
            ),
            const SizedBox(height: 15),
            Container(
              alignment: Alignment.centerLeft,
              child: Text(
                "Peso:",
                style: fuenteChica,
              ),
            ),
            TextField(
              controller: pesoController,
              inputFormatters: [
                FilteringTextInputFormatter.deny(RegExp(r'["|!/()?$#%&°*+-:;]')),
              ],
              decoration: InputDecoration(labelText: 'Tu peso', labelStyle: fuenteChica),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 15),
            Container(alignment: Alignment.centerLeft, child: Text("Altura", style: fuenteChica)),
            TextField(
              controller: alturaController,
              inputFormatters: [
                FilteringTextInputFormatter.deny(RegExp(r'["|!/()?$#%&°*+-:;]')),
              ],
              decoration: InputDecoration(labelText: 'Tu altura', labelStyle: fuenteChica),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 15),
            Container(alignment: Alignment.centerLeft, child: Text("¿Cuál es tu meta de peso?", style: fuenteChica)),
            TextField(
              controller: pesoObjController,
              inputFormatters: [
                FilteringTextInputFormatter.deny(RegExp(r'["|!/()?$#%&°*+-:;]')),
              ],
              decoration: InputDecoration(labelText: 'Peso objetivo', labelStyle: fuenteChica),
              keyboardType: TextInputType.number,
            ),
            ElevatedButton(
              onPressed: () async {
                //genera problema de concurrencia, revisar a futuro
                final snapUsuarios = await usuariosRef.get();
                if (snapUsuarios.exists) {
                  int maxId = 0;
                  for (var user in snapUsuarios.children) {
                    maxId = max(maxId, int.tryParse(user.key ?? "") ?? -1);
                  }
                  Map<String, dynamic> datosUser = {
                    "genero": generoUsuario,
                    "fechaNac": dateToString(fechaNac),
                    "peso": pesoController.text,
                    "altura": alturaController.text,
                    "pesoObjetivo": pesoObjController.text
                  };
                  await usuariosRef.child("$maxId").update(datosUser);
                  id = maxId;
                  peso = pesoController.text as double;
                  altura = alturaController.text as double;
                  pesoObjetivo = pesoObjController.text as double;
                } else {
                  //crear usuarios si no existe
                }
                setState(() {});
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
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class Pantalla3 extends StatefulWidget {
  const Pantalla3({super.key});

  @override
  State<Pantalla3> createState() => _Pantalla3State();
}

class _Pantalla3State extends State<Pantalla3> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
