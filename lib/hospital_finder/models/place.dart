

class Place{
  final String name;
  final double latitude;
  final double longitude;
  final String placeId;
  final String photoUrl;

  Place({this.name, this.latitude, this.longitude, this.placeId, this.photoUrl});

  factory Place.fromJson(Map<String, dynamic> json){
    final location  = json["geometry"]["location"];
    Iterable photos = json["photos"];
    return Place(
        placeId: json["place_id"],
        name: json["name"],
        latitude: location["lat"],
        longitude : location["lng"],
        photoUrl: photos == null ? "images/place-holder.png" : photos.first["photo_reference"].toString()
    );
  }

}