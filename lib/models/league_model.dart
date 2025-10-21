
class League {
  final int id;
  final String name;
  final String alias;

  const League({
    required this.id,
    required this.name,
    required this.alias,
  });

  factory League.fromJson(Map<String, dynamic> json) {
    return League(
      id: json['id'] as int,
      name: json['name'] as String,
      alias: json['alias'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'alias': alias,
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is League &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'League{id: $id, name: $name, alias: $alias}';
}
