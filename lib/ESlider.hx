package lib;

import sk.thenet.FM;
import sk.thenet.bmp.Bitmap;
import sk.thenet.bmp.manip.*;
import sk.thenet.geom.Point2DI;
import sk.thenet.plat.Platform;
import sk.thenet.ui.*;
import sk.thenet.ui.disp.Button;
import sk.thenet.ui.DisplayBuilder.DisplayType;

class ESlider extends UIElement {
  public var w:Int;
  public var h:Int;
  public var vertical:Bool;
  public var pos:Int;
  
  private var bg:Bitmap;
  
  public function new(id:String, x:Int, y:Int, w:Int, h:Int, ?vertical:Bool = false) {
    super(id, x, y);
    this.w = w;
    this.h = h;
    this.vertical = vertical;
    pos = 0;
    updateBG();
  }
  
  private function updateBG():Void {
    var box = new Box(
         new Point2DI(1, 1), new Point2DI(9, 9)
        ,vertical ? 3 : w, vertical ? h : 3
      );
    var itf = Main.am.getBitmap("interface").fluent;
    bg = Platform.createBitmap(w, h, 0);
    bg.blitAlpha(
         itf >> new Cut(10, 32, 10, 10) >> box
        ,vertical ? ((w - 1) >> 1) : 0, vertical ? 0 : ((h - 1) >> 1)
      );
  }
  
  override public function tick(display:Display):Void {
    super.tick(display);
    if (vertical) {
      display.children[0].y = pos;
    } else {
      display.children[0].x = pos;
    }
  }
  
  override public function toUI():DisplayType {
    return Panel(bg, [
         WithName(id)
        ,WithXY(x, y)
        ,Interface.button(vertical ? w : 5, vertical ? 5 : h, [
            WithName("control")
          ])
      ]);
  }
  
  override public function drag(dname:Array<String>, event:EDisplayDrag):Void {
    if (dname.length > 1 && dname[1] == "control") {
      pos += (vertical ? event.ry : event.rx);
      pos = FM.clampI(pos, 0, vertical ? h - 5 : w - 5);
    }
  }
}
