import 'package:flutter/material.dart';
import 'package:selendra_marketplace_app/all_export.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

String _phone, _password;

class SignUpPhoneForm extends StatelessWidget {
  final Function signInPhoneFunc;
  final Function facebookSignIn;
  final Function googleSignIn;

  SignUpPhoneForm(this.signInPhoneFunc, this.facebookSignIn, this.googleSignIn);

  final _phoneFormKey = GlobalKey<FormState>();

  void validateAndSubmit() {
    if (_phoneFormKey.currentState.validate()) {
      _phoneFormKey.currentState.save();
      print(_phone);
      print(_password);
      signInPhoneFunc(_phone, _password);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      child: Form(
        key: _phoneFormKey,
        child: Column(
          children: [
            SizedBox(
              height: 20,
            ),
            Container(
              child: IntlPhoneField(
                decoration: InputDecoration(
                  labelText:
                      AppLocalizeService.of(context).translate('phone_hint'),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: kDefaultColor),
                    borderRadius:
                        BorderRadius.all(Radius.circular(kDefaultRadius)),
                  ),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.greenAccent),
                      borderRadius:
                          BorderRadius.all(Radius.circular(kDefaultRadius))),
                ),
                initialCountryCode: 'KH',
                validator: (value) =>
                    value.isEmpty ? "Phone Number is empty" : null,
                onChanged: (phone) {
                  print(phone.completeNumber);
                  _phone = phone.completeNumber.toString();
                },
              ),
            ),
            SizedBox(
              height: 10,
            ),
            ReusePwField(
              labelText: AppLocalizeService.of(context).translate('password'),
              validator: (value) => value.isEmpty || value.length < 6
                  ? "Password is empty or less than 6 character"
                  : null,
              onSaved: (value) => _password = value,
            ),
            SizedBox(
              height: 40,
            ),
            ReuseButton.getItem(
                AppLocalizeService.of(context).translate('signup_string'), () {
              validateAndSubmit();
            }, context),
            SizedBox(height: 10),
            ReuseFlatButton.getItem(
                AppLocalizeService.of(context).translate('had_an_account'),
                AppLocalizeService.of(context).translate('signin_string'), () {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SignIn(),
                  ));
            }),
            SizedBox(
              height: 10,
            ),
            Text(
              AppLocalizeService.of(context).translate('or_string'),
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            SizedBox(
              height: 10,
            ),
            _buildBtnSocialRow(),
          ],
        ),
      ),
    );
  }

  Widget _buildBtnSocialRow() {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          BtnSocial(() {
            facebookSignIn();
          }, AssetImage('images/facebook.jpg')),
          SizedBox(width: 20),
          BtnSocial(() {
            googleSignIn();
          }, AssetImage('images/google.jpg')),
        ],
      ),
    );
  }
}
