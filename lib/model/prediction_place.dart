class PredictionPlace {
  String? placeId;
  String? maintext;
  String? secondrarytext;

  PredictionPlace({
    this.placeId,
    this.maintext,
    this.secondrarytext,
  });

  PredictionPlace.fromJson(Map<String, dynamic> json) {
    placeId = json['place_id'];
    maintext = json['structured_formatting']['main_text'];
    secondrarytext = json['structured_formatting']['secondary_text'];
  }
}
