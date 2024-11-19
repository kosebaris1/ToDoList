class Istek{
  String istek;
  Istek(this.istek);

  Istek.fromMap(Map<String,dynamic> map):
        istek=map["istek"];



  Map<String,dynamic> toMap(){
    return {
      "istekler":istek
    };
  }
}