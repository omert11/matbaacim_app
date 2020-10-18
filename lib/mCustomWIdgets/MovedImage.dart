import 'dart:io';

import 'package:flutter/cupertino.dart';

// ignore: must_be_immutable
class MovedImage extends StatefulWidget{
  MovedImage({
    @required this.onDoubleTap,
    @required this.index,
    @required this.position,
    @required this.midScaledPos,
    @required this.areaPos,
    @required this.picScle,
    @required this.imageScle,
    @required this.imageFile,
  });
  final ValueChanged<int> onDoubleTap;
  final int index;
  Offset position;
  final Offset areaPos;
  final Offset midScaledPos;
  final double picScle;
  final double imageScle;
  final File imageFile;
  @override
  _MovedImage createState() => _MovedImage();
}
class _MovedImage extends State<MovedImage>{
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
          child:Transform.scale(scale:widget.imageScle,child: Image.file(widget.imageFile))),
    );
  }

}