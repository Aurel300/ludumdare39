package lib;

import sk.thenet.FM;
import sk.thenet.bmp.manip.*;
import sk.thenet.plat.Platform;

class WStory extends Window {
  public var lastPoints:Float;
  public var storyId:String;
  public var chargeEl:EBitmap;
  public var el:EBitmap;
  
  public function new() {
    super();
    this.x = 40;
    this.y = 10;
    w = contentW = 256;
    h = contentH = 256;
    lastPoints = 100;
    id = "story";
    icon = Icon.SPEECH;
    close = () -> { show = false; };
    var charged = Main.am.getBitmap("story2").fluent >> new Cut(0, 0, 256, 256)
      << new Blit(Main.am.getBitmap("story2").fluent >> new Cut(256, 0, 256, 256), 0, 0);
    contents = [
         chargeEl = new EBitmap("charge", 0, 0, charged)
        ,el = new EBitmap("bmp", 0, 0, Main.am.getBitmap("story1"))
      ];
    remap();
  }
  
  public function showTitle(title:String):Void {
    this.title = 'Story ($title)';
    Interface.updateWindowText(display.children[1], this.title, w);
  }
  
  override public function tick():Void {
    super.tick();
    if (show && storyId == "story2") {
      lastPoints = FM.floor((lastPoints * 10 + Story.POINTS) / 11);
      el.h = 23 + FM.floor(((100 - lastPoints) / 100) * 233);
    } else {
      el.h = -1;
    }
  }
  
  public function showStory(storyId:String):Void {
    this.storyId = storyId;
    show = true;
    chargeEl.show = (storyId == "story2");
    el.bmp = Main.am.getBitmap(storyId);
    showTitle(switch (storyId) {
        case "story1": "At your desk";
        case "story2": "Batterycorp building";
        case "story3": "The lift";
        case "story4": "Dispatching";
        case _: "???";
      });
  }
}
