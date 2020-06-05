import 'viewModels/placeListViewModel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'pages/homePage.dart';

class App extends StatelessWidget {
  final String currentUserId;
  App({this.currentUserId});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home:
        ChangeNotifierProvider(
          create: (context) => PlaceListViewModel(),
          child: HomePage(currentUserId: currentUserId,),
        )
    );
  }
}
