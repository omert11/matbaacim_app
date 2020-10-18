
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TextSizerPicker extends StatefulWidget {
  const TextSizerPicker({
    @required this.sizeValue,
    @required this.widhValue,
    @required this.selectedColor,
    @required this.selectedFontfamily,
    @required this.onSizeChanged,
    @required this.onWidhChanged,
    this.sizeMax: 62,
    this.sizeMin: 6,
    this.textImput: 'Lorem Ipsum',
  });

  final double sizeValue;
  final FontWeight widhValue;
  final ValueChanged<double> onSizeChanged;
  final ValueChanged<FontWeight> onWidhChanged;
  final double sizeMin;
  final double sizeMax;
  final Color selectedColor;
  final String selectedFontfamily;
  final String textImput;

  @override
  _TextSizerPicker createState() => _TextSizerPicker();
}

class _TextSizerPicker extends State<TextSizerPicker> {
  double currentSize;
  double currentWidh;
  FontWeight mFontW;

  @override
  void initState() {
    currentSize = widget.sizeValue;
    mFontW = widget.widhValue;
    currentWidh=mFontW.index.toDouble();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Text(
            widget.textImput,
            style: TextStyle(
                color: widget.selectedColor,
                fontFamily: widget.selectedFontfamily,
                fontSize: currentSize,
                fontWeight: mFontW),
          ),
          Container(
            height: 50,
          ),
          Column(
            children: <Widget>[
              Text(
                'Metin boyutu',
                style: TextStyle(fontSize: 12),
              ),
              Slider(
                  onChanged: (val) {
                    setState(() {
                      widget.onSizeChanged(val);
                      currentSize = val;
                    });
                  },
                  value: currentSize,
                  max: widget.sizeMax,
                  min: widget.sizeMin)
            ],
          ),
          Column(
            children: <Widget>[
              Text(
                'Metin kalınlığı',
                style: TextStyle(fontSize: 12),
              ),
              Slider(
                  onChanged: (val) {
                    setState(() {
                      currentWidh = val;
                      switch (val.floor()) {
                        case 0:
                          mFontW = FontWeight.w100;
                          break;
                        case 1:
                          mFontW = FontWeight.w200;
                          break;
                        case 2:
                          mFontW = FontWeight.w300;
                          break;
                        case 3:
                          mFontW = FontWeight.w400;
                          break;
                        case 4:
                          mFontW = FontWeight.w500;
                          break;
                        case 5:
                          mFontW = FontWeight.w600;
                          break;
                        case 6:
                          mFontW = FontWeight.w700;
                          break;
                        case 7:
                          mFontW = FontWeight.w800;
                          break;
                        case 8:
                          mFontW = FontWeight.w900;
                          break;
                      }
                      widget.onWidhChanged(mFontW);
                    });
                  },
                  value: currentWidh,
                  max: 8,
                  min: 0)
            ],
          )
        ],
      ),
    );
  }
}
