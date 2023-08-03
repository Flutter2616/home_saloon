import 'package:get/get.dart';
import 'package:home_saloon/screen/cart_screen/cart_modal.dart';
import 'package:home_saloon/screen/homescreen/service_modal.dart';

class Cartcontroller extends GetxController {
  RxInt total_order_price = 0.obs;

  List<Cartmodal> cartlist = [];
}
