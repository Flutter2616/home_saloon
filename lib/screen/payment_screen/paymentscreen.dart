import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_credit_card/credit_card_brand.dart';
import 'package:flutter_credit_card/credit_card_widget.dart';
import 'package:flutter_credit_card/custom_card_type_icon.dart';
import 'package:get/get.dart';
import 'package:home_saloon/screen/homescreen/home_screen.dart';
import 'package:home_saloon/screen/payment_screen/payment_controller.dart';
import 'package:home_saloon/screen/payment_screen/payment_modal.dart';
import 'package:home_saloon/utils/firebase_data.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:sizer/sizer.dart';

class Paymentscreen extends StatefulWidget {
  const Paymentscreen({super.key});

  @override
  State<Paymentscreen> createState() => _PaymentscreenState();
}

class _PaymentscreenState extends State<Paymentscreen> {
  Paymentcontroller payment = Get.put(Paymentcontroller());

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
                    Get.back();
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
              StreamBuilder(
                stream: Firebasedata.data.card_read("${user['uid']}"),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Center(
                      child: Text("${snapshot.error}"),
                    );
                  } else if (snapshot.hasData) {
                    QuerySnapshot qs = snapshot.data!;
                    List<QueryDocumentSnapshot> query = qs.docs;
                    Map m1 = {};
                    payment.cardlist.clear();
                    for (var x in query) {
                      String id = x.id;
                      m1 = x.data() as Map;
                      Paymentmodal modal = Paymentmodal(
                        cardnumber: m1['cardnumber'],
                        cardname: m1['cardname'],
                        carddate: m1['carddate'],
                        cardcvv: m1['cardcvv'],
                      );
                      payment.cardlist.add(modal);
                    }
                    return Column(
                      children: payment.cardlist
                          .asMap()
                          .entries
                          .map(
                            (e) => CreditCardWidget(
                              height: 25.h,
                              width: 100.w,isHolderNameVisible: true,
                              cardBgColor: Colors.black,
                              isChipVisible: true,
                              isSwipeGestureEnabled: true,
                              obscureCardCvv: false,
                              obscureCardNumber: true,
                              cardNumber:
                                  "${payment.cardlist[e.key].cardnumber}",
                              expiryDate: "${payment.cardlist[e.key].carddate}",
                              cardHolderName:
                                  "${payment.cardlist[e.key].cardname}",
                              cvvCode: "${payment.cardlist[e.key].cardcvv}",
                              showBackView: false,
                              onCreditCardWidgetChange: (p0) {},
                            ),
                          )
                          .toList(),
                    );
                  }
                  return Center(
                    child: LoadingAnimationWidget.hexagonDots(
                        color: Color(0xff451cf1), size: 30.sp),
                  );
                },
              ),
              const SizedBox(height: 15),
              ListTile(
                  onTap: () {
                    Get.toNamed("addpayment");
                  },
                  leading: Icon(Icons.add, color: Colors.black, size: 15.sp),
                  title: Text(
                    "Add payment method",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w400),
                  ),
                  minLeadingWidth: 5.w),
            ],
            crossAxisAlignment: CrossAxisAlignment.start,
          ),
        ),
      ),
    );
  }
}
