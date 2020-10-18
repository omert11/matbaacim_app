import 'package:flutter/material.dart';

class PhotoShowRoom extends StatefulWidget{
  const PhotoShowRoom({
    @required this.uRls,
});
  final List<String> uRls;
  @override
  _PhotoShowRoom createState()=>_PhotoShowRoom();
}
class _PhotoShowRoom extends State<PhotoShowRoom>{

  @override
  Widget build(BuildContext context) {
    return Image.network(widget.uRls[0]);
  }

}