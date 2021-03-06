import 'package:flutter/material.dart';
import 'package:stats/NomineeMasterObject.dart';
import 'package:stats/dropcity/draggable_view.dart';

class DraggableText extends StatefulWidget {
  final NomineesEntityList item;
  final Size size;

  bool enabled = true;
  DraggableText(this.item, {this.size});

  @override
  _DraggableCityState createState() => new _DraggableCityState();
}

class _DraggableCityState extends State<DraggableText> {
  @override
  Widget build(BuildContext context) {
    return new Padding(

        padding: new EdgeInsets.all(10.0),
        child: new LongPressDraggable<NomineesEntityList>(
            onDraggableCanceled: (velocity, offset) {
              setState(() {
                widget.item.selected = false;
                widget.item.status = Status.none;
              });
            },
            childWhenDragging: new DragAvatarBorder(new Text(widget.item.nomineeName),
                color: Colors.yellow, size: widget.size),
            child: new  Container(
                decoration: new BoxDecoration(
                  border: Border.all(color: Colors.blueGrey),
                  shape: BoxShape.circle,
                 // color: Colors.blueGrey,
//                  image: new DecorationImage(
//                    image: new AssetImage("images/nominee_images/nominee0.jpg"),
//                    fit: BoxFit.cover,
//                  ),
                ),
                child: new Center(
                  child:Text(widget.item.nomineeName,textAlign: TextAlign.center,
                      style: new TextStyle(color: Colors.black,fontSize: 14.0,
                          fontWeight: FontWeight.bold))
                  ,
                )),
            data: widget.item,
            feedback: new DragAvatarBorder(

              new Text(widget.item.nomineeName,
                  style: new TextStyle(
                      fontSize: 16.0,
                      color: Colors.blueGrey,
                      decoration: TextDecoration.none)),
              size: widget.size,
              color: Colors.transparent,
            )));
  }
}
