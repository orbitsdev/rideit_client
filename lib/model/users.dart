import 'package:cloud_firestore/cloud_firestore.dart';

class Users {

  String? id;
  String? name;
  String? email;
  String? phone;
  String? image_url;
  String? image_file;
  String? device_token;
  bool? new_acount;
 
  String? map_mode;
  bool? authorize;
 
  Users({
    this.id,
    this.name,
    this.email,
    this.phone,
    this.image_url,
    this.image_file,
    this.device_token,
    this.new_acount,
    this.map_mode,
    this.authorize,
    
  });




  factory Users.fromJson(Map<String, dynamic> json){

    Users  user = Users();
    user.id = json['id'];
    user.name = json['name'];
    user.email = json['email'];
    user.phone = json['phone'];
    user.image_url = json['image_url'];
    user.image_file = json['image_file'];
    user.device_token = json["device_token"];
    user.new_acount = json["new_acount"];
    user.map_mode = json["map_mode"];
    user.authorize = json["authorize"];

    return user;
  }
  Map<String, dynamic> toJson()=>{
   'id':id,
   'name':    name,
   'email':    email,
   'phone':    phone,
   'image_url':    image_url,
   'image_file':    image_file,
   'device_token':    device_token,
   'new_acount':    new_acount,
   'map_mode': map_mode,
   'authorize': authorize
  };
   
}
