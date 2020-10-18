import 'package:fexm/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CostomButton extends StatefulWidget {
  const CostomButton({
    @required this.onclick,
    this.textsize: 14,
    this.textcolor: Colors.white,
    this.text: '',
    this.heigh,
    this.visible: true,
    this.padding,
    this.widh,
    this.backgroundcolor: Primaryclor,
    this.ofsetx: 0,
    this.ofsety: 0,
    this.opaticy: 1,
    this.radius: 7,
    this.pressclor: Colors.deepOrangeAccent,
    this.fontWeight: FontWeight.w400,
    this.fontFamily: 'ave',
  });

  final double ofsetx;
  final double ofsety;
  final double opaticy;
  final String text;
  final String fontFamily;
  final FontWeight fontWeight;
  final bool visible;
  final VoidCallback onclick;
  final Color backgroundcolor;
  final Color pressclor;
  final Color textcolor;
  final double textsize;
  final double radius;
  final double widh;
  final double heigh;
  final EdgeInsetsGeometry padding;

  @override
  _CostomButton createState() => _CostomButton();
}

class _CostomButton extends State<CostomButton> {
  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: widget.visible,
      child: Opacity(
          opacity: widget.opaticy,
          child: Transform.translate(
            offset: Offset(widget.ofsetx, widget.ofsety),
            child: Container(
              height: widget.heigh,
              width: widget.widh,
              margin: widget.padding,
              child: ButtonTheme(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(widget.radius)),
                  child: RaisedButton(
                    onPressed: widget.onclick,
                    color: widget.backgroundcolor,
                    highlightColor: widget.pressclor,
                    child: Text(
                      widget.text,
                      style: TextStyle(
                          color: widget.textcolor,
                          fontSize: widget.textsize,
                          fontFamily: widget.fontFamily,
                          fontWeight: widget.fontWeight),
                    ),
                  )),
            ),
          )),
    );
  }
}
