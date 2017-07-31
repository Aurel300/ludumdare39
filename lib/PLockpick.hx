package lib;

import sk.thenet.stream.prng.*;

class PLockpick extends Puzzle {
  public var direct   :Bool;
  public var pins     :Array<Int>;
  public var tolerance:Int;
  public var fallSpeed:Int;
  public var window   :WLockpick;
  
  public function new(num:Int) {
    super('lockpk$num');
    sequel = (num < 4 ? 'lockpk${num + 1}' : null);
    points = (switch (num) {
        case 0: 5;
        case 1: 5;
        case 2: 10;
        case 3: 15;
        case _: 20;
      });
    var prng = new Generator(new XORShift(0x70C83D01));
    direct = num < 2;
    for (i in 0...num * 2) prng.next();
    pins = [ for (i in 0...(num + 3 - (num == 4 ? 3 : 0))) prng.nextMod(24) ];
    tolerance = 8 - num * 1;
    fallSpeed = (num == 4 ? 1 : 0);
    if (num == 4) tolerance += 2;
  }
  
  override public function spawn():Array<Window> {
    return [window = new WLockpick(this)];
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
