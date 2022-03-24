import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:tricycleapp/UI/constant.dart';
import 'package:tricycleapp/widgets/horizontalspace.dart';
import 'package:tricycleapp/widgets/verticalspace.dart';
import 'package:url_launcher/url_launcher.dart';

class Ongoingtrip extends StatefulWidget {
  const Ongoingtrip({ Key? key }) : super(key: key);
  static const screenName = '/ongoingtrip';
  @override
  _OngoingtripState createState() => _OngoingtripState();
}

class _OngoingtripState extends State<Ongoingtrip> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Title'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20,),
        child:Column(
            crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: double.infinity,
            ),
            Verticalspace(20),
              ClipOval(
                      child: Container(
                        color: TEXT_WHITE_2,
                        padding: EdgeInsets.all(2),
                        child: ClipOval(
                          child:  Image.asset(
                                  'assets/images/images.jpg',
                                  height: 120,
                                  width: 120,
                                  fit: BoxFit.cover,
                                )
                              
                        ),)
                        ),
                        Verticalspace(8),
                          Text('Brian Orbino',
                    style: Get.textTheme.headline1!.copyWith(
                        color: ELSA_TEXT_WHITE, fontWeight: FontWeight.w300),
                    textAlign: TextAlign.center),
                Verticalspace(4),
                Text('Driver',
                    style: Get.textTheme.headline1!.copyWith(
                        color: ELSA_TEXT_GREY,
                        fontSize: 16,
                        fontWeight: FontWeight.w300),
                    textAlign: TextAlign.center),
                      Verticalspace(24),

                  Material(
                        color: BACKGROUND_BLACK,
                         borderRadius: BorderRadius.all(Radius.circular(8)),
                    child: InkWell(
                     onTap: () async{
                      await launch('tel:09366303145');
                             },
                      child: Container(
                        padding: EdgeInsets.all(12),
                      
                        child: Row(
                    
                          children: [
                            Container(
                              height: 40,
                              width: 40,
                              child: Center(child: FaIcon(FontAwesomeIcons.mobileAlt, color: ELSA_GREEN,),),
                            ),
                            Verticalspace(5),
                            Text(
                                    '093877123327',
                                    style: Get.textTheme.bodyText1!.copyWith(),
                                  )
                          ],
                        ),
                      ),
                    ),
                  )
               
          ],
        ),
      ),
    );
    
  }

}