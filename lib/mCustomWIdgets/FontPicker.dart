import 'package:flutter/material.dart';

class FontPicker extends StatefulWidget {
  const FontPicker(
      {@required this.sizeValue,
      @required this.widhValue,
      @required this.selectedColor,
      @required this.onFontChanged,
      this.font: 'lato',
      this.text: 'Lorem ipsum'});

  final ValueChanged<String> onFontChanged;
  final String font;
  final String text;
  final Color selectedColor;
  final double sizeValue;
  final FontWeight widhValue;

  @override
  _FontPicker createState() => _FontPicker();
}

class _FontPicker extends State<FontPicker> {
  String mFont;
  List<String> mFontList=<String>['ave','lato','prox','teko','merri','chivo','rob','cap','his','heinz','qua','cool'];
  @override
  void initState() {
    mFont=widget.font;
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Column(
      children: <Widget>[
        Text(
          widget.text,
          style: TextStyle(
              color: widget.selectedColor,
              fontFamily:mFont,
              fontSize: widget.sizeValue,
              fontWeight: widget.widhValue),
        ),
        Container(
          height: 50,
        ),
        Container(height: 200,child:ListView.builder(itemCount:mFontList.length,itemBuilder:(BuildContext context, int index){
          String listedFont=mFontList[index];
          return InkWell(onTap:(){
            setState(() {
              widget.onFontChanged(listedFont);
              mFont=listedFont;
            });
          },child: Container(padding:EdgeInsets.all(5),child:Text(listedFont.toLowerCase(),style:TextStyle(color:Colors.black,fontFamily:listedFont),),));
        }) ,)
      ],
    ));
  }
}
