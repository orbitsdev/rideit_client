import 'package:flutter/material.dart';

class Totalearningline extends StatelessWidget {
const Totalearningline({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context){
    return Center(
                        child: Container(
                          width: MediaQuery.of(context).size.width *0.40,
                          height: 5,
                           decoration: BoxDecoration(
                                gradient: LinearGradient(
                          begin: Alignment.topRight,
                          end: Alignment.bottomLeft,
                          colors: [
                           Colors.red,
                           Colors.blue
                          ],
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(20))
                    // color: BACKGROUND_BLACK_LIGHT_MORE_LIGHT,
                        ),

                        
                        ),
                      );
  }
}