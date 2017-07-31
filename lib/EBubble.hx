package lib;

import sk.thenet.bmp.Bitmap;
import sk.thenet.plat.Platform;
import sk.thenet.ui.*;
import sk.thenet.ui.disp.Panel;
import sk.thenet.ui.disp.BoxPanel;
import sk.thenet.ui.DisplayBuilder.DisplayType;

class EBubble extends UIElement {
  static inline var BUBBLE_HEIGHT = 55;
  
  private var player:Bool;
  private var flip:Bool = false;
  private var bmp:Bitmap;
  private var text(default, set):String;
  private function set_text(ntext:String):String {
    if (text == ntext) {
      return text;
    }
    text = ntext;
    bmp.fill(0);
    Main.font[1].render(bmp, 0, 0, text, Main.font);
    return text;
  }
  
  public function new() {
    super("bubble", 0, 0);
    bmp = Platform.createBitmap(360, BUBBLE_HEIGHT - 10, 0);
    set_text("");
    show = false;
  }
  
  public function say(player:Bool, text:String, origin:String):Void {
    this.player = player;
    set_text(origin != null ? origin + " says: $D(click anywhere to continue)$A\n'" + text + "'" : text);
    show = true;
  }
  
  public function setXY(x:Int, y:Int):Void {
    this.x = x;
    flip = (y < BUBBLE_HEIGHT);
    if (flip) {
      this.y = y + BUBBLE_HEIGHT + 16;
    } else {
      this.y = y - BUBBLE_HEIGHT + 20;
    }
  }
  
  override public function tick(display:Display):Void {
    super.tick(display);
    display.w = SMain.SCREEN_WIDTH;
    display.h = SMain.SCREEN_HEIGHT;
    display.children[0].children[0].x = x + 10;
    display.children[0].children[0].y = (flip ? -7 : BUBBLE_HEIGHT - 1);
    (cast display.children[0].children[0]:Panel).bmp = Interface.bubblePoint[flip ? 1 : 0];
    display.children[0].children[0].show = player;
    display.children[0].y = y;
    
  }
  
  override public function toUI():DisplayType {
    return Panel(null, [
         WithName(id)
        ,BoxPanel(Interface.bubble, Interface.bubbleCut1, Interface.bubbleCut2, 380, BUBBLE_HEIGHT, [
             WithX(10)
            ,Panel(Interface.bubblePoint[0], [])
            ,Panel(bmp, [WithXY(10, 5)])
          ])
      ]);
  }
  
  override public function click(dname:Array<String>, event:EDisplayClick):Void {
    WPortrait.talking = false;
    show = false;
  }
}
