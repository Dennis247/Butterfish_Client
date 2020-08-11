import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider_pattern/helpers/constants.dart';
import 'package:provider_pattern/provider/authProvider.dart';

import 'auth_screen.dart';

class ResetPasswordScreen extends StatefulWidget {
  static const routeName = '/reset-password';

  @override
  _ResetPasswordScreenState createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final String background = "assets/images/homepage.jpg";
  String _email;
  TextEditingController _emailTextEditingController =
      new TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey();

  var _isLoading = false;

  void _showErrorDialog(String headerText, Color color, String errorMessage) {
    showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
              title: Text(
                headerText,
                style: TextStyle(color: color),
              ),
              content: Text(errorMessage),
              actions: <Widget>[
                FlatButton(
                    child: Text("OK"),
                    onPressed: () {
                      Navigator.of(ctx).pop();
                    })
              ],
            ));
  }

  Future<void> _submit() async {
    if (!_formKey.currentState.validate()) {
      // Invalid!
      return;
    }
    _formKey.currentState.save();
    setState(() {
      _isLoading = true;
    });
    try {
      _email = _email.trim();
      await Provider.of<AuthProvider>(context, listen: false)
          .resetPassword(_email);
      String sucessMessage = "A reset link has been sent to your mail $_email";
      _showErrorDialog(
          "Password Reset Sucessfull", Colors.green, sucessMessage);
      setState(() {
        _isLoading = false;
        _emailTextEditingController.text = "";
      });

      //load user profile
    } on HttpException catch (error) {
      var errorMessage = "password recovery failed";
      if (error.toString().contains("EMAIL_NOT_FOUND"))
        errorMessage = "The user with Email $_email does not exist";

      _showErrorDialog("Something Went Wrong", Colors.red, errorMessage);
      setState(() {
        _isLoading = false;
      });
    } catch (error) {
      const errormessage = "could not authenticate the email";
      _showErrorDialog("Something Went Wrong", Colors.red, errormessage);
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context).size;
    return Scaffold(
      body: Form(
        key: _formKey,
        child: Container(
          color: Constants.darkPrimary,
          child: Stack(
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(20.0),
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage(background), fit: BoxFit.cover)),
              ),
              Container(
                padding: EdgeInsets.all(20.0),
                color: Colors.black.withOpacity(0.7),
              ),
              SingleChildScrollView(
                padding: EdgeInsets.all(20.0),
                physics: BouncingScrollPhysics(),
                scrollDirection: Axis.vertical,
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      SizedBox(
                        height: mediaQuery.height * 0.05,
                      ),
                      Text(
                        "Welcome Back",
                        style: TextStyle(color: Colors.white, fontSize: 20.0),
                      ),
                      Text(
                        "Enter Email used for registering account",
                        style: TextStyle(color: Colors.white, fontSize: 12.0),
                      ),
                      SizedBox(
                        height: 30.0,
                      ),
                      TextFormField(
                        style: TextStyle(color: Colors.white),
                        controller: _emailTextEditingController,
                        validator: (value) {
                          if (value.isEmpty || !value.contains('@')) {
                            return 'Invalid email!';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _email = value;
                        },
                        decoration: InputDecoration(
                            hintText: "email",
                            hintStyle: TextStyle(color: Colors.white70),
                            enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white54))),
                      ),
                      SizedBox(
                        height: mediaQuery.height * 0.02,
                      ),
                      SizedBox(
                        height: 25.0,
                      ),
                      SizedBox(
                        height: 40,
                        width: mediaQuery.width / 1.5,
                        child: RaisedButton(
                          child: _isLoading
                              ? CircularProgressIndicator()
                              : Text(
                                  "RESET PASSWORD",
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 18),
                                ),
                          color: Colors.white,
                          onPressed: _submit,
                        ),
                      ),
                      SizedBox(
                        height: mediaQuery.height * 0.02,
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).pushNamed(AuthScreen.routeName);
                        },
                        child: Text(
                          "Go back to Login?",
                          style: TextStyle(color: Colors.white, fontSize: 12),
                          textAlign: TextAlign.right,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
