import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:home_saloon/screen/address_screen/address_controller.dart';
import 'package:home_saloon/screen/address_screen/address_modal.dart';
import 'package:home_saloon/utils/firebase_data.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:sizer/sizer.dart';

class ShowAddress extends StatefulWidget {
  const ShowAddress({super.key});

  @override
  State<ShowAddress> createState() => _ShowAddressState();
}

class _ShowAddressState extends State<ShowAddress> {
  Addresscontroller address = Get.put(Addresscontroller());

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
                            .toList(),
                      );
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
