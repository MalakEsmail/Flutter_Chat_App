import 'package:flutter/material.dart';
import 'package:my_flutter_chat_app/views/signIn.dart';
import 'package:my_flutter_chat_app/views/signUp.dart';

class Authenticate extends StatefulWidget {
  @override
  _AuthenticateState createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {
  bool showSignIn = true;

  void toggleView() {
    showSignIn = !showSignIn;
  }

  @override
  Widget build(BuildContext context) {
    if (showSignIn) {
      return SignIn(toggleView);
    } else {
      return SignUp(toggleView);
    }
  }
}
