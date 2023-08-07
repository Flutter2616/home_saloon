import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:home_saloon/screen/map_screen/map_controller.dart';
import 'package:home_saloon/utils/firebase_helper.dart';
import 'package:sizer/sizer.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class Splashscreen extends StatefulWidget {
  const Splashscreen({super.key});

  @override
  State<Splashscreen> createState() => _SplashscreenState();
}

class _SplashscreenState extends State<Splashscreen> {
  bool status=false;
  Mapcontroller map=Get.put(Mapcontroller());
  @override
  void initState() {
    super.initState();
    status=Firebasehelper.helper.checkuser();
    print(status);
  }


  @override
  Widget build(BuildContext context) {
    Timer(Duration(seconds: 4), () async {
      status==false?Get.offAllNamed('intro'):Get.offAllNamed('home');
    });
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(0xffcdc5f5),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                "assets/images/logo.png",
                height: 40.w,
                width: 80.w,
                fit: BoxFit.fill,
              ),
              LoadingAnimationWidget.hexagonDots(color: Color(0xff451cf1), size: 30.sp)
            ],
          ),
        ),
      ),
    );
  }
}
