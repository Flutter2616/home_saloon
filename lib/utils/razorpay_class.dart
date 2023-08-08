import 'package:get/get.dart';
import 'package:home_saloon/screen/cart_screen/cart_controller.dart';
import 'package:home_saloon/screen/cart_screen/cart_modal.dart';
import 'package:home_saloon/utils/firebase_data.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

import '../screen/homescreen/home_screen.dart';

class PaymentHelper {
  PaymentHelper._();

  static PaymentHelper payment = PaymentHelper._();
  Cartcontroller cart = Get.put(Cartcontroller());

  void setPayment(double total) {
    final razorpay = Razorpay();

    razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);

    var options = {
      'key': 'rzp_test_Clh8SuMsBPGZPc',
      'amount': "$total",
      'name': 'prince rawal',
      'description': 'Home saloon',
      'prefill': {'contact': '9725381787', 'email': 'flutter2616@gmail.com'}
    };

    razorpay.open(options);
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    for (var x in cart.cartlist) {
      Cartmodal modal = Cartmodal(
        address: {
          "name": "${cart.modal!.last} ${cart.modal!.last}",
          "phonenumber": "${cart.modal!.number}",
          "pincode": "${cart.modal!.pincode}",
          "address":
              "${cart.modal!.house},${cart.modal!.residency},${cart.modal!.city},${cart.modal!.state}"
        },
        servicetime: x.servicetime,
        desc: x.desc,
        price: x.price,
        qty: x.qty,
        time: x.time,
        gender: x.gender,
        name: x.name,
        type: x.type,
        img: x.img,
        offer: x.offer,
        status: "pending",
      );
      Firebasedata.data.buycart(modal, "${user['uid']}");
      Firebasedata.data.delete_cart("${x.id}");
    }
    cart.selecttime.value='';
    Get.offAllNamed('home');
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    // Do something when payment fails
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    // Do something when an external wallet was selected
  }
}
