import 'package:flutter/material.dart';
import 'package:utilitymanagement/model/user.dart';
import 'package:utilitymanagement/services/authentication.dart';
import 'package:utilitymanagement/services/firestore.dart';


class LoginSignUpPage extends StatefulWidget {
  LoginSignUpPage({this.auth, this.loginCallBack});

  final BaseAuth auth;
  final VoidCallback loginCallBack;

  @override
  _LoginSignUpPageState createState() => _LoginSignUpPageState();
}

class _LoginSignUpPageState extends State<LoginSignUpPage> {
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  Widget _myAnimatedWidget;

  bool _isMobileLoading;
  String _mobileNumber;
  String _smsCode;
  String _verificationID;
  User _user;

  FocusNode focusNode1 = FocusNode();
  FocusNode focusNode2 = FocusNode();
  FocusNode focusNode3 = FocusNode();
  FocusNode focusNode4 = FocusNode();
  FocusNode focusNode5 = FocusNode();
  FocusNode focusNode6 = FocusNode();

  @override
  void initState() {
    _isMobileLoading = false;
    _myAnimatedWidget = Container();
    _smsCode = "";
    super.initState();
  }
  
  void _showSnackBar(String text){
    final snackBar = SnackBar(content: Text(text));
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }

  void codeSent(String verificationID, [int forceResendingToken]) async {
    _verificationID = verificationID;
    _showSnackBar("A code has been sent!");
  }

  Widget _showCodeInput() {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      child: TextFormField(
        keyboardType: TextInputType.number,
        decoration: InputDecoration(labelText: "Verification Code"),
        onSaved: (String verifcode) {
          _smsCode = verifcode;
        }
      )
    );
  }

  Widget _showSubmitButton() {
    String userId = "";
    return RaisedButton(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Text(
        "Login",
      ),
      onPressed: () async {
        _formKey.currentState.save();
        userId = await widget.auth.signInMobile(
          _verificationID,
          _smsCode,
          _mobileNumber,
          _user.email,
          _user.password
        );

        if(userId != "" && userId != null && userId.length >0) {
          widget.loginCallBack();
        }

      },
    );
  }

  Widget _showMessage(){
    return Row(
      // mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        SizedBox(width: 10),
        Icon(Icons.info, color: Colors.white, size: 20.0),
        SizedBox(width: 10),
        Expanded(
          child: RichText(
          text: TextSpan(children: [
            TextSpan(
                text: 'We sent a ',
                style: TextStyle(
                    color: Colors.white, fontWeight: FontWeight.w400)),
            TextSpan(
                text: 'One Time Password',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.0,
                    fontWeight: FontWeight.w700)),
            TextSpan(
                text: ' to this mobile number',
                style: TextStyle(
                    color: Colors.white, fontWeight: FontWeight.w400)),
          ])),
        )
      ],
    );
  }

  Widget _showMobileInput() {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      child: TextFormField(
        keyboardType: TextInputType.phone,
        decoration: InputDecoration(
          icon: Icon(Icons.phone, color: Colors.teal[500]),
          labelText: "Mobile Number",
          prefix: Text("+63"),
          suffix: _isMobileLoading? Padding(child: SizedBox(height: 20, width: 20, child: CircularProgressIndicator(),), padding: EdgeInsets.only(right: 5)):null
        ),
        onSaved: (String mobile) => _mobileNumber = "+63$mobile",
        onFieldSubmitted: (String mobile) async {
          String mobileNumber = "+63$mobile";
          Widget nextWidget;
          setState(() {
            _isMobileLoading = true;
          });
          _user = await UserService().getUserDetailsByPhone(mobileNumber);

          if (_user == null) {
            nextWidget = Text("Sign up sa ka dong");
          } else {
            _verificationID = await widget.auth.verifyMobile(mobileNumber, codeSent);
            nextWidget = Column(
              children: <Widget>[
                _showCodeInput(),
                _showMessage(),
                _showSubmitButton()
              ],
            );
          }
          setState(() {
            _isMobileLoading = false;
            _myAnimatedWidget = nextWidget;
          });
        },
      ),
    );
  }

  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Container(
        color: Colors.teal[500],
        alignment: Alignment.center,
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              _showMobileInput(),
              AnimatedSwitcher(
                duration: Duration(milliseconds: 200),
                transitionBuilder: (child, animation) {
                  return ScaleTransition(child: child, scale: animation,);
                  // return RotationTransition(child: child, turns: animation,);
                },
                child: _myAnimatedWidget
              ),
            ],
          ),
        )
      )
    );
  }
}