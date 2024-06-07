import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:voting_app/models/votacion_models.dart';

class VotacionService {
  static const String _keyVotaciones = 'votaciones';

  Future<List<Votacion>> obtenerVotaciones() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(_keyVotaciones);
    if (data != null) {
      final List<dynamic> jsonData = jsonDecode(data);
      return jsonData.map<Votacion>((item) => Votacion.fromJson(item)).toList();
    }
    return [];
  }

  Future<void> guardarVotaciones(List<Votacion> votaciones) async {
    final prefs = await SharedPreferences.getInstance();
    final data = jsonEncode(votaciones.map((v) => v.toJson()).toList());
    await prefs.setString(_keyVotaciones, data);
  }
}
