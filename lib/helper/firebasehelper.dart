import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
FirebaseAuth authinstance = FirebaseAuth.instance;
User? firebaseuser;

//cloudfirestore
FirebaseFirestore firestore = FirebaseFirestore.instance;
CollectionReference requestcollecctionrefference = firestore.collection('request');
CollectionReference availabledriversrefference = firestore.collection('availableDrivers');

