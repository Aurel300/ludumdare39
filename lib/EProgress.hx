package lib;

import sk.thenet.FM;
import sk.thenet.bmp.Bitmap;
import sk.thenet.bmp.manip.*;
import sk.thenet.geom.Point2DI;
import sk.thenet.plat.Platform;
import sk.thenet.ui.*;
import sk.thenet.ui.disp.Button;
import sk.thenet.ui.DisplayBuilder.DisplayType;

class EProgress extends UIElement {
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
    var box = new Box(new Point2DI(1, 1), new Point2DI(9, 9), w, h);
    var itf = Main.am.getBitmap("interface").fluent;
    bg = itf >> new Cut(20, 32, 10, 10) >> box;
  }
  
  override public function tick(display:Display):Void {
    super.tick(display);
    if (vertical) {
      display.children[0].h = pos;
    } else {
      display.children[0].w = pos;
    }
  }
  
  override public function toUI():DisplayType {
    return Panel(bg, [
         WithName(id)
        ,WithXY(x, y)
        ,SolidPanel(Main.pal[7], w - 4, h - 4, [
             WithName("fill")
            ,WithXY(2, 2)
          ])
      ]);
  }
}
