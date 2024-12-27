import 'package:project/globales.dart';

Future<void> verificarClaveUsuario() async {
  final snapUsuario = await usuariosRef.child("$id/clave").get();

  if (snapUsuario.exists) {
    String claveAlmacenada = snapUsuario.value.toString();
    claveValida = claveAlmacenada == clave;
  }
  claveValida = false;
}
