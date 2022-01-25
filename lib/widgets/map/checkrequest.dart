import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:tricycleapp/controller/mapcontroller.dart';
import 'package:tricycleapp/helper/firebasehelper.dart';

import 'package:tricycleapp/screens/home_screen.dart';
import 'package:tricycleapp/widgets/closerequest.dart';

class Checkrequest extends StatelessWidget {
  final Function setRequestState;
  final Function setPolyLine;
  final Function clearPolylines;

  Checkrequest({
    required this.setRequestState,
    required this.setPolyLine,
    required this.clearPolylines,
  });

  @override
  Widget build(BuildContext context) {
    var mapxcontroller = Get.find<Mapcontroller>();
    return SingleChildScrollView(
      child: Container(
        // margin: EdgeInsets.symmetric(
        //   horizontal: 4,
        // ),
        padding: EdgeInsets.only(top: 20, left: 20, right: 20, bottom: 12),
        width: double.infinity,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(8), topRight: Radius.circular(8)),
            boxShadow: [
              BoxShadow(
                  color: Colors.black54,
                  blurRadius: 8.0,
                  spreadRadius: 1.0,
                  offset: Offset(0.7, 0.20)),
            ]),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Closerequest(closerequest: setRequestState,clearPolylines: clearPolylines,),
            Text(
              'Request Details',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Text(
              'Your current location will be use as pickuploction ',
              style: TextStyle(
                fontSize: 14,
              ),
            ),
            Divider(
              thickness: 2,
              color: Colors.grey[300],
            ),
            Row(
              children: [
                Text(
                  'DESTINATION',
                  style: TextStyle(
                      color: Colors.blue[800], fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  width: 6,
                ),
                Text(
                  '|',
                  style: TextStyle(
                      color: Colors.yellow[800], fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  width: 6,
                ),
                Text(
                  'ROUTE ',
                  style: TextStyle(
                      color: Colors.purple[800], fontWeight: FontWeight.bold),
                ),
              ],
            ),
            Divider(
              thickness: 2,
              color: Colors.grey[300],
            ),
            Text(
              'Name: Kristine Teruel',
              style: TextStyle(
                fontSize: 14,
              ),
            ),
            SizedBox(
              height: 8,
            ),
            Text(
              'Phone: 09366303145',
              style: TextStyle(
                fontSize: 14,
              ),
            ),
            SizedBox(
              height: 8,
            ),
            Text(
              'Pickuplocation: 278 Salem St kalawag 2',
              style: TextStyle(
                fontSize: 14,
              ),
            ),
            SizedBox(
              height: 8,
            ),
            Text(
              'Destination: Isulan Central Plaza',
              style: TextStyle(
                fontSize: 14,
              ),
            ),
            SizedBox(
              height: 8,
            ),
            Text(
              'Distance : 1 km',
              style: TextStyle(
                fontSize: 14,
              ),
            ),
            Divider(
              thickness: 2,
              color: Colors.grey[300],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton.icon(
                    icon: FaIcon(FontAwesomeIcons.arrowCircleLeft),
                    onPressed: () {
                      setRequestState(RequestTricycleState.picklocation);
                    },
                    label: Text('Back')),
                ElevatedButton.icon(
                    icon: FaIcon(FontAwesomeIcons.checkCircle),
                    onPressed: () {
                      mapxcontroller.senRequest();
                      // print(mapxcontroller.routedirectiondetails
                      //           .value.polylines_encoded);
                      //       setPolyLine(
                      //           mapxcontroller.routedirectiondetails.value
                      //               .polylines_encoded,
                      //           mapxcontroller
                      //               .routedirectiondetails.value.bound_ne,
                      //           mapxcontroller.routedirectiondetails.value
                      //               .bound_sw);
                    },
                    label: Text('SEND REQUEST')),
              ],
            ),
            Divider(
              thickness: 2,
              color: Colors.grey[300],
            ),
            StreamBuilder(
                stream: requestcollecctionrefference
                    .orderBy('created_at')
                    .snapshots(),
                builder:
                    (context, AsyncSnapshot<QuerySnapshot<Object?>> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    SizedBox(
                      height: 15,
                      width: 15,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation(Colors.white),
                      ),
                    );
                  } 

                  if(snapshot.hasData){
var documents = snapshot.data!.docs;

                      if(documents.length >0 ){
  return Column(
                      children: [
                        ElevatedButton(onPressed: (){
                          mapxcontroller.cancelRequest();
                        }, child: Text('cancel')),
                        SizedBox(
                          height: 5,
                        ),
                        ListView.builder(
                            shrinkWrap: true,
                            itemCount: documents.length,
                            itemBuilder: (context, index) {
                              return Text(documents[index]['drop_address']);
                            }),
                      ],
                    );
                      }
                  
                  }
                    return Container();
                  }
            )
          ],
        ),
      ),
    );
  }
}
