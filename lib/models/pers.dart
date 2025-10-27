class ImpPer {
  final String name;
  final String code;

  ImpPer({required this.name, required this.code});

  @override
  String toString() {
    return "Per $name";
  }
}

final ImpPer fullGameImpPer = ImpPer(name: "Full Game", code: "fullGame");
final ImpPer benchImpPer = ImpPer(name: "Bench", code: "bench");
final ImpPer startImpPer = ImpPer(name: "Start", code: "start");
