import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
FirebaseAuth authinstance = FirebaseAuth.instance;
User? firebaseuser;

//cloudfirestore
FirebaseFirestore firestore = FirebaseFirestore.instance;
CollectionReference userrefference = firestore.collection('passengers');
CollectionReference availabledriversrefference = firestore.collection('availabledrivers');
CollectionReference requestrefference = firestore.collection('request');
CollectionReference ongoingtriprefference = firestore.collection('ongointrip');
CollectionReference ratingsrefference = firestore.collection('ratings');
CollectionReference passengertriphistoryreferrence = firestore.collection('passengertriphistory');
Stream<DocumentSnapshot<Object?>>? requeststream =  requestrefference.doc(authinstance.currentUser!.uid).snapshots();
Stream<DocumentSnapshot<Object?>>? ongoingtripstream =  requestrefference.doc(authinstance.currentUser!.uid).collection('ongoingtrip').doc(authinstance.currentUser!.uid).snapshots();
Stream<DocumentSnapshot<Object?>>? driverlocationstream = requestrefference.doc(authinstance.currentUser!.uid).collection('ongoingtrip').doc(authinstance.currentUser!.uid).snapshots();
CollectionReference publicreferrence = firestore.collection('public');
StreamSubscription<DocumentSnapshot<Object?>>?  driverstream;


//cloud storage
FirebaseStorage storage = FirebaseStorage.instance;  

//cloudmessaging
FirebaseMessaging messaginginstance = FirebaseMessaging.instance;

