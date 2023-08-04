import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:home_saloon/screen/booking_screen/book_screen.dart';
import 'package:home_saloon/screen/setting/setting_controller.dart';
import 'package:home_saloon/screen/setting/setting_screen.dart';
import 'package:sizer/sizer.dart';

class Dashscreen extends StatefulWidget {
  const Dashscreen({super.key});

  @override
  State<Dashscreen> createState() => _DashscreenState();
}

class _DashscreenState extends State<Dashscreen> {
  Settingcontroller setting=Get.put(Settingcontroller(),);
  @override
  void initState() {
    super.initState();
    setting.pageindex.value=1;
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Obx(
          () => IndexedStack(index: setting.pageindex.value,
            children: [
              Bookscreen(),
              Settingscreen(),
            ],
          ),
        ),
        bottomNavigationBar: Obx(
          () => BottomNavigationBar(
            items: [
              BottomNavigationBarItem(label: "Booking",icon: Icon(Icons.list,size: 15.sp,)),
              BottomNavigationBarItem(label: "Account",icon: Icon(Icons.person_2_outlined,size: 15.sp),activeIcon: Icon(Icons.person_2_outlined,size: 18.sp)),
            ],
            backgroundColor: Colors.white,selectedFontSize: 12.sp,unselectedFontSize: 10.sp,selectedItemColor: Color(0xff6E4CFE),
            currentIndex: setting.pageindex.value,onTap: (value) {
              setting.pageindex.value=value;
            },
            elevation: 0,
          ),
        ),
      ),
    );
  }
}
