class Player {
  final int id;
  final String fullName;
  final DateTime birthDate;

  const Player({
    required this.id,
    required this.fullName,
    required this.birthDate,
  });

  factory Player.fromJson(Map<String, dynamic> json) {
    return Player(
      id: json['id'] as int,
      fullName: json['full_name'] as String,
      birthDate: DateTime.parse(json['birth_date_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'full_name': fullName,
      'birth_date': birthDate.toIso8601String(),
    };
  }

  int get age {
    final now = DateTime.now();
    int age = now.year - birthDate.year;
    if (now.month < birthDate.month ||
        (now.month == birthDate.month && now.day < birthDate.day)) {
      age--;
    }
    return age;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Player &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'Player{id: $id, fullName: $fullName, age: $age}';
}
