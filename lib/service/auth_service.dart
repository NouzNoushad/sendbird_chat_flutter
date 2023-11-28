import 'package:sendbird_chat_sdk/sendbird_chat_sdk.dart';
import 'package:sendbird_flutter/service/user_service.dart';

class AuthService {
  static Future<void> loginUser(String userId) async {
    await SendbirdChat.connect(userId);
    await UserService.setLoginUserId();
  }
}
