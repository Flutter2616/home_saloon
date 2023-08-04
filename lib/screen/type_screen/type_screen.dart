import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:home_saloon/screen/cart_screen/cart_controller.dart';
import 'package:home_saloon/screen/cart_screen/cart_modal.dart';
import 'package:home_saloon/screen/homescreen/home_controller.dart';
import 'package:home_saloon/screen/homescreen/home_screen.dart';
import 'package:home_saloon/screen/homescreen/service_modal.dart';
import 'package:home_saloon/utils/firebase_data.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:sizer/sizer.dart';

class Typescreen extends StatefulWidget {
  const Typescreen({super.key});

  @override
  State<Typescreen> createState() => _TypescreenState();
}

//6E4CFE
class _TypescreenState extends State<Typescreen> {
  Homecontroller controller = Get.put(Homecontroller());
  Cartcontroller cart = Get.put(Cartcontroller());
  Map m1 = Get.arguments;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          alignment: Alignment(0, 0.9),
          children: [
            CustomScrollView(
              slivers: [
                SliverAppBar(
                  leading: IconButton(
                      onPressed: () {
                        Get.back();
                      },
                      icon: Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                        size: 18.sp,
                      )),
                  floating: false,
                  expandedHeight: 25.h,
                  backgroundColor: Colors.white,
                  collapsedHeight: 10.h,
                  pinned: false,
                  elevation: 0,
                  flexibleSpace: Container(
                    height: 25.h,
                    padding: EdgeInsets.all(10),
                    alignment: Alignment.bottomLeft,
                    decoration: BoxDecoration(
                        color: Colors.black,
                        image: DecorationImage(
                          opacity: 100,
                          image: NetworkImage("${m1['img']}"),
                          fit: BoxFit.cover,
                        )),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text("For men",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w400,
                                fontSize: 10.sp)),
                        Text("${m1['name']}",
                            style: TextStyle(
                                letterSpacing: 1,
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                                fontSize: 20.sp)),
                      ],
                    ),
                  ),
                  // actions: [
                  //   Padding(
                  //     padding: const EdgeInsets.only(right: 10.0),
                  //     child: Icon(Icons.search, color: Colors.white, size: 18.sp),
                  //   ),
                  // ],
                ),
                SliverToBoxAdapter(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            contact(
                              "Call",
                              Icon(Icons.phone_enabled_outlined,
                                  size: 20.sp, color: Colors.black),
                            ),
                            const SizedBox(width: 25),
                            contact(
                              "Direction",
                              Icon(Icons.location_on_outlined,
                                  size: 20.sp, color: Colors.black),
                            ),
                            const SizedBox(width: 25),
                            contact(
                              "Share",
                              Icon(Icons.ios_share,
                                  size: 20.sp, color: Colors.black),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Divider(
                            height: 1,
                            color: Colors.grey.shade200,
                            thickness: 2),
                        const SizedBox(height: 15),
                        Row(
                          children: [
                            offer("50% off", "use code:FREE50"),
                            const SizedBox(width: 10),
                            offer(
                                "60% off on Debit Card", "No coupon required"),
                          ],
                        ),
                        const SizedBox(height: 25),
                        Divider(
                            height: 2,
                            color: Colors.grey.shade200,
                            thickness: 5),
                        const SizedBox(height: 15),
                        StreamBuilder(
                          stream:
                              Firebasedata.data.readdata(type: "${m1['name']}"),
                          builder: (context, snapshot) {
                            if (snapshot.hasError) {
                              return Center(
                                child: Text("${snapshot.hasError}"),
                              );
                            } else if (snapshot.hasData) {
                              QuerySnapshot qs = snapshot.data!;
                              print("query data:${qs}");
                              List<QueryDocumentSnapshot> querylist = qs.docs;
                              print("list lenght:${querylist.length}");
                              Map m1 = {};
                              controller.alllist.clear();
                              // controller.packagelist.clear();
                              for (var x in querylist) {
                                String id = x.id;
                                m1 = x.data() as Map;
                                Servicemodal modal = Servicemodal(
                                  name: m1['detail'],
                                  gender: m1['gender'],
                                  time: m1['time'],
                                  desc: m1['description'],
                                  price: num.parse(m1['price']),
                                  offer: m1['offer'],
                                  img: m1['img'],
                                  type: m1['type'],
                                );
                                controller.alllist.add(modal);
                              }
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 20),
                                  Text(
                                    "Recommonded(${controller.alllist.length})",
                                    style: TextStyle(
                                        fontSize: 15.sp,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black),
                                  ),
                                  const SizedBox(height: 15),
                                  controller.alllist.isEmpty
                                      ? Center(
                                          child: Text("No service available",
                                              style: TextStyle(
                                                  fontSize: 15.sp,
                                                  color: Colors.grey)),
                                        )
                                      : Column(
                                          children: controller.alllist
                                              .asMap()
                                              .entries
                                              .map((e) => product(
                                                  controller.alllist[e.key]))
                                              .toList(),
                                        ),
                                ],
                              );
                            }
                            return Center(
                              child: LoadingAnimationWidget.hexagonDots(
                                  color: Color(0xff451cf1), size: 30.sp),
                            );
                          },
                        ),
                        const SizedBox(height: 20),
                        Text(
                          "Package",
                          style: TextStyle(
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w500,
                              color: Colors.black),
                        ),
                        const SizedBox(height: 15),
                        Column(
                          children: controller.packagelist
                              .asMap()
                              .entries
                              .map(
                                  (e) => product(controller.packagelist[e.key]))
                              .toList(),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
            StreamBuilder(
              stream: Firebasedata.data.cart_Read(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(
                    child: Text("${snapshot.error}"),
                  );
                } else if (snapshot.hasData) {
                  QuerySnapshot qs = snapshot.data!;
                  // print("querydata: ${qs.docs.length}");
                  List<QueryDocumentSnapshot> querylist = qs.docs;
                  Map m1 = {};
                  cart.total_order_price.value = 0;
                  cart.cartlist.clear();
                  for (var x in querylist) {
                    String id = x.id;
                    m1 = x.data() as Map;
                    Cartmodal modal = Cartmodal(
                      type: m1['type'],
                      img: m1['img'],
                      id: id,
                      offer: m1['offer'],
                      price: m1['price'],
                      desc: m1['desc'],
                      time: m1['time'],
                      gender: m1['gender'],
                      name: m1['detail'],
                      qty: m1['qty'],
                    );
                    cart.total_order_price = (cart.total_order_price +
                        (m1['price'] * m1['qty'])) as RxInt;
                    cart.cartlist.add(modal);
                  }
                  return cart.cartlist.isEmpty
                      ? Container()
                      : Container(
                          width: 90.w,
                          alignment: Alignment.center,
                          padding: EdgeInsets.all(10),
                          height: 7.h,
                          decoration: BoxDecoration(
                              color: Color(0xff6E4CFE),
                              borderRadius: BorderRadius.circular(8.sp)),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 14, vertical: 0),
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5.sp),
                                    border: Border.all(color: Colors.white)),
                                child: Text("${cart.cartlist.length}",
                                    style: TextStyle(
                                        fontSize: 15.sp,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500)),
                              ),
                              const SizedBox(width: 10),
                              Column(crossAxisAlignment: CrossAxisAlignment.start,mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text(
                                    "\$${cart.total_order_price}",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        color: Colors.white,
                                        fontSize: 12.sp),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    "plus Taxes",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        color: Colors.white,
                                        fontSize: 10.sp),
                                  ),
                                ],
                              ),
                              Spacer(),
                              InkWell(onTap: () {
                                Get.toNamed("cart");
                              },
                                child: Text(
                                  "Continue",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      color: Colors.white,
                                      fontSize: 13.sp),
                                ),
                              ),
                            ],
                          ),
                        );
                }
                return Container();
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget product(Servicemodal alllist) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        children: [
          Container(
            // height: 10.h,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 10.h,
                  width: 10.h,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: NetworkImage("${alllist.img}"),
                          fit: BoxFit.cover),
                      borderRadius: BorderRadius.circular(5.sp)),
                ),
                const SizedBox(width: 10),
                Container(
                  width: 45.w,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize: 15.sp,
                            color: Colors.black,
                            fontWeight: FontWeight.w500),
                        "${alllist.name}",
                      ),
                      // const SizedBox(height: 10),
                      Text(
                        "\$${alllist.price}",
                        style: TextStyle(
                            fontSize: 12.sp,
                            color: Colors.grey.shade600,
                            fontWeight: FontWeight.w400),
                      ),
                      const SizedBox(height: 15),
                      Row(
                        children: [
                          Icon(Icons.av_timer,
                              color: Colors.grey.shade600, size: 15.sp),
                          Text(
                            "${alllist.time}",
                            style: TextStyle(
                                fontSize: 10.sp,
                                color: Colors.grey.shade600,
                                fontWeight: FontWeight.w400),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Spacer(),
                InkWell(
                  onTap: () {
                    Cartmodal modal = Cartmodal(
                        price: alllist.price,
                        desc: alllist.desc,
                        time: alllist.time,
                        gender: alllist.gender,
                        name: alllist.name,
                        qty: 1,
                        offer: alllist.offer,
                        img: alllist.img,
                        type: alllist.type);
                    Firebasedata.data.add_Cartdata(modal, user['uid']);
                  },
                  child: Container(
                    height: 3.5.h,
                    width: 22.w,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        border: Border.all(color: Color(0xff6E4CFE)),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                              color: Colors.grey.shade200,
                              blurRadius: 5,
                              spreadRadius: 4,
                              offset: Offset(0, 2.5))
                        ],
                        borderRadius: BorderRadius.circular(5.sp)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text("Select",
                            style: TextStyle(
                                color: Color(0xff6E4CFE), fontSize: 12.sp)),
                        Icon(
                          Icons.add,
                          size: 15.sp,
                          color: Color(0xff6E4CFE),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Divider(height: 1, color: Colors.grey.shade200, thickness: 2),
        ],
      ),
    );
  }

  Container offer(String title, String msg) {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6.sp),
          border: Border.all(color: Colors.grey.shade300, width: 1)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Image.asset("assets/icon/offer.png"),
              const SizedBox(width: 10),
              Text(
                "$title",
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                    fontSize: 15.sp),
              )
            ],
            mainAxisSize: MainAxisSize.min,
          ),
          const SizedBox(height: 5),
          Text(
            "$msg",
            style: TextStyle(color: Colors.black, fontSize: 9.sp),
          )
        ],
      ),
    );
  }

  Column contact(String title, Icon i) {
    return Column(
      children: [
        i,
        Text(
          "$title",
          style: TextStyle(
              fontSize: 11.sp,
              // fontWeight: FontWeight.w400,
              color: Colors.black),
        )
      ],
    );
  }
}
