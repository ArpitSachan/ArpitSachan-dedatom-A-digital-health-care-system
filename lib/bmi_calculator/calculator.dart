import 'dart:math';


class Calculator{
  Calculator({this.height, this.weight});

  final int height;
  final int weight;

  double _bmi;
  String calculatebmi(){
    _bmi= weight/pow(height/100, 2);
    return _bmi.toStringAsFixed(1);
  }

  String getResult(){
    if(_bmi>=25)
    {
      return 'Overeight';
    }
    else if(_bmi>18.5){
      return 'Normal';
    }
    else
    {
      return 'Underweight';
    }
  }

  String getInterpretation(){
    if(_bmi>=25)
    {
      return 'You have a higher than normal body weight. try to exercise';
    }
    else if(_bmi>18.5){
      return 'You have a normal body weight. Good job!';
    }
    else
    {
      return 'You have a lower that normal body weight. You cn eat a bit more';
    }
  }
}