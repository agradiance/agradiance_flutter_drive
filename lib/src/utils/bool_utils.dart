class BoolUtils {
  static bool parseOrNullValue(
    final dynamic source, {
    bool orNullValue = false,
    bool caseSensitive = false,
  }) {
    final res = bool.tryParse(source.toString(), caseSensitive: caseSensitive);
    if (res != null) {
      return res;
    } else {
      return orNullValue;
    }
  }
}
