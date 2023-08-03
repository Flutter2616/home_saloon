import 'dart:async';

import 'package:get/get.dart';

class Introcontroller extends GetxController {
  RxInt pageindex = 0.obs;

  List<Map> introdetail = [
    {
      "img": "assets/intro/bg1.png",
      "text":
          "Schedule your Appointment with the best Hair Stylist in your Town."
    },
    {
      "img": "assets/intro/bg2.png",
      "text": "Schedule the Appointmentin the best Salon for yourKids."
    },
    {
      "img": "assets/intro/bg3.png",
      "text": "Book yourself a massage therapist to release all your stress."
    },
  ];

}
