import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:voting_app/models/votacion_models.dart';
import 'package:voting_app/services/votacion_service.dart';

class ResultadosScreen extends StatelessWidget {
  final VotacionService _votacionService = VotacionService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Resultados de Votaciones')),
      body: FutureBuilder<List<Votacion>>(
        future: _votacionService.obtenerVotaciones(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No hay votaciones disponibles.'));
          }

          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final votacion = snapshot.data![index];
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
                            DetalleResultadosScreen(votacion: votacion),
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
                          votacion.estaAbierta
                              ? 'Votación en curso'
                              : 'Votación cerrada',
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

class DetalleResultadosScreen extends StatelessWidget {
  final Votacion votacion;

  DetalleResultadosScreen({required this.votacion});

  @override
  Widget build(BuildContext context) {
    List<charts.Series<Candidato, String>> series = [
      charts.Series(
        id: 'Votos',
        data: votacion.candidatos,
        domainFn: (Candidato candidato, _) => candidato.nombre,
        measureFn: (Candidato candidato, _) => candidato.votos,
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
      )
    ];

    int totalVotos =
        votacion.candidatos.fold(0, (sum, item) => sum + item.votos);

    return Scaffold(
      appBar: AppBar(title: Text('Resultados: ${votacion.nombre}')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: 16),
            Center(
              child: Container(
                height: 300,
                width: 800,
                child: charts.BarChart(
                  series,
                  animate: true,
                ),
              ),
            ),
            SizedBox(height: 16),
            Expanded(
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.75,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                itemCount: votacion.candidatos.length,
                itemBuilder: (context, index) {
                  final candidato = votacion.candidatos[index];
                  double porcentaje = (candidato.votos / totalVotos) * 100;

                  return Card(
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
                          Text(
                            'Votos: ${candidato.votos} (${porcentaje.toStringAsFixed(2)}%)',
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
