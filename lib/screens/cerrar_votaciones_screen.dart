import 'package:flutter/material.dart';
import 'package:voting_app/models/votacion_models.dart';
import 'package:voting_app/services/votacion_service.dart';

class CerrarVotacionScreen extends StatelessWidget {
  final VotacionService _votacionService = VotacionService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Cerrar Votación')),
      body: FutureBuilder<List<Votacion>>(
        future: _votacionService.obtenerVotaciones(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No hay votaciones disponibles.'));
          }

          final votacionesAbiertas =
              snapshot.data!.where((v) => v.estaAbierta).toList();
          if (votacionesAbiertas.isEmpty) {
            return Center(child: Text('No hay votaciones abiertas.'));
          }

          return ListView.builder(
            itemCount: votacionesAbiertas.length,
            itemBuilder: (context, index) {
              final votacion = votacionesAbiertas[index];
              return Card(
                margin: EdgeInsets.all(8.0),
                child: ListTile(
                  title: Text(votacion.nombre),
                  subtitle: Text('Candidatos: ${votacion.candidatos.length}'),
                  onTap: () async {
                    votacion.estaAbierta = false;
                    final votaciones =
                        await _votacionService.obtenerVotaciones();
                    final index =
                        votaciones.indexWhere((v) => v.id == votacion.id);
                    if (index != -1) {
                      votaciones[index] = votacion;
                      await _votacionService.guardarVotaciones(votaciones);
                    }
                    Navigator.pop(context);
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
