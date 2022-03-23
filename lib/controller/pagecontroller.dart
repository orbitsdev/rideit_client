

import 'package:get/get.dart';

class Pagecontroller extends GetxController{


var pageindex = 1.obs;


void updatePageIndex(int index){
  pageindex = index.obs;
  print(pageindex);
}
//for request
var currenStep = 0.obs;

}