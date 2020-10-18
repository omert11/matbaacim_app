import 'package:flutter/material.dart';
import 'package:liquid_progress_indicator/liquid_progress_indicator.dart';

import '../main.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({
    @required this.contex,
    this.splashVisib: true,
    this.logotext: 'Matbaacım',
    this.logotop: 250,
    this.scaleLogo: 1,
    this.backgroundcolor: BlackLight,
    this.subtext1: 'v$versioncode',
    this.subtext2: '',
    this.logocolor: Colors.white,
    this.textprogress: '0',
    this.textinfo: 'Yükleniyor',
    this.paddingproggres: 50,
    this.subcolor:Primaryclor
  });

  final bool splashVisib;
  final String logotext;
  final String textinfo;
  final String textprogress;
  final String subtext1;
  final String subtext2;
  final double logotop;
  final double paddingproggres;
  final double scaleLogo;
  final BuildContext contex;
  final Color backgroundcolor;
  final Color logocolor;
  final Color subcolor;

  @override
  _SplashScreen createState() => _SplashScreen();
}

class _SplashScreen extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return Visibility(
        visible: widget.splashVisib,
        child: Container(
          color: widget.backgroundcolor,
          height: MediaQuery.of(widget.contex).size.height,
          width: MediaQuery.of(widget.contex).size.width,
          child: Stack(
            children: <Widget>[
              Positioned(
                top: widget.logotop,
                left: 0,
                right: 0,
                child: Transform.scale(
                  scale: widget.scaleLogo,
                  child: Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        Text(
                          widget.logotext,
                          style: TextStyle(
                              color: widget.logocolor,
                              fontFamily: 'lato',
                              fontWeight: FontWeight.w200,
                              fontSize: 60),
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            Text(
                              widget.subtext1,
                              style: TextStyle(
                                  color: widget.subcolor,
                                  fontFamily: 'lato',
                                  fontWeight: FontWeight.w400,
                                  fontSize: 20),
                            ),
                            Container(
                              width: 10,
                            ),
                            Text(
                              widget.subtext2,
                              style: TextStyle(
                                  color: widget.logocolor,
                                  fontFamily: 'lato',
                                  fontWeight: FontWeight.w400,
                                  fontSize: 20),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 0,
                right: 0,
                top: widget.logotop+100,
                child: Text(
                  widget.textinfo,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: widget.logocolor, fontSize: 16,fontWeight: FontWeight.w300),
                ),
              ),
              Positioned(
                left: 0,
                right: 0,
                top: widget.logotop+ 120,
                child: Text(
                  widget.textprogress + '%',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: widget.logocolor, fontSize: 12,fontWeight: FontWeight.w300),
                ),
              ),
              Positioned(
                left: widget.paddingproggres,
                right: widget.paddingproggres,
                top: widget.logotop + 150,
                child:Container(height:35,child:LiquidLinearProgressIndicator(
                  backgroundColor: widget.logocolor,
                  value: double.parse(widget.textprogress)/100,
                  valueColor: AlwaysStoppedAnimation(widget.subcolor),
                  direction: Axis.horizontal,
                ),)
              )
            ],
          ),
        ));
  }
}
