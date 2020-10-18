import 'package:flutter/cupertino.dart';

// ignore: must_be_immutable
class MovedText extends StatefulWidget {
  MovedText({
    @required this.onDoubleTap,
    @required this.fontFamily,
    @required this.index,
    @required this.text,
    @required this.fontSize,
    @required this.textColor,
    @required this.position,
    @required this.fontWidh,
    @required this.midScaledPos,
    @required this.areaPos,
    @required this.picScle,
  });
  final ValueChanged<int> onDoubleTap;
  final int index;
  final String text;
  final String fontFamily;
  final Color textColor;
  final double fontSize;
  final FontWeight fontWidh;
  Offset position;
  final Offset areaPos;
  final Offset midScaledPos;
  final double picScle;

  @override
  _MovedText createState() => _MovedText();
}

class _MovedText extends State<MovedText> {
  Offset mFingerPos=Offset.zero;
  @override
  void initState() {

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: widget.position.dy,
      left: widget.position.dx,
      child: GestureDetector(
         onPanStart: (mDeatils){
          mFingerPos=mDeatils.localPosition;
           },
          onDoubleTap:(){
            widget.onDoubleTap(widget.index);
           } ,
          onPanUpdate: (mDeatils) {
            setState(() {
              widget.position =
                  (mDeatils.globalPosition / widget.picScle - widget.areaPos) +
                      widget.midScaledPos-mFingerPos;
            });
          },
          child: Text(
            widget.text,
            style: TextStyle(
                color: widget.textColor,
                fontSize: widget.fontSize,
                fontWeight: widget.fontWidh,fontFamily: widget.fontFamily),
          )),
    );
  }
}
