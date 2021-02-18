import 'package:flutter/material.dart';
import 'package:flutter_calendar/app_state/user_state.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

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
      body: SingleChildScrollView(
        child: ConstrainedBox(
          constraints:
              BoxConstraints(maxHeight: MediaQuery.of(context).size.height),
          child: Container(
            padding: EdgeInsets.all(30),
            decoration: BoxDecoration(),
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  FlutterLogo(
                    size: 150,
                  ),
                  Text(
                    'Login to Start',
                    textAlign: TextAlign.center,
                  ),
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
                        _styledSignInBtn('Sign In', false),
                        _styledSignInBtn('Register', true),
                      ],
                    ),
                  ),
                  // ---------------------------
                  Text(
                    '- OR -',
                    textAlign: TextAlign.center,
                  ),
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
    print('nevigatin....');
    await Provider.of<UserState>(context, listen: false).fetchUserFromDB();
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
