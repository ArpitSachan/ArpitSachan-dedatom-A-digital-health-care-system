import 'package:flutter/material.dart';
class ReusableCard extends StatelessWidget {

  ReusableCard({@required this.colour, this.cardChild, this.onPress});
  final Color colour; //immuatable: (final and const) they can't be change once assigned
  final Widget cardChild;
  final Function onPress;
  @override // const ->runs during compile time and final after compilation
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPress,
      child: Container(
        child: cardChild,
        margin: EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          color: colour,
        ),
      ),
    );
  }
}