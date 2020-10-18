import 'package:fexm/datas/editoraddData.dart';
import 'package:fexm/datas/urundata.dart';
import 'package:fexm/mCustomWIdgets/CostomTextField.dart';
import 'package:fexm/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';

class SepetBox extends StatefulWidget {
  const SepetBox({
    @required this.uData,
    @required this.btnSil,
    @required this.btnDz,
    @required this.onAdetChange,
    @required this.sepetData,
});
  final Urundata uData;
  final SepetData sepetData;
  final VoidCallback btnSil;
  final VoidCallback btnDz;
  final ValueChanged<int> onAdetChange;
  @override
  _SepetBox createState() => _SepetBox();
}
class _SepetBox extends State<SepetBox> {
  TextEditingController cnt=TextEditingController();
  @override
  void initState() {
    cnt.text=widget.sepetData.adet;
    cnt.addListener((){
      try{
       int adet=int.parse(cnt.text);
        widget.onAdetChange(adet);
      }catch(e){
        cnt.text=widget.sepetData.adet;
      }
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(5),
      margin: EdgeInsets.all(2),
      decoration: BoxDecoration(color: AccentHard,border: Border.all(color:BlackLight_t,width: 0.2)),
      child: Column(
        children: <Widget>[
          InkWell(
            onTap: (){},
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Image.network(widget.uData.urunres,width: 75,height: 75,),
                Container(width: 10,),
                Column(crossAxisAlignment:CrossAxisAlignment.start,children: <Widget>[
                  Text('Satıcı Firma:  ${widget.uData.ureticiisim}',style: TextStyle(fontSize: 12),),
                  Container(height: 5,),
                  Text(widget.uData.urunisim,style: TextStyle(fontSize: 18)),
                  Container(height: 5,),
                  Text('Tahmini Fiyat:${(int.parse(widget.sepetData.adet)*widget.uData.fiyat).toStringAsFixed(2)}₺',style: TextStyle(fontSize: 16,fontWeight: FontWeight.w500)),
                ],)
              ],
            ),
          ),
          Row(mainAxisAlignment: MainAxisAlignment.center,crossAxisAlignment:CrossAxisAlignment.center,children: <Widget>[
            InkWell(onTap: (){widget.btnSil();},child:Text('Sil',style:TextStyle(color:Primaryclor),),),
            Container(margin:EdgeInsets.symmetric(horizontal: 10),height: 20,width: 1,color: BlackLight_t,),
            InkWell(onTap:(){widget.btnDz();},child: Text('Düzenle',style:TextStyle(color:Primaryclor),)),
            Container(margin:EdgeInsets.symmetric(horizontal: 10),height: 20,width: 1,color: BlackLight_t,),
            Text('Adet',style:TextStyle(color:Primaryclor),),
            CostomTextField(border: false,controller: cnt,widh:60,inputType:TextInputType.number,textsize: 16,padding: EdgeInsets.only(left: 5),)
          ],)
        ],
      ),
    );
  }
}
