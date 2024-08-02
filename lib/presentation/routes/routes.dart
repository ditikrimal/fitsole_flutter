import 'package:fitsole_flutter/presentation/screen/home/home.dart';
import 'package:fitsole_flutter/presentation/screen/login/loading_page.dart';
import 'package:fitsole_flutter/presentation/screen/login/login_page.dart';
import 'package:fitsole_flutter/presentation/screen/login/otp_page.dart';
import 'package:fitsole_flutter/presentation/screen/login/register_page.dart';
import 'package:fitsole_flutter/presentation/screen/start/start_home_page.dart';
import 'package:fitsole_flutter/presentation/test.dart';
import 'package:flutter/material.dart';

Map<String, Widget Function(BuildContext context)> routes = {
  //'testPage': (context) => TestPage(),
  'loadingPage': (context) => LoadingPage(),
  'getStarted': (context) => StartHomePage(),
  'signInPage': (context) => SignInPage(),
  'signUpPage': (context) => SignUpPage(),
  'homePage': (context) => HomePage(),
  'testPage': (context) => TestHomeScreen(),
  // 'cartPage'      : ( context ) => CartPage(),
  // 'favoritePage'  : ( context ) => FavoritePage(),
  // 'profilePage'   : ( context ) => ProfilePage(),
};
