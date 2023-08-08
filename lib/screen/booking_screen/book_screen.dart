import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:home_saloon/screen/booking_screen/book_controller.dart';
import 'package:sizer/sizer.dart';

class Bookscreen extends StatefulWidget {
  const Bookscreen({super.key});

  @override
  State<Bookscreen> createState() => _BookscreenState();
}

//0xff6E4CFE
class _BookscreenState extends State<Bookscreen> {
  Bookcontroller book=Get.put(Bookcontroller());
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          leading: InkWell(
              onTap: () {
                Get.back();
              },
              child: Icon(Icons.arrow_back, color: Colors.black, size: 15.sp)),
          backgroundColor: Colors.white,
          elevation: 1,
          bottom: TabBar(
            onTap: (value) {
              print("value:==$value");
              if(value==0)
                {
                  book.tab.value=="complate";
                }
              else if(value==1)
                {
                  book.tab.value="pending";
                }
              print("tab value:==${book.tab.value}");
            },
            physics: NeverScrollableScrollPhysics(),
            indicatorColor: Color(0xff6E4CFE),
            labelColor: Color(0xff6E4CFE),
            unselectedLabelColor: Colors.grey,
            unselectedLabelStyle: TextStyle(
                color: Colors.grey,
                fontWeight: FontWeight.w600,
                fontSize: 12.sp),
            indicatorWeight: 3,
            labelStyle: TextStyle(
                color: Colors.grey,
                fontWeight: FontWeight.w500,
                fontSize: 12.sp),
            tabs: [
              Tab(text: "Past"),
              Tab(text: "Upcoming"),
              Tab(text: "Favorite"),
            ],
          ),
          title: Text(
            "Your Booking",
            style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
                color: Colors.black),
          ),
        ),
      ),
    );
  }
}
