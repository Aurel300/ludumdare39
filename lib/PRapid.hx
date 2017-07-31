package lib;

class PRapid extends Puzzle {
  public var fallSpeed:Int;
  public var window   :WRapid;
  
  public function new(num:Int) {
    super('rapid$num');
    points = 5;
  }
  
  override public function spawn():Array<Window> {
    return [window = new WRapid(this)];
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
