import 'package:cloud_firestore/cloud_firestore.dart';

class Users {

  String? id;
  String? name;
  String? email;
  String? phone;
  String? image_url;
  String? image_file;
  String? device_token;
 
 
  Users({
    this.id,
    this.name,
    this.email,
    this.phone,
    this.image_url,
    this.image_file,
    this.device_token,

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

    return user;
  }

   
}
