package lib;

import sk.thenet.FM;
import sk.thenet.anim.Phaser;
import sk.thenet.app.Keyboard;
import sk.thenet.app.Keyboard.Key;
import sk.thenet.bmp.manip.Box;
import sk.thenet.ui.*;

class WLift extends Window {
  var indicator:ESlider;
  var posTarget:Int;
  
  public function new() {
    super();
    w = contentW = 50;
    h = contentH = 125;
    x = 30;
    y = 60;
    show = false;
    id = "lift";
    title = "Floors";
    closable = false;
    posTarget = -1;
    icon = Icon.LIFT;
    contents = [ for (i in 0...5) new EButtonText('floor${5 - i - 1}', 17, 17 + i * 18, 16, 18, ' ${5 - i}') ];
    contents.push(indicator = new ESlider("indicator", 2, 17, 12, 5 * 18, true));
    contents.push(new EDisable("disable", 2, 17, 12, 5 * 18));
    indicator.pos = floorPos(Story.LIFT_FLOOR);
    remap();
  }
  
  function floorPos(floor:Int):Int {
    return 7 + (4 - floor) * 18;
  }
  
  override public function tick():Void {
    super.tick();
    if (posTarget != -1) {
      var mod = FM.signI(posTarget - indicator.pos);
      if (mod != 0) {
        indicator.pos += mod;
      } else {
        posTarget = -1;
        show = false;
        (cast Main.puzzlesMap.get("maze0"):PMaze).enter([
             "Foyer"
            ,"Dispatching"
            ,"Your office"
            ,"Your office"
            ,"Your office"
          ][Story.LIFT_FLOOR]);
      }
    }
  }
  
  override public function elementClick(dname:Array<String>, event:EDisplayClick):Void {
    if (posTarget != -1) {
      return;
    }
    switch (dname[0]) {
      case _.substr(0, 5) => "floor":
      Story.LIFT_FLOOR = Std.parseInt(dname[0].substr(5));
      posTarget = floorPos(Story.LIFT_FLOOR);
    }
  }
}
