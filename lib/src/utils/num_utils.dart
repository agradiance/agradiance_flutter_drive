class NumUtils {
  static num? parseOrNullValue(
    final dynamic source, {
    num? orNullValue = 0,
    bool caseSensitive = false,
  }) {
    final res = num.tryParse(source.toString());
    if (res != null) {
      return res;
    } else {
      return orNullValue;
    }
  }
}
