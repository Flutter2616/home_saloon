import 'package:get/get.dart';
import 'package:home_saloon/screen/payment_screen/payment_modal.dart';

class Paymentcontroller extends GetxController
{
  RxString cardnumber=''.obs;
  RxString cardname=''.obs;
  RxString cardcvv=''.obs;
  RxString carddate=''.obs;

  List<Paymentmodal> cardlist=[];
}