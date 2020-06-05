
import 'package:flash_chat/hospital_finder/pages/doctorsList.dart';
import 'package:flash_chat/hospital_finder/utils/urlHelper.dart';
import 'package:flash_chat/hospital_finder/viewModels/placeViewModel.dart';
import 'package:flutter/material.dart';


class PlaceList extends StatelessWidget {
final String currentUserId;
  final List<PlaceViewModel> places;

  PlaceList({this.places, this.currentUserId});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: this.places.length,
      itemBuilder: (context, index){
        final place = this.places[index];
        return FlatButton(
          child: ListTile(
            contentPadding: EdgeInsets.all(3.0),
            leading: Container(
                width: 100,
                height: 100,
                child: Image.network(UrlHelper.urlForReferenceImage(place.photoUrl), fit :BoxFit.cover,)),
            title: Text(place.name),
          ),
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => DoctorsList(placeName: place.name, currentUserId: currentUserId,)));
          },
        );
      },
    );
  }
}
