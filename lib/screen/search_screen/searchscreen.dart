import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:home_saloon/screen/cart_screen/cart_modal.dart';
import 'package:home_saloon/screen/homescreen/home_screen.dart';
import 'package:home_saloon/screen/homescreen/service_modal.dart';
import 'package:home_saloon/screen/search_screen/searchcontroller.dart';
import 'package:home_saloon/utils/firebase_data.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:sizer/sizer.dart';

class Searchscreen extends StatefulWidget {
  const Searchscreen({super.key});

  @override
  State<Searchscreen> createState() => _SearchscreenState();
}

class _SearchscreenState extends State<Searchscreen> {
  TextEditingController txtsearch = TextEditingController();
  Searchcontroller search = Get.put(Searchcontroller());

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 10),
              TextField(
                  controller: txtsearch,
                  onChanged: (value) {
                    search.searchtext.value = value;
                  },
                  style: TextStyle(
                      fontSize: 13.sp,
                      color: Colors.black,
                      fontWeight: FontWeight.w400),
                  cursorColor: Color(0xff6E4CFE),
                  // controller: txtsearch,
                  decoration: InputDecoration(
                      hintText: "Search service",
                      hintStyle: TextStyle(
                          letterSpacing: 1,
                          color: Colors.grey.shade500,
                          fontWeight: FontWeight.w400,
                          fontSize: 13.sp),
                      border: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey)),
                      focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Color(0xff6E4CFE))),
                      prefixIcon: Icon(
                        Icons.search,
                        size: 15.sp,
                        color: Color(0xff6E4CFE),
                      ))),
              StreamBuilder(
                stream: Firebasedata.data.readdata(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    Center(child: Text("${snapshot.error}"));
                  } else if (snapshot.hasData) {
                    QuerySnapshot qs = snapshot.data!;
                    List<QueryDocumentSnapshot> query = qs.docs;
                    Map m1 = {};
                    search.servicelist.clear();

                    for (var x in query) {
                      String id = x.id;
                      m1 = x.data() as Map;
                      Servicemodal modal = Servicemodal(
                        name: m1['detail'],
                        gender: m1['gender'],
                        time: m1['time'],
                        desc: m1['description'],
                        price: int.parse(m1['price']),
                        offer: m1['offer'],
                        img: m1['img'],
                        type: m1['type'],
                      );
                      search.servicelist.add(modal);
                    }
                    search.filterlist.clear();
                    if (txtsearch.text.isEmpty) {
                      search.filterlist.clear();
                    } else {
                      print("not empty");
                      for (var x in search.servicelist) {
                        if (txtsearch.text.toLowerCase() ==
                                x.name!.toLowerCase() ||
                            txtsearch.text.toLowerCase() ==
                                x.type!.toLowerCase()) {
                          search.filterlist.add(x);
                          print("filterlist:===${search.filterlist.length}");
                        }
                      }
                    }

                    return search.filterlist.isNotEmpty
                        ? Expanded(
                            child: Obx(
                            () => ListView.builder(
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8.0),
                                  child: Column(
                                    children: [
                                      Container(
                                        // height: 10.h,
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              height: 10.h,
                                              width: 10.h,
                                              decoration: BoxDecoration(
                                                  image: DecorationImage(
                                                      image: NetworkImage(
                                                          "${search.filterlist[index].img}"),
                                                      fit: BoxFit.cover),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          5.sp)),
                                            ),
                                            const SizedBox(width: 10),
                                            Container(
                                              width: 45.w,
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceAround,
                                                children: [
                                                  Text(
                                                    maxLines: 2,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                        fontSize: 15.sp,
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.w500),
                                                    "${search.filterlist[index].name}",
                                                  ),
                                                  // const SizedBox(height: 10),
                                                  Text(
                                                    "\$${search.filterlist[index].price}",
                                                    style: TextStyle(
                                                        fontSize: 12.sp,
                                                        color: Colors
                                                            .grey.shade600,
                                                        fontWeight:
                                                            FontWeight.w400),
                                                  ),
                                                  const SizedBox(height: 15),
                                                  Row(
                                                    children: [
                                                      Icon(Icons.av_timer,
                                                          color: Colors
                                                              .grey.shade600,
                                                          size: 15.sp),
                                                      Text(
                                                        "${search.filterlist[index].time}",
                                                        style: TextStyle(
                                                            fontSize: 10.sp,
                                                            color: Colors
                                                                .grey.shade600,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w400),
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
                                                    price: search
                                                        .filterlist[index]
                                                        .price,
                                                    desc: search
                                                        .filterlist[index].desc,
                                                    time: search
                                                        .filterlist[index].time,
                                                    gender: search
                                                        .filterlist[index]
                                                        .gender,
                                                    name: search
                                                        .filterlist[index].name,
                                                    qty: 1,
                                                    offer: search
                                                        .filterlist[index]
                                                        .offer,
                                                    img: search
                                                        .filterlist[index].img,
                                                    type: search
                                                        .filterlist[index]
                                                        .type);
                                                Firebasedata.data.add_Cartdata(
                                                    modal, user['uid']);
                                              },
                                              child: Container(
                                                height: 3.5.h,
                                                width: 22.w,
                                                alignment: Alignment.center,
                                                decoration: BoxDecoration(
                                                    border: Border.all(
                                                        color:
                                                            Color(0xff6E4CFE)),
                                                    color: Colors.white,
                                                    boxShadow: [
                                                      BoxShadow(
                                                          color: Colors
                                                              .grey.shade200,
                                                          blurRadius: 5,
                                                          spreadRadius: 4,
                                                          offset:
                                                              Offset(0, 2.5))
                                                    ],
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5.sp)),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceEvenly,
                                                  children: [
                                                    Text("Select",
                                                        style: TextStyle(
                                                            color: Color(
                                                                0xff6E4CFE),
                                                            fontSize: 12.sp)),
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
                                      Divider(
                                          height: 1,
                                          color: Colors.grey.shade200,
                                          thickness: 2),
                                    ],
                                  ),
                                );
                              },
                              itemCount: search.filterlist.length,
                            ),
                          ))
                        : Container();
                  }
                  return LoadingAnimationWidget.hexagonDots(
                      color: Color(0xff451cf1), size: 30.sp);
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
//0xff6E4CFE
