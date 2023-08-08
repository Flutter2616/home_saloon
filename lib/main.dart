import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:home_saloon/screen/address_screen/show_address_screen.dart';
import 'package:home_saloon/screen/booking_screen/book_screen.dart';
import 'package:home_saloon/screen/booking_screen/view_booking_screen.dart';
import 'package:home_saloon/screen/homescreen/home_screen.dart';
import 'package:home_saloon/screen/introo_screen/introscreen.dart';
import 'package:home_saloon/screen/login/login_screen.dart';
import 'package:home_saloon/screen/login/signup_screen.dart';
import 'package:home_saloon/screen/payment_screen/add_payment_screen.dart';
import 'package:home_saloon/screen/payment_screen/paymentscreen.dart';
import 'package:home_saloon/screen/search_screen/searchscreen.dart';
import 'package:home_saloon/screen/splash_screen.dart';
import 'package:home_saloon/screen/type_screen/type_screen.dart';
import 'package:sizer/sizer.dart';
import 'firebase_options.dart';
import 'screen/address_screen/new_address_screen.dart';
import 'screen/cart_screen/cartscreen.dart';
import 'screen/map_screen/map_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    Sizer(
      builder: (context, orientation, deviceType) =>
          GetMaterialApp(
            debugShowCheckedModeBanner: false,
            // initialRoute: "search",
            routes: {
              '/': (context) => Splashscreen(),
              'intro': (context) => IntroScreen(),
              'map': (context) => Mapscreen(),
              'login': (context) => Loginscreen(),
              'signup': (context) => Signupscreen(),
              'home': (context) => Homescreen(),
              'type': (context) => Typescreen(),
              'cart': (context) => Cartscreen(),
              'book': (context) => Bookscreen(),
              'payment': (context) => Paymentscreen(),
              'newaddress': (context) => Newaddress(),
              'showaddress': (context) => ShowAddress(),
              'order': (context) => ViewBookingScreen(),
              'addpayment': (context) => AddPaymentScreen(),
              'search': (context) => Searchscreen(),
            },
          ),
    ),
  );
}
