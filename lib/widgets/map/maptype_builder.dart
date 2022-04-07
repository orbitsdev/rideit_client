import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class MaptypeBuilder extends StatelessWidget {

  
  final String name;
  final String image;
  const MaptypeBuilder({
    Key? key,
    required this.name,
    required this.image,
  }) : super(key: key);


  @override
  Widget build(BuildContext context){
    return  Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
      ),
                        margin: EdgeInsets.all(3),
                        width: 100,
                        height: 100,
                        child: Stack(
                          alignment: Alignment.center,
                          fit: StackFit.expand,
                          children: [
                            Image.asset(image, fit: BoxFit.cover),
                            Positioned(
                              bottom: 0,
                              left:0,
                              right: 0,
                              child: Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                       Colors.transparent,
                                      Colors.black54,
                                    ]
                                  )
                                ),
                                child: Container(
                                  padding: EdgeInsets.all(4),
                                  child: Center(child: Text(name)))),
    
                              ),
                              Positioned(
                                top: 40,
                                right: 40,
                                child: FaIcon(FontAwesomeIcons.mapMarkerAlt, color: Colors.red, size: 20,))
                          ],
                        ),
                        
                        );
  }
}
