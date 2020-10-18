class Katagoridata{
  String katalogres;
  String katagori;
  String baslik1;
  String baslik2;
  String toplamurun;
  String kaydeden;
Katagoridata(this.katalogres,this.katagori,this.baslik1,this.baslik2,this.toplamurun,this.kaydeden);
toJson(){
  return{
    'katalogres':katalogres,
    'katagori':katagori,
    'baslik1':baslik1,
    'baslik2':baslik2,
    'toplamurun':toplamurun,
    'kaydeden':kaydeden,
  };
}
}