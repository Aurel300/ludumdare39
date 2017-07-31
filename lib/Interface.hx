package lib;

import haxe.ds.Vector;
import sk.thenet.FM;
import sk.thenet.bmp.Bitmap;
import sk.thenet.bmp.manip.*;
import sk.thenet.geom.Point2DI;
import sk.thenet.plat.Platform;
import sk.thenet.ui.*;
import sk.thenet.ui.disp.*;
import sk.thenet.ui.DisplayBuilder.DisplayType;

class Interface {
  public static inline var FRAME_WIDTH = 10;
  public static inline var FRAME_HEIGHT = 18;
  
  public static var cursor:Cursor;
  public static var icons:Vector<Bitmap>;
  public static var iconsSel:Vector<Bitmap>;
  public static var iconsSmall:Vector<Bitmap>;
  
  static var cursors:Vector<Bitmap>;
  public static var bubble:Bitmap;
  public static var bubbleCut1:Point2DI;
  public static var bubbleCut2:Point2DI;
  public static var bubblePoint:Vector<Bitmap>;
  public static var textBG:Bitmap;
  static var frame:Bitmap;
  static var frameCut1:Point2DI;
  static var frameCut2:Point2DI;
  public static var buttonCut1:Point2DI;
  public static var buttonCut2:Point2DI;
  static var buttons:Map<String, Vector<Bitmap>>;
  static var buttonIcons:Map<String, Bitmap>;
  static var barBG:Bitmap;
  
  public static function init(itf:Bitmap):Void {
    var bf = itf.fluent;
    cursors = Vector.fromArrayCopy([ for (i in 0...4) bf >> new Cut(i * 16, 56, 16, 16) ]);
    cursor = new Cursor(cursors[0], -1, -2);
    bubble = bf >> new Cut(48, 8, 16, 16);
    bubbleCut1 = new Point2DI(5, 5);
    bubbleCut2 = new Point2DI(11, 11);
    bubblePoint = Vector.fromArrayCopy([ for (i in 0...2) bf >> new Cut(64, 8 + i * 8, 8, 8) ]);
    frame = bf >> new Cut(24, 8, 24, 24);
    frameCut1 = new Point2DI(5, 5);
    frameCut2 = new Point2DI(19, 19);
    buttonCut1 = new Point2DI(1, 1);
    buttonCut2 = new Point2DI(9, 9);
    var bg = bf >> new Cut(0, 32, 10, 10);
    var bgDown = bf >> new Cut(10, 32, 10, 10);
    buttonIcons = new Map();
    buttons = [
         "bg" => Vector.fromArrayCopy([bg, bgDown])
      ];
    var icopos = 0;
    for (key in ["close", "minimise", "left", "right", "down", "up"]) {
      buttonIcons[key] = bf >> new Cut(icopos, 42, 10, 10);
      buttons[key] = Vector.fromArrayCopy([
           bg >> new Copy() << new Blit(buttonIcons[key])
          ,bgDown >> new Copy() << new Blit(buttonIcons[key])
        ]);
      icopos += 10;
    }
    barBG = bf >> new Cut(20, 32, 10, 10);
    textBG = bf >> new Cut(30, 32, 10, 10);
    icons = new Vector<Bitmap>(Icon.ICON_COUNT);
    iconsSel = new Vector<Bitmap>(Icon.ICON_COUNT);
    iconsSmall = new Vector<Bitmap>(Icon.ICON_COUNT);
    icons[0] = Platform.createBitmap(16, 16, 0);
    iconsSel[0] = Platform.createBitmap(16, 16, Main.pal[7]);
    iconsSmall[0] = Platform.createBitmap(16, 16, 0);
    for (i in 1...Icon.ICON_COUNT) {
      icons[i] = bf >> new Cut(88 + ((i - 1) % 4) * 16, ((i - 1) >> 2) * 16, 16, 16);
      iconsSel[i] = Platform.createBitmap(16, 16, Main.pal[7]).fluent
        << new Blit(bf >> new Cut(88 + ((i - 1) % 4) * 16, ((i - 1) >> 2) * 16, 16, 16));
      iconsSmall[i] = bf >> new Cut(152 + ((i - 1) % 4) * 8, ((i - 1) >> 2) * 8, 8, 8);
    }
  }
  
  public static function button(w:Int, h:Int, ch:Array<DisplayType>):DisplayType {
    return BoxButton(
         buttons["bg"][0], buttons["bg"][0], buttons["bg"][1]
        ,buttonCut1, buttonCut2, w, h, ch
      );
  }
  
  public static function buttonIcon(w:Int, h:Int, icon:String, ch:Array<DisplayType>):DisplayType {
    return BoxButton(
         buttons[icon][0], buttons[icon][0], buttons[icon][1]
        ,buttonCut1, buttonCut2, w, h, ch
      );
  }
  
  public static function button10Icon(icon:String, ch:Array<DisplayType>):DisplayType {
    return Button(
         buttons[icon][0], buttons[icon][0], buttons[icon][1], ch
      );
  }
  
  public static function windowFrame(
    w:Int, h:Int, contentW:Int, contentH:Int, ch:Array<DisplayType>
  ):DisplayType {
    var scroll = contentW > w || contentH > h;
    return BoxPanel(frame, frameCut1, frameCut2, w + FRAME_WIDTH, h + FRAME_HEIGHT, [
         WithName("frame")
        ,Clip(w - (scroll ? 10 : 0), h - (scroll ? 10 : 0), [
             WithName("clip")
            ,WithXY(5, 13)
            ,Panel(null, ch)
          ])
        ,BoxPanel(barBG, buttonCut1, buttonCut2, FM.maxI(1, w - 30), 10, [
             WithXY(15, h + 3)
            ,WithShow(scroll)
          ])
        ,BoxPanel(barBG, buttonCut1, buttonCut2, 10, FM.maxI(1, h - 20), [
             WithXY(w - 5, 23)
            ,WithShow(scroll)
          ])
        ,button10Icon("left", [
             WithXY(5, h + 3)
            ,WithName("scrollLeft")
            ,WithShow(scroll)
          ])
        ,button10Icon("right", [
             WithXY(w - 15, h + 3)
            ,WithName("scrollRight")
            ,WithShow(scroll)
          ])
        ,button10Icon("bg", [
             WithXY(15, h + 3)
            ,WithName("scrollBarX")
            ,WithShow(scroll)
          ])
        ,button10Icon("up", [
             WithXY(w - 5, 13)
            ,WithName("scrollUp")
            ,WithShow(scroll)
          ])
        ,button10Icon("down", [
             WithXY(w - 5, h + 3)
            ,WithName("scrollDown")
            ,WithShow(scroll)
          ])
        ,button10Icon("bg", [
             WithXY(w - 5, 23)
            ,WithName("scrollBarY")
            ,WithShow(scroll)
          ])
      ]);
  }
  
  public static function windowTitle(
    icon:Icon, title:String, focused:Bool, minimisable:Bool, closable:Bool, w:Int
  ):DisplayType {
    var text = Platform.createBitmap(FM.maxI(w - 5 - (closable ? 10 : 0) - (minimisable ? 10 : 0), 1), 10, 0);
    Main.font[5].render(text, 0, 0, title);
    return SolidPanel(Main.pal[focused ? 7 : 6], w + 4, 10, [
         WithName("title")
        ,WithXY(3, 3)
        ,Panel(iconsSmall[icon], [
            WithXY(1, 1)
          ])
        ,Panel(text, [
            WithXY(9, 0)
          ])
      ].concat(closable ? [
        Button(buttons["close"][0], buttons["close"][0], buttons["close"][1], [
             WithName("close")
            ,WithXY(w - 6, 0)
          ])
      ] : []).concat(minimisable ? [
        Button(buttons["minimise"][0], buttons["minimise"][0], buttons["minimise"][1], [
             WithName("minimise")
            ,WithXY(w - 6 - (closable ? 10 : 0), 0)
          ])
      ] : []));
  }
  
  public static function updateWindowFrame(
    display:Display, minimised:Bool, w:Int, h:Int, contentW:Int, contentH:Int
  ):Void {
    var panel = (cast display:BoxPanel);
    panel.children[0].show = !minimised;
    if (minimised) {
      if (panel.h != 14) {
        panel.h = 14;
        panel.update();
      }
    } else {
      if (panel.h == 14) {
        panel.h = h + FRAME_HEIGHT;
        panel.update();
      }
      var scroll = contentW > w || contentH > h;
      panel.children[0].w = w - (scroll ? 10 : 0);
      panel.children[0].h = h - (scroll ? 10 : 0);
      for (i in 1...9) {
        panel.children[i].show = scroll;
      }
    }
  }
  
  public static function updateWindowTitle(
    display:Display, focused:Bool, w:Int
  ):Void {
    var panel = (cast display:SolidPanel);
    panel.colour = Main.pal[focused ? 7 : 6];
    panel.w = w + 4;
  }
  
  public static function updateWindowText(
    display:Display, title:String, w:Int
  ):Void {
    var text = Platform.createBitmap(FM.maxI(w - 25, 1), 10, 0);
    Main.font[5].render(text, 0, 0, title);
    (cast display.children[1]:Panel).bmp = text;
  }
}
