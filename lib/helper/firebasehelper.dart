import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
FirebaseAuth authinstance = FirebaseAuth.instance;
User? firebaseuser;

//cloudfirestore
FirebaseFirestore firestore = FirebaseFirestore.instance;
CollectionReference userrefference = firestore.collection('passengers');
CollectionReference availabledriversrefference = firestore.collection('availabledrivers');
CollectionReference requestrefference = firestore.collection('request');
CollectionReference ongoingtriprefference = firestore.collection('ongointrip');
Stream<DocumentSnapshot<Object?>>? requeststream =  requestrefference.doc(authinstance.currentUser!.uid).snapshots();
Stream<DocumentSnapshot<Object?>>? ongoingtripstream =  ongoingtriprefference.doc(authinstance.currentUser!.uid).snapshots();
Stream<DocumentSnapshot<Object?>>? driverlocationstream =  ongoingtriprefference.doc(authinstance.currentUser!.uid).snapshots();


 