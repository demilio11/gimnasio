import 'package:project/globales.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> guardarShared(String idUsuario, String clave) async {
  SharedPreferences? prefs;
  prefs = await SharedPreferences.getInstance();
  await prefs.setString('userName', userName ?? "");
  await prefs.setString('clave', clave);
  await prefs.setString('generoUsuario', generoUsuario ?? "");
  await prefs.setString('fechaNac', dateToString(fechaNac));
  await prefs.setString('peso', peso.toString());
  await prefs.setString('altura', altura.toString());
  await prefs.setString('pesoObjetivo', pesoObjetivo.toString());
}

Future<void> leerShared() async {
  SharedPreferences? prefs;
  prefs = await SharedPreferences.getInstance();
  pass = prefs.getString('clave') ?? '';
  userName = prefs.getString('userName') ?? '';
  generoUsuario = prefs.getString('generoUsuario') ?? '';
  fechaNac = stringToDate(prefs.getString('fechaNac') ?? '');
  peso = prefs.getDouble('peso');
  altura = prefs.getDouble('altura');
  pesoObjetivo = prefs.getDouble('pesoObjetivo');
}

String dateToString(DateTime? date) {
  if (date == null) {
    return "";
  }
  return "${date.day}/${date.month}/${date.year}";
}

DateTime? stringToDate(String str) {
  List partes = str.split("/");
  if (partes.length == 3) {
    return DateTime(partes[0], partes[1], partes[2]);
  }
  return null;
}

bool areAllAsigned(List<Set> musculosPorDia) {
  Set focus = enfoque;
  for (var conj in musculosPorDia) {
    focus = focus.difference(conj);
  }
  return focus.isEmpty;
}

List assignTrainingDays(List<Set> musculosPorDia) {
  List result = [];
  for (var dia in musculosPorDia) {
    if (dia.isNotEmpty) {
      result.add(dia);
    } else {
      break;
    }
  }
  return result;
}
