import 'package:flutter/material.dart';
import 'package:tricycleapp/UI/constant.dart';
import 'package:tricycleapp/widgets/horizontalspace.dart';
import 'package:tricycleapp/widgets/verticalspace.dart';

class Paymensummarybox extends StatelessWidget {



  final String title;
  final String value;
  const Paymensummarybox({
    Key? key,
    required this.title,
    required this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context){
    return   Container(
    


                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(

                                  constraints: BoxConstraints(
                                    minWidth: 30
                                  ),
                                  child: Text('${title}', style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w100
                                  )),
                                ),

                                Flexible(

                                  child: Text('${value}', style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w300
                                  ), textAlign: TextAlign.right,),
                                ),
                              ],
                            ),
                          );
  }
}
