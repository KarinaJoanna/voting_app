import 'package:flutter/material.dart';
import 'package:voting_app/screens/nueva_votacion_screen.dart';
import 'package:voting_app/screens/continuar_votacion_screen.dart';
import 'package:voting_app/screens/cerrar_votaciones_screen.dart';
import 'package:voting_app/screens/resultados_screen.dart';

class WelcomeScreen extends StatefulWidget {
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  int _hoveredIndex = -1;

  Widget _buildOptionCard({
    required IconData icon,
    required String label,
    required Function onTap,
    required int index,
  }) {
    return MouseRegion(
      onEnter: (_) => setState(() {
        _hoveredIndex = index;
      }),
      onExit: (_) => setState(() {
        _hoveredIndex = -1;
      }),
      child: AnimatedContainer(
        duration: Duration(milliseconds: 200),
        margin: EdgeInsets.all(8.0),
        width: _hoveredIndex == index ? 160 : 150,
        height: _hoveredIndex == index ? 160 : 150,
        decoration: BoxDecoration(
          color: _hoveredIndex == index
              ? Colors.blueGrey[100]
              : Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(8.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 8.0,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: InkWell(
          onTap: () => onTap(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 48, color: Colors.blue),
              SizedBox(height: 8),
              Text(
                label,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Votación app')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Wrap(
            spacing: 16.0,
            runSpacing: 16.0,
            alignment: WrapAlignment.center,
            children: [
              _buildOptionCard(
                icon: Icons.add,
                label: 'Crear nueva votación',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => NuevaVotacionScreen()),
                  );
                },
                index: 0,
              ),
              _buildOptionCard(
                icon: Icons.how_to_vote,
                label: 'Continuar votación',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ContinuarVotacionScreen()),
                  );
                },
                index: 1,
              ),
              _buildOptionCard(
                icon: Icons.close,
                label: 'Cerrar votación',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => CerrarVotacionScreen()),
                  );
                },
                index: 2,
              ),
              _buildOptionCard(
                icon: Icons.poll,
                label: 'Consulta de resultados',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ResultadosScreen()),
                  );
                },
                index: 3,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
