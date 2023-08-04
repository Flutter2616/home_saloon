import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:home_saloon/screen/homescreen/home_screen.dart';
import 'package:home_saloon/screen/setting/setting_controller.dart';
import 'package:home_saloon/utils/firebase_helper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sizer/sizer.dart';

class Settingscreen extends StatefulWidget {
  const Settingscreen({super.key});

  @override
  State<Settingscreen> createState() => _SettingscreenState();
}

//0xff6E4CFE
class _SettingscreenState extends State<Settingscreen> {
  Settingcontroller setting = Settingcontroller();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // const SizedBox(height: 10),
        Container(
          alignment: Alignment.center,
          height: 9.h,
          padding: EdgeInsets.symmetric(horizontal: 25),
          decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                  bottom: BorderSide(color: Colors.grey.shade200, width: 2))),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              InkWell(
                onTap: () async {
                  ImagePicker pickimage = ImagePicker();
                  XFile? image =
                      await pickimage.pickImage(source: ImageSource.gallery);
                  setting.path.value = image!.path;
                },
                child: CircleAvatar(
                    radius: 18.sp,
                    backgroundImage: FileImage(File("${setting.path}"))),
              ),
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
        InkWell(
          onTap: () {
            // Get.toNamed("book");
          },
          child: tile(
              Icon(Icons.favorite_border, color: Colors.black, size: 18.sp),
              "Your favorite",
              "Recorder your favorite service in a click"),
        ),
        InkWell(onTap: () {
          Get.toNamed("payment");
        },
          child: tile(Icon(Icons.payment, color: Colors.black, size: 18.sp), "Payment",
              "Payment methods, Transaction History"),
        ),
        tile(Icon(Icons.note_alt_outlined, color: Colors.black, size: 18.sp),
            "Manage Address", ""),
        tile(
            Icon(Icons.notifications_outlined,
                color: Colors.black, size: 18.sp),
            "Notification",
            "View your past notification"),
        tile(
            Icon(Icons.work_outline, color: Colors.black, size: 18.sp),
            "Register as partner",
            "Want to list your service? Register with us"),
        tile(Icon(Icons.error_outline, color: Colors.black, size: 18.sp),
            "About", "Privacy Policy, Terms of Services, Licenses"),
        InkWell(
          onTap: () {
            Get.bottomSheet(
              // enableDrag: false,
              isDismissible: false,
              Container(
                color: Colors.white,
                height: 20.h,
                padding: EdgeInsets.symmetric(horizontal: 25),
                alignment: Alignment.center,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Logout?",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 12.sp,
                                fontWeight: FontWeight.bold)),
                        InkWell(onTap: () {
                          Get.back();
                        },
                          child: Icon(Icons.close,
                              size: 15.sp, color: Colors.black, weight: 100),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text("Are you sure want to logout from the app?",
                        style: TextStyle(
                            color: Colors.grey,
                            fontSize: 10.sp,
                            fontWeight: FontWeight.w500)),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(onTap: () {
                          Get.back();
                        },
                          child: Container(
                            height: 5.h,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8.sp),
                                color: Colors.white,
                                border: Border.all(color: Color(0xff6E4CFE))),
                            width: 35.w,
                            alignment: Alignment.center,
                            child: Text("Cancel",
                                style: TextStyle(
                                    color: Color(0xff6E4CFE), fontSize: 12.sp)),
                          ),
                        ),
                        const SizedBox(width: 10),
                        InkWell(onTap: () {
                          Firebasehelper.helper.logout();
                        },
                          child: Container(
                            height: 5.h,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8.sp),
                                color: Colors.red.shade600,),
                            width: 45.w,
                            alignment: Alignment.center,
                            child: Text("Logout",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 12.sp,fontWeight: FontWeight.w500)),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
            // print("logout========");
          },
          child: tile(
              Icon(Icons.login, color: Colors.red.shade600, size: 18.sp),
              "Logout",
              ""),
        ),
      ],
    );
  }

  Padding tile(Icon i, String title, String subtitle) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: ListTile(
          title: Text(
            "$title",
            style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 12.sp,
                color: title == 'Logout' ? Colors.red.shade600 : Colors.black),
          ),
          minLeadingWidth: 5.w,
          trailing: Icon(Icons.arrow_forward_ios,
              size: 12.sp,
              color: title == 'Logout' ? Colors.red.shade600 : Colors.black),
          leading: i,
          subtitle: Text("$subtitle")),
    );
  }
}
