class DateTimeUtils {
  static DateTime? parseOrNullValue(final dynamic source, {DateTime? orNullValue}) {
    final res = DateTime.tryParse(source.toString());
    if (res != null) {
      return res;
    } else {
      return orNullValue;
    }
  }
}
