import 'package:get/get.dart';
import 'package:home_saloon/screen/homescreen/service_modal.dart';

class Searchcontroller extends GetxController
{
  RxString searchtext='print'.obs;
  RxList<Servicemodal> filterlist=<Servicemodal>[].obs;
  RxList<Servicemodal> servicelist=<Servicemodal>[].obs;
  void search_Method(String search)
  {
    if(search.isEmpty)
      {
        filterlist.clear();
      }
    else
      {
        for(var x in servicelist)
          {
            if(search.toLowerCase()==x.name!.toLowerCase()||search.toLowerCase()==x.type!.toLowerCase())
              {
                filterlist.add(x);
                print("filterlist:===${filterlist.length}");
              }
          }
      }
  }
}