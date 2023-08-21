import 'package:eduMap/pages/wrapper.dart';
import 'package:flutter/material.dart';
import 'package:eduMap/constants/app_constants.dart';
import 'package:eduMap/constants/color_constants.dart';
import 'package:eduMap/providers/auth_provider.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

import '../widgets/widgets.dart';
import 'pages.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    AuthProvider authProvider = Provider.of<AuthProvider>(context);
    switch (authProvider.status) {
      case Status.authenticateError:
        Fluttertoast.showToast(msg: "로그인에 실패하였습니다.");
        break;
      case Status.authenticateCanceled:
        Fluttertoast.showToast(msg: "로그인을 취소하였습니다.");
        break;
      case Status.authenticated:
        Fluttertoast.showToast(msg: "로그인에 성공하였습니다.");
        break;
      default:
        break;
    }

    return Material(
      child: Column(
        children: [
          const SizedBox(height: 180),
          Container(
            height: 100,
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(color: Colors.black, width: 0.3),
              ),
            ),
            child: const SizedBox(
                width: 300,
                child: Center(
                    child: Text(
                  '소셜 로그인',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ))),
          ),
          const SizedBox(height: 25),
          TextButton(
            onPressed: () async {
              handleLogIn(authProvider, context, 'kakao');
            },
            style: styleButton,
            child: SizedBox(
                width: 250, child: Image.asset('images/kakao_button.png')),
          ),
          TextButton(
            onPressed: () {
              handleLogIn(authProvider, context, 'google');
            },
            style: styleButton,
            child: SizedBox(
              width: 250,
              child: Image.asset('images/google_button.png'),
            ),
          ),
          TextButton(
            onPressed: () {
              // showAlert(context, "title", "naver login");
            },
            style: styleButton,
            child: SizedBox(
              width: 250,
              child: Image.asset('images/naver_button.png'),
            ),
          ),
          TextButton(
            onPressed: () {
              // showAlert(context, "title", "apple login");
            },
            style: styleButton,
            child: SizedBox(
              width: 250,
              child: Image.asset('images/apple_button.png'),
            ),
          ),
          SizedBox(height: 100, child: loading ? spinkit : Container()),
          SizedBox(
            height: 100,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                    onPressed: () {},
                    child: Text(' 유저 가이드 ', style: buttomTextStyle)),
                const Text('|'),
                TextButton(
                    onPressed: () {},
                    child: Text(' 이용 약관 ', style: buttomTextStyle)),
                const Text('|'),
                TextButton(
                    onPressed: () {},
                    child: Text(' 이메일 문의 ', style: buttomTextStyle)),
              ],
            ),
          ),
          const SizedBox(height: 50, child: Text('ABLOCK Inc.'))
        ],
      ),
    );
  }

  Future<void> handleLogIn(
      AuthProvider authProvider, BuildContext context, String provider) async {
    setState(() => loading = true);
    await authProvider.handleSignIn(provider).then((isSuccess) {
      if (isSuccess) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => Wrapper(),
          ),
        );
      }
    }).catchError((error, stackTrace) {
      Fluttertoast.showToast(msg: error.toString());
    });
    setState(() => loading = false);

    authProvider.handleException();
  }
}

final styleButton = TextButton.styleFrom(
  padding: const EdgeInsets.all(8),
);

final buttomTextStyle =
    const TextStyle(fontSize: 12, color: Colors.grey, letterSpacing: 1.5);

final spinkit = SpinKitCircle(
  itemBuilder: (BuildContext context, int index) {
    return const DecoratedBox(
      decoration: BoxDecoration(color: Color.fromARGB(255, 125, 125, 125)),
    );
  },
);
