import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:home_saloon/screen/booking_screen/book_controller.dart';
import 'package:home_saloon/screen/cart_screen/cart_modal.dart';
import 'package:home_saloon/screen/homescreen/home_screen.dart';
import 'package:home_saloon/utils/firebase_data.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:sizer/sizer.dart';

class ViewBookingScreen extends StatefulWidget {
  const ViewBookingScreen({super.key});

  @override
  State<ViewBookingScreen> createState() => _ViewBookingScreenState();
}

class _ViewBookingScreenState extends State<ViewBookingScreen> {
  Bookcontroller book = Get.put(Bookcontroller());

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => StreamBuilder(
        stream:
            Firebasedata.data.buy_read("${user['uid']}", "${book.tab.value}"),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text("${snapshot.error}"),
            );
          } else if (snapshot.hasData) {
            QuerySnapshot qs = snapshot.data!;
            // print("snapshot:===${snapshot.data}");
            List<QueryDocumentSnapshot> query = qs.docs;
            // print("query:===${query.length}");
            book.orderlist.clear();
            Map m1 = {};
            for (var x in query) {
              String? id = x.id;
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
                  servicetime: m1['servicetime'],
                  status: m1['status'],
                  address: m1['address']);
              book.orderlist.add(modal);
            }
            // print("orderlist:===${book.orderlist.length}");
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: ListView.builder(
                  itemBuilder: (context, index) {
                    return Container(
                      margin: EdgeInsets.symmetric(vertical: 8),
                      height: 20.h,
                      padding: EdgeInsets.all(10),
                      // color: Colors.white,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("${book.orderlist[index].name}",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 15.sp,
                                  fontWeight: FontWeight.w500)),
                          const SizedBox(height: 5),
                          Row(
                            children: [
                              Text(
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  "\$${book.orderlist[index].price}*${book.orderlist[index].qty}",
                                  style: TextStyle(
                                      color: Colors.grey, fontSize: 10.sp)),
                              const SizedBox(width: 15),
                              Text("|",
                                  style: TextStyle(
                                      color: Colors.grey, fontSize: 10.sp)),
                              const SizedBox(width: 15),
                              Text("Service time:${book.orderlist[index].time}",
                                  style: TextStyle(
                                      color: Colors.grey, fontSize: 10.sp)),
                            ],
                          ),
                          const SizedBox(height: 5),
                          Text("Gender:${book.orderlist[index].gender}",
                              style: TextStyle(
                                  color: Colors.grey, fontSize: 10.sp)),
                          const SizedBox(height: 5),
                          Text("Status:${book.orderlist[index].status}",
                              style: TextStyle(
                                  color: Colors.grey, fontSize: 10.sp)),
                          const SizedBox(height: 5),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              InkWell(
                                onTap: () {
                                  if (book.orderlist[index].status ==
                                      'pending') {
                                    Firebasedata.data.delete_buy(
                                        "${user['uid']}",
                                        "${book.orderlist[index].id}");
                                  } else {}
                                },
                                child: Container(
                                  height: 4.h,
                                  width: 30.w,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8.sp),
                                      border: Border.all(
                                          color: book.orderlist[index].status ==
                                                  'pending'
                                              ? Colors.red.shade700
                                              : Color(0xff6E4CFE))),
                                  child: Text(
                                      book.orderlist[index].status == 'pending'
                                          ? "Cancel Order"
                                          : "Reorder Booking",
                                      style: TextStyle(
                                          color: book.orderlist[index].status ==
                                                  'pending'
                                              ? Colors.red.shade700
                                              : Color(0xff6E4CFE),
                                          fontSize: 10.sp)),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                  itemCount: book.orderlist.length),
            );
          }
          return Center(
            child: LoadingAnimationWidget.hexagonDots(
                color: Color(0xff451cf1), size: 30.sp),
          );
        },
      ),
    );
  }
}
//0xff6E4CFE
