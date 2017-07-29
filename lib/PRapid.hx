package lib;

class PRapid extends Puzzle {
  public var fallSpeed:Int;
  public var instruct :String;
  
  public function new(num:Int) {
    super('rapid$num');
    instruct =
"Click the enabled buttons to
fill the progress bar.
Be quick!";
  }
  
  override public function spawn():Array<Window> {
    return [new WRapid(this)];
  }
}
