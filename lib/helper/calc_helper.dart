class CalcHelper {

  int getCountFromBeginIndex(int beginIndex) {
    int result;
    final int index = beginIndex ~/ 100;
    if(beginIndex < 1000) {
      result = int.parse(index.toString());
    }else if(beginIndex >= 1000 && beginIndex < 10000) {
      result = int.parse(index.toString().substring(0,2));
    }else if(beginIndex >= 10000 && beginIndex < 100000) {
      result = int.parse(index.toString().substring(0,3));
    }
    return result;
  }

}