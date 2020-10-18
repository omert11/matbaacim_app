import 'package:fexm/main.dart';
import 'package:flutter/material.dart';

class CircularImageInternet extends StatefulWidget {
  const CircularImageInternet(
      {this.padding,
      this.url,
      this.widh: 50,
      this.heigh: 50,
      this.border: false,
      this.bordercolor: BlackLight,
      this.bacgroundcolor: Colors.transparent,
      this.borderWidh:1});

  final String url;
  final double widh;
  final double heigh;
  final bool border;
  final Color bordercolor;
  final double borderWidh;
  final Color bacgroundcolor;
  final EdgeInsetsGeometry padding;

  @override
  _CircularImageInternet createState() => _CircularImageInternet();
}

class _CircularImageInternet extends State<CircularImageInternet> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.widh,
      height: widget.heigh,
      padding: widget.padding,
      decoration: BoxDecoration(
          borderRadius: new BorderRadius.all(new Radius.circular(widget.widh/2)),
          border: new Border.all(
            color:widget.border?widget.bordercolor:Colors.transparent,
            width: widget.borderWidh,
          ),
          color: widget.bacgroundcolor,
          image: new DecorationImage(
            image: new NetworkImage(widget.url),
            fit: BoxFit.cover,
          )),
    );
  }
}
