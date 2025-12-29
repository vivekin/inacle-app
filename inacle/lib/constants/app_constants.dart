

import 'package:inacle_app/models/auth_model.dart';
import 'package:inacle_app/models/agent_model.dart';
import 'package:inacle_app/models/client_response_model.dart';
import 'package:inacle_app/models/language_model.dart';

class AppConstants {
    static List<LanguageModel> languages = [
    LanguageModel(
        imageUrl: '', //Images.english,
        languageName: 'English',
        countryCode: 'US',
        languageCode: 'en'),
    LanguageModel(
        imageUrl: '', //Images.arabic,
        languageName: 'عربى',
        countryCode: 'SA',
        languageCode: 'ar'),
    LanguageModel(
        imageUrl: '', //Images.arabic,
        languageName: 'Spanish',
        countryCode: 'ES',
        languageCode: 'es'),
  ];

  static const String LOGIN_RESPONSE = 'inacle_client_login_response';

   static bool isLoggin = false;
   static LoginResponse user = LoginResponse();
   static List<AgentModel> agentList = [];
   static ClientDetailsResponse clientDetails = ClientDetailsResponse();
}