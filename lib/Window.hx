package lib;

import sk.thenet.ui.*;

class Window {
  public var id:String;
  public var title:String;
  public var icon:Icon;
  public var x:Int;
  public var y:Int;
  public var w:Int;
  public var h:Int;
  public var focused:Bool;
  public var minimised:Bool;
  public var resizable:Bool;
  public var movable:Bool;
  public var minimisable:Bool;
  public var closable:Bool;
  public var wMin:Int;
  public var hMin:Int;
  public var wMax:Int;
  public var hMax:Int;
  public var contents:Array<UIElement>;
  
  public var display:Display;
  
  public var z(never, set):Int;
  private inline function set_z(z:Int):Int {
    if (display != null) {
      display.z = z;
    }
    return z;
  }
  
  public function new() {
    id = null;
    title = "Untitled";
    icon = Icon.NORMAL;
    x = 10;
    y = 10;
    w = 300;
    h = 100;
    focused = false;
    minimised = false;
    resizable = false;
    movable = true;
    minimisable = true;
    closable = true;
    wMin = 30;
    hMin = 30;
    wMax = 30;
    hMax = 30;
    contents = [];
  }
  
  public function toUI():Display {
    return display = DisplayBuilder.build([
        Panel(null, [
             WithName(id)
            ,WithXY(x, y)
            ,Interface.windowFrame(w, h, [ for (c in contents) c.toUI() ])
            ,Interface.windowTitle(icon, title, focused, minimisable, closable, w)
          ])
      ])[0];
  }
}
