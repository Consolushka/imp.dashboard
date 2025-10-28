class Sorting {
  bool? _isAscending;

  Sorting({bool? isAscending}) {
    _isAscending = isAscending;
  }

  void toggle() {
    if (_isAscending == null) {
      _isAscending = true;
      return;
    }

    _isAscending = !_isAscending!;
  }

  void disable() {
    _isAscending = null;
  }

  bool? get isAscending => _isAscending;
}
