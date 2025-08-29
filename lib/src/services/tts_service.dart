// import 'dart:io';

// import 'package:flutter/foundation.dart';
// import 'package:flutter_tts/flutter_tts.dart';

// class TTSService {
//   TTSService._(this.flutterTts) {
//     //
//     flutterTts.setSharedInstance(true);

//     if (!kIsWasm && Platform.isIOS) {
//       flutterTts.setIosAudioCategory(IosTextToSpeechAudioCategory.ambient, [
//         IosTextToSpeechAudioCategoryOptions.allowBluetooth,
//         IosTextToSpeechAudioCategoryOptions.allowBluetoothA2DP,
//         IosTextToSpeechAudioCategoryOptions.mixWithOthers,
//       ], IosTextToSpeechAudioMode.voicePrompt);
//     }

//     // To await speak completion.
//     flutterTts.awaitSpeakCompletion(true);

//     // To await synthesize to file completion.
//     flutterTts.awaitSynthCompletion(true);
//   }
//   static final TTSService _internal = TTSService._(FlutterTts());

//   factory TTSService() {
//     return _internal;
//   }

//   static TTSService get instance => TTSService();

//   final FlutterTts flutterTts;

//   /// [result] == 1 is speaking
//   Future<dynamic> speak({required String text}) async {
//     return await flutterTts.speak(text);
//   }

//   /// [result] == 1 is stopped
//   Future<dynamic> stop() async {
//     return await flutterTts.stop();
//   }

//   ///
//   Future<dynamic> getLanguages() async {
//     return await flutterTts.getLanguages;
//   }

//   /// [setLanguage] e.g. setLanguage("en-US");
//   Future<dynamic> setLanguage({required String language}) async {
//     return await flutterTts.setLanguage(language);
//   }

//   Future<dynamic> setSpeechRate({required String language}) async {
//     await flutterTts.setSpeechRate(1.0);
//   }

//   Future<dynamic> setVolume({required String language}) async {
//     return await flutterTts.setVolume(1.0);
//   }

//   Future<dynamic> setPitch({required String language}) async {
//     return await flutterTts.setPitch(1.0);
//   }

//   Future<dynamic> isLanguageAvailable({required String language}) async {
//     return await flutterTts.isLanguageAvailable("en-US");
//   }

//   Future<dynamic> pause({required String language}) async {
//     if (kIsWeb || kIsWasm || Platform.isAndroid || Platform.isIOS) {
//       // iOS, Android and Web only
//       //see the "Pausing on Android" section for more info
//       return await flutterTts.pause();
//     } else {
//       // pause
//     }
//   }

//   Future<dynamic> synthesizeToFile({required String language}) async {
//     // iOS, macOS, and Android only
//     // The last parameter is an optional boolean value for isFullPath (defaults to false)
//     await flutterTts.synthesizeToFile("Hello World", Platform.isAndroid ? "tts.wav" : "tts.caf", false);
//   }

//   // Each voice is a Map containing at least these keys: name, locale
//   // - Windows (UWP voices) only: gender, identifier
//   // - iOS, macOS only: quality, gender, identifier
//   // - Android only: quality, latency, network_required, features
//   Future<dynamic> getVoices({required String language}) async {
//     List<Map> voices = await flutterTts.getVoices;
//     return voices;
//   }

//   Future<dynamic> setVoice({required String language}) async {
//     await flutterTts.setVoice({"name": "Karen", "locale": "en-AU"});
//   }

//   Future<dynamic> setVoiceIOSMacOS({required String language}) async {
//     // iOS, macOS only
//     await flutterTts.setVoice({"identifier": "com.apple.voice.compact.en-AU.Karen"});
//   }

//   Future<dynamic> setSharedInstance({required String language}) async {
//     // iOS only
//     await flutterTts.setSharedInstance(true);
//   }

//   Future<dynamic> speakAndroid({required String language}) async {
//     // Android only
//     await flutterTts.speak("Hello World", focus: true);
//   }

//   Future<dynamic> setSilence({required String language}) async {
//     await flutterTts.setSilence(2);
//   }

//   Future<dynamic> getEngines({required String language}) async {
//     await flutterTts.getEngines;
//   }

//   Future<dynamic> getDefaultVoice({required String language}) async {
//     await flutterTts.getDefaultVoice;
//   }

//   Future<dynamic> isLanguageInstalled({required String language}) async {
//     await flutterTts.isLanguageInstalled("en-AU");
//   }

//   Future<dynamic> areLanguagesInstalled({required String language}) async {
//     await flutterTts.areLanguagesInstalled(["en-AU", "en-US"]);
//   }

//   Future<dynamic> setQueueMode({required String language}) async {
//     await flutterTts.setQueueMode(1);
//   }

//   Future<dynamic> getMaxSpeechInputLength({required String language}) async {
//     await flutterTts.getMaxSpeechInputLength;
//   }

//   Future<dynamic> setAudioAttributesForNavigation({required String language}) async {
//     await flutterTts.setAudioAttributesForNavigation();
//   }

//   Future<dynamic> setStartHandler({required dynamic Function() handler}) async {
//     flutterTts.setStartHandler(handler);
//   }

//   Future<dynamic> setCompletionHandler({required dynamic Function() handler}) async {
//     flutterTts.setCompletionHandler(handler);
//   }

//   Future<dynamic> setProgressHandler({required dynamic Function(String, int, int, String) handler}) async {
//     flutterTts.setProgressHandler(handler);
//   }

//   Future<dynamic> setErrorHandler({required dynamic Function(dynamic) handler}) async {
//     flutterTts.setErrorHandler(handler);
//   }

//   Future<dynamic> setCancelHandler({required dynamic Function() handler}) async {
//     flutterTts.setCancelHandler(handler);
//   }

//   Future<dynamic> setPauseHandler({required dynamic Function() handler}) async {
//     // Android, iOS and Web
//     flutterTts.setPauseHandler(handler);
//   }

//   Future<dynamic> setContinueHandler({required dynamic Function() handler}) async {
//     flutterTts.setContinueHandler(handler);
//   }
// }
