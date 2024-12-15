class Sensor {
  final String comodo;
  final String nome;
  final Map<String, dynamic> dados;

  Sensor({required this.comodo, required this.nome, required this.dados});

  // Converter o sensor para JSON
  Map<String, dynamic> toJson() {
    return {
      'comodo': comodo,
      'nome': nome,
      'dados': dados,
    };
  }

  // Criar o sensor a partir do JSON
  factory Sensor.fromJson(Map<String, dynamic> json) {
    return Sensor(
      comodo: json['comodo'],
      nome: json['nome'],
      dados: Map<String, dynamic>.from(json['dados']),
    );
  }
}
