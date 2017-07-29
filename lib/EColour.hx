package lib;

import haxe.ds.Vector;
import sk.thenet.bmp.*;
import sk.thenet.plat.Platform;
import sk.thenet.ui.*;
import sk.thenet.ui.disp.Panel;
import sk.thenet.ui.DisplayBuilder.DisplayType;

class EColour extends UIElement {
  public var colour:Colour;
  private var lcolour:Colour;
  
  private var bmp:Bitmap;
  
  public function new(id:String, x:Int, y:Int, w:Int, h:Int, colour:Colour) {
    super(id, x, y);
    this.colour = colour;
    bmp = Platform.createBitmap(w, h, colour);
  }
  
  override public function update(el:Display):Void {
    if (colour != lcolour) {
      bmp.fill(colour);
      lcolour = colour;
    }
  }
  
  override public function tick(display:Display):Void {
    super.tick(display);
    update(display);
    (cast display:Panel).bmp = bmp;
  }
  
  override public function toUI():DisplayType {
    return Panel(bmp, [
         WithName(id)
        ,WithXY(x, y)
      ]);
  }
}
