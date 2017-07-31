package lib;

class PAvoid extends Puzzle {
  public var window:WAvoid;
  
  public function new(num:Int) {
    super('avoid$num');
    points = 5;
  }
  
  override public function spawn():Array<Window> {
    return [window = new WAvoid(this)];
  }
  
  override public function start():Void {
    super.start();
    Main.wm.showWindow(window);
  }
  
  override public function stop():Void {
    super.stop();
    window.show = false;
  }
}
