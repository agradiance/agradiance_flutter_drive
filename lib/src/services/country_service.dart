import 'package:country_picker/country_picker.dart';
import 'package:dlibphonenumber/dlibphonenumber.dart';

class AppCountryService {
  static final AppCountryService _internal = AppCountryService._(
    phoneUtil: PhoneNumberUtil.instance,
    countryservice: CountryService(),
  );

  factory AppCountryService() {
    return _internal;
  }

  final PhoneNumberUtil phoneUtil;
  final CountryService countryservice;

  AppCountryService._({required this.phoneUtil, required this.countryservice});
  Future<Country?> getCountryFromPhoneCode(String phoneCode) async {
    return CountryService().findByPhoneCode(phoneCode);
  }

  String? formartPhoneNumber({
    required String phoneNumber,
    required String countryCode,
    final PhoneNumberFormat phoneNumberFormat = PhoneNumberFormat.international,
  }) {
    try {
      PhoneNumber numberProto = phoneUtil.parse(phoneNumber, countryCode);
      if (phoneUtil.isValidNumber(numberProto)) {
        return phoneUtil.format(numberProto, phoneNumberFormat);
      }
    } on NumberParseException {
      //dprint("NumberParseException was thrown: ${e.toString()}");
    }

    return null;
  }
}
