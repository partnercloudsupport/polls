import 'package:flutter/material.dart';
import 'package:stats/NomineeMasterObject.dart';
import 'package:stats/dropcity/draggable_image.dart';

//import 'package:stats/dropcity/country.dart';
import 'package:stats/dropcity/draggable_text.dart';
import 'package:stats/dropcity/drop_target.dart';

class GameView1 extends StatefulWidget {
  List<NomineesEntityList> items;
  List<NomineesEntityList> items1 = new List();
  int voteBy;

  GameView1(this.items, this.voteBy) {
    items1.add(items.elementAt(0));
    items1.elementAt(0).nomineesDescription = "To Nominate Long Press & Grag Here";
  }

  @override
  _GameViewState createState() => new _GameViewState();
}

class _GameViewState extends State<GameView1> {
  final _gap = 8.0;
  final _margin = 10.0;

  Map<int, NomineesEntityList> pairs = {};

  bool validated = false;

  int score = 0;

  Size getDragableSize({Size areaSize, int numItems}) {
    final landScape = areaSize.width > areaSize.height;
    final targetWidth =
        (areaSize.width - (2 * _margin) - (_gap * (numItems - 1))) / numItems;
    return new Size(targetWidth, areaSize.height * (landScape ? 0.25 : 0.2));
  }

  Size getTargetSize({Size areaSize, int numItems}) {
    final landScape = areaSize.width > areaSize.height;
    final targetWidth =
        (areaSize.width - (2 * _margin) - (_gap * (1 - 1))) / 1;
    return new Size(targetWidth, areaSize.height * (landScape ? 0.45 : 0.3));
  }

  Widget _buildButton(String icon, VoidCallback onPress) => new Padding(
      padding: new EdgeInsets.all(10.0),
      child: new FloatingActionButton(
          heroTag: "btn2",
          mini: true,
          backgroundColor: Colors.blueGrey,
          child: Image(
            image: new AssetImage(icon),
            width: 22,
            height: 22,
            color: null,
            fit: BoxFit.scaleDown,
            alignment: Alignment.center,
          ),
          onPressed: onPress));

  Widget _buildButton1(String icon, VoidCallback onPress) => new Padding(
      padding: new EdgeInsets.all(10.0),
      child: new FloatingActionButton(
          heroTag: "btn4",
          mini: true,
          backgroundColor: Colors.blueGrey,
          child: Image(
            image: new AssetImage(icon),
            width: 32,
            height: 32,
            color: null,
            fit: BoxFit.scaleDown,
            alignment: Alignment.center,
          ),
          onPressed: onPress));

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);

    final size = mq.size;
    final numItems = 4;
    final draggableSize = getDragableSize(areaSize: size, numItems: numItems);
    final targetSize = getTargetSize(areaSize: size, numItems: numItems);

    if(widget.voteBy==1){
      return new Column(
          mainAxisAlignment: mq.orientation == Orientation.landscape
              ? MainAxisAlignment.end
              : MainAxisAlignment.spaceEvenly,
          children: [
            new Expanded(child: _buildDragableTextList(draggableSize)),
            _buildTargetRow(targetSize, draggableSize),
          ]);
    }
    else if(widget.voteBy==2){
      return new Column(
          mainAxisAlignment: mq.orientation == Orientation.landscape
              ? MainAxisAlignment.end
              : MainAxisAlignment.spaceEvenly,
          children: [
            new Expanded(child: _buildDragableImageList(draggableSize)),
            _buildTargetRow(targetSize, draggableSize),
          ]);
    }


  }

  Widget _buildValidateButton() => new Row(
      mainAxisAlignment: MainAxisAlignment.end,
      mainAxisSize: MainAxisSize.max,
      children: [
        new Text('lock : $score / ${widget.items.length}'),
//        _buildButton(validated ? Icons.refresh : Icons.check,
//            validated ? _onClear : _onValidate)
      ]);

  Widget _buildDragableTextList(Size itemSize) => new Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        Flexible(
          child: GridView.count(
            primary: true,
            padding: const EdgeInsets.all(15.0),
//                crossAxisSpacing: 2.0,
            crossAxisCount: 3,
            children: widget.items
                .where((item) => !item.selected)
                .map((item) => new DraggableText(item, size: itemSize))
                .toList(),
          ),
        )
      ]);

  Widget _buildDragableImageList(Size itemSize) => new Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        Flexible(
          child: GridView.count(
           // primary: true,
            padding: const EdgeInsets.all(1.0),
                crossAxisSpacing: 9.0,
            crossAxisCount: 3,
            children: widget.items
                .where((item) => !item.selected)
                .map((item) => new DraggableImages(item, size: itemSize))
                .toList(),
          ),
        )
      ]);

  Widget _buildTargetRow(Size targetSize, Size itemSize) =>
      new NotificationListener<SelectionNotification>(
        onNotification: _onSelection,
        child:
        Container(

               color: Colors.grey[300],
            child:  Column(children: <Widget>[
          new Row(

              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: widget.items1
                  .map((item) => new DropTarget(item,
                  selectedItem: pairs[item.id],
                  size: targetSize,
                  itemSize: itemSize))
                  .toList()),

                      Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                mainAxisSize: MainAxisSize.max,
                children: [
//                  Container(
//                    color: Colors.transparent,
//                    height: 5,
//                    width: 5,
//                  ),


                  _buildButton(validated ? 'images/refresh.png':'images/yes.png',validated ? _onClear : _onValidate),
                  _buildButton1('images/vote.png',validated ? _onClear : _onValidate),


                ]),
       ]),

        ),


      );

  bool _onSelection(SelectionNotification notif) {
    setState(() {
      // on de-selection
      if (notif.cancel) {
        if (notif.item != null) notif.item.selected = false;
        pairs.remove(notif.dropIndex);
      } else {
        // if target was associated with other country
        if (pairs[notif.dropIndex] != null)
          pairs[notif.dropIndex].selected = false;

        // if country was associated with other dropTarget
        if (pairs.containsValue(notif.item))
          pairs.remove(pairs.keys.firstWhere((k) => pairs[k] == notif.item));
        _onItemSelection(notif.item, notif.dropIndex);
      }
    });
    return false;
  }

  void _onItemSelection(NomineesEntityList selectedItem, int targetId) {
    setState(() {
      if (selectedItem != null) {
        selectedItem.selected = true;
        selectedItem.status = Status.none;
      }

      pairs[targetId] = selectedItem;
    });
  }

  void _onValidate() {
    setState(() {
      score = 0;
      pairs.forEach((index, item) {
        if (item.id == index) {
          item.status = Status.correct;
          score++;
        } else
          item.status = Status.wrong;
      });
      validated = true;
    });
  }

  void _onClear() {
    setState(() {
      pairs.forEach((index, item) {
        item.status = Status.none;
        item.selected = false;
      });
      pairs.clear();
      validated = false;
    });
  }
}
