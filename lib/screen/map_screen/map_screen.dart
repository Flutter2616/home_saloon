import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:home_saloon/screen/map_screen/map_controller.dart';
import 'package:sizer/sizer.dart';

class Mapscreen extends StatefulWidget {
  const Mapscreen({super.key});

  @override
  State<Mapscreen> createState() => _MapscreenState();
}

class _MapscreenState extends State<Mapscreen> {
  Mapcontroller map = Get.put(Mapcontroller());
  LocationPermission? permission;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            Column(
              children: [
                Expanded(
                  child: Container(
                    height: 50.h,
                    child: Obx(
                      () => GoogleMap(
                        myLocationButtonEnabled: true,
                        myLocationEnabled: true,
                        markers: map.create_marker(),
                        onTap: (argument) async {
                          map.lat.value = argument.latitude;
                          map.log.value = argument.longitude;
                          List<Placemark> placemark =
                              await placemarkFromCoordinates(
                                  map.lat.value, map.log.value);
                          map.placemark.clear();
                          map.placemark.value = placemark;
                          map.place.value = map.placemark[0];
                          Get.back();
                          // print("location:${map.placemark[0]}");
                        },
                        initialCameraPosition: CameraPosition(
                            target: LatLng(map.lat.value, map.log.value),
                            zoom: 11.0,
                            tilt: 0,
                            bearing: 0),
                      ),
                    ),
                  ),
                ),
                Container(
                  height: 20.h,
                  padding: EdgeInsets.all(10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.my_location, color: Colors.black, size: 15.sp),
                          const SizedBox(width: 10),
                          Obx(
                            () => Text(
                                "${map.place.value.locality},${map.place.value.country}",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 15.sp)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 15),
                      Obx(
                        () => Text(
                            "${map.place.value.postalCode},${map.place.value.subLocality},${map.place.value.thoroughfare}",
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontSize: 10.sp,
                                fontWeight: FontWeight.w400,
                                color: Colors.grey)),
                      ),
                      const SizedBox(height: 15),
                      InkWell(
                        onTap: () async {
                          permission = await Geolocator.checkPermission();
                          if (permission == LocationPermission.denied) {
                            permission = await Geolocator.requestPermission();
                          }
                          Position position = await Geolocator.getCurrentPosition(
                              desiredAccuracy: LocationAccuracy.high);

                          map.lat.value = position.latitude;
                          map.log.value = position.longitude;
                          map.placemark.clear();
                          List<Placemark> placemark =
                              await placemarkFromCoordinates(
                                  map.lat.value, map.log.value);
                          map.placemark.value = placemark;
                          map.place.value = map.placemark[0];
                          Get.back();

                          // print("${map.place.value}");
                        },
                        child: Container(
                          height: 5.h,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              color: Color(0xff6E4CFE),
                              borderRadius: BorderRadius.circular(8.sp)),
                          child: Text("Confirm Location",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 15.sp)),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: InkWell(onTap: () {
                Get.back();
              },child: Icon(Icons.arrow_back,color: Colors.black,size: 20.sp)),
            ),
          ],
        ),
      ),
    );
  }
}
//0xff6E4CFE
