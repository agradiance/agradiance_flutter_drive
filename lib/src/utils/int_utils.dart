class IntUtils {
  static String padLeft(
    final dynamic source, {
    int fallBackSource = 0,
    int width = 0,
    String padding = "0",
  }) {
    final res = int.tryParse(source.toString()) ?? fallBackSource;
    return res.toString().padLeft(width, padding);
  }
}
