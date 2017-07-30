package lib;

import haxe.ds.Vector;
import sk.thenet.FM;
import sk.thenet.ui.*;

class WFolder extends Window {
  public var folder:EFolder;
  
  public function new(id:String, title:String, x:Int, y:Int, iw:Int, ih:Int, icons:Array<Icon>) {
    super();
    this.x = x;
    this.y = y;
    w = contentW = iw * 20;
    h = contentH = ih * 20;
    this.id = id;
    this.title = title;
    icon = Icon.DOCUMENT;
    folder = new EFolder("folder", 2, 2, iw, ih, icons);
    contents = [folder];
    remap();
  }
  
  override public function update():Void {
    super.update();
    folder.wm = wm;
    if (!focused) {
      folder.selected = -1;
      folder.doUpdate = true;
    }
  }
}
