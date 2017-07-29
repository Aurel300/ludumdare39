package lib;

import sk.thenet.FM;
import sk.thenet.bmp.Bitmap;
import sk.thenet.geom.Point2DI;
import sk.thenet.plat.Platform;
import sk.thenet.ui.*;
import sk.thenet.ui.disp.Panel;
import sk.thenet.ui.DisplayBuilder.DisplayType;

class EText extends UIElement {
  public var w:Int;
  public var h:Int;
  public var text:String;
  public var textHeight:Int;
  
  private var bmp:Bitmap;
  
  public function new(id:String, x:Int, y:Int, w:Int, h:Int, text:String) {
    super(id, x, y);
    this.w = w;
    this.h = h;
    this.text = text;
    bmp = Platform.createBitmap(w, h, 0);
    updateText();
  }
  
  private function updateText():Void {
    bmp.fill(0);
    textHeight = Main.font[0].render(bmp, 0, 0, text).y;
  }
  
  override public function update(el:Display):Void {
    updateText();
    (cast el:Panel).bmp = bmp;
  }
  
  override public function toUI():DisplayType {
    return Panel(bmp, [
         WithName(id)
        ,WithXY(x, y)
      ]);
  }
}
