class NovoKarte {
  final String id;
  final String nomeUsuario;
  final double valorSaldo;
  final DateTime dataInclusao;
  final String cpfUsuario;
  final bool acessoVip;
  final int acessoGratis;

  NovoKarte({
    required this.id,
    required this.nomeUsuario,
    required this.valorSaldo,
    required this.dataInclusao,
    required this.cpfUsuario,
    required this.acessoVip,
    required this.acessoGratis,
  });

  factory NovoKarte.fromJson(Map<String, dynamic> json) {
    return NovoKarte(
      id: json['id'],
      nomeUsuario: json['nomeUsuario'],
      valorSaldo: double.parse(json['valorSaldo'].toString()),
      dataInclusao: DateTime.fromMillisecondsSinceEpoch(json['dataInclusao']),
      cpfUsuario: json['cpfUsuario'],
      acessoVip: json['acessoVip'],
      acessoGratis: json['acessoGratis'] as int,
    );
  }
}
