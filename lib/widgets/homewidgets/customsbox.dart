import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tricycleapp/UI/constant.dart';



class Customsbox extends StatelessWidget {

  final String title;
  final String subtitle;
  final IconData icon;
  final List<Color> colors;


 
  const Customsbox({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.colors,

  }) : super(key: key);
  


  @override
  Widget build(BuildContext context){
    return Container(    
          margin: EdgeInsets.symmetric(horizontal: 8.0,),
        padding: EdgeInsets.all(12),

      decoration: BoxDecoration(
        color: LIGHT_CONTAINER,
        borderRadius: BorderRadius.all(Radius.circular(containerRadius)),
      ),
      child:Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(17)),
            //
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomLeft,
              colors: [
                  colors[0],
                  colors[1]
              ],
            )
            ),
            padding: EdgeInsets.all(12),
            child: Icon(icon, color: Colors.white, size: 28,)),
            SizedBox(
              height: 8,
            ),
          Text(title, style: Get.textTheme.headline1!.copyWith(
            color: ELSA_TEXT_WHITE,
            fontSize: 24,
            fontWeight: FontWeight.w800
          )),

          SizedBox(
            height: 12,
          ),
          Text('Total ${subtitle}', style:  Get.theme.textTheme.bodyText1!.copyWith(
            color: ELSA_TEXT_WHITE,
              ),),
           SizedBox(
            height: 14,
          ),
            Center(
                        child: Container(
                          width: MediaQuery.of(context).size.width *0.40,
                          height: 8,
                           decoration: BoxDecoration(
                              color: lINE_LIGHT,
                        borderRadius: BorderRadius.all(Radius.circular(20))
                    // color: BACKGROUND_BLACK_LIGHT_MORE_LIGHT,
                        ),

                        
                        ),
                      ),
       
        ],
      ),
    );
  }
}
