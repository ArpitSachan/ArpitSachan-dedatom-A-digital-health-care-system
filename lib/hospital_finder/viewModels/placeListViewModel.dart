import 'dart:core';
import 'package:flutter/material.dart';
import 'package:flash_chat/hospital_finder/services/web_service.dart';
import 'package:flash_chat/hospital_finder/viewModels/placeViewModel.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';


class PlaceListViewModel extends ChangeNotifier {

  var places = List<PlaceViewModel>();
  var mapType = MapType.normal;

  void toggleMap(){
    this.mapType=this.mapType==MapType.normal?MapType.satellite:MapType.normal;
    notifyListeners();
  }

  Future<void> fetchPlacesByKeywordAndPosition(String keyword, double latitude, double longitude) async{

    final results = await WebService().fetchPlacesByKeywordAndPosition(keyword, latitude, longitude);
    this.places = results.map((place) => PlaceViewModel(place)).toList();
    notifyListeners();
  }

}