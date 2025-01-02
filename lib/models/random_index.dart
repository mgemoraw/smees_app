import "dart:math" as math;


bool checkIndex(List<int> indexes, int index) {
  for (int j in indexes) {
    if (index == j) {
      return true;
    }
  }
  return false;
}
// geerate radom indices
List <int> generateIndexes(List items, int size) {
  //
  List <int> indexes = [];
  var randIndex = 0;
  for (int i = 0;  i < size; i++){
    randIndex  = math.Random().nextInt(items.length);
    bool indexFound = checkIndex(indexes, randIndex);

    while (indexFound) {
      randIndex = math.Random().nextInt(items.length);
      indexFound = checkIndex(indexes, randIndex);
    }
    indexes.add(randIndex);
  }

  return indexes;
}