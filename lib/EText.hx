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
  public var text(default, set):String;
  private function set_text(ntext:String):String {
    if (text == ntext) {
      return text;
    }
    text = ntext;
    bmp.fill(0);
    textHeight = Main.font[1].render(bmp, 0, 0, text, Main.font).y;
    if (textHeight > bmp.height) {
      bmp = Platform.createBitmap(w, textHeight, 0);
      textHeight = Main.font[1].render(bmp, 0, 0, text, Main.font).y;
    }
    return text;
  }
  
  public var textHeight:Int;
  
  private var bmp:Bitmap;
  
  public function new(id:String, x:Int, y:Int, w:Int, h:Int, text:String) {
    super(id, x, y);
    this.w = w;
    this.h = h;
    bmp = Platform.createBitmap(w, h, 0);
    set_text(text);
  }
  
  override public function toUI():DisplayType {
    return Panel(bmp, [
         WithName(id)
        ,WithXY(x, y)
      ]);
  }
  
  override public function tick(display:Display):Void {
    super.tick(display);
    (cast display:Panel).bmp = bmp;
  }
}
