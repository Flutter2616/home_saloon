import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

class Paymentscreen extends StatefulWidget {
  const Paymentscreen({super.key});

  @override
  State<Paymentscreen> createState() => _PaymentscreenState();
}

class _PaymentscreenState extends State<Paymentscreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Column(
            children: [
              const SizedBox(height: 20),
              InkWell(
                  onTap: () {
                    Get.offAllNamed("dash");
                  },
                  child: Icon(Icons.close, color: Colors.black, size: 18.sp)),
              const SizedBox(height: 15),
              Text(
                "Payment method",
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 18.sp),
              ),
              const SizedBox(height: 15),
              ListTile(
                  leading: Icon(Icons.add, color: Colors.black, size: 15.sp),
                  title: Text(
                    "Add payment method",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w400),
                  ),minLeadingWidth: 5.w),
            ],
            crossAxisAlignment: CrossAxisAlignment.start,
          ),
        ),
      ),
    );
  }
}
