class Istekdata{
  int inputtype;
  String istenecek;
  int type;
  List<String> list;
  Istekdata.yazi(this.inputtype,this.istenecek,this.type);
  Istekdata.res(this.istenecek,this.type);
  Istekdata.switc(this.istenecek,this.type);
  Istekdata.rad(this.list,this.istenecek,this.type);
  toJson(){
    return{
      'inputtype':inputtype,
      'istenecek':istenecek,
      'type':type,
      'list':list,
    };
  }
}