import 'dart:async';
import 'package:flash_chat/hospital_finder/viewModels/placeListViewModel.dart';
import 'package:flash_chat/hospital_finder/widgets/placeList.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:flash_chat/hospital_finder/viewModels/placeViewModel.dart';



class HomePage extends StatefulWidget {
  final String currentUserId;
  HomePage({this.currentUserId});
  @override
  _HomePageState createState() => _HomePageState(currentUserId: currentUserId);
}

class _HomePageState extends State<HomePage> {

  final String currentUserId;
  _HomePageState({this.currentUserId});
  Completer<GoogleMapController> _controller = Completer();
  Position _currentPosition;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }


  Set<Marker> _getPlaceMarkers(List<PlaceViewModel> places){

    return places.map((place) {
      return Marker(
          markerId: MarkerId(place.placeId),
          icon: BitmapDescriptor.defaultMarker,
          infoWindow: InfoWindow(title: place.name),
          position: LatLng(place.latitude, place.longitude)
      );
    }).toSet();

  }
  Future<void> _onMapCreated(GoogleMapController controller) async{
    _controller.complete(controller);
    _currentPosition = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
        target: LatLng(_currentPosition.latitude, _currentPosition.longitude), zoom: 14)));
  }
  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<PlaceListViewModel>(context);
    print(vm.places);
    return Scaffold(
      body: Stack(
        children: <Widget>[
          GoogleMap(
            mapType: vm.mapType,
            markers: _getPlaceMarkers(vm.places),
            myLocationEnabled: true,
            onMapCreated: _onMapCreated,
            initialCameraPosition: CameraPosition(
                target:  LatLng(28.545111, 77.199493),
                zoom: 14
            ),
          ),
          SafeArea(
            child: TextField(
              onSubmitted: (value){
                vm.fetchPlacesByKeywordAndPosition(value, _currentPosition.latitude, _currentPosition.longitude);
              },
              decoration: InputDecoration(
                  labelText: "Search",
                  fillColor: Colors.white,
                  filled: true
              ),
            ),
          ),
          Visibility(
              visible: vm.places.length > 0 ? true : false,
              child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Align(
                      alignment: Alignment.bottomLeft,
                      child: FlatButton(
                        child: Text('Show List',
                          style: TextStyle(color: Colors.white,
                          fontFamily: 'NotoSans'
                          ),),
                        onPressed: () {
                          showModalBottomSheet(
                              context: context,
                              builder:(context) => PlaceList(places: vm.places, currentUserId : currentUserId));
                        },
                        color: Colors.grey,
                      ),
                    ),
                  )
              )
          ),
          Positioned(
            top: 100,
            right: 5,
            child: FloatingActionButton(
              onPressed: () {
                vm.toggleMap();
              },
              child: Icon(Icons.map),
            ),
          )
        ],
      ),
    );
  }
}
