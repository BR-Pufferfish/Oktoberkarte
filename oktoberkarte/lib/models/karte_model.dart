class NovoKarte {
  final String id;
  final String nomeUsuario;
  final double valorSaldo;
  final DateTime dataInclusao;

  NovoKarte({
    required this.id,
    required this.nomeUsuario,
    required this.valorSaldo,
    required this.dataInclusao,
  });

  factory NovoKarte.fromJson(Map<String, dynamic> json) {
    return NovoKarte(
      id: json['id'],
      nomeUsuario: json['nomeUsuario'],
      valorSaldo: double.parse(json['valorSaldo'].toString()),
      dataInclusao: DateTime.fromMillisecondsSinceEpoch(json['dataInclusao']),
    );
  }
}
