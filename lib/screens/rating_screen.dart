
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:tricycleapp/UI/constant.dart';
import 'package:tricycleapp/controller/requestdatacontroller.dart';
import 'package:tricycleapp/widgets/verticalspace.dart';

class RatingScreen extends StatefulWidget {
  const RatingScreen({Key? key}) : super(key: key);
  static const String screenName = "/ratngs";

  @override
  State<RatingScreen> createState() => _RatingScreenState();
}

class _RatingScreenState extends State<RatingScreen> {
  var requestxcontroller = Get.find<Requestdatacontroller>();

  var comment  = TextEditingController();
  ConfettiController? conffetecontroller;
  int rate = 3;
  String ratedescription="Excellent";
  

@override
  void setState(VoidCallback fn) {

    if(mounted){
    super.setState(fn);

    }
  }

  @override
  void initState() { 
    comment.addListener(() => setState(() { }));
  
    conffetecontroller = ConfettiController(duration: Duration(seconds: 2));
    //conffetecontroller!.play();

    super.initState();
    
  }

  void rateRider(){
  String? commentvalue = comment.text.replaceAll(' ', '');
  if(commentvalue == '') {
    commentvalue = null;
  }
    
    requestxcontroller.rateDriver(commentvalue, rate, ratedescription);
 
  }

  @override
  void dispose() {
    conffetecontroller!.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        excludeHeaderSemantics: true,
        elevation: 0,
        
        leading: IconButton(onPressed: (){

          requestxcontroller.deleteTrip();

        }, icon: Text('Skip', style: Get.textTheme.bodyText1,))
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(25),
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Stack(
 
            children: [
              Align(
                alignment: Alignment.topCenter,
                child: ConfettiWidget(confettiController: conffetecontroller as ConfettiController,
                blastDirectionality: BlastDirectionality.explosive,
                shouldLoop: true,
                emissionFrequency: 0.01,
                numberOfParticles: 5,
                minimumSize: Size(5, 10),
                maximumSize: Size(15, 25),
                colors: [
                  ELSA_BLUE,
             
                        ELSA_ORANGE,

                  ELSA_PURPLE_1_,
                        ELSA_YELLOW_TEXT,
                       PINK_1
                ],
                ),
              ),
              Column(                  
                children: [
                  Verticalspace(60),
                  Container(
                    width: double.infinity,
                  ),
    
                   
                    
                   
                  Container(
      
                    child: Text('Thank You!'.toUpperCase(), style: Get.textTheme.headline1!.copyWith(
                    color: Colors.white
                    ),),
                  ),
                  Verticalspace(24),
                  RatingBar(
                    initialRating: rate.toDouble(),
                    minRating: 1,
                    direction: Axis.horizontal,
                    allowHalfRating: false,
                    itemCount: 3,
                    itemSize: 50,
                    ratingWidget: RatingWidget(
                    full: FaIcon(FontAwesomeIcons.solidStar, color: Colors.yellow),
                    half: FaIcon(FontAwesomeIcons.solidStarHalf,  color: Colors.yellow),
                    empty:  FaIcon(FontAwesomeIcons.solidStar,  color: BACKGROUND_TOP),
                  ),
                    itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                    
                    onRatingUpdate: (rating) {
                      setState(() {
                        rate = rating.toInt();

                        if(rate ==1){

                          ratedescription = "Unsatisfied ";
                        }

                        if(rate== 2){
                          ratedescription = "Nice";

                        }

                        if(rate ==3){
                          ratedescription = "Excellent";
                        }


                      });
                    },
                  ),
                  Verticalspace(24),
                  Text('${rate}'.toUpperCase(), style: Get.textTheme.headline1!.copyWith(
                  color: Colors.white,
                  fontSize: 60,
                    fontWeight: FontWeight.w900
                  ),), 
                  Verticalspace(12),
                  Divider(
                    thickness: 1,
                    color: LIGHT_CONTAINER,
                  ),
                 
                    Container(
                      width: double.infinity,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Verticalspace(12),
                          Text('Rate our driver performance'.toUpperCase(), style: Get.textTheme.bodyText1!.copyWith(
                            fontWeight: FontWeight.w600,
                            color: ELSA_BLUE_2_,
                            fontSize: 14,
                          ),),
                          Verticalspace(12),
                          Text('${ratedescription}', style: Get.textTheme.bodyText1!.copyWith(
                            fontWeight: FontWeight.w600,
                            color: ELSA_TEXT_WHITE,
                            fontSize: 18,
                          ),),
                          Verticalspace(24),
                          Text('Say something'.toUpperCase(), style: Get.textTheme.bodyText1!.copyWith(
                            fontWeight: FontWeight.w600,
                            color: ELSA_BLUE_2_,
                            fontSize: 14,
                          ),),
                          Verticalspace(12),
                          TextField(
                            cursorColor: ELSA_TEXT_WHITE,
                            style: TextStyle(
                              color: ELSA_TEXT_WHITE
                            ),
                            controller: comment,
                            keyboardType: TextInputType.text,
                            
                            decoration: InputDecoration(
                            suffixIcon: comment.text.isEmpty ? null: IconButton(onPressed: (){
                                comment.clear();
                              }, icon: FaIcon(FontAwesomeIcons.times, color: Colors.white,) ),  
                              
                              fillColor: LIGHT_CONTAINER,
                              filled: true,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8)
                              )
                              
                            ),

                          ),

                          Verticalspace(24),

                          Container(
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
                                                ELSA_BLUE,
                                              ],
                                            ),
                                          ),
                                          child: MaterialButton(
                                            materialTapTargetSize:
                                                MaterialTapTargetSize.shrinkWrap,
                                            shape: const StadiumBorder(),
                                            child:  Text(
                                              'Continue'.toUpperCase(),
                                              style: TextStyle(
                                                  color: Colors.white, fontSize: 20),
                                            ),
                                            onPressed: (){
                                              rateRider();
                                            },
                                          ),
                                        )
                                        
                        ],
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
