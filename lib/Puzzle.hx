package lib;

class Puzzle {
  public static var solving:Int = 0;
  
  public var id:String;
  public var locked:Bool;
  public var solved:Bool;
  public var sequel:String;
  public var points:Int = 0;
  
  public function new(id:String) {
    this.id = id;
    locked = true;
    solved = false;
  }
  
  public function spawn():Array<Window> {
    return null;
  }
  
  public function start():Void {
    solving++;
  }
  
  public function stop():Void {
    solving--;
  }
  
  public function solve():Void {
    stop();
    Main.wm.solvePuzzle(id);
  }
}
