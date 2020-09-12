import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider_pattern/helpers/constants.dart';
import 'package:provider_pattern/models/userProfile.dart';
import 'package:provider_pattern/pages/auth/reset_password_screen.dart';
import 'package:provider_pattern/pages/home/homePage.dart';
import 'package:provider_pattern/provider/authProvider.dart';
import 'package:country_code_picker/country_code_picker.dart';

enum AuthMode { Signup, Login }

class AuthScreen extends StatefulWidget {
  static const routeName = '/auth';

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final String background = "assets/images/homepage.jpg";
  final GlobalKey<FormState> _formKey = GlobalKey();
  AuthMode _authMode = AuthMode.Login;
  var _isLoading = false;
  final _passwordController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _referalController = TextEditingController();

  final _phoneNumberController = TextEditingController();
  String _countryDialCOde = "";
  String _country = "";
  String _countryAbbv;

  _buildInputWidget(
      {@required String hintText,
      @required String errorMessage,
      @required TextEditingController textEditingController,
      @required bool obScuretext,
      @required bool isRequired,
      @required TextInputType textInputType}) {
    return TextFormField(
      obscureText: obScuretext,
      style: TextStyle(color: Colors.white),
      controller: textEditingController,
      keyboardType: textInputType,
      validator: (value) {
        if (!isRequired) return null;
        if (value.isEmpty) {
          return errorMessage;
        }
        return null;
      },
      decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.white70),
          enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.white54))),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _passwordController.dispose();
  }

  _setLoadingState(bool state) {
    setState(() {
      _isLoading = state;
    });
  }

  Future<void> _submit() async {
    if (!_formKey.currentState.validate()) {
      // Invalid!
      return;
    }
    _formKey.currentState.save();
    _setLoadingState(true);
    UserProfile _userProfile = new UserProfile(
        userId: "",
        phoneNumber: _phoneNumberController.text.trim(),
        email: _emailController.text.trim(),
        address: "",
        firstName: _firstNameController.text.trim(),
        lastName: _lastNameController.text.trim(),
        country: _country,
        countryCode: _countryDialCOde,
        countryAbbv: _countryAbbv,
        units: 10.0,
        usedCoupons: "",
        password: _passwordController.text.trim());
    if (_authMode == AuthMode.Login) {
      final response = await Provider.of<AuthProvider>(context, listen: false)
          .authenticateUser(_userProfile, Constants.signInWithPassword);
      if (!response.isSUcessfull) {
        _setLoadingState(false);
        return Constants.showErrorDialog(response.responseMessage, context);
      }
    } else {
      final response = await Provider.of<AuthProvider>(context, listen: false)
          .authenticateUser(_userProfile, Constants.signUp,
              referalCode: _referalController.text);
      if (!response.isSUcessfull) {
        _setLoadingState(false);
        return Constants.showErrorDialog(response.responseMessage, context);
      }
    }
    Navigator.of(context).pushReplacementNamed(HomePage.routeName);
  }

  void _switchAuthMode() {
    if (_authMode == AuthMode.Login) {
      setState(() {
        _authMode = AuthMode.Signup;
      });
    } else {
      setState(() {
        _authMode = AuthMode.Login;
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
                        "Sign in to continue",
                        style: TextStyle(color: Colors.white, fontSize: 12.0),
                      ),
                      SizedBox(
                        height: 30.0,
                      ),
                      if (_authMode == AuthMode.Signup)
                        _buildInputWidget(
                            textEditingController: _firstNameController,
                            hintText: "First Name",
                            isRequired: true,
                            errorMessage: "First Name Cannot be empty",
                            obScuretext: false,
                            textInputType: TextInputType.text),
                      SizedBox(
                        height: mediaQuery.height * 0.02,
                      ),
                      if (_authMode == AuthMode.Signup)
                        _buildInputWidget(
                            textEditingController: _lastNameController,
                            hintText: "Last Name",
                            isRequired: true,
                            errorMessage: "Last Name Cannot be empty",
                            obScuretext: false,
                            textInputType: TextInputType.text),
                      SizedBox(
                        height: mediaQuery.height * 0.02,
                      ),
                      if (_authMode == AuthMode.Signup)
                        Row(
                          children: <Widget>[
                            Expanded(
                              flex: 1,
                              child: CountryCodePicker(
                                onChanged: (e) {
                                  _country = e.name;
                                  _countryDialCOde = e.dialCode;
                                  _countryAbbv = e.code;
                                },
                                hideMainText: false,
                                // Initial selection and favorite can be one of code ('IT') OR dial_code('+39')
                                initialSelection: 'KE',
                                //   favorite: ['US', 'KE', 'GY'],
                                countryFilter: ['KE'],
                                // optional. Shows only country name and flag
                                showCountryOnly: false,
                                // optional. Shows only country name and flag when popup is closed.
                                showOnlyCountryWhenClosed: false,
                                // optional. aligns the flag and the Text left
                                alignLeft: false,
                                onInit: (e) {
                                  _country = e.name;
                                  _countryDialCOde = e.dialCode;
                                  _countryAbbv = e.code;
                                },
                              ),
                            ),
                            Expanded(
                              flex: 3,
                              child: _buildInputWidget(
                                  textEditingController: _phoneNumberController,
                                  hintText: "Phone Number",
                                  isRequired: true,
                                  errorMessage: "Phone Number cannot be emppty",
                                  obScuretext: false,
                                  textInputType: TextInputType.number),
                            ),
                          ],
                        ),
                      SizedBox(
                        height: mediaQuery.height * 0.02,
                      ),
                      _buildInputWidget(
                          textEditingController: _emailController,
                          hintText: "Email",
                          isRequired: true,
                          errorMessage: "Email cannot be emppty",
                          obScuretext: false,
                          textInputType: TextInputType.text),
                      SizedBox(
                        height: mediaQuery.height * 0.02,
                      ),
                      _buildInputWidget(
                          textEditingController: _passwordController,
                          hintText: "Password",
                          isRequired: true,
                          errorMessage: "Password  cannot be emppty",
                          obScuretext: false,
                          textInputType: TextInputType.text),
                      SizedBox(
                        height: mediaQuery.height * 0.03,
                      ),
                      if (_authMode == AuthMode.Signup)
                        _buildInputWidget(
                            textEditingController: _referalController,
                            hintText: "Enter Referal Code",
                            isRequired: false,
                            errorMessage: "",
                            obScuretext: false,
                            textInputType: TextInputType.text),
                      SizedBox(
                        height: mediaQuery.height * 0.03,
                      ),
                      SizedBox(
                        height: 40,
                        width: mediaQuery.width / 1.2,
                        child: RaisedButton(
                          child: _isLoading
                              ? CircularProgressIndicator()
                              : Text(
                                  "${_authMode == AuthMode.Login ? 'LOGIN' : 'SIGN UP'} ",
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 18),
                                ),
                          color: Colors.white,
                          onPressed: _submit,
                        ),
                      ),
                      SizedBox(
                        height: mediaQuery.height * 0.03,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          GestureDetector(
                            onTap: () {
                              _switchAuthMode();
                            },
                            child: Text(
                              _authMode == AuthMode.Login
                                  ? 'DO NOT HAVE AN ACCOUNT ?  SIGN UP'
                                  : 'ALREADY HAVE AN ACCOUNT : LOGIN',
                              style: TextStyle(
                                  color: Colors.white, fontSize: 14.0),
                            ),
                          ),
                          SizedBox(
                            width: 10.0,
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 25.0,
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context)
                              .pushNamed(ResetPasswordScreen.routeName);
                        },
                        child: Text(
                          "Forgot your password?",
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
