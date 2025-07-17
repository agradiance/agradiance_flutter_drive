// import '../../utils/storage/app_shared_preferences.dart';

// abstract class TokenStorage {
//   static const String _tokenKey = 'auth_token';
//   static const String _isLoggedInKey = '_isLoggedInKey';
//   static const String _dateLoggedIn = '_dateLoggedIn';

//   static Future<bool> get isSignedIn async {
//     return (await TokenStorage.getToken()).isLoggedIn ?? false;
//   }

//   // Save the token
//   static Future<void> saveToken(String token) async {
//     final prefs = await AppSharedPreferences.preference;
//     if (await prefs.setString(_tokenKey, token)) {
//       await prefs.setBool(_isLoggedInKey, true);
//       await prefs.setString(_dateLoggedIn, DateTime.now().toString());
//     }
//   }

//   // Retrieve the token
//   static Future<({String? token, DateTime? loginDate, bool? isLoggedIn})> getToken() async {
//     final prefs = await AppSharedPreferences.preference;
//     final token = prefs.getString(_tokenKey);
//     final isLoggedIn = prefs.getBool(_isLoggedInKey);
//     final dateLoggedIn = DateTime.tryParse(prefs.getString(_dateLoggedIn) ?? '');

//     return (token: token, isLoggedIn: isLoggedIn, loginDate: dateLoggedIn);
//   }

//   // Remove the token
//   static Future<void> removeToken() async {
//     final prefs = await AppSharedPreferences.preference;
//     await prefs.remove(_tokenKey);
//     await prefs.remove(_isLoggedInKey);
//     await prefs.remove(_dateLoggedIn);
//   }
// }
