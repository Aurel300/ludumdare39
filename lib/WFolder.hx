package lib;

import haxe.ds.Vector;
import sk.thenet.FM;
import sk.thenet.ui.*;

class WFolder extends Window {
  public function new(id:String, title:String, x:Int, y:Int, iw:Int, ih:Int) {
    super();
    this.x = x;
    this.y = y;
    w = contentW = iw * 20;
    h = contentH = ih * 20;
    this.id = id;
    this.title = title;
    icon = Icon.DOCUMENT;
    contents = [
        new EFolder("folder", 2, 2, iw, ih, [Icon.FACE])
      ];
    remap();
  }
  
  override public function update():Void {
    super.update();
    (cast contents[0]:EFolder).wm = wm;
  }
}
