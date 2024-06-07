import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:voting_app/models/votacion_models.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> guardarVotacion(Votacion votacion) async {
    await _db.collection('votaciones').doc(votacion.id).set(votacion.toJson());
  }

  Future<List<Votacion>> obtenerVotaciones() async {
    QuerySnapshot snapshot = await _db.collection('votaciones').get();
    return snapshot.docs
        .map((doc) => Votacion.fromJson(doc.data() as Map<String, dynamic>))
        .toList();
  }

  Future<void> actualizarVotos(
      String votacionId, String candidatoNombre) async {
    final votacionRef = _db.collection('votaciones').doc(votacionId);
    final votacionSnapshot = await votacionRef.get();
    if (votacionSnapshot.exists) {
      final votacionData = votacionSnapshot.data() as Map<String, dynamic>;
      final votacion = Votacion.fromJson(votacionData);

      final candidato =
          votacion.candidatos.firstWhere((c) => c.nombre == candidatoNombre);
      candidato.votos += 1;

      await votacionRef.update(votacion.toJson());
    }
  }
}
