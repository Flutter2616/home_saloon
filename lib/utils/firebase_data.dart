import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:home_saloon/screen/address_screen/address_modal.dart';
import 'package:home_saloon/screen/cart_screen/cart_modal.dart';
import 'package:home_saloon/screen/homescreen/service_modal.dart';

import '../screen/homescreen/home_screen.dart';

class Firebasedata {
  static Firebasedata data = Firebasedata._();

  Firebasedata._();

  FirebaseFirestore fire = FirebaseFirestore.instance;

  Stream<QuerySnapshot<Map<String, dynamic>>> readdata({String? type}) {
    if (type != null) {
      return fire
          .collection('service')
          .where("detail", isEqualTo: "$type")
          .snapshots();
    } else {
      return fire.collection("service").snapshots();
    }
  }

  void add_Cartdata(Cartmodal modal, String uid) {
    fire.collection("addcart").doc("${uid}").collection("mycart").add({
      "detail": modal.name,
      "img":
          "https://img.freepik.com/free-photo/handsome-man-barber-shop-styling-hair_1303-20978.jpg",
      "type": modal.type,
      "price": modal.price,
      "time": modal.time,
      "description": modal.desc,
      "offer": modal.offer,
      "qty": modal.qty,
      "gender": modal.gender
    });
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> cart_Read() {
    return fire
        .collection("addcart")
        .doc("${user['uid']}")
        .collection("mycart")
        .snapshots();
  }

  void update_Cart(Cartmodal modal) {
    fire
        .collection("addcart")
        .doc("${user['uid']}")
        .collection("mycart")
        .doc("${modal.id}")
        .set({
      "detail": modal.name,
      "img":
          "https://img.freepik.com/free-photo/handsome-man-barber-shop-styling-hair_1303-20978.jpg",
      "type": modal.type,
      "price": modal.price,
      "time": modal.time,
      "description": modal.desc,
      "offer": modal.offer,
      "gender": modal.gender,
      "address":modal.address,
      "qty": modal.qty,
      "servicetime": modal.servicetime,
      "status": modal.status,
    });
  }

  void delete_cart(String id) {
    fire
        .collection("addcart")
        .doc("${user['uid']}")
        .collection("mycart")
        .doc("${id}")
        .delete();
  }

  void buycart(Cartmodal modal,String uid)
  {
    fire.collection("user").doc("${uid}").collection("buycart").add({
      "detail": modal.name,
      "img":
      "https://img.freepik.com/free-photo/handsome-man-barber-shop-styling-hair_1303-20978.jpg",
      "type": modal.type,
      "price": modal.price,
      "time": modal.time,
      "description": modal.desc,
      "offer": modal.offer,
      "qty": modal.qty,
      "gender": modal.gender,
      "status":modal.status,
      "address":modal.address,"servicetime":modal.servicetime,
    });
  }
  
  void buy_read(String uid,String status)
  {
    fire.collection("user").doc("${uid}").collection("buycart").where("status",isEqualTo: "$status");
  }
  //======================================address fire store=========================
  void add_Address(String uid,Addressmodal modal) {
    fire.collection("user").doc("${uid}").collection("myaddress").add({
      "first name":modal.first,
      "last name":modal.last,
      "phone number":modal.number,
      "house flat no":modal.house,
      "pincode":modal.pincode,
      "residency name":modal.residency,
      "city":modal.city,
      "state":modal.state,
    });
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> read_address()
  {
    return fire.collection("user").doc("${user['uid']}").collection("myaddress").snapshots();
  }

  void delete_Address(String id)
  {
    fire.collection("user").doc("${user['uid']}").collection("myaddress").doc("${id}").delete();
  }


  void update_Address(Addressmodal modal,String uid)
  {
    fire.collection("user").doc("${uid}").collection("myaddress").doc("${modal.id}").set({
      "first name":modal.first,
      "last name":modal.last,
      "phone number":modal.number,
      "house flat no":modal.house,
      "pincode":modal.pincode,
      "residency name":modal.residency,
      "city":modal.city,
      "state":modal.state,
    });
  }
}
