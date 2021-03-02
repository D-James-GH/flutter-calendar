import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

// custom lib
import '../navigation/home_navigator.dart';
import '../services/services.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final AuthService auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  String _email;
  String _password;
  String _displayName;
  String _confirmPassword;
  bool _isRegistering = false;

  final TextStyle textStyle = TextStyle(fontFamily: 'Montserrat', fontSize: 20);

  @override
  void initState() {
    super.initState();
    auth.getCurrentUser.then(
      (user) {
        if (user != null) {
          navigateToHome();
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);
          if (!currentFocus.hasPrimaryFocus &&
              currentFocus.focusedChild != null) {
            currentFocus.focusedChild.unfocus();
          }
        },
        behavior: HitTestBehavior.translucent,
        child: SingleChildScrollView(
          child: Container(
            constraints:
                BoxConstraints(minHeight: MediaQuery.of(context).size.height),
            padding: EdgeInsets.all(30),
            decoration: BoxDecoration(),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  FlutterLogo(
                    size: 150,
                  ),

                  SizedBox(height: 20),
                  Text(
                    'Login to Start',
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 20),
                  // email sign in -------------
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        _styledTextField(
                            hintText: 'Email',
                            isObscured: false,
                            onChanged: (value) => setState(() {
                                  _email = value.trimRight();
                                })),
                        SizedBox(height: 20),
                        _styledTextField(
                            hintText: 'password',
                            isObscured: true,
                            onChanged: (value) => setState(() {
                                  _password = value.trimRight();
                                })),
                        SizedBox(height: 20),
                        ..._showRegisterForm(),
                        Row(
                          children: [
                            Expanded(
                              child: Container(),
                            ),
                            GestureDetector(
                              child: Text('Forgotten password?'),
                              onTap: _resetPassword,
                            ),
                          ],
                        ),
                        SizedBox(height: 20),
                        _styledSignInBtn('Sign In', false),
                        _styledSignInBtn('Register', true),
                      ],
                    ),
                  ),
                  // ---------------------------
                  SizedBox(height: 20),
                  Text(
                    '- OR -',
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 20),
                  LoginIconButton(
                    navigateToHome: navigateToHome,
                    icon: FontAwesomeIcons.google,
                    loginMethod: auth.googleSignIn,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _styledTextField(
      {@required String hintText,
      @required bool isObscured,
      @required Function onChanged}) {
    return TextFormField(
      obscureText: isObscured,
      keyboardType:
          hintText == 'Email' ? TextInputType.emailAddress : TextInputType.text,
      style: textStyle,
      onChanged: onChanged,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: hintText,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32)),
      ),
    );
  }

  Widget _styledSignInBtn(
    String text,
    bool isFlat,
  ) {
    Widget button;
    Widget btnBody(_text) => Container(
          padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
          decoration: BoxDecoration(
              // borderRadius: BorderRadius.circular(32),
              ),
          child: Text(
            _text,
            style: TextStyle(
              fontSize: textStyle.fontSize,
              fontFamily: textStyle.fontFamily,
              color: isFlat ? Colors.black45 : Colors.white,
            ),
          ),
        );

    if (isFlat) {
      if (!_isRegistering) {
        button = FlatButton(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
            child: btnBody(text),
            onPressed: () => setState(() {
                  _isRegistering = !_isRegistering;
                }));
      } else {
        button = IconButton(
          icon: Icon(
            Icons.arrow_upward_outlined,
            color: Colors.black45,
            size: 40,
          ),
          onPressed: () => setState(() {
            _isRegistering = !_isRegistering;
          }),
        );
      }
    } else {
      if (!_isRegistering) {
        button = RaisedButton(
          color: Colors.lightBlue,
          child: btnBody(text),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
          onPressed: () async {
            var user = await auth.userSignIn(_email, _password);
            if (user != null) {
              navigateToHome();
            }
          },
        );
      } else {
        button = RaisedButton(
          color: Colors.lightBlue,
          child: btnBody('Register Now'),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
          onPressed: () async {
            if (_password == _confirmPassword) {
              var user =
                  await auth.userRegister(_email, _password, _displayName);
              if (user != null) {
                navigateToHome();
              }
            } else {
              print('error');
            }
          },
        );
      }
    }
    return SizedBox(width: double.infinity, child: button);
  }

  List<Widget> _showRegisterForm() {
    if (_isRegistering) {
      return [
        _styledTextField(
            hintText: 'Confirm Password',
            isObscured: true,
            onChanged: (value) => setState(() {
                  _confirmPassword = value.trimRight();
                })),
        SizedBox(height: 20),
        _styledTextField(
            hintText: 'Display Name',
            isObscured: false,
            onChanged: (value) => setState(() {
                  _displayName = value.trimRight();
                })),
        SizedBox(height: 20),
      ];
    } else
      return [];
  }

  void navigateToHome() async {
    // await Provider.of<UserState>(context, listen: false).fetchUserFromDB();
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => Home()),
    );
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the
    // widget tree.
    super.dispose();
  }

  void _resetPassword() async {
    if (_email != '' && _email != null) {
      await locator<AuthService>().resetPassword(_email);
      showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return Dialog(
            child: Container(
              height: 150,
              padding: EdgeInsets.symmetric(vertical: 30, horizontal: 10),
              child: Column(
                children: [
                  Text(
                    'An email has been sent to $_email',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.black87, fontSize: 18),
                  ),
                  Expanded(
                    child: Container(),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Container(),
                      ),
                      TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: Text('Confirm'))
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      );
    }
  }
}

/// A resuable login button for multiple auth methods
class LoginIconButton extends StatelessWidget {
  final IconData icon;
  final Function loginMethod;
  final Function navigateToHome;

  const LoginIconButton(
      {Key key, this.icon, this.loginMethod, @required this.navigateToHome})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Ink(
      decoration: const ShapeDecoration(
        color: Colors.lightBlue,
        shape: CircleBorder(),
      ),
      child: IconButton(
          icon: Icon(
            icon,
            color: Colors.white,
          ),
          onPressed: () async {
            var user = await loginMethod();
            if (user != null) {
              navigateToHome();
            }
          }),
    );
  }
}
