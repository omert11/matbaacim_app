import 'package:fexm/datas/editoraddData.dart';
import 'package:fexm/datas/kullanicidata.dart';

class SiparisDetayim{
  Kullanicidata siparisciData;
  String picRes;
  String urunKat;
  String urunKod;
  DateTime siprisDate;
  Map<dynamic,dynamic> istekcevaplari;
  List<EditoraddData> screenResources;
  SiparisDetayim(this.siparisciData,this.siprisDate,this.screenResources,this.istekcevaplari,this.picRes,this.urunKat,this.urunKod);
}