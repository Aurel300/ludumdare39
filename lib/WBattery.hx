package lib;

import sk.thenet.FM;
import sk.thenet.anim.Phaser;
import sk.thenet.app.Keyboard;
import sk.thenet.app.Keyboard.Key;
import sk.thenet.bmp.manip.Box;
import sk.thenet.ui.*;

class WBattery extends Window {
  var indicator:EProgress;
  var text:EText;
  
  public function new() {
    super();
    w = contentW = 108;
    h = contentH = 40;
    x = 90;
    y = 120;
    show = false;
    id = help = "battery";
    title = "Batterycorp";
    close = () -> { show = false; };
    icon = Icon.BATTERY;
    contents = [
       indicator = new EProgress("indicator", 2, 2, 104, 20, false)
      ,text = new EText("text", 2, 24, 104, 20, "")
    ];
    indicator.pos = 0;
    remap();
  }
  
  override public function tick():Void {
    super.tick();
    indicator.pos = FM.minI(100, Story.POINTS);
    text.text = 'PU: ${Story.POINTS} / 100';
  }
}
