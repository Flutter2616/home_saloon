import 'package:flutter/material.dart';
import 'package:home_saloon/screen/homescreen/home_screen.dart';
import 'package:sizer/sizer.dart';

class Settingscreen extends StatefulWidget {
  const Settingscreen({super.key});

  @override
  State<Settingscreen> createState() => _SettingscreenState();
}

//0xff6E4CFE
class _SettingscreenState extends State<Settingscreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          children: [
            // const SizedBox(height: 10),
            Container(
              alignment: Alignment.center,
              height: 9.h,
              padding: EdgeInsets.symmetric(horizontal: 25),
              decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border(
                      bottom:
                          BorderSide(color: Colors.grey.shade200, width: 2))),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(
                      radius: 18.sp,
                      backgroundImage: AssetImage("assets/intro/bg1.png")),
                  const SizedBox(width: 8),
                  Column(
                    children: [
                      Text(
                        "${user['name'] ?? 'Name'}",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        "${user['email']}",
                        style: TextStyle(
                            color: Colors.grey,
                            fontSize: 10.sp,
                            fontWeight: FontWeight.w500),
                      ),
                    ],
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                  ),
                  Spacer(),
                  Text(
                    "Edit",
                    style: TextStyle(
                        color: Color(0xff6E4CFE),
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(8.0),
              child: ListTile(
                  title: Text(
                    "Your favorite",
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 12.sp,
                        color: Colors.black),
                  ),
                  minLeadingWidth: 5.w,
                  trailing: Icon(Icons.arrow_forward_ios,
                      size: 12.sp, color: Colors.black),
                  leading: Icon(Icons.favorite_border,
                      color: Colors.black, size: 18.sp),
                  subtitle: Text("Reorder your favorite service in a click")),
            ),
          ],
        ),
      ),
    );
  }
}
