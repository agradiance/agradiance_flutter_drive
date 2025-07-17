import 'package:jiffy/jiffy.dart';

extension DatetimeExtension on DateTime {
  String format(String pattern) {
    return Jiffy.parseFromDateTime(this).format(pattern: pattern);
  }
}
