import 'package:flutter/material.dart';

class SettingsWidget extends StatefulWidget {
  SettingsWidget({Key key}) : super(key: key);

  @override
  SettingsWidgetState createState() => new SettingsWidgetState();
}

class SettingsWidgetState extends State<SettingsWidget> {
  String votess;

  List _voteby =
  ["star rating", "number rating","emoji feedback","like / dislike","yes / no / maybe","text nomination", "image nomination", "video nomination",];

  //votess
  //["4 star rating", "5 number rating","6 emoji feedback","8 like / dislike","7 yes / no / maybe","1 text nomination", "2 image nomination", "3 video nomination",];


  List<DropdownMenuItem<String>> _dropDownMenuItems;
  String currentCity;

  @override
  void initState() {
    _dropDownMenuItems = getDropDownMenuItems();
    currentCity = _dropDownMenuItems[0].value;
    super.initState();
  }

  List<DropdownMenuItem<String>> getDropDownMenuItems() {
    List<DropdownMenuItem<String>> items = new List();
    for (String city in _voteby) {
      items.add(new DropdownMenuItem(
          value: city,
          child: new Text(city)
      ));
    }
    return items;
  }

  @override
  Widget build(BuildContext context) {
    return new Container(
      color: Colors.grey,
      child: new Center(
          child: new Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
//              new Container(
//                padding: new EdgeInsets.all(0.0),
//              ),
              new DropdownButton(
                style: new TextStyle( color: Colors.blueGrey, fontSize: 12.0,fontWeight: FontWeight.bold),
                value: currentCity,
                items: _dropDownMenuItems,
                onChanged: changedDropDownItem,
              )
            ],
          )
      ),
    );
  }

  void changedDropDownItem(String selectedCity) {
    setState(() {
      currentCity = selectedCity;
      votess=selectedCity;
    });
  }

}