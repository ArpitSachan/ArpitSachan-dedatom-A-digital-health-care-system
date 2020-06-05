import 'package:flutter/material.dart';
import 'icon_content.dart';
import 'reusable.dart';
import 'constant.dart';
import 'results_page.dart';
import 'roundiconbutton.dart';
import 'button_bottom.dart';
import 'calculator.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

enum Gender {
  male,
  female,
}
class InputPage extends StatefulWidget {
  @override
  _InputPageState createState() => _InputPageState();
}
class _InputPageState extends State<InputPage> {
  Gender selected;
  int height = 180;
  int weight = 60;
  int age = 19;
//  Color maleColour=inactiveColour;
//  Color femaleColour=inactiveColour;

//  void updateColour(Gender gender){
//    if(gender==Gender.male)
//      {
//        if(maleColour==inactiveColour)
//          {
//            maleColour=activeCardColour;
//            femaleColour=inactiveColour;
//          }
//        else
//          {
//            maleColour=inactiveColour;
//          }
//      }
//    else if(gender==Gender.female)
//      {
//        if(femaleColour==inactiveColour)
//        {
//          femaleColour=activeCardColour;
//          maleColour=inactiveColour;
//        }
//        else
//        {
//          femaleColour=inactiveColour;
//        }
//      }
//  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('BMI CALCULATOR'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(
            child: Row(
              children: <Widget>[
                Expanded(
                  child: ReusableCard(
                    onPress: () {
                      setState(() {
                        selected = Gender.male;
                      });
                    },
                    colour: selected == Gender.male
                        ? kActiveCardColour
                        : kInactiveColour,
                    cardChild:
                    IconContent(icon: FontAwesomeIcons.mars, label: 'MALE'),
                  ),
                ),
                Expanded(
                  child: ReusableCard(
                    onPress: () {
                      setState(() {
                        selected = Gender.female;
                      });
                    },
                    colour: selected == Gender.female
                        ? kActiveCardColour
                        : kInactiveColour,
                   cardChild: IconContent(
                        icon: FontAwesomeIcons.venus, label: 'FEMALE'),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ReusableCard(
              colour: kInactiveColour,
              cardChild: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'HEIGHT',
                    style: kLabelTextStyle,
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline:
                    TextBaseline.alphabetic, // to use upper baseline
                    children: <Widget>[
                      Text(
                        height.toString(),
                        style: kNumberTextStyle,
                      ),
                      Text(
                        'cm',
                        style: kLabelTextStyle,
                      )
                    ],
                  ),
                  SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      inactiveTrackColor: Color(0xFF8D8E98),
                      activeTrackColor: Colors.white,
                      thumbColor: Color(0xFFEB1555),
                      overlayColor: Color(0x29EB1555),
                      thumbShape:
                      RoundSliderThumbShape(enabledThumbRadius: 15.0),
                      overlayShape:
                      RoundSliderOverlayShape(overlayRadius: 30.0),
                    ), // we use copywith to alter some of the properties.
                    child: Slider(
                      value: height.toDouble(),
                      min: 120,
                      max: 220,
                      onChanged: (double newValue) {
                        setState(() {
                          height = newValue.round();
                        });
                      },
                    ),
                  )
                ],
              ),
            ),
          ),
          Expanded(
            child: Row(
              children: <Widget>[
                Expanded(
                  child: ReusableCard(
                    colour: kInactiveColour,
                    cardChild: Column(
                      children: <Widget>[
                        Text('WEIGHT',
                          style: kLabelTextStyle,
                        ),
                        Text(
                          weight.toString(),
                          style: kNumberTextStyle,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            RoundIconButton(
                             icon: FontAwesomeIcons.minus,
                              onPressed: () {
                                setState(() {
                                  weight--;
                                });
                              },
                            ),
                            SizedBox(width: 10.0),
                            RoundIconButton(
                              icon: FontAwesomeIcons.plus,

                              onPressed: () {
                                setState(() {
                                  weight++;
                                });
                              },
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: ReusableCard(
                    colour: kInactiveColour,
                    cardChild: Column(
                      children: <Widget>[
                        Text('AGE',
                          style: kLabelTextStyle,
                        ),
                        Text(
                          age.toString(),
                          style: kNumberTextStyle,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            RoundIconButton(
                              icon: FontAwesomeIcons.minus,
                              onPressed: () {
                                setState(() {
                                  age--;
                                });
                              },
                            ),
                            SizedBox(width: 10.0),
                            RoundIconButton(
                              icon: FontAwesomeIcons.plus,
                              onPressed: () {
                                setState(() {
                                  age++;
                                });
                              },
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          BottomButton(buttonTitle: 'CALCULATE', onTap: () {

            Calculator calc =Calculator(height: height, weight: weight);

            Navigator.push(context, MaterialPageRoute(builder: (context){
              return ResultsPage(
                bmiResult: calc.calculatebmi(),
                resultText: calc.getResult(),
                interpretation: calc.getInterpretation(),
              );
            }));
          },),
        ],
      ),
    );
  }
}