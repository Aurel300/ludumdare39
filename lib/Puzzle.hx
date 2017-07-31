package lib;

class Puzzle {
  public var id:String;
  public var locked:Bool;
  public var solved:Bool;
  
  public function new(id:String) {
    this.id = id;
    locked = true;
    solved = false;
  }
  
  public function spawn():Array<Window> {
    return null;
  }
  
  public function solve():Void {
    if (Save.solved.indexOf(id) == -1) {
      Save.solved.push(id);
      solved = true;
    }
  }
}
