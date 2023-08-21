import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';

class KakaoService {
  Future signInWithKakao() async {
    try {
      bool talkInstalled = await isKakaoTalkInstalled();

      // If Kakao Talk has been installed, log in with Kakao Talk. Otherwise, log in with Kakao Account.
      talkInstalled
          ? await UserApi.instance.loginWithKakaoTalk()
          : await UserApi.instance.loginWithKakaoAccount();

      User user = await UserApi.instance.me();
      print('카카오톡으로 로그인 성공'
          '\nuserID: ${user.id}'
          '\nEmail: ${user.kakaoAccount?.email}');

      return user;
    } catch (error) {
      print('카카오톡으로 로그인 실패 $error');
    }
    return null;
  }

  Future unlinkKakao() async {
    /// Unlink current user from the app.
    try {
      await UserApi.instance.unlink();
      print('Unlink succeeds. Tokens are deleted from SDK.');
    } catch (e) {
      print('Unlink fails.');
    }
  }
}
