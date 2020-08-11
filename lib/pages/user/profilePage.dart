import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider_pattern/helpers/constants.dart';
import 'package:provider_pattern/models/userProfile.dart';
import 'package:provider_pattern/pages/widgets/app_drawer.dart';
import 'package:provider_pattern/provider/authProvider.dart';

class ProfilePage extends StatefulWidget {
  static final String routeName = "ProfilePage";

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  var _isLoading = false;
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _addressController = TextEditingController();
  final _phoneNumberController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey();

  @override
  void initState() {
    _firstNameController.text = loggedInUser.firstName;
    _lastNameController.text = loggedInUser.lastName;
    _addressController.text = loggedInUser.address;
    _phoneNumberController.text = loggedInUser.phoneNumber;
    super.initState();
  }

  _buildInputWidget(
      {@required String hintText,
      @required String errorMessage,
      @required TextEditingController textEditingController,
      @required bool obScuretext,
      @required TextInputType textInputType}) {
    return TextFormField(
      obscureText: obScuretext,
      style: TextStyle(color: Colors.black),
      controller: textEditingController,
      keyboardType: textInputType,
      validator: (value) {
        if (value.isEmpty) {
          return errorMessage;
        }
        return null;
      },
      decoration: InputDecoration(
          labelText: hintText,
          hintStyle: TextStyle(color: Constants.primaryColor),
          enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Constants.primaryColor))),
    );
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
    loggedInUser = new UserProfile(
        userId: loggedInUser.userId,
        phoneNumber: _phoneNumberController.text.trim(),
        address: _addressController.text.trim(),
        firstName: _firstNameController.text.trim(),
        lastName: _lastNameController.text.trim(),
        units: loggedInUser.units,
        usedCoupons: loggedInUser.usedCoupons,
        country: loggedInUser.country,
        countryAbbv: loggedInUser.countryAbbv,
        countryCode: loggedInUser.countryCode,
        email: loggedInUser.email,
        referalCode: loggedInUser.referalCode);
    final response = await Provider.of<AuthProvider>(context, listen: false)
        .updateUserProfile(loggedInUser);
    if (!response.isSUcessfull) {
      Constants.showErrorDialog(response.responseMessage, context);
    } else {
      Constants.showSuccessDialogue(response.responseMessage, context);
    }
    _setLoadingState(false);
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        actions: <Widget>[
          IconButton(
              icon: Icon(
                Icons.save,
                color: Colors.white,
              ),
              onPressed: _submit),
        ],
        title: Text(
          "PROFILE",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      drawer: AppDrawer(),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      _buildInputWidget(
                          textEditingController: _firstNameController,
                          hintText: "First Name",
                          errorMessage: "First Name Cannot be empty",
                          obScuretext: false,
                          textInputType: TextInputType.text),
                      SizedBox(
                        height: mediaQuery.height * 0.02,
                      ),
                      _buildInputWidget(
                          textEditingController: _lastNameController,
                          hintText: "Last Name",
                          errorMessage: "Last Name Cannot be empty",
                          obScuretext: false,
                          textInputType: TextInputType.text),
                      SizedBox(
                        height: mediaQuery.height * 0.02,
                      ),
                      _buildInputWidget(
                          textEditingController: _phoneNumberController,
                          hintText: "Phone Number",
                          errorMessage: "Phone Number Cannot be empty",
                          obScuretext: false,
                          textInputType: TextInputType.text),
                      SizedBox(
                        height: mediaQuery.height * 0.02,
                      ),
                      _buildInputWidget(
                          textEditingController: _addressController,
                          hintText: "Address",
                          errorMessage: "Address Cannot be empty",
                          obScuretext: false,
                          textInputType: TextInputType.text),
                      SizedBox(
                        height: mediaQuery.height * 0.02,
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
