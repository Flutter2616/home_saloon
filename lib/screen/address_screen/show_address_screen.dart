import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:home_saloon/screen/address_screen/address_controller.dart';
import 'package:home_saloon/screen/address_screen/address_modal.dart';
import 'package:home_saloon/screen/cart_screen/cart_controller.dart';
import 'package:home_saloon/screen/cart_screen/cart_modal.dart';
import 'package:home_saloon/utils/firebase_data.dart';
import 'package:home_saloon/utils/razorpay_class.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:sizer/sizer.dart';

class ShowAddress extends StatefulWidget {
  const ShowAddress({super.key});

  @override
  State<ShowAddress> createState() => _ShowAddressState();
}

class _ShowAddressState extends State<ShowAddress> {
  Addresscontroller address = Get.put(Addresscontroller());
  Cartcontroller cart = Get.put(Cartcontroller());
  String status = Get.arguments;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                InkWell(
                    onTap: () {
                      Get.back();
                    },
                    child: Icon(Icons.close, color: Colors.black, size: 18.sp)),
                const SizedBox(height: 10),
                Text(
                  "Your saved Addresses",
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                      fontSize: 15.sp),
                ),
                const SizedBox(height: 15),
                StreamBuilder(
                  stream: Firebasedata.data.read_address(),
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
                      address.addresslist.clear();
                      for (var x in querylist) {
                        String id = x.id;
                        m1 = x.data() as Map;
                        Addressmodal modal = Addressmodal(
                          first: m1['first name'],
                          id: id,
                          last: m1['last name'],
                          city: m1['city'],
                          state: m1['state'],
                          house: m1['house flat no'],
                          number: m1['phone number'],
                          pincode: m1['pincode'],
                          residency: m1['residency name'],
                        );
                        address.addresslist.add(modal);
                      }
                      return Column(
                        children: address.addresslist
                            .asMap()
                            .entries
                            .map((e) => view_address(e.key))
                            .toList(),);

                    }
                    return LoadingAnimationWidget.hexagonDots(
                        color: Color(0xff451cf1), size: 30.sp);
                  },
                ),
                const SizedBox(height: 15),
                ListTile(
                    onTap: () {
                      Get.toNamed("newaddress",
                          arguments: {"status": 0, "index": null});
                    },
                    leading: Icon(Icons.add, color: Colors.black, size: 15.sp),
                    title: Text(
                      "Add New Address",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w400),
                    ),
                    minLeadingWidth: 5.w),
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
                                PaymentHelper.payment.setPayment(cart.total_order_price.value.toDouble());
                              },
                              child: Text(
                                "Payment",
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

  Padding view_address(int index) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            minLeadingWidth: 5.w,
            trailing: Visibility(
              visible: status == "select" ? true : false,
              child: Obx(
                () => Radio(
                  activeColor: Color(0xff6E4CFE),
                  value: "${address.addresslist[index].id}",
                  groupValue: cart.selectaddress.value,
                  onChanged: (value) {
                    cart.selectaddress.value = value!;
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
                          address: {
                            "name":
                                "${address.addresslist[index].first} ${address.addresslist[index].first}",
                            "phonenumber":
                                "${address.addresslist[index].number}",
                            "pincode": "${address.addresslist[index].pincode}",
                            "address":
                                "${address.addresslist[index].house},${address.addresslist[index].residency},${address.addresslist[index].city},${address.addresslist[index].state}"
                          });
                      Firebasedata.data.update_Cart(modal);
                    }
                  },
                ),
              ),
            ),
            leading: CircleAvatar(
                backgroundColor: Colors.grey.shade400,
                radius: 10.sp,
                child: Icon(
                  Icons.home_outlined,
                  size: 15.sp,
                  color: Colors.black,
                )),
            title: Text(
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                "${address.addresslist[index].first} ${address.addresslist[index].last}",
                style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w500,
                    color: Colors.black)),
            subtitle: Text(
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                "${address.addresslist[index].pincode},${address.addresslist[index].house},${address.addresslist[index].residency},${address.addresslist[index].city},${address.addresslist[index].state}",
                style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w400,
                    color: Colors.grey.shade400)),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              InkWell(
                onTap: () {
                  Firebasedata.data
                      .delete_Address("${address.addresslist[index].id}");
                },
                child: Text("Delete",
                    style:
                        TextStyle(fontSize: 12.sp, color: Color(0xff6E4CFE))),
              ),
              InkWell(
                onTap: () {
                  Get.toNamed("newaddress",
                      arguments: {"status": 1, "index": index});
                },
                child: Text("Edit",
                    style:
                        TextStyle(fontSize: 12.sp, color: Color(0xff6E4CFE))),
              ),
            ],
          ),
          const SizedBox(height: 5),
          Image.asset("assets/icon/Line.png",
              width: 100.w, fit: BoxFit.fitWidth),
        ],
      ),
    );
  }
}
