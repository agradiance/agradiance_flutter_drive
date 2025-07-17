import 'package:lite_validator/lite_validator.dart';

extension LiteValidatorExtension on LiteValidator {
  static String? academicSessionValidator({required String? value, required String? errorMessage}) {
    if (value != null && value.split('/').isNotEmpty) {
      value.split('/').first;
      final firstYear = int.tryParse(value.split('/').first) ?? 0;
      final secondYear = int.tryParse(value.split('/').last) ?? 0;

      if (secondYear - firstYear == 1) {
        return null;
      }
    }

    return errorMessage;
  }

  /// URL regex
  static const Pattern url =
      r"^((((H|h)(T|t)|(F|f))(T|t)(P|p)((S|s)?))\://)?(www.|[a-zA-Z0-9].)[a-zA-Z0-9\-\.]+\.[a-zA-Z]{2,6}(\:[0-9]{1,5})*(/($|[a-zA-Z0-9\.\,\;\?\'\\\+&amp;%\$#\=~_\-]+))*$";

  /// URL regex
  static const Pattern phoneGeneral = r"^(?:\+?\d{1,4}[\s-]?)?(?:\(?\d{3,5}\)?[\s-]?)?\d{3,4}[\s-]?\d{4}$";

  /// Details input such as details about me, text
  static Pattern details({int? min, int? max}) {
    final raw = r"^([^`~@#\$%^&\*\\]){__min__,__max__}$";
    return raw.replaceFirst("__min__", "${min ?? 1}").replaceFirst("__max__", "${max ?? ''}");
  }
}
