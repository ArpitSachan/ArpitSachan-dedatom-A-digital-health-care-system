class UrlHelper{

  static String urlForReferenceImage(String photoReferenceId){
    return "https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photoreference=$photoReferenceId&key=AIzaSyAnUvLWaPgyt8rAo68en585S6r1Ll27s_g";
  }

  static String urlForPlaceKeywordAndLocation(String keyword, double latitude, double longitude){
    return "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=$latitude,$longitude&radius=20000&keyword=$keyword&key=AIzaSyAnUvLWaPgyt8rAo68en585S6r1Ll27s_g";

  }
}