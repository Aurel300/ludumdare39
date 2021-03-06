package lib;

import sk.thenet.FM;
import sk.thenet.bmp.Bitmap;
import sk.thenet.bmp.manip.*;
import sk.thenet.geom.Point2DI;
import sk.thenet.plat.Platform;
import sk.thenet.ui.*;
import sk.thenet.ui.disp.Button;
import sk.thenet.ui.DisplayBuilder.DisplayType;

class EButtonText extends UIElement {
  public var w:Int;
  public var h:Int;
  public var text(default, set):String;
  private function set_text(ntext:String):String {
    if (text == ntext) {
      return text;
    }
    text = ntext;
    var box = new Box(new Point2DI(1, 1), new Point2DI(9, 9), w, h);
    var itf = Main.am.getBitmap("interface").fluent;
    bmp = itf >> new Cut(0, 32, 10, 10) >> box;
    bmpDown = itf >> new Cut(10, 32, 10, 10) >> box;
    var textBmp = Platform.createBitmap(w, h, 0);
    var size = Main.font[0].render(textBmp, 0, 0, text);
    size.x = FM.minI(w, size.x);
    size.y = FM.minI(h, size.y - 3);
    bmp.blitAlphaRect(textBmp, (w - size.x) >> 1, (h - size.y) >> 1, 0, 0, size.x, size.y + 5);
    bmpDown.blitAlphaRect(textBmp, ((w - size.x) >> 1) + 1, ((h - size.y) >> 1) + 1, 0, 0, size.x, size.y + 5);
    return text;
  }
  
  private var bmp:Bitmap;
  private var bmpDown:Bitmap;
  
  public function new(id:String, x:Int, y:Int, w:Int, h:Int, text:String) {
    super(id, x, y);
    this.w = w;
    this.h = h;
    set_text(text);
  }
  
  override public function tick(display:Display):Void {
    super.tick(display);
    (cast display:Button).bmp = bmp;
    (cast display:Button).bmpOver = bmp;
    (cast display:Button).bmpDown = bmpDown;
  }
  
  override public function toUI():DisplayType {
    return Button(bmp, bmp, bmpDown, [
         WithName(id)
        ,WithXY(x, y)
      ]);
  }
}
