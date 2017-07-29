package lib;

import sk.thenet.stream.prng.*;

class PLockpick extends Puzzle {
  public var direct   :Bool;
  public var pins     :Array<Int>;
  public var tolerance:Int;
  public var fallSpeed:Int;
  public var instruct :String;
  
  public function new(num:Int) {
    super('lockpk$num');
    var prng = new Generator(new XORShift(0x70C83D01));
    direct = num < 2;
    for (i in 0...num * 2) prng.next();
    pins = [ for (i in 0...(num + 3 - (num == 4 ? 3 : 0))) prng.nextMod(24) ];
    tolerance = 8 - num * 1;
    fallSpeed = (num == 4 ? 1 : 0);
    if (num == 4) tolerance += 2;
    instruct = (switch (num) {
        case 0: 
"Set the pins (sliders) to the
correct positions. The lock
will unlock when all sliders
are green.";
        case 2:
"This time you have to move
the pins with your lockpick.
Move the horizontal slider to
access the correct pin, then
press the button to push it up.
Press reset if you push a pin
too far.";
        case 4:
"Be quick, the pins now fall
down over time!";
        case _: null;
      });
  }
  
  override public function spawn():Array<Window> {
    return [new WLockpick(this)];
  }
}
