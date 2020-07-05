import 'package:flutter/material.dart';
import 'package:utilitymanagement/pages/HomePage.dart';
import 'package:utilitymanagement/pages/LoginPage.dart';
import 'package:utilitymanagement/services/authentication.dart';

enum AuthStatus {
  NOT_DETERMINED,
  NOT_LOGGED_IN,
  LOGGED_IN
}

// Page to determine which page to start with
class RootPage extends StatefulWidget {
  RootPage({this.auth});
  final BaseAuth auth;

  @override
  _RootPageState createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  AuthStatus authStatus = AuthStatus.NOT_DETERMINED;
  String _userId = "";

  @override
  void initState() {
    widget.auth.getCurrentUser().then((user) {
      setState(() {
        if(user != null) {
          _userId = user?.uid;
        }
        authStatus =
          user?.uid == null ? AuthStatus.NOT_LOGGED_IN : AuthStatus.LOGGED_IN;
      });
    });
    super.initState();
  }
  
  void loginCallback() {
    widget.auth.getCurrentUser().then((user) {
      setState(() {
        _userId = user.uid.toString();
      });
    });
    setState(() {
      authStatus = AuthStatus.LOGGED_IN;
    });
  }
  
  void logoutCallBack() {
    widget.auth.signOut().then((user) {
      setState(() {
        _userId = "";
        authStatus = AuthStatus.NOT_LOGGED_IN;
      });
    });
  }

  Widget _showWaitingScreen() {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: CircularProgressIndicator(),
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    // return HomePage();
    switch(authStatus) {
      case AuthStatus.LOGGED_IN:
        if ( _userId != null && _userId.length > 0) {
          return HomePage(auth: widget.auth, logoutCallBack: logoutCallBack);
        } else {
          return _showWaitingScreen();
        }
        break;
      case AuthStatus.NOT_LOGGED_IN:
        return LoginSignUpPage(
            auth: widget.auth,
            loginCallBack: loginCallback
        );
        return HomePage();
        break;
      default:
        return _showWaitingScreen();
    }
  }
}



