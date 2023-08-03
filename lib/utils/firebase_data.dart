import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
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

  void add_Cartdata(Servicemodal modal, String uid) {
    fire.collection("addcart").doc("${uid}").collection("mycart").add({
      "detail": modal.name,
      "img":
          "https://img.freepik.com/free-photo/handsome-man-barber-shop-styling-hair_1303-20978.jpg",
      "type": modal.type,
      "price": modal.price,
      "time": modal.time,
      "description": modal.desc,
      "offer": modal.offer,
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
      "qty": modal.qty,
      "servicetime": modal.servicetime,
      "status": modal.status,
    });
  }

  void delete_cart(String id)
  {
    fire.collection("addcart").doc("${user['uid']}").collection("mycart").doc("${id}").delete();
  }
}
