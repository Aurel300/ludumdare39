package lib;

import sk.thenet.stream.prng.*;

class Save {
  public static var username(default, set):String;
  public static inline function set_username(name:String):String {
    var seeds = name.split("").map(a -> a.charCodeAt(0));
    var seed = seeds[0];
    for (i in 1...seeds.length) {
      seed *= seeds[i];
      seed %= 0x100000;
    }
    var prng = new Generator(new XORShift(seed));
    faceEyes = prng.nextMod(8);
    faceNose = prng.nextMod(8);
    faceHair = prng.nextMod(4);
    Save.username = name;
    return name;
  }
  
  public static var faceEyes:Int;
  public static var faceNose:Int;
  public static var faceHair:Int;
  public static var solved:Array<String>;
  
  public static function init():Void {
    faceEyes = 0;
    faceNose = 0;
    faceHair = 0;
    solved = [];
  }
}
