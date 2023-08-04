import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:home_saloon/screen/introo_screen/intro_controller.dart';
import 'package:sizer/sizer.dart';

class IntroScreen extends StatefulWidget {
  const IntroScreen({super.key});

  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  Introcontroller controller = Get.put(Introcontroller());

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            PageView(physics: NeverScrollableScrollPhysics(),
             children: [
               Obx(() =>  screen(controller.introdetail[controller.pageindex.value]['img'])),
             ],
              scrollDirection: Axis.horizontal,
              reverse: false,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 100.w,
                    height: 10.h,
                    alignment: Alignment.topLeft,
                    child: Obx(
                      () => Text(
                          "${controller.introdetail[controller.pageindex.value]['text']}",
                          maxLines: 4,
                          style: TextStyle(
                              color: Colors.white,
                              letterSpacing: 2,
                              wordSpacing: 5,
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w500),
                          textAlign: TextAlign.start),
                    ),
                  ),
                  SizedBox(height: 40),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: controller.introdetail
                          .asMap()
                          .entries
                          .map((e) => Obx(
                                () => Container(
                                  height: controller.pageindex.value == e.key
                                      ? 3.w
                                      : 2.w,
                                  width: controller.pageindex.value == e.key
                                      ? 3.w
                                      : 2.w,
                                  margin: EdgeInsets.symmetric(horizontal: 3),
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: e.key == controller.pageindex.value
                                          ? Colors.white
                                          : Colors.grey.shade400),
                                ),
                              ))
                          .toList()),
                  SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(onTap: () {
                        Get.offAllNamed("login");
                      },child: button("Login", Colors.transparent, Colors.white)),
                      InkWell(onTap: () {
                        if(controller.pageindex.value<controller.introdetail.length-1)
                          {
                            controller.pageindex.value++;
                          }
                        else
                          {
                            Get.offAllNamed("login");
                          }
                      },
                        child: Obx(() => button(
                            controller.pageindex.value <= 1
                                ? "Next"
                                : "Get started",
                            Colors.white,
                            Color(0xff6440FE))),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Container screen(String img) {
    return Container(
                 height: 100.h,
                 width: 100.w,
                 decoration: BoxDecoration(
               color: Color(0xdd000000),
               image: DecorationImage(
                   image: AssetImage(
                       "${img}"),
                   fit: BoxFit.cover,
                   opacity: 180)),
               );
  }

  Container button(String title, Color c, Color textcolor) {
    return Container(
      height: 5.5.h,
      width: 45.w,
      alignment: Alignment.center,
      decoration: BoxDecoration(
          color: c,
          borderRadius: BorderRadius.circular(5.sp),
          border: Border.all(color: Colors.white)),
      child: Text("$title",
          style: TextStyle(
            color: textcolor,
            fontSize: 15.sp,
          )),
    );
  }
}
