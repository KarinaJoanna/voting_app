import 'package:flutter/material.dart';
import 'package:voting_app/models/votacion_models.dart';
import 'package:voting_app/services/votacion_service.dart';

class NuevaVotacionScreen extends StatefulWidget {
  @override
  _NuevaVotacionScreenState createState() => _NuevaVotacionScreenState();
}

class _NuevaVotacionScreenState extends State<NuevaVotacionScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nombreVotacionController =
      TextEditingController();
  final List<TextEditingController> _candidatoControllers = [
    TextEditingController(),
    TextEditingController()
  ];
  final VotacionService _votacionService = VotacionService();

  void _crearVotacion() async {
    if (_formKey.currentState!.validate()) {
      final nuevaVotacion = Votacion(
        DateTime.now().toString(),
        _nombreVotacionController.text,
        _candidatoControllers
            .map((controller) => Candidato(controller.text, 0))
            .toList(),
        true,
      );

      final votaciones = await _votacionService.obtenerVotaciones();
      votaciones.add(nuevaVotacion);
      await _votacionService.guardarVotaciones(votaciones);

      Navigator.pop(context);
    }
  }

  void _agregarCandidato() {
    setState(() {
      _candidatoControllers.add(TextEditingController());
    });
  }

  void _eliminarCandidato(int index) {
    setState(() {
      _candidatoControllers.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Crear nueva votación')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                controller: _nombreVotacionController,
                decoration: InputDecoration(
                  labelText: 'Nombre de la votación',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese el nombre de la votación';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              Expanded(
                child: Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: _candidatoControllers.map((controller) {
                            return Container(
                              width: 350,
                              height: 400, // Aumentamos el ancho de las cards
                              child: Card(
                                margin: EdgeInsets.symmetric(horizontal: 8.0),
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Icon(Icons.person, size: 50),
                                      SizedBox(height: 8),
                                      TextFormField(
                                        controller: controller,
                                        decoration: InputDecoration(
                                          labelText: 'Nombre del candidato',
                                          border: OutlineInputBorder(),
                                        ),
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Por favor ingrese el nombre del candidato';
                                          }
                                          return null;
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _agregarCandidato,
                      child: Text('Agregar candidato'),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: _crearVotacion,
                child: Text('Crear votación'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
