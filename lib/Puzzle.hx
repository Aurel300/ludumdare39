package lib;

class Puzzle {
  public var id:String;
  
  public function new(id:String) {
    this.id = id;
  }
  
  public function spawn():Array<Window> {
    return null;
  }
  
  public function solve():Void {
    if (Save.solved.indexOf(id) == -1) {
      Save.solved.push(id);
    }
  }
}
