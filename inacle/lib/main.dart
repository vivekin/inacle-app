import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:inacle_app/app.dart';
import 'package:inacle_app/services/shared_pref.dart';
import 'helper/get_di.dart' as di;

void main() async{
    WidgetsFlutterBinding.ensureInitialized();

  SharedPref sharedPref = SharedPref();
  await sharedPref.init();
  Map<String, Map<String, String>> languages = await di.init();
  log(languages.toString());
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
    .then((_) {
  runApp( const MyApp());
  });
}

