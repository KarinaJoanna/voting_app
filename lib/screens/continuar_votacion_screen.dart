import 'package:flutter/material.dart';
import 'package:voting_app/models/votacion_models.dart';
import 'package:voting_app/services/votacion_service.dart';

class ContinuarVotacionScreen extends StatelessWidget {
  final VotacionService _votacionService = VotacionService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Continuar Votación')),
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
                margin: EdgeInsets.all(16.0),
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.0),
                ),
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            DetalleVotacionScreen(votacion: votacion),
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          votacion.nombre,
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Candidatos: ${votacion.candidatos.length}',
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class DetalleVotacionScreen extends StatefulWidget {
  final Votacion votacion;

  DetalleVotacionScreen({required this.votacion});

  @override
  _DetalleVotacionScreenState createState() => _DetalleVotacionScreenState();
}

class _DetalleVotacionScreenState extends State<DetalleVotacionScreen> {
  final VotacionService _votacionService = VotacionService();

  void _votarPorCandidato(Candidato candidato) async {
    setState(() {
      candidato.votar();
    });

    // Guardar cambios en la votación
    final votaciones = await _votacionService.obtenerVotaciones();
    final index = votaciones.indexWhere((v) => v.id == widget.votacion.id);
    if (index != -1) {
      votaciones[index] = widget.votacion;
      await _votacionService.guardarVotaciones(votaciones);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Votación: ${widget.votacion.nombre}')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.75,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
          ),
          itemCount: widget.votacion.candidatos.length,
          itemBuilder: (context, index) {
            final candidato = widget.votacion.candidatos[index];
            return Card(
              margin: EdgeInsets.all(8.0),
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.person, size: 48, color: Colors.blue),
                    SizedBox(height: 8),
                    Text(
                      candidato.nombre,
                      style: TextStyle(fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: () {
                        _votarPorCandidato(candidato);
                      },
                      child: Text('Votar'),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
