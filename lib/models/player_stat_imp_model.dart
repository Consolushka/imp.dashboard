class PlayerStatImp {
  final double imp;
  final String per;

  PlayerStatImp({required this.imp, required this.per});

  factory PlayerStatImp.fromJson(Map<String, dynamic> json) {
    return PlayerStatImp(
      imp: json['imp'] as double,
      per: json['per'] as String
    );
  }
}
