import 'package:flutter/material.dart';

class CostomTextField extends StatefulWidget {
  const CostomTextField({
    @required this.border,
    @required this.controller,
    this.widh: 360,
    this.padding,
    this.label,
    this.visible: true,
    this.heigh,
    this.errortext: '',
    this.errored: false,
    this.inputType: TextInputType.text,
    this.opaticy: 1,
    this.hint: '',
    this.ic,
    this.ofsetx: 0,
    this.ofsety: 0,
    this.fontWeight: FontWeight.w400,
    this.textsize: 14,
    this.fontFamily: 'ave',
    this.textcolor: Colors.black,
    this.hintcolor: Colors.grey,
    this.textAlign: TextAlign.start,
    this.textpadding,
  });

  final double opaticy;
  final double ofsetx;
  final double ofsety;
  final double textsize;
  final FontWeight fontWeight;
  final Color textcolor;
  final Color hintcolor;
  final String fontFamily;
  final String hint;
  final String label;
  final Icon ic;
  final bool border;
  final TextInputType inputType;
  final bool errored;
  final String errortext;
  final TextEditingController controller;
  final bool visible;
  final double widh;
  final double heigh;
  final TextAlign textAlign;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry textpadding;

  @override
  _CostomTextField createState() => _CostomTextField();
}

class _CostomTextField extends State<CostomTextField> {
  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: widget.visible,
      child: Opacity(
          opacity: widget.opaticy,
          child: Transform.translate(
            offset: Offset(widget.ofsetx, widget.ofsety),
            child: Container(
              padding: widget.padding,
              height: widget.heigh,
              width: widget.widh,
              child: TextField(
                  controller: widget.controller,
                  textAlign: widget.textAlign,
                  style: TextStyle(
                      color: widget.textcolor,
                      fontSize: widget.textsize,
                      fontWeight: widget.fontWeight,
                      fontFamily: widget.fontFamily),
                  decoration: widget.border
                      ? InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(4)),
                              borderSide: BorderSide(
                                  width: 2, color: Colors.orangeAccent)),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(4)),
                            borderSide:
                                BorderSide(width: 2, color: Color(0xFFF07C00)),
                          ),
                          disabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(4)),
                            borderSide:
                                BorderSide(width: 2, color: Color(0xFFF07C00)),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(4)),
                            borderSide:
                                BorderSide(width: 2, color: Color(0xFFF07C00)),
                          ),
                          errorBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(4)),
                              borderSide:
                                  BorderSide(width: 2, color: Colors.red)),
                          focusedErrorBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(4)),
                              borderSide: BorderSide(
                                  width: 2, color: Colors.redAccent)),
                          hintText: widget.hint,
                          errorText: widget.errored ? widget.errortext : null,
                          labelStyle: TextStyle(color: Colors.orangeAccent),
                          labelText: widget.label,
                          prefixIcon: widget.ic,
                          contentPadding: widget.textpadding,
                        )
                      : InputDecoration(
                          border: InputBorder.none,
                          hintText: widget.hint,
                          hintStyle: TextStyle(color: widget.hintcolor),
                          labelStyle: TextStyle(color: Colors.orangeAccent),
                          labelText: widget.label,
                        ),
                  textCapitalization: TextCapitalization.sentences,
                  keyboardType: widget.inputType),
            ),
          )),
    );
  }
}
