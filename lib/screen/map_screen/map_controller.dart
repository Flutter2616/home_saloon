import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Mapcontroller extends GetxController {

  RxDouble lat = 20.5937.obs;
  RxDouble log = 78.9629.obs;

  RxList<Placemark> placemark=<Placemark>[].obs;
  Rx<Placemark> place = Placemark().obs;

  Set<Marker> create_marker() {
    return {
      Marker(
        markerId: MarkerId("your location"),
        position: LatLng(lat.value, log.value),
      ),
    };
  }
}
