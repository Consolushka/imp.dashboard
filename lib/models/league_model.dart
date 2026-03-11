
class League {
  final int id;
  final String name;
  final String alias;
  final int order;

  const League({
    required this.id,
    required this.name,
    required this.alias,
    required this.order,
  });

  factory League.fromJson(Map<String, dynamic> json) {
    return League(
      id: json['id'] as int,
      name: json['name'] as String,
      alias: json['alias'] as String,
      order: json['order'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'alias': alias,
      'order': order,
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
  String toString() => 'League{id: $id, name: $name, alias: $alias, order: $order}';
}
