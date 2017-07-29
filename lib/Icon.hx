package lib;

@:enum
abstract Icon(Int) from Int to Int {
  var NORMAL = 0;
  var BATTERY = 1;
  var FACE = 2;
  var KEY = 3;
}
