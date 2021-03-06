import 'package:fdsr/component/bottom_icons.dart';
import 'package:fdsr/component/edit_text.dart';
import 'package:fdsr/component/rounded_button.dart';
import 'package:fdsr/modules/register/register.dart';
import 'package:fdsr/utils/constant.dart';
import 'package:fdsr/utils/facebook_signin.dart';
import 'package:fdsr/utils/google_signin.dart';
import 'package:fdsr/utils/signin_config.dart';
import 'package:fdsr/utils/twitter_signin.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'login_controller.dart';

class Login extends StatelessWidget {
  final getLoginController = Get.put(LoginController());
  final sharedPrefarance = GetStorage();

  @override
  build(BuildContext context) {
    var config = sharedPrefarance.read(Constant.LOGIN_WITH);
    Size size = Get.size;

    if (config.runtimeType == String) {
      if (config == SignInConfig.GOOGLE.toString()) {
        AppGoogleSignIn().isSignin();
      }
      if (config == SignInConfig.FACEBOOK.toString()) {
        AppFacebookSignin().isFacebookLogin();
      }
      if (config == SignInConfig.EMAIL.toString()) {
        Constant.isLoggedIn();
      }
      if (config == SignInConfig.TWITTER.toString()) {
        //print('coming here');
        AppTwitterSignin().isAppTwitterSignin();
      }
    }
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Container(
            height: size.height *
                (size.height > 770
                    ? 0.7
                    : size.height > 670
                        ? 0.8
                        : 0.9),
            width: 500,
            child: Padding(
              padding: EdgeInsets.fromLTRB(21, 0, 21, 0),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Image.asset(
                      "images/logo.jpg",
                      width: 160,
                      height: 160,
                    ),
                    Text(
                      'Login',
                      style: TextStyle(
                        fontSize: 31,
                        fontWeight: FontWeight.w700,
                      ),
                      textAlign: TextAlign.start,
                    ),
                    SizedBox(height: 8),
                    EditText('email', false, Icons.alternate_email, (data) {},
                        getLoginController.loginEmailController),
                    Divider(
                      color: Colors.black,
                      thickness: 1,
                    ),
                    EditText('password', true, Icons.lock_outlined, (data) {},
                        getLoginController.loginPasswordController),
                    Divider(
                      color: Colors.black,
                      thickness: 1,
                    ),
                    SizedBox(height: 10),
                    RoundedButton('Login', () async {
                      //button click
                      String message =
                          await getLoginController.performEmailLogin();
                      Constant.showAlertDialog(message);
                    }),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Divider(
                            color: Colors.grey,
                            thickness: 1,
                          ),
                        ),
                        Expanded(
                            flex: 2,
                            child: Text(
                              'Or sign in with',
                              textAlign: TextAlign.center,
                            )),
                        Expanded(
                          child: Divider(
                            color: Colors.grey,
                            thickness: 1,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        BottomIcons(FontAwesomeIcons.google, () async {
                          AppGoogleSignIn appGoogleSignIn = AppGoogleSignIn();
                          await appGoogleSignIn.handleGooleSignIn();
                          await appGoogleSignIn.isSignin();
                        }),
                        SizedBox(width: 20),
                        BottomIcons(FontAwesomeIcons.facebook, () {
                          AppFacebookSignin().performFacebookLogin();
                        }),
                        SizedBox(width: 20),
                        BottomIcons(FontAwesomeIcons.twitter, () async {
                          await AppTwitterSignin().performTwitterSignin();
                        }),
                        /*SizedBox(width: 20),
                        Platform.isIOS
                            ? BottomIcons(FontAwesomeIcons.apple, () {}):
                        SizedBox(width: 20),*/
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('New User ?'),
                        TextButton(
                          onPressed: () {
                            Get.to(() => Register());
                          },
                          child: Text(
                            ' Register',
                            style: TextStyle(color: Colors.indigo),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
