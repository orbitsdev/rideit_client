import 'package:flutter/foundation.dart';

class PublicData {


int? fee;
int? minimum_km_basis;
  PublicData({
    this.fee,
    this.minimum_km_basis,
  });

  factory PublicData.fromJson(Map<String,dynamic> json){
      PublicData publicdata = PublicData();

      publicdata.fee =  json['fee'];
      publicdata.minimum_km_basis =  json['minimum_km_basis'];

     return publicdata; 
  }

  Map<String, dynamic> toJson()=>{
    'fee': fee,
    'minimum_km_basis': minimum_km_basis
  };
}
