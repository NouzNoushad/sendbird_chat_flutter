import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sendbird_chat_sdk/sendbird_chat_sdk.dart';
import 'package:sendbird_flutter/presentation/login_screen.dart';

const yourAppId = '356B5320-A380-4A54-8A82-96EFC9D0D127';
void main() {
  runZonedGuarded<Future<void>>(
    () async {
      WidgetsFlutterBinding.ensureInitialized();
      FlutterError.onError = (errorDetails) {
        debugPrint('[FlutterError] ${errorDetails.stack}');
      };
      runApp(MyApp());
    },
    (error, stackTrace) async {
      debugPrint('[Error] $error\n$stackTrace');
    },
  );
}

class MyApp extends StatelessWidget {
  MyApp({super.key}) {
    SendbirdChat.init(appId: yourAppId);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        ),
        debugShowCheckedModeBanner: false,
        home: const LoginScreen());
  }
}
