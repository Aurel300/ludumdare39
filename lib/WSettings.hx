package lib;

import sk.thenet.FM;
import sk.thenet.ui.*;

class WSettings extends Window {
  public var sliderSound:ESlider;
  public var sliderMusic:ESlider;
  public var sliderDouble:ESlider;
  public var status:EText;
  
  public function new() {
    super();
    x = y = 70;
    w = contentW = 135;
    h = contentH = 75;
    id = "settings";
    title = "System settings";
    icon = Icon.SETTINGS;
    contents = [
         new EBitmap("labelsound", 5, 5, Interface.icons[Icon.SOUND])
        ,sliderSound = new ESlider("sound", 25, 5, 105, 16)
        ,new EBitmap("labelmusic", 5, 5 + 20, Interface.icons[Icon.MUSIC])
        ,sliderMusic = new ESlider("music", 25, 5 + 20, 105, 16)
        ,new EBitmap("labeldouble", 5, 5 + 40, Interface.icons[Icon.DOUBLE_CLICK])
        ,sliderDouble = new ESlider("double", 25, 5 + 40, 105, 16)
        ,status = new EText("status", 5, 3 + 60, 135, 16, "")
      ];
    sliderSound.pos = sliderMusic.pos = 100;
    sliderDouble.pos = 80;
    remap();
  }
  
  override public function elementDrag(dname:Array<String>, event:EDisplayDrag):Void {
    super.elementDrag(dname, event);
    status.text = (switch (dname[0]) {
        case "sound":
        Main.volumeSound = (sliderSound.pos / 100);
        "Sound volume: " + sliderSound.pos;
        case "music":
        Main.volumeMusic = (sliderMusic.pos / 100);
        "Music volume: " + sliderMusic.pos;
        case "double":
        Main.wm.ui.doubleClick = FM.floor(((sliderDouble.pos * 5 + 100) / 1000) * 30);
        status.text = "Double click time: " + (sliderDouble.pos * 5 + 100) + "ms";
        case _: "";
      });
  }
}
