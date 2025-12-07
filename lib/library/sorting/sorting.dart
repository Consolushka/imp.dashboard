class Sorting {
  late String _id;
  bool? _isAscending;
  Function(bool isAscending)? _sortingCallback;

  Sorting({required String id, bool? isAscending, Function(bool isAscending)? callback}) {
    _id = id;
    _isAscending = isAscending;
    _sortingCallback = callback;
  }

  String get id => _id;

  void toggle() {
    if (_isAscending == null) {
      _isAscending = true;
    } else {
      _isAscending = !_isAscending!;
    }

    sort();

  }

  void disable() {
    _isAscending = null;
  }

  void sort() {
    _sortingCallback!(_isAscending!);
  }

  bool? get isAscending => _isAscending;
}
