import 'package:flutter/material.dart';
import 'package:tricycleapp/UI/constant.dart';


class Elsabuttoncustome extends StatelessWidget {

final String label;
final double radius;
final Function function;


  const Elsabuttoncustome({
    Key? key,
    required this.label,
    required this.radius,
    required this.function,
  }) : super(key: key);

  @override
  Widget build(BuildContext context){
    return Container(
                                      margin: EdgeInsets.symmetric(horizontal: 12,),
                                      width: double.infinity,
                                          height: 60,
                                      decoration: const ShapeDecoration(
                                        shape: StadiumBorder(),
                                        gradient: LinearGradient(
                                          end: Alignment.bottomCenter,
                                          begin: Alignment.topCenter,
                                          colors: [
                                              ELSA_BLUE_2_,
                                              ELSA_BLUE_1_,
                                          ],
                                        ),
                                      ),
                                      child: MaterialButton(
                                        materialTapTargetSize:
                                            MaterialTapTargetSize.shrinkWrap,
                                        shape: const StadiumBorder(),
                                        child:  Text(
                                          label,
                                          style: TextStyle(
                                              color: Colors.white, fontSize: 20),
                                        ),
                                        onPressed: ()=> function(),
                                      ),
                                    );
  }
}
