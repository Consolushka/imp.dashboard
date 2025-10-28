class Sorting {
  bool? _isAscending;
  Function(bool isAscending)? _sortingCallback;

  Sorting({bool? isAscending, Function(bool isAscending)? callback}) {
    _isAscending = isAscending;
    _sortingCallback = callback;
  }

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
