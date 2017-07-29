package lib;

import haxe.ds.Vector;
import sk.thenet.bmp.Bitmap;
import sk.thenet.bmp.manip.*;
import sk.thenet.geom.Point2DI;
import sk.thenet.plat.Platform;
import sk.thenet.ui.DisplayBuilder.DisplayType;

class Interface {
  static var frame:Bitmap;
  static var frameCut1:Point2DI;
  static var frameCut2:Point2DI;
  static var buttonClose:Bitmap;
  static var buttonCloseDown:Bitmap;
  static var buttonMinimise:Bitmap;
  static var buttonMinimiseDown:Bitmap;
  static var icons:Vector<Bitmap>;
  
  public static function init(itf:Bitmap, ico:Bitmap):Void {
    var bf = itf.fluent;
    frame = bf >> new Cut(24, 8, 24, 24);
    frameCut1 = new Point2DI(5, 5);
    frameCut2 = new Point2DI(19, 19);
    buttonClose = bf >> new Cut(0, 32, 10, 10);
    buttonCloseDown = bf >> new Cut(10, 32, 10, 10);
    var iconClose = bf >> new Cut(0, 42, 10, 10);
    buttonClose.blitAlpha(iconClose, 0, 0);
    buttonCloseDown.blitAlpha(iconClose, 0, 0);
    buttonMinimise = bf >> new Cut(0, 32, 10, 10);
    buttonMinimiseDown = bf >> new Cut(10, 32, 10, 10);
    var iconMinimise = bf >> new Cut(10, 42, 10, 10);
    buttonMinimise.blitAlpha(iconMinimise, 0, 0);
    buttonMinimiseDown.blitAlpha(iconMinimise, 0, 0);
    bf = ico.fluent;
    icons = new Vector<Bitmap>(8);
    for (i in 0...icons.length) {
      icons[i] = bf >> new Cut(i * 8, 0, 8, 8);
    }
  }
  
  public static function windowFrame(
    w:Int, h:Int, ch:Array<DisplayType>
  ):DisplayType {
    return BoxPanel(frame, frameCut1, frameCut2, w, h, ch);
  }
  
  public static function windowTitle(
    icon:Icon, title:String, focused:Bool, minimisable:Bool, closable:Bool, w:Int
  ):DisplayType {
    var text = Platform.createBitmap(w - 36, 10, 0);
    Main.font[5].render(text, 0, 0, title);
    return SolidPanel(Main.pal[focused ? 7 : 6], w - 6, 10, [
         WithName("title")
        ,WithXY(3, 3)
        ,Panel(icons[icon], [
            WithXY(1, 1)
          ])
        ,Panel(text, [
            WithXY(9, 0)
          ])
      ].concat(closable ? [
        Button(buttonClose, buttonClose, buttonCloseDown, [
             WithName("close")
            ,WithXY(w - 16, 0)
          ])
      ] : []).concat(minimisable ? [
        Button(buttonMinimise, buttonMinimise, buttonMinimiseDown, [
             WithName("minimise")
            ,WithXY(w - 16 - (closable ? 10 : 0), 0)
          ])
      ] : []));
  }
}
