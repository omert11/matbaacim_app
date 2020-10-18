
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ImageSizerPicker extends StatefulWidget {
  const ImageSizerPicker({
    @required this.sizeValue,
    @required this.onSizeChanged,
    this.sizeMax: 5,
    this.sizeMin: 0,
  });

  final double sizeValue;
  final ValueChanged<double> onSizeChanged;
  final double sizeMin;
  final double sizeMax;
  @override
  _ImageSizerPicker createState() => _ImageSizerPicker();
}

class _ImageSizerPicker extends State<ImageSizerPicker> {
  double currentSize;
  @override
  void initState() {
    currentSize = widget.sizeValue;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Container(height:150,width: 150,child: Transform.scale(scale: currentSize,child:Icon(Icons.ac_unit,color: Colors.lightBlueAccent,))),
          Container(
            height: 50,
          ),
          Column(
            children: <Widget>[
              Text(
                'Resim boyutu :'+currentSize.toStringAsFixed(2),
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
        ],
      ),
    );
  }
}
