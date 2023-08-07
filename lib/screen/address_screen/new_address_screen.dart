import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:home_saloon/screen/address_screen/address_controller.dart';
import 'package:home_saloon/screen/address_screen/address_modal.dart';
import 'package:home_saloon/utils/firebase_data.dart';
import 'package:sizer/sizer.dart';

import '../homescreen/home_screen.dart';

class Newaddress extends StatefulWidget {
  const Newaddress({super.key});

  @override
  State<Newaddress> createState() => _NewaddressState();
}

class _NewaddressState extends State<Newaddress> {
  TextEditingController txtfirstname = TextEditingController();
  TextEditingController txtlastname = TextEditingController();
  TextEditingController txtflatno = TextEditingController();
  TextEditingController txtpincode = TextEditingController();
  TextEditingController txtresidencyname = TextEditingController();
  TextEditingController txtcity = TextEditingController();
  TextEditingController txtstate = TextEditingController();
  TextEditingController txtphone = TextEditingController();
  Addresscontroller address=Get.put(Addresscontroller());

  GlobalKey<FormState> key = GlobalKey();
  Map m1=Get.arguments;
  @override
  void initState() {
    super.initState();
    if(m1['status']==1)
      {
        txtfirstname=TextEditingController(text: address.addresslist[m1['index']].first);
        txtlastname=TextEditingController(text: address.addresslist[m1['index']].last);
        txtcity=TextEditingController(text: address.addresslist[m1['index']].city);
        txtstate=TextEditingController(text: address.addresslist[m1['index']].state);
        txtresidencyname=TextEditingController(text: address.addresslist[m1['index']].residency);
        txtpincode=TextEditingController(text: "${address.addresslist[m1['index']].pincode}");
        txtphone=TextEditingController(text:"${address.addresslist[m1['index']].number}");
        txtflatno=TextEditingController(text: address.addresslist[m1['index']].house);
      }
  }
  @override
  Widget build(BuildContext context) {
    return Form(
      key: key,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.white,
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(onTap: () {
                        Get.back();
                      },child: Icon(Icons.close, size: 15.sp, color: Colors.black)),
                      InkWell(
                        onTap: () {
                          if (key.currentState!.validate()) {
                            Addressmodal modal = Addressmodal(
                                number: int.parse(txtphone.text),
                                city: txtcity.text,
                                first: txtfirstname.text,
                                last: txtlastname.text,
                                house: txtflatno.text,
                                pincode: int.parse(txtpincode.text),
                                residency: txtresidencyname.text,
                                state: txtstate.text);
                            Firebasedata.data.add_Address("${user['uid']}", modal);
                            Get.offAllNamed("showaddress");
                          }
                        },
                        child: Text(
                          "Add",
                          style: TextStyle(
                              color: Color(0xff6E4CFE), fontSize: 12.sp),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 15),
                  Text("Add New Address",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w600)),
                  const SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: 45.w,
                        height: 8.h,
                        child: textfield(txtfirstname, "First Name",
                            TextInputType.name, "Enter first name"),
                      ),
                      Container(
                          width: 45.w,
                          height: 8.h,
                          child: textfield(txtlastname, "Last Name",
                              TextInputType.name, "Enter last name")),
                    ],
                  ),
                  const SizedBox(height: 10),
                  textfield(txtflatno, "House/Flat no.",
                      TextInputType.streetAddress, "Enter house no"),
                  const SizedBox(height: 10),
                  textfield(txtpincode, "Pincode", TextInputType.number,
                      "Enter pincode"),
                  const SizedBox(height: 10),
                  textfield(txtresidencyname, "Residency/socity name",
                      TextInputType.name, "Enter socity name"),
                  const SizedBox(height: 10),
                  textfield(txtcity, "City", TextInputType.name, "Enter city"),
                  const SizedBox(height: 10),
                  textfield(
                      txtstate, "State", TextInputType.name, "Enter state"),
                  const SizedBox(height: 10),
                  textfield(txtphone, "Phone Number", TextInputType.number,
                      "Enter number"),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  TextFormField textfield(TextEditingController controller, String hint,
      TextInputType type, String error) {
    return TextFormField(
      controller: controller,
      validator: (value) {
        if (value!.isEmpty || value == null) {
          return "$error";
        }
        return null;
      },
      textInputAction: TextInputAction.next,
      maxLines: 1,
      keyboardType: type,
      style: TextStyle(
          fontSize: 12.sp, color: Colors.black, fontWeight: FontWeight.w400),
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.sp),
          borderSide: BorderSide(
            color: Colors.grey,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.sp),
          borderSide: BorderSide(
            color: Color(0xff6E4CFE),
          ),
        ),
        hintText: "${hint}",
        hintStyle: TextStyle(
          color: Colors.grey.shade400,
          fontSize: 12.sp,
        ),
      ),
    );
  }
}
//0xff6E4CFE
