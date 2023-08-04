import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:home_saloon/screen/cart_screen/cart_modal.dart';
import 'package:home_saloon/screen/homescreen/home_controller.dart';
import 'package:home_saloon/screen/homescreen/service_modal.dart';
import 'package:home_saloon/utils/firebase_data.dart';
import 'package:home_saloon/utils/firebase_helper.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:sizer/sizer.dart';

Map user = {};

class Homescreen extends StatefulWidget {
  const Homescreen({super.key});

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  TextEditingController txtsearch = TextEditingController();
  Homecontroller controller = Get.put(Homecontroller());

//6E4CFE
  @override
  void initState() {
    super.initState();
    user = Firebasehelper.helper.userdetail();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: StreamBuilder(
          stream: Firebasedata.data.readdata(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text("${snapshot.error}");
            } else if (snapshot.hasData) {
              QuerySnapshot qs = snapshot.data!;
              List<QueryDocumentSnapshot> querylist = qs.docs;
              Map m1 = {};
              controller.alllist.clear();
              controller.packagelist.clear();
              controller.offerlist.clear();
              for (var x in querylist) {
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
                if (m1['type'] == 'package') {
                  controller.packagelist.add(modal);
                }
                if (m1['offer'] != null) {
                  controller.offerlist.add(modal);
                }
                controller.alllist.add(modal);
              }
              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Row(
                        children: [
                          InkWell(onTap: () {
                            Get.toNamed("dash");
                          },
                            child: CircleAvatar(
                                radius: 15.sp,
                                backgroundImage:
                                    AssetImage("assets/intro/bg1.png")),
                          ),
                          const SizedBox(width: 5),
                          Text(
                            "Surat ,india",
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w500,
                                fontSize: 15.sp),
                          ),
                          const SizedBox(width: 5),
                          Icon(Icons.keyboard_arrow_down_outlined,
                              color: Colors.black, size: 15.sp),
                          Spacer(),
                          IconButton(
                              onPressed: () {
                                Get.toNamed("cart");
                              },
                              icon: Icon(Icons.shopping_cart_outlined,
                                  color: Colors.black, size: 20.sp)),
                        ],
                      ),
                    ),
                    const SizedBox(height: 15),
                    Container(
                      height: 5.h,
                      margin: EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.sp),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.grey.shade300,
                                blurRadius: 5,
                                spreadRadius: 3,
                                offset: Offset(0, 3))
                          ],
                          color: Colors.white),
                      padding: EdgeInsets.all(5),
                      alignment: Alignment.bottomCenter,
                      child: TextField(
                          style: TextStyle(
                              fontSize: 13.sp,
                              color: Colors.black,
                              fontWeight: FontWeight.w400),
                          cursorColor: Color(0xff6E4CFE),
                          controller: txtsearch,
                          decoration: InputDecoration(
                              hintText: "Search service",
                              hintStyle: TextStyle(
                                  letterSpacing: 1,
                                  color: Colors.grey.shade500,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 13.sp),
                              border: InputBorder.none,
                              prefixIcon: Icon(
                                Icons.search,
                                size: 15.sp,
                                color: Color(0xff6E4CFE),
                              ))),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15.0),
                      child: Column(
                        children: [
                          const SizedBox(height: 15),
                          title("Beauty services"),
                          const SizedBox(height: 15),
                          SizedBox(
                            height: 30.h,
                            child: GridView(
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 3,
                                      crossAxisSpacing: 5,
                                      mainAxisSpacing: 5),
                              children: [
                                servicetype("Haircut",
                                    "https://www.bonneviesalon.com/wp-content/uploads/2020/10/Mens-Haircuts-Orlando.jpg"),
                                servicetype("Facecare",
                                    "https://www.rd.com/wp-content/uploads/2017/04/ft-Grooming-Treatments-Every-Man-Should-Be-Getting.jpg"),
                                servicetype("Shaving",
                                    "https://img.freepik.com/premium-photo/young-man-shaving-with-straight-edge-razor-by-hairdresser-barbershop_359687-547.jpg"),
                                servicetype("Massage",
                                    "https://www.evobee.com/uploads/products/image/d8877e901460e116efee7b568f0d5580.jpg"),
                                servicetype("Haircare",
                                    "https://www.refinesalons.com/wp-content/uploads/2021/12/scalp-treatment-1.jpg"),
                                servicetype("Haircolor",
                                    "https://www.bonneviesalon.com/wp-content/uploads/2020/10/Mens-Haircuts-Orlando.jpg"),
                              ],
                              physics: NeverScrollableScrollPhysics(),
                            ),
                          ),
                          title("Popular Package for you"),
                          const SizedBox(height: 15),
                          SizedBox(
                            height: 35.h,
                            child: ListView.builder(
                              physics: BouncingScrollPhysics(),
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (context, index) {
                                return service(controller.packagelist[index],null);
                              },
                              itemCount: controller.packagelist.length,
                            ),
                          ),
                          title("Best Offers"),
                          const SizedBox(height: 15),
                          SizedBox(
                            height: 35.h,
                            child: ListView.builder(
                              physics: BouncingScrollPhysics(),
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (context, index) {
                                return service(controller.offerlist[index],controller.offerlist[index].offer);
                              },
                              itemCount: controller.offerlist.length,
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              );
            }
            return Center(
              child: LoadingAnimationWidget.hexagonDots(
                  color: Color(0xff451cf1), size: 30.sp),
            );
          },
        ),
      ),
    );
  }

  Padding service(Servicemodal modal,String? offer) {
    return Padding(
      padding: const EdgeInsets.only(right: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
              width: 80.w,
              height: 18.h,
              padding: EdgeInsets.all(10),
              alignment: Alignment.bottomLeft,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: NetworkImage("${modal.img}"),
                      fit: BoxFit.cover,
                      opacity: 100),
                  borderRadius: BorderRadius.circular(10.sp),
                  color: Colors.black),
              child: offer != null
                  ? Container(height: 4.h,
                      padding: EdgeInsets.all(5),
                      // alignment: Alignment.center,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8.sp)),
                      child: Row(mainAxisSize: MainAxisSize.min,
                        children: [
                          Image.asset("assets/icon/offer.png"),
                          const SizedBox(width: 5),
                          Text("${offer}",
                              style: TextStyle(
                                  color: Color(0xff6E4CFE),
                                  fontWeight: FontWeight.w400,
                                  fontSize: 10.sp)),
                        ],
                      ),
                    )
                  : Container()),
          const SizedBox(height: 5),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("FOR MEN",
                      style: TextStyle(
                          color: Colors.grey.shade500,
                          fontWeight: FontWeight.w500,
                          fontSize: 10.sp)),
                  const SizedBox(height: 5),
                  Text("\$${modal.price}",
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                          fontSize: 15.sp)),
                  const SizedBox(height: 5),
                  Container(
                    width: 60.w,
                    child: Text("${modal.name}",
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            color: Colors.grey.shade500,
                            fontWeight: FontWeight.w500,
                            fontSize: 12.sp)),
                  ),
                  const SizedBox(height: 5),
                  Text("Durationtime ${modal.time}",
                      style: TextStyle(
                          color: Colors.grey.shade500,
                          fontWeight: FontWeight.w500,
                          fontSize: 12.sp)),
                ],
              ),
              InkWell(
                onTap: () {
                  Cartmodal cart = Cartmodal(
                      price: modal.price,
                      desc: modal.desc,
                      time: modal.time,
                      gender: modal.gender,
                      name: modal.name,
                      qty: 1,
                      offer: modal.offer,
                      img: modal.img,
                      type: modal.type);
                  Firebasedata.data.add_Cartdata(cart, user['uid']);
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
          )
        ],
      ),
    );
  }

  Row title(String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "$title",
          style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 16.sp,
              color: Colors.black),
        ),
        Text(
          "see all",
          style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 12.sp,
              color: Color(0xff6E4CFE)),
        )
      ],
    );
  }

  Widget servicetype(String name, String img) {
    return InkWell(
      onTap: () {
        Get.toNamed("type", arguments: {'name': name, "img": img});
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 30.sp,
            backgroundColor: Colors.grey,
            backgroundImage: NetworkImage("$img"),
          ),
          const SizedBox(height: 10),
          Text(
            "$name",
            style: TextStyle(),
          )
        ],
      ),
    );
  }
}
