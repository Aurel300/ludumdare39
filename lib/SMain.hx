package lib;

import sk.thenet.FM;
import sk.thenet.app.*;
import sk.thenet.ui.*;

class SMain extends State {
  static inline var SCREEN_WIDTH:Int = 400;
  static inline var SCREEN_HEIGHT:Int = 300;
  
  public var ui:UI;
  public var windows:Array<Window>;
  public var focused:Window;
  
  public function new(app:Main) {
    super("main", app);
    ui = new UI([]);
    ui.listen("displayclick", elementClick);
    ui.listen("displaydrag", elementDrag);
    windows = [];
    [
       new WTest(10, 10)
      ,new WTest(40, 40)
      ,new WTest(50, 20)
    ].map(updateWindow);
  }
  
  private function elementFocus(event:{display:Display}):Window {
    var dname = event.display.fullName.split(".");
    var window = getWindow(dname[0]);
    if (focused != window) {
      if (focused != null) {
        focused.focused = false;
        updateWindow(focused);
        focused = null;
      }
      focused = window;
      focused.focused = true;
      updateWindow(focused);
    }
    return focused;
  }
  
  private function elementClick(event:EDisplayClick):Bool {
    var window = elementFocus(event);
    var dname = event.display.fullName.split(".");
    if (dname.length == 3 && dname[1] == "title" && dname[2] == "close") {
      focused = null;
      removeWindow(window);
    }
    return true;
  }
  
  private function elementDrag(event:EDisplayDrag):Bool {
    if (event.rx == 0 && event.ry == 0) {
      return true;
    }
    var window = elementFocus(event);
    var dname = event.display.fullName.split(".");
    if (dname.length == 2 && dname[1] == "title") {
      window.x += event.rx;
      window.y += event.ry;
      window.x = FM.clampI(window.x, 0, SCREEN_WIDTH - window.w);
      window.y = FM.clampI(window.y, 0, SCREEN_HEIGHT - window.h);
      updateWindow(window);
    }
    return true;
  }
  
  private function getWindow(id:String):Window {
    for (w in windows) {
      if (w.id == id) {
        return w;
      }
    }
    return null;
  }
  
  private function updateWindow(win:Window):Void {
    if (ui.get(win.id) != null) {
      ui.list.remove(ui.get(win.id));
      if (win.focused) {
        windows.remove(win);
        windows.push(win);
      }
    } else {
      windows.push(win);
    }
    ui.list.push(win.toUI());
    reorder();
    ui.update();
  }
  
  private function removeWindow(win:Window):Void {
    if (ui.get(win.id) != null) {
      ui.list.remove(ui.get(win.id));
      windows.remove(win);
    }
    reorder();
    ui.update(); 
  }
  
  private function reorder():Void {
    for (z in 0...windows.length) {
      windows[z].z = z;
    }
  }
  
  override public function to() {
    ui.reset();
  }
  
  override public function tick() {
    app.bitmap.fill(Main.pal[3]);
    ui.render(app.bitmap);
  }
  
  override public function mouseMove(mx:Int, my:Int) {
    ui.mouseMove(mx, my);
  }
  
  override public function mouseDown(mx:Int, my:Int) {
    ui.mouseDown(mx, my);
  }
  
  override public function mouseUp(mx:Int, my:Int) {
    ui.mouseUp(mx, my);
  }
}
