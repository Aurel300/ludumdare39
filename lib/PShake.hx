package lib;

class PShake extends Puzzle {
  public var window:WShake;
  
  public function new(num:Int) {
    super('shake$num');
    points = 5;
  }
  
  override public function spawn():Array<Window> {
    return [window = new WShake(this)];
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
