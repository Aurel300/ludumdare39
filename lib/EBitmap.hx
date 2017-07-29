package lib;

import sk.thenet.bmp.Bitmap;
import sk.thenet.ui.*;
import sk.thenet.ui.disp.Panel;
import sk.thenet.ui.DisplayBuilder.DisplayType;

class EBitmap extends UIElement {
  public var bmp:Bitmap;
  
  public function new(id:String, x:Int, y:Int, bmp:Bitmap) {
    super(id, x, y);
    this.bmp = bmp;
  }
  
  override public function update(el:Display):Void {
    (cast el:Panel).bmp = bmp;
  }
  
  override public function toUI():DisplayType {
    return Panel(bmp, [
         WithName(id)
        ,WithXY(x, y)
      ]);
  }
}
