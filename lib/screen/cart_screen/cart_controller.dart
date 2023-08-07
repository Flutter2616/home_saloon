import 'package:get/get.dart';
import 'package:home_saloon/screen/cart_screen/cart_modal.dart';
import 'package:home_saloon/screen/homescreen/service_modal.dart';

class Cartcontroller extends GetxController {
  RxInt total_order_price =0.obs;
  RxString selectaddress="".obs;
//0xff6E4CFE
  List<Cartmodal> cartlist = [];
  RxString selecttime="".obs;
  List<String> timelist=<String>[
      "10:00AM",
      "10:30AM",
      "11:00AM",
      "11:30AM",
      "12:00PM",
      "12:30PM",
      "1:00PM",
      "1:30PM",
  ].obs;
}
