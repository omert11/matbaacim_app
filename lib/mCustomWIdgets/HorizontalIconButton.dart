import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../main.dart';

class HorizontalIconButtton extends StatefulWidget {
  const HorizontalIconButtton({
    @required this.text,
    @required this.onclick,
    this.textsize: 14,
    this.textcolor: Colors.black,
    this.bColor: Colors.white,
    this.textisaretci: '',
    this.widh: 360,
    this.heighdivider: 1,
    this.notification:false,
    this.colordivider: BlackLight_t,
    this.paddingtext,
    this.icon: Icons.chevron_right,
    this.iconcolor:Colors.black,
    this.colorNotification:Colors.redAccent,
    this.notificationtext:''
  });

  final String text;
  final String notificationtext;
  final bool notification;
  final Color colorNotification;
  final String textisaretci;
  final VoidCallback onclick;
  final Color bColor;
  final IconData icon;
  final Color iconcolor;
  final Color colordivider;
  final Color textcolor;
  final double textsize;
  final double widh;
  final double heighdivider;
  final EdgeInsetsGeometry paddingtext;

  @override
  _HorizontalIconButtton createState() => _HorizontalIconButtton();
}

class _HorizontalIconButtton extends State<HorizontalIconButtton> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onclick,
      child: Container(
          width: widget.widh,
          color: widget.bColor,
          padding: EdgeInsets.only(top: 10),
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Container(
                          padding: widget.paddingtext,
                          child: Text(
                            widget.text,
                            style: TextStyle(color: widget.textcolor, fontSize: widget.textsize),
                          )),
                      widget.notification?Icon(Icons.notifications,color: widget.colorNotification,):Container(),
                      widget.notification?Text('(${widget.notificationtext})',style: TextStyle(color: widget.colorNotification),):Container()
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Text(
                        widget.textisaretci,
                        style: TextStyle(color: Primaryclor),
                      ),
                      Icon(
                        widget.icon,
                        color: widget.iconcolor,
                      ),
                    ],
                  )
                ],
              ),
              Container(
                height: 10,
              ),
              Divider(
                color: widget.colordivider,
                height: widget.heighdivider,
              )
            ],
          )),
    );
  }
}
