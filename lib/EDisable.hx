package lib;

import haxe.ds.Vector;
import sk.thenet.bmp.*;
import sk.thenet.plat.Platform;
import sk.thenet.ui.*;
import sk.thenet.ui.disp.Panel;
import sk.thenet.ui.DisplayBuilder.DisplayType;

class EDisable extends UIElement {
  public var bmp:Bitmap;
  
  public function new(id:String, x:Int, y:Int, w:Int, h:Int) {
    super(id, x, y);
    var vec = new Vector<Colour>(w * h);
    var vi = 0;
    for (iy in 0...h) for (ix in 0...w) {
      vec[vi] = ix % 2 == iy % 2 ? Main.pal[3] : 0;
      vi++;
    }
    bmp = Platform.createBitmap(w, h, 0);
    bmp.setVector(vec);
  }
  
  override public function toUI():DisplayType {
    return Panel(bmp, [
         WithName(id)
        ,WithXY(x, y)
      ]);
  }
}
