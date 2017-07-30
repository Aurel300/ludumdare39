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
  public var contentsMap:Map<String, UIElement>;
  public var contentW:Int;
  public var contentH:Int;
  
  public var wm:SMain;
  public var displayCh:Array<Display>;
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
    icon = Icon.DOCUMENT;
    x = 10;
    y = 10;
    w = contentW = 300;
    h = contentH = 100;
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
  
  public function tick():Void {
    if (displayCh == null) {
      return;
    }
    for (c in displayCh) {
      contentsMap.get(c.name).tick(c);
    }
  }
  
  private function remap():Void {
    contentsMap = new Map<String, UIElement>();
    for (c in contents) {
      contentsMap.set(c.id, c);
    }
  }
  
  public function update():Void {
    display.x = x;
    display.y = y;
    Interface.updateWindowTitle(display.children[1], focused, w);
  }
  
  public function toUI():Display {
    display = DisplayBuilder.build([
        Panel(null, [
             WithName(id)
            ,WithXY(x, y)
            ,Interface.windowFrame(w, h, contentW, contentH, [ for (c in contents) c.toUI() ])
            ,Interface.windowTitle(icon, title, focused, minimisable, closable, w)
          ])
      ])[0];
    display.children[0].children[0].children[0].sort = false;
    displayCh = display.children[0].children[0].children[0].children;
    return display;
  }
  
  public function drag(rx:Int, ry:Int):Void {}
  
  public function elementClick(dname:Array<String>, event:EDisplayClick):Void {
    for (c in contents) {
      if (c.id == dname[0]) {
        c.click(dname, event);
        break;
      }
    }
  }
  
  public function elementDrag(dname:Array<String>, event:EDisplayDrag):Void {
    for (c in contents) {
      if (c.id == dname[0]) {
        c.drag(dname, event);
        break;
      }
    }
  }
  
  public function elementDrop(dname:Array<String>, event:EDisplayDrop):EFolder {
    for (c in contents) {
      if (c.id == dname[0]) {
        return c.drop(dname, event);
        break;
      }
    }
    return null;
  }
}
