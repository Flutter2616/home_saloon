import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class Bookscreen extends StatefulWidget {
  const Bookscreen({super.key});

  @override
  State<Bookscreen> createState() => _BookscreenState();
}

//0xff6E4CFE
class _BookscreenState extends State<Bookscreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 1,
          bottom: TabBar(
            onTap: (value) {},
            physics: NeverScrollableScrollPhysics(),
            indicatorColor: Color(0xff6E4CFE),
            labelColor: Color(0xff6E4CFE),
            unselectedLabelColor: Colors.grey,
            unselectedLabelStyle: TextStyle(
                color: Colors.grey,
                fontWeight: FontWeight.w600,
                fontSize: 12.sp),indicatorWeight: 3,
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
