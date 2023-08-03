import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:home_saloon/screen/cart_screen/cart_controller.dart';
import 'package:home_saloon/screen/cart_screen/cart_modal.dart';
import 'package:home_saloon/screen/homescreen/home_controller.dart';
import 'package:home_saloon/screen/homescreen/service_modal.dart';
import 'package:home_saloon/utils/firebase_data.dart';
import 'package:sizer/sizer.dart';

import '../homescreen/home_screen.dart';

class Cartscreen extends StatefulWidget {
  const Cartscreen({super.key});

  @override
  State<Cartscreen> createState() => _CartscreenState();
}

class _CartscreenState extends State<Cartscreen> {
  Cartcontroller cart = Get.put(Cartcontroller());
  Homecontroller controller = Get.put(Homecontroller());

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 5),
                InkWell(
                  onTap: () {
                    Get.back();
                  },
                  child: Icon(
                    Icons.arrow_back,
                    size: 18.sp,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  "Checkout",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w600),
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
                      cart.cartlist.clear();
                      for (var x in querylist) {
                        String id = x.id;
                        m1 = x.data() as Map;
                        Cartmodal modal = Cartmodal(
                          type: m1['type'],
                          img: m1['img'],
                          id: id,
                          offer: m1['offer'],
                          price: int.parse("${m1['price']}"),
                          desc: m1['desc'],
                          time: m1['time'],
                          gender: m1['gender'],
                          name: m1['detail'],
                          qty: int.parse("${m1['qty']}"),
                        );
                        print("price:=${m1['price']}");
                        cart.cartlist.add(modal);
                      }
                      return Column(
                          children: cart.cartlist
                              .asMap()
                              .entries
                              .map(
                                (e) => Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 5.0),
                                  child: Column(
                                    children: [
                                      Container(
                                        width: 100.w,
                                        decoration:
                                            BoxDecoration(color: Colors.white),
                                        padding:
                                            EdgeInsets.symmetric(vertical: 5),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                    cart.cartlist[e.key].type ==
                                                            "package"
                                                        ? "${cart.cartlist[e.key].type}"
                                                        : "${cart.cartlist[e.key].name}",
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontSize: 11.sp)),
                                                Container(
                                                  height: 3.5.h,
                                                  padding: EdgeInsets.all(8),
                                                  alignment: Alignment.center,
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8.sp),
                                                      border: Border.all(
                                                          color: Color(
                                                              0xff6440FE))),
                                                  child: Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      InkWell(
                                                        onTap: () {
                                                          if (cart
                                                                  .cartlist[
                                                                      e.key]
                                                                  .qty! <
                                                              2) {
                                                            Firebasedata.data
                                                                .delete_cart(
                                                                    "${cart.cartlist[e.key].id}");
                                                          } else {
                                                            Cartmodal modal = Cartmodal(
                                                                qty: (cart
                                                                        .cartlist[e
                                                                            .key]
                                                                        .qty! -
                                                                    1),
                                                                name: cart
                                                                    .cartlist[
                                                                        e.key]
                                                                    .name,
                                                                gender: cart
                                                                    .cartlist[
                                                                        e.key]
                                                                    .gender,
                                                                time: cart
                                                                    .cartlist[
                                                                        e.key]
                                                                    .time,
                                                                desc: cart
                                                                    .cartlist[
                                                                        e.key]
                                                                    .desc,
                                                                price: cart
                                                                    .cartlist[e.key]
                                                                    .price);
                                                            Firebasedata.data
                                                                .update_Cart(
                                                                    modal);
                                                          }
                                                        },
                                                        child: Icon(
                                                          Icons.remove,
                                                          size: 12.sp,
                                                          color:
                                                              Color(0xff6440FE),
                                                        ),
                                                      ),
                                                      const SizedBox(width: 5),
                                                      Text(
                                                          "${cart.cartlist[e.key].qty}",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              fontSize: 10.sp)),
                                                      const SizedBox(width: 5),
                                                      Icon(
                                                        Icons.add,
                                                        size: 12.sp,
                                                        color:
                                                            Color(0xff6440FE),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 5),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                    "\$${cart.cartlist[e.key].price}",
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontSize: 10.sp)),
                                                Text(
                                                    "\$${cart.cartlist[e.key].price! * cart.cartlist[e.key].qty!}",
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontSize: 10.sp)),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      Divider(
                                          height: 1,
                                          color: Colors.grey.shade300,
                                          thickness: 1),
                                    ],
                                  ),
                                ),
                              )
                              .toList());
                    }
                    return Center(
                      child: Container(
                        alignment: Alignment.center,
                        height: 5.h,
                        width: 70.w,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8.sp),
                          border: Border.all(color: Colors.black),
                        ),
                        child: Text("Add to cart service"),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 20),
                Divider(height: 1, color: Colors.grey.shade200, thickness: 5),
                ListTile(
                    minLeadingWidth: 5.w,
                    leading: Image.asset("assets/icon/offer.png"),
                    title: Text("Offer & Promo Code",
                        style: TextStyle(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w500,
                            color: Colors.black)),
                    trailing: Text("View Offer",
                        style: TextStyle(
                            fontSize: 10.sp,
                            fontWeight: FontWeight.w500,
                            color: Color(0xff6440FE))),
                    tileColor: Colors.white),
                Divider(height: 1, color: Colors.grey.shade200, thickness: 5),
                const SizedBox(height: 20),
                Text(
                  "Frequently added together",
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                      fontSize: 15.sp),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  height: 18.h,
                  child: ListView.builder(
                    itemBuilder: (context, index) {
                      return service(controller.alllist[index]);
                    },
                    scrollDirection: Axis.horizontal,
                    itemCount: controller.alllist.length > 3
                        ? 3
                        : controller.alllist.length,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Padding service(Servicemodal alllist) {
    return Padding(
      padding: const EdgeInsets.only(right: 15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 9.h,
            width: 9.h,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: NetworkImage("${alllist.img}"), fit: BoxFit.cover),
                borderRadius: BorderRadius.circular(5.sp)),
          ),
          Text(
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
                fontSize: 12.sp,
                color: Colors.black,
                fontWeight: FontWeight.w500),
            alllist.type == "package" ? "${alllist.type}" : "${alllist.name}",
          ),
          Text(
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
                fontSize: 10.sp,
                color: Colors.black,
                fontWeight: FontWeight.w500),
            "\$${alllist.price}",
          ),
          InkWell(
            onTap: () {
              Firebasedata.data.add_Cartdata(alllist, user['uid']);
            },
            child: Container(
              height: 3.h,
              width: 20.w,
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
                      style:
                          TextStyle(color: Color(0xff6E4CFE), fontSize: 10.sp)),
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
    );
  }
}
