import 'package:get/get.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class PaymentHelper {
  PaymentHelper._();

  static PaymentHelper payment = PaymentHelper._();

  void setPayment(double total) {
    final razorpay = Razorpay();

    razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);

    var options = {
      'key': 'rzp_test_Clh8SuMsBPGZPc',
      'amount': "$total",
      'name': 'Acme Corp.',
      'description': 'Home saloon',
      'prefill': {
        'contact': '9725381787',
        'email': 'flutter2616@gmail.com'
      }
    };

    razorpay.open(options);
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    // Do something when payment success
    Get.offAllNamed('home');
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    // Do something when payment fails
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    // Do something when an external wallet was selected
  }
}