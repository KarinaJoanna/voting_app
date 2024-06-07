class Candidato {
  String nombre;
  int votos;

  Candidato(this.nombre, this.votos);

  // Método para convertir una instancia de Candidato a JSON
  Map<String, dynamic> toJson() => {
        'nombre': nombre,
        'votos': votos,
      };

  // Método para crear una instancia de Candidato desde JSON
  factory Candidato.fromJson(Map<String, dynamic> json) => Candidato(
        json['nombre'],
        json['votos'],
      );

  // Método para incrementar los votos
  void votar() {
    votos++;
  }
}

class Votacion {
  String id;
  String nombre;
  List<Candidato> candidatos;
  bool estaAbierta;

  Votacion(this.id, this.nombre, this.candidatos, this.estaAbierta);

  // Método para convertir una instancia de Votacion a JSON
  Map<String, dynamic> toJson() => {
        'id': id,
        'nombre': nombre,
        'candidatos': candidatos.map((c) => c.toJson()).toList(),
        'estaAbierta': estaAbierta,
      };

  // Método para crear una instancia de Votacion desde JSON
  factory Votacion.fromJson(Map<String, dynamic> json) => Votacion(
        json['id'],
        json['nombre'],
        (json['candidatos'] as List)
            .map((item) => Candidato.fromJson(item))
            .toList(),
        json['estaAbierta'],
      );
}
