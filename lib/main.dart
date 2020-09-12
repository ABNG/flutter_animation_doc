import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:marquee/marquee.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation _animation;
  final key = GlobalKey<AnimatedListState>();
  List<String> _items = ["items 1", "items 2", "items 3", "items 4"];
  String text1 = "hello world";
  String text2 = "Ok Bye";
  String text3 = "Ending Text";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller =
        AnimationController(vsync: this, duration: Duration(microseconds: 200));
    _animation = CurvedAnimation(curve: Curves.elasticIn, parent: controller);
    _animation = Tween<Offset>(begin: Offset.zero, end: Offset(0.5, 0))
        .animate(_animation);
    _animation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        controller.reverse();
      }
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          addItem();
          controller.forward();
        },
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Container(
              width: double.infinity,
              height: 80,
              color: Colors.orange,
              child: Marquee(
                text: "$text1      $text2         $text3",
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                blankSpace: 150.0,
                pauseAfterRound: Duration(seconds: 1),
                startPadding: 10.0,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: PhysicalModel(
                //if we need elevation and border radius use physical model
                color: Colors.red,
                elevation: 2,
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  height: 100.0,
                  width: 300,
                  margin: EdgeInsets.symmetric(horizontal: 18),
                  alignment: Alignment.center,
                  child: SlideTransition(
                      position: _animation, child: Text("Slide Transition")),
                ),
              ),
            ),
            Expanded(
              child: AnimatedList(
                key: key,
                initialItemCount: _items.length,
                itemBuilder: (context, int index, Animation<double> animation) {
                  return buildItem(_items[index], animation, index);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildItem(String item, Animation animation, int index) {
    //we can use any transition here
//    return SizeTransition(
//      sizeFactor: animation,
//      child: Card(
//        elevation: 2,
//        child: ListTile(
//          title: Text(
//            item,
//            style: TextStyle(fontWeight: FontWeight.bold),
//          ),
//          trailing: IconButton(
//            onPressed: () {
//              removeItem(index);
//            },
//            icon: Icon(
//              Icons.close,
//              color: Colors.red,
//            ),
//          ),
//          leading: CircleAvatar(
//            backgroundColor: Colors.amber,
//          ),
//        ),
//      ),
//    );
//    return FadeTransition(
//      opacity: animation,
//      child: Card(
//        elevation: 2,
//        child: ListTile(
//          title: Text(
//            item,
//            style: TextStyle(fontWeight: FontWeight.bold),
//          ),
//          trailing: IconButton(
//            onPressed: () {
//              removeItem(index);
//            },
//            icon: Icon(
//              Icons.close,
//              color: Colors.red,
//            ),
//          ),
//          leading: CircleAvatar(
//            backgroundColor: Colors.amber,
//          ),
//        ),
//      ),
//    );
//
    return ScaleTransition(
      scale: animation,
      child: Card(
        elevation: 2,
        child: ListTile(
          title: Text(
            item,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          trailing: IconButton(
            onPressed: () {
              removeItem(index);
            },
            icon: Icon(
              Icons.close,
              color: Colors.red,
            ),
          ),
          leading: CircleAvatar(
            backgroundColor: Colors.amber,
          ),
        ),
      ),
    );
  }

  removeItem(int index) {
    String removeItemed = _items.removeAt(index);
    AnimatedListRemovedItemBuilder builder = (context, animation) {
      return buildItem(removeItemed, animation, index);
    };
    key.currentState.removeItem(index, builder);
  }

  void addItem() {
    int i = _items.length > 0 ? _items.length : 0;
    _items.insert(i, "Item ${_items.length + 1}");
    key.currentState.insertItem(i);
  }
}
