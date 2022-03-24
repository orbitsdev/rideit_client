class PredictionPlace {
  String? placeId;
  String? maintext;
  String? secondrarytext;

  PredictionPlace({
    this.placeId,
    this.maintext,
    this.secondrarytext,
  });

   factory PredictionPlace.fromJson(Map<String, dynamic> json) {
    
    PredictionPlace predictionpplace = PredictionPlace();
    predictionpplace.placeId = json['place_id'];
    predictionpplace.maintext = json['structured_formatting']['main_text'];
    predictionpplace.secondrarytext = json['structured_formatting']['secondary_text'];
    return predictionpplace;
  }

  Map<String, dynamic> toJson()=>{
     'placeId': placeId,
   'maintext':         maintext,
   'secondrarytext':         secondrarytext,
  };

  
}
