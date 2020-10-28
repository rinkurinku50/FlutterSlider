import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'dart:math' as math;

class MyHomeWidget extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<MyHomeWidget> {
  int _intialValues = 72;
  int _minValue = 30;
  int _maxValue = 100;
  bool _checkCon = false;

  @override
  Widget build(BuildContext context) {
    var _height = MediaQuery.of(context).size.height;
    var _width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text('Slider'),
        backgroundColor: Colors.orange,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: _width * 0.2,
                        height: _height * 0.08,
                        child: RaisedButton(
                          color: Colors.orange,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          onPressed: _checkCon == true
                              ? null
                              : () {
                                  setState(() {
                                    _checkCon = true;
                                  });
                                },
                          child: Center(
                            child: Text(
                              'Lbs',
                              style: TextStyle(
                                  color: Colors.white, fontSize: 20.0),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 25.0,
                      ),
                      Container(
                        width: _width * 0.2,
                        height: _height * 0.08,
                        child: RaisedButton(
                          color: Colors.orange,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          onPressed: _checkCon == false
                              ? null
                              : () {
                                  setState(() {
                                    _checkCon = false;
                                  });
                                },
                          child: Center(
                            child: Text(
                              'Kg',
                              style: TextStyle(
                                  color: Colors.white, fontSize: 20.0),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: _height * 0.05),
                  Container(
                    width: _width,
                    height: _height * 0.1,
                    child: Stack(
                      overflow: Overflow.visible,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              height: _height * 0.05,
                              color: Colors.orange,
                            ),
                            SizedBox(height: 15.0),
                            Flexible(
                              child: LayoutBuilder(
                                builder: (context, constraints) {
                                  //print(constraints.maxWidth);

                                  return WeightSlider(
                                    value: _intialValues,
                                    onChanged: (value) {
                                      //print(value);
                                      setState(() {
                                        _intialValues = value;
                                      });
                                    },
                                    minValue: _minValue,
                                    maxValue: _maxValue,
                                    width: constraints.maxWidth,
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                        Positioned(
                            left: _width * 0.5,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  height: _height * 0.1,
                                  child: CustomPaint(
                                    painter: CustomLine(_height),
                                  ),
                                ),
                              ],
                            )),
                        _checkCon == false
                            ? Positioned(
                                top: _height * 0.1,
                                left: _width * 0.45,
                                child: Container(
                                  child: Text(
                                    _intialValues.toString(),
                                    style: TextStyle(
                                        fontSize: _width * 0.08,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ))
                            : Positioned(
                                top: _height * 0.1,
                                left: _width * 0.4,
                                child: Container(
                                  child: Text(
                                    (_intialValues * 2.2046).toStringAsFixed(2),
                                    style: TextStyle(
                                        fontSize: _width * 0.08,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ))
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CustomLine extends CustomPainter {
  double getHeight = 0;

  CustomLine(this.getHeight);
  @override
  void paint(Canvas canvas, Size size) {
    final Paint stroke = Paint()
      ..color = Colors.black87
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4;
    Rect rect = Rect.fromLTWH(0, 0, 4, getHeight * 0.1);
    Radius radius = Radius.circular(10);
    RRect rrect = RRect.fromRectAndRadius(rect, radius);
    canvas.drawRRect(rrect, stroke);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

class WeightSlider extends StatelessWidget {
  WeightSlider({
    Key key,
    @required this.minValue,
    @required this.maxValue,
    @required this.value,
    @required this.onChanged,
    @required this.width,
  })  : scrollController = new ScrollController(
          initialScrollOffset: (value - minValue) * width / 3,
        ),
        super(key: key);

  final int minValue;
  final int maxValue;
  final int value;
  final ValueChanged<int> onChanged;
  final double width;
  final ScrollController scrollController;

  double get itemExtent => width / 3;

  int _indexToValue(int index) => minValue + (index - 1);

  @override
  build(BuildContext context) {
    int itemCount = (maxValue - minValue) + 3;
    return NotificationListener(
      onNotification: _onNotification,
      child: new ListView.builder(
        controller: scrollController,
        scrollDirection: Axis.horizontal,
        itemExtent: itemExtent,
        itemCount: itemCount,
        physics: BouncingScrollPhysics(),
        itemBuilder: (BuildContext context, int index) {
          int itemValue = _indexToValue(index);
          bool isExtra = index == 0 || index == itemCount - 1;

          return isExtra
              ? new Container() //empty first and last element
              : GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () => _animateTo(itemValue, durationMillis: 50),
                  child: Container(
                    decoration: BoxDecoration(
                        shape: BoxShape.circle, color: Colors.orange),
                  ),
                );
        },
      ),
    );
  }

  TextStyle _getDefaultTextStyle() {
    return new TextStyle(
      color: Color.fromRGBO(196, 197, 203, 1.0),
      fontSize: 14.0,
    );
  }

  TextStyle _getHighlightTextStyle(BuildContext context) {
    return new TextStyle(
      color: Theme.of(context).primaryColor,
      fontSize: 28.0,
    );
  }

  TextStyle _getTextStyle(BuildContext context, int itemValue) {
    return itemValue == value
        ? _getHighlightTextStyle(context)
        : _getDefaultTextStyle();
  }

  bool _userStoppedScrolling(Notification notification) {
    return notification is UserScrollNotification &&
        notification.direction == ScrollDirection.idle &&
        scrollController.position.activity is! HoldScrollActivity;
  }

  _animateTo(int valueToSelect, {int durationMillis = 200}) {
    double targetExtent = (valueToSelect - minValue) * itemExtent;
    scrollController.animateTo(
      targetExtent,
      duration: new Duration(milliseconds: durationMillis),
      curve: Curves.decelerate,
    );
  }

  int _offsetToMiddleIndex(double offset) => (offset + width / 2) ~/ itemExtent;

  int _offsetToMiddleValue(double offset) {
    int indexOfMiddleElement = _offsetToMiddleIndex(offset);

    int middleValue = _indexToValue(indexOfMiddleElement);
    middleValue = math.max(minValue, math.min(maxValue, middleValue));
    return middleValue;
  }

  bool _onNotification(Notification notification) {
    if (notification is ScrollNotification) {
      int middleValue = _offsetToMiddleValue(notification.metrics.pixels);

      if (_userStoppedScrolling(notification)) {
        _animateTo(middleValue);
      }

      if (middleValue != value) {
        onChanged(middleValue); //update selection
      }
    }
    return true;
  }
}
