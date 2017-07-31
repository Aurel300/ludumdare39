package lib;

import sk.thenet.bmp.Bitmap;
import sk.thenet.ui.*;
import sk.thenet.ui.disp.Panel;
import sk.thenet.ui.DisplayBuilder.DisplayType;

class EBitmap extends UIElement {
  public var bmp:Bitmap;
  public var h:Int;
  
  public function new(id:String, x:Int, y:Int, bmp:Bitmap) {
    super(id, x, y);
    h = -1;
    this.bmp = bmp;
  }
  
  override public function tick(display:Display):Void {
    super.tick(display);
    (cast display:Panel).bmp = bmp;
    if (h != -1) {
      display.h = h;
    } else {
      display.h = bmp.height;
    }
  }
  
  override public function toUI():DisplayType {
    return Panel(bmp, [
         WithName(id)
        ,WithXY(x, y)
      ]);
  }
}
