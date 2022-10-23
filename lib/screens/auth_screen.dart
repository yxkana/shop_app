import 'dart:convert';
import 'dart:math';

import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/models/http_exceptions.dart';
import '../providers/auth.dart';

enum AuthMode { Signup, Login } //Two mods which could show

class AuthScreen extends StatelessWidget {
  static const routeName = '/auth';
  bool choice = false;

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    // final transformConfig = Matrix4.rotationZ(-8 * pi / 180);
    // transformConfig.translate(-10.0);
    return Scaffold(
      // resizeToAvoidBottomInset: false,
      body: Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                ///Přechod mezi dvěma barvami
                colors: [
                  Color.fromRGBO(215, 117, 255, 1).withOpacity(0.5),
                  Color.fromRGBO(255, 188, 117, 1).withOpacity(0.9),
                ],
                begin: Alignment.topLeft, //Odkud kam budou barvi přecházet
                end: Alignment.bottomRight,
                stops: [0, 1],
              ),
            ),
          ),
          SingleChildScrollView(
            child: Container(
              height: deviceSize.height,
              width: deviceSize.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Flexible(
                    child: Container(
                      margin: EdgeInsets.only(bottom: 20.0),
                      padding:
                          EdgeInsets.symmetric(vertical: 8.0, horizontal: 94.0),
                      transform: Matrix4.rotationZ(
                          -8 * pi / 180) //With Matrix4 we can rotate objects
                        ..translate(
                            -10.0), //we need use dotdot .. its for just edit previsous segmet before dotdot
                      // ..translate(-10.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.deepOrange.shade900,
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 8,
                            color: Colors.black26,
                            offset: Offset(0, 2),
                          )
                        ],
                      ),
                      child: Text(
                        'MyShop',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.background,
                          fontSize: 50,
                          fontFamily: 'Anton',
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ),
                  ),
                  Flexible(
                    flex: deviceSize.width > 600 ? 2 : 1,
                    child: AuthCard(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AuthCard extends StatefulWidget {
  const AuthCard({
    Key? key,
  }) : super(key: key);

  @override
  _AuthCardState createState() => _AuthCardState();
}

class _AuthCardState extends State<AuthCard>
    with SingleTickerProviderStateMixin {
  final GlobalKey<FormState> _formKey = GlobalKey();
  bool wrongEmail = false;
  bool wrongPassword = false;
  AuthMode _authMode = AuthMode.Login;
  Map<String, String> _authData = {
    'email': '',
    'password': '',
  };
  var _isLoading = false;
  final _passwordController = TextEditingController();

  late AnimationController _controller; //Animation controller

  late Animation<Offset> _slideAnimation; //Animation parametres
  late Animation<double> _opacityAnimation; //Animation parameter

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this,
        duration: Duration(
            milliseconds: 300)); //How long will take animation time to finish
    _slideAnimation = Tween<Offset>(
            //Tween animation bettween two objects. Změnšovaní nebo zvětšovaní objectu.
            begin: Offset(0, -0.5),
            end:
                Offset(0, 0)) //Here we store information required for animation
        .animate(CurvedAnimation(
            //Here we set what animation we use
            parent: _controller, //We set a Animation controller
            curve:
                Curves //How animation will be played (př.   liner - po celou dobu animace se rychlost animace nezmení)
                    .linear));
    _opacityAnimation = Tween(begin: 0.0, end: 1.0)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));
    _slideAnimation.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  Future<void> _submit() async {
    print(wrongEmail);

    _formKey.currentState?.save();
    setState(() {
      _isLoading = true;
    });
    try {
      if (_authMode == AuthMode.Login) {
        print("ssssss");
        await Provider.of<Auth>(context, listen: false)
            .loginUP(_authData["email"], _authData["password"]);
      } else {
        // Sign user up
        await Provider.of<Auth>(context, listen: false)
            .signUP(_authData["email"], _authData["password"]);
      }
    } on ErrorDescription catch (error) {
      if (error.toString().contains("EMAIL")) {
        wrongEmail = true;
        //errorMessage = Provider.of<Auth>(context, listen: false).message;
      } else if (error.toString().contains("INVALID_PASSWORD")) {
        wrongPassword = true;
      }
    } catch (error) {
      throw error;
    }

    setState(() {
      _isLoading = false;
    });
    if (!_formKey.currentState!.validate()) {
      setState(() {
        wrongEmail = false;
        wrongPassword = false;
      });

      return;
    }
  }

  void _switchAuthMode() {
    if (_authMode == AuthMode.Login) {
      setState(() {
        _authMode = AuthMode.Signup;
      });
      _controller.forward(); //Animation controller
    } else {
      setState(() {
        _authMode = AuthMode.Login;
      });
      _controller.reverse(); //Animation controller
    }
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 8.0,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        curve: Curves.linear,
        height: _authMode == AuthMode.Signup ? 340 : 260,
        //height: _heightAnimation.value.height, //Animation parametres
        constraints: BoxConstraints(
            minHeight: _authMode == AuthMode.Signup
                ? 340
                : 260), //Animation parametres
        width: deviceSize.width * 0.75,
        padding: EdgeInsets.all(16.0),

        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                TextFormField(
                  decoration: InputDecoration(labelText: 'E-Mail'),
                  keyboardType: TextInputType.emailAddress,
                  validator: (email) {
                    if (email!.isEmpty || !email.contains("@")) {
                      return "Invalid email adress";
                    }
                    if (email.isNotEmpty && wrongEmail) {
                      return "Wrong email";
                    }
                    if (email.isNotEmpty && wrongEmail == false) {
                      return null;
                    }
                  },
                  onSaved: (value) {
                    _authData['email'] = value as String;
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Password'),
                  obscureText:
                      true, //User input is hidden on the screen common use with passwords  ******
                  controller: _passwordController,
                  validator: (value) {
                    if (value!.isEmpty || value.length < 5) {
                      return 'Password is too short!';
                    }
                    if (value.isNotEmpty && wrongPassword) {
                      return "Wrong Password";
                    }
                    if (value.isNotEmpty && wrongPassword == false) {
                      return null;
                    }
                  },
                  onSaved: (value) {
                    if (value == null) {
                      return;
                    } else {
                      _authData['password'] = value;
                    }
                  },
                ),
                AnimatedContainer(
                  duration: Duration(milliseconds: 300),
                  constraints: BoxConstraints(
                      minHeight: _authMode == AuthMode.Signup ? 60 : 0,
                      maxHeight: _authMode == AuthMode.Login ? 0 : 60),
                  curve: Curves.easeInOut,
                  child: FadeTransition(
                    opacity:
                        _opacityAnimation, //For this we need animation controller
                    child: SlideTransition(
                      position: _slideAnimation,
                      child: TextFormField(
                        enabled: _authMode == AuthMode.Signup,
                        decoration:
                            InputDecoration(labelText: 'Confirm Password'),
                        obscureText: true,
                        validator: _authMode == AuthMode.Signup
                            ? (value) {
                                if (value != _passwordController.text) {
                                  return 'Passwords do not match!';
                                }
                              }
                            : null,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                if (_isLoading)
                  CircularProgressIndicator()
                else
                  ElevatedButton(
                    child:
                        Text(_authMode == AuthMode.Login ? 'LOGIN' : 'SIGN UP'),
                    onPressed: _submit,
                    style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 30, vertical: 8),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30)),
                        primary: Theme.of(context).primaryColor,
                        onPrimary: Colors.white),
                  ),
                TextButton(
                  child: Text(
                      '${_authMode == AuthMode.Login ? 'SIGNUP' : 'LOGIN'} INSTEAD'),
                  onPressed: _switchAuthMode,
                  style: TextButton.styleFrom(
                      padding:
                          EdgeInsets.symmetric(horizontal: 30.0, vertical: 4),
                      primary: Theme.of(context).primaryColor,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
