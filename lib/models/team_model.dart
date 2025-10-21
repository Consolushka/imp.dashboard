class Team {
  final int id;
  final String name;
  final String homeTown;

  const Team({
    required this.id,
    required this.name,
    required this.homeTown,
  });

  factory Team.fromJson(Map<String, dynamic> json) {
    return Team(
      id: json['id'] as int,
      name: json['name'] as String,
      homeTown: json['home_town'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'home_town': homeTown,
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Team &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'Team{id: $id, name: $name, homeTown: $homeTown}';
}
