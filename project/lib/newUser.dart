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
          ],
        ),
      ),
    );
  }
}
