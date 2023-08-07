import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:home_saloon/screen/cart_screen/cart_controller.dart';
import 'package:home_saloon/screen/cart_screen/cart_modal.dart';
import 'package:home_saloon/screen/homescreen/home_controller.dart';
import 'package:home_saloon/screen/homescreen/service_modal.dart';
import 'package:home_saloon/screen/map_screen/map_controller.dart';
import 'package:home_saloon/screen/homescreen/setting_controller.dart';
import 'package:home_saloon/utils/firebase_data.dart';
import 'package:home_saloon/utils/firebase_helper.dart';
import 'package:image_picker/image_picker.dart';
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
  Mapcontroller map = Get.put(Mapcontroller());
  Cartcontroller cart = Get.put(Cartcontroller());
  GlobalKey<ScaffoldState> key = GlobalKey();
  Settingcontroller setting = Get.put(Settingcontroller());

//6E4CFE
  @override
  void initState() {
    super.initState();
    user = Firebasehelper.helper.userdetail();
    getlocation();
  }

  Future<void> getlocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    map.lat.value = position.latitude;
    map.log.value = position.longitude;
    map.placemark.clear();
    List<Placemark> placemark =
        await placemarkFromCoordinates(map.lat.value, map.log.value);
    map.placemark.value = placemark;
    map.place.value = map.placemark[0];

    print("===================== ${map.place}");
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        drawer: Drawer(
          width: 65.w,
          child: Column(
            children: [
              // const SizedBox(height: 10),
              Container(
                alignment: Alignment.center,
                height: 9.h,
                padding: EdgeInsets.symmetric(horizontal: 15),
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border(
                        bottom:
                            BorderSide(color: Colors.grey.shade200, width: 2))),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: () async {
                        ImagePicker pickimage = ImagePicker();
                        XFile? image = await pickimage.pickImage(
                            source: ImageSource.gallery);
                        setting.path.value = image!.path;
                      },
                      child: Obx(
                        () => CircleAvatar(
                            radius: 15.sp,
                            backgroundImage:
                                FileImage(File("${setting.path.value}"))),
                      ),
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
                    Icon(Icons.favorite_border,
                        color: Colors.black, size: 15.sp),
                    "Your favorite",
                    "Recorder your favorite service in a click"),
              ),
              InkWell(
                onTap: () {
                  Get.toNamed("payment");
                },
                child: tile(
                    Icon(Icons.payment, color: Colors.black, size: 15.sp),
                    "Payment",
                    "Payment methods, Transaction History"),
              ),
              InkWell(
                onTap: () {
                  Get.toNamed("showaddress", arguments: "save");
                },
                child: tile(
                    Icon(Icons.note_alt_outlined,
                        color: Colors.black, size: 15.sp),
                    "Manage Address",
                    ""),
              ),
              InkWell(
                onTap: () {
                  Get.toNamed("book");
                },
                child: tile(Icon(Icons.list, color: Colors.black, size: 15.sp),
                    "Your Booking", "View your past and upcoming booking"),
              ),
              tile(
                  Icon(Icons.notifications_outlined,
                      color: Colors.black, size: 15.sp),
                  "Notification",
                  "View your past notification"),
              tile(
                  Icon(Icons.work_outline, color: Colors.black, size: 15.sp),
                  "Register as partner",
                  "Want to list your service? Register with us"),
              tile(Icon(Icons.error_outline, color: Colors.black, size: 15.sp),
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
                              InkWell(
                                onTap: () {
                                  Get.back();
                                },
                                child: Icon(Icons.close,
                                    size: 15.sp,
                                    color: Colors.black,
                                    weight: 100),
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
                              InkWell(
                                onTap: () {
                                  Get.back();
                                },
                                child: Container(
                                  height: 5.h,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8.sp),
                                      color: Colors.white,
                                      border:
                                          Border.all(color: Color(0xff6E4CFE))),
                                  width: 35.w,
                                  alignment: Alignment.center,
                                  child: Text("Cancel",
                                      style: TextStyle(
                                          color: Color(0xff6E4CFE),
                                          fontSize: 12.sp)),
                                ),
                              ),
                              const SizedBox(width: 10),
                              InkWell(
                                onTap: () {
                                  Firebasehelper.helper.logout();
                                },
                                child: Container(
                                  height: 5.h,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8.sp),
                                    color: Colors.red.shade600,
                                  ),
                                  width: 45.w,
                                  alignment: Alignment.center,
                                  child: Text("Logout",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 12.sp,
                                          fontWeight: FontWeight.w500)),
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
          ),
        ),
        key: key,
        body: Stack(
          alignment: Alignment(0, 0.9),
          children: [
            StreamBuilder(
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
                              InkWell(
                                onTap: () {
                                  // Get.toNamed("setting");
                                  key.currentState!.openDrawer();
                                },
                                child: CircleAvatar(
                                    radius: 15.sp,
                                    backgroundImage:
                                        AssetImage("assets/intro/bg1.png")),
                              ),
                              const SizedBox(width: 5),
                              InkWell(
                                onTap: () {
                                  Get.toNamed("map");
                                },
                                child: Row(
                                  children: [
                                    Obx(
                                      () => Container(
                                        width: 35.w,
                                        child: Text(
                                          "${map.place.value.locality},${map.place.value.country}",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.w500,
                                              fontSize: 15.sp),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 5),
                                    Icon(Icons.keyboard_arrow_down_outlined,
                                        color: Colors.black, size: 15.sp),
                                  ],
                                ),
                              ),
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
                                    return service(
                                        controller.packagelist[index], null);
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
                                    return service(controller.offerlist[index],
                                        controller.offerlist[index].offer);
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
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
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

  Padding service(Servicemodal modal, String? offer) {
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
                  ? Container(
                      height: 4.h,
                      padding: EdgeInsets.all(5),
                      // alignment: Alignment.center,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8.sp)),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
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

Padding tile(Icon i, String title, String subtitle) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 2.0),
    child: Column(
      children: [
        ListTile(
          title: Text(
            "$title",
            style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 10.sp,
                color: title == 'Logout' ? Colors.red.shade600 : Colors.black),
          ),
          minLeadingWidth: 5.w,
          trailing: Icon(Icons.arrow_forward_ios,
              size: 10.sp,
              color: title == 'Logout' ? Colors.red.shade600 : Colors.black),
          leading: i,
          // subtitle: Text("$subtitle"),
        ),
        const SizedBox(height: 5),
        Divider(height: 1, color: Colors.grey.shade200, thickness: 2),
      ],
    ),
  );
}
