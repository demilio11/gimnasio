import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:project/globales.dart';

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
      appBar: AppBar(
        toolbarHeight: 100,
        backgroundColor: appBarColor,
        title: Text(
          "Mi perfil",
          style: fuenteGrande,
        ),
      ),
      body: Column(
        children: [
          Text(
            "Género",
            style: fuenteChica,
          ),
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
              }).toList()),
          Text("Fecha de Nacimiento", style: fuenteChica),
          ElevatedButton(
              onPressed: () async {
                DateTime now = DateTime.now();
                DateTime? pickedDate = await showDatePicker(context: context, firstDate: DateTime(1900), lastDate: DateTime.now());
              },
              child: child),
          Text("Peso", style: fuenteChica),
          TextField(
            controller: pesoController,
            inputFormatters: [
              FilteringTextInputFormatter.deny(RegExp(r'["|!/()?$#%&°*+-:;]')),
            ],
            decoration: const InputDecoration(labelText: 'Tu peso'),
            keyboardType: TextInputType.number,
          ),
          Text("Altura", style: fuenteChica),
          TextField(
            controller: alturaController,
            inputFormatters: [
              FilteringTextInputFormatter.deny(RegExp(r'["|!/()?$#%&°*+-:;]')),
            ],
            decoration: const InputDecoration(labelText: 'Tu altura'),
            keyboardType: TextInputType.number,
          ),
          Text("¿Cuál es tu meta de peso?", style: fuenteChica),
          TextField(
            controller: pesoObjController,
            inputFormatters: [
              FilteringTextInputFormatter.deny(RegExp(r'["|!/()?$#%&°*+-:;]')),
            ],
            decoration: const InputDecoration(labelText: 'Peso objetivo'),
            keyboardType: TextInputType.number,
          ),
        ],
      ),
    );
  }
}
