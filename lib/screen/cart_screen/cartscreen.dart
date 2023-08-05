import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:home_saloon/screen/cart_screen/cart_controller.dart';
import 'package:home_saloon/screen/cart_screen/cart_modal.dart';
import 'package:home_saloon/screen/homescreen/home_controller.dart';
import 'package:home_saloon/screen/homescreen/service_modal.dart';
import 'package:home_saloon/utils/firebase_data.dart';
import 'package:home_saloon/utils/razorpay_class.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
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
                const SizedBox(height: 10),
                InkWell(
                  onTap: () {
                    Get.back();
                  },
                  child: Icon(
                    Icons.arrow_back,
                    size: 20.sp,
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
                const SizedBox(height: 20),
                Image.asset("assets/icon/Line.png",
                    width: 100.w, fit: BoxFit.fitWidth),
                const SizedBox(height: 10),
                ListTile(
                  minLeadingWidth: 5.w,
                  onTap: () {
                    Get.dialog(
                      barrierDismissible: true,
                      AlertDialog(
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SizedBox(
                                height: 22.h,
                                width: 100.w,
                                child: GridView.builder(
                                  physics: NeverScrollableScrollPhysics(),
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 2,
                                          mainAxisExtent: 4.5.h,
                                          crossAxisSpacing: 8,
                                          mainAxisSpacing: 8),
                                  itemBuilder: (context, index) {
                                    return InkWell(
                                      onTap: () {
                                        cart.selecttime.value =
                                            cart.timelist[index];
                                      },
                                      child: Obx(
                                        () => Container(
                                          width: cart.timelist[index] ==
                                                  cart.selecttime.value
                                              ? 42.w
                                              : 40.w,
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              border: Border.all(
                                                  color: cart.timelist[index] ==
                                                          cart.selecttime.value
                                                      ? Color(0xff6E4CFE)
                                                      : Colors.black),
                                              borderRadius:
                                                  BorderRadius.circular(8.sp)),
                                          child: Text("${cart.timelist[index]}",
                                              style: TextStyle(
                                                  color: cart.timelist[index] ==
                                                          cart.selecttime.value
                                                      ? Color(0xff6E4CFE)
                                                      : Colors.black,
                                                  fontSize:
                                                      cart.timelist[index] ==
                                                              cart.selecttime
                                                                  .value
                                                          ? 12.sp
                                                          : 10.sp)),
                                        ),
                                      ),
                                    );
                                  },
                                  itemCount: cart.timelist.length,
                                ),
                              ),
                            ],
                          ),
                          title: Text(
                            "When would you like your service",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w500),
                          )),
                    );
                  },
                  title: Text(
                    "Select Time",
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                        fontSize: 12.sp),
                  ),
                  leading: Icon(Icons.watch_later_outlined,
                      color: Colors.black, size: 18.sp),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Obx(
                        () => Text("${cart.selecttime.value}",
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 12.sp,
                              color: Colors.black,
                            )),
                      ),
                      SizedBox(width: 10),
                      Icon(Icons.arrow_forward_ios,
                          color: Color(0xff6E4CFE), size: 15.sp),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Image.asset("assets/icon/Line.png",
                    width: 100.w, fit: BoxFit.fitWidth),
                const SizedBox(height: 20),
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
                          ? Center(
                              child: InkWell(
                                onTap: () {
                                  Get.offAllNamed("home");
                                },
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
                              ),
                            )
                          : Column(
                              children: cart.cartlist
                                  .asMap()
                                  .entries
                                  .map(
                                    (e) => Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 5.0),
                                      child: Column(
                                        children: [
                                          Container(
                                            width: 100.w,
                                            decoration: BoxDecoration(
                                                color: Colors.white),
                                            padding: EdgeInsets.symmetric(
                                                vertical: 5),
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
                                                        cart.cartlist[e.key]
                                                                    .type ==
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
                                                      padding:
                                                          EdgeInsets.all(8),
                                                      alignment:
                                                          Alignment.center,
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
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
                                                              if (cart.cartlist[e.key].qty! <
                                                                  2) {
                                                                Firebasedata
                                                                    .data
                                                                    .delete_cart(
                                                                        "${cart.cartlist[e.key].id}");
                                                              } else {
                                                                Cartmodal
                                                                    modal =
                                                                    Cartmodal(
                                                                  qty: (cart
                                                                          .cartlist[
                                                                              e.key]
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
                                                                      .cartlist[
                                                                          e.key]
                                                                      .price,
                                                                  id: cart
                                                                      .cartlist[
                                                                          e.key]
                                                                      .id,
                                                                  type: cart
                                                                      .cartlist[
                                                                          e.key]
                                                                      .type,
                                                                  img: cart
                                                                      .cartlist[
                                                                          e.key]
                                                                      .img,
                                                                  offer: cart
                                                                      .cartlist[
                                                                          e.key]
                                                                      .offer,
                                                                );
                                                                Firebasedata
                                                                    .data
                                                                    .update_Cart(
                                                                        modal);
                                                              }
                                                            },
                                                            child: Icon(
                                                              Icons.remove,
                                                              size: 12.sp,
                                                              color: Color(
                                                                  0xff6440FE),
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                              width: 5),
                                                          Text(
                                                              "${cart.cartlist[e.key].qty}",
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .black,
                                                                  fontSize:
                                                                      10.sp)),
                                                          const SizedBox(
                                                              width: 5),
                                                          InkWell(
                                                            onTap: () {
                                                              Cartmodal modal =
                                                                  Cartmodal(
                                                                qty: (cart
                                                                        .cartlist[
                                                                            e.key]
                                                                        .qty! +
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
                                                                    .cartlist[
                                                                        e.key]
                                                                    .price,
                                                                id: cart
                                                                    .cartlist[
                                                                        e.key]
                                                                    .id,
                                                                type: cart
                                                                    .cartlist[
                                                                        e.key]
                                                                    .type,
                                                                img: cart
                                                                    .cartlist[
                                                                        e.key]
                                                                    .img,
                                                                offer: cart
                                                                    .cartlist[
                                                                        e.key]
                                                                    .offer,
                                                              );
                                                              Firebasedata.data
                                                                  .update_Cart(
                                                                      modal);
                                                            },
                                                            child: Icon(
                                                              Icons.add,
                                                              size: 12.sp,
                                                              color: Color(
                                                                  0xff6440FE),
                                                            ),
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
                      child: InkWell(
                        onTap: () {
                          Get.offAllNamed("home");
                        },
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
                StreamBuilder(
                  stream: Firebasedata.data.readdata(),
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
                      controller.alllist.clear();
                      for (var x in querylist) {
                        String id = x.id;
                        m1 = x.data() as Map;
                        Servicemodal modal = Servicemodal(
                          type: m1['type'],
                          img: m1['img'],
                          offer: m1['offer'],
                          price: num.parse(m1['price']),
                          desc: m1['desc'],
                          time: m1['time'],
                          gender: m1['gender'],
                          name: m1['detail'],
                        );
                        controller.alllist.add(modal);
                      }
                      return SizedBox(
                        height: 18.h,
                        child: ListView.builder(
                          itemBuilder: (context, index) {
                            return service(controller.alllist[index]);
                          },
                          scrollDirection: Axis.horizontal,
                          itemCount: controller.alllist.length > 5
                              ? 5
                              : controller.alllist.length,
                        ),
                      );
                    }
                    return Center(
                      child: LoadingAnimationWidget.hexagonDots(
                          color: Color(0xff451cf1), size: 30.sp),
                    );
                  },
                ),
                const SizedBox(height: 20),
                Divider(height: 1, color: Colors.grey.shade200, thickness: 5),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("item total",
                        style: TextStyle(
                            fontSize: 10.sp,
                            fontWeight: FontWeight.w400,
                            color: Colors.black)),
                    Text("\$${cart.total_order_price.value}",
                        style: TextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w400,
                            color: Colors.black)),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Coupan Discount",
                        style: TextStyle(
                            fontSize: 10.sp,
                            fontWeight: FontWeight.w400,
                            color: Colors.black)),
                    Text("-\$0",
                        style: TextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w500,
                            color: Colors.green.shade700)),
                  ],
                ),
                const SizedBox(height: 10),
                Divider(height: 1, color: Colors.grey.shade200, thickness: 1),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Amount Payable",
                        style: TextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w600,
                            color: Colors.black)),
                    Text("\$${cart.total_order_price}",
                        style: TextStyle(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w600,
                            color: Colors.black)),
                  ],
                ),
                const SizedBox(height: 20),
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
                              width: 100.w,
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
                                        borderRadius:
                                            BorderRadius.circular(5.sp),
                                        border:
                                            Border.all(color: Colors.white)),
                                    child: Text("${cart.cartlist.length}",
                                        style: TextStyle(
                                            fontSize: 15.sp,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w500)),
                                  ),
                                  const SizedBox(width: 10),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
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
                                  InkWell(
                                    onTap: () {
                                      for (var x in cart.cartlist) {
                                        Cartmodal modal = Cartmodal(
                                          offer: x.offer,
                                          img: x.img,
                                          type: x.type,
                                          id: x.id,
                                          qty: x.qty,
                                          name: x.name,
                                          gender: x.gender,
                                          time: x.time,
                                          price: x.price,
                                          desc: x.desc,
                                          servicetime: cart.selecttime.value,
                                        );
                                        Firebasedata.data.update_Cart(modal);
                                      }
                                      PaymentHelper.payment.setPayment(cart.total_order_price.value.toDouble());
                                    },
                                    child: Text(
                                      "Order",
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
