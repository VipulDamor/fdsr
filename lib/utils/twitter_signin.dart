import 'package:fdsr/modules/dashboard/dashboard.dart';
import 'package:fdsr/utils/constant.dart';
import 'package:fdsr/utils/signin_config.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:twitter_login/twitter_login.dart';

class AppTwitterSignin {
  final API_KEY = 'gGIuXDhDUaPT09TDcoKF0WpX6';
  final API_SECRET_KEY = 't00Swzubrp09HBA0Pd9ZhuamEJWyULP1KHKOu8m0rzmH7z5lbW';
  final sharedPrefarance = GetStorage();

  Future<UserCredential> signInWithTwitter() async {
    // Create a new provider
    TwitterAuthProvider twitterProvider = TwitterAuthProvider();

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithPopup(twitterProvider);

    // Or use signInWithRedirect
    // return await FirebaseAuth.instance.signInWithRedirect(twitterProvider);
  }

  Future<void> performTwitterSignin() async {
    if (kIsWeb) {
      try {
        TwitterAuthProvider twitterProvider = TwitterAuthProvider();
        // Once signed in, return the UserCredential
        UserCredential credential =
            await FirebaseAuth.instance.signInWithPopup(twitterProvider);

        if (credential != null && credential.user != null) {
          String? email = credential.user!.email;
          String id = credential.user!.uid;

          sharedPrefarance.write(Constant.GOOGLE_SIGNIN_EMAIL, email);
          sharedPrefarance.write(Constant.GOOGLE_SIGNIN_ID, id);

          Get.offAll(() => DashBoardScreen(),
              arguments: [SignInConfig.TWITTER, email, id]);
        }
      } on FirebaseAuthException catch (error) {
        print(error.code);
        if (error.code == 'account-exists-with-different-credential') {
          String message = 'An account already exists with the same email';
          Constant.showAlertDialog(message);
        }
      }
    } else {
      final twitterLogin = TwitterLogin(
        apiKey: API_KEY,
        apiSecretKey: API_SECRET_KEY,
        redirectURI: 'fdsr://',
      );
      final authResult = await twitterLogin.login();

      //print(authResult);
      switch (authResult.status) {
        case TwitterLoginStatus.loggedIn:
          String email = authResult.user!.email.toString();
          String id = authResult.user!.id.toString();

          sharedPrefarance.write(Constant.GOOGLE_SIGNIN_EMAIL, email);
          sharedPrefarance.write(Constant.GOOGLE_SIGNIN_ID, id);

          Get.offAll(() => DashBoardScreen(),
              arguments: [SignInConfig.TWITTER, email, id]);

          print('====== Login success ======');
          break;
        case TwitterLoginStatus.cancelledByUser:
          // cancel
          print('====== Login cancel ======');
          break;
        case TwitterLoginStatus.error:
        case null:
          // error
          print('====== Login error ======');
          break;
      }
    }
  }

  Future<void> isAppTwitterSignin() async {
    try {
      final id = sharedPrefarance.read(Constant.GOOGLE_SIGNIN_ID);
      final email = sharedPrefarance.read(Constant.GOOGLE_SIGNIN_EMAIL);

      SchedulerBinding.instance!.addPostFrameCallback((_) {
        Get.offAll(() => DashBoardScreen(),
            arguments: [SignInConfig.TWITTER, email, id]);
      });
    } catch (error) {
      print(error);
    }
  }
}
