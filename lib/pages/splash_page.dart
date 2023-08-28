import 'package:eduMap/pages/wrapper.dart';
import 'package:eduMap/widgets/spinner.dart';
import 'package:flutter/material.dart';
import 'package:eduMap/providers/auth_provider.dart';
import 'package:provider/provider.dart';

import 'pages.dart';

class SplashPage extends StatefulWidget {
  SplashPage({super.key});

  @override
  SplashPageState createState() => SplashPageState();
}

class SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 2), () {
      // just delay for showing this slash page clearer because it too fast
      checkSignedIn();
    });
  }

  void checkSignedIn() async {
    AuthProvider authProvider = context.read<AuthProvider>();
    bool isLoggedIn = await authProvider.isLoggedIn();
    if (isLoggedIn) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Wrapper()),
      );
      return;
    }
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                return AspectRatio(
                  aspectRatio: constraints.maxWidth / constraints.maxHeight,
                  child: Image.asset(
                    'images/splash.png',
                    fit: BoxFit.cover,
                  ),
                );
              },
            ),
            Center(
              child: SizedBox(
                  height: 100,
                  child: Spinner(
                    color: 'white',
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
