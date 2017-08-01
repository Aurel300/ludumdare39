package lib;

import sk.thenet.FM;
import sk.thenet.app.*;
import sk.thenet.app.Keyboard.Key;
import sk.thenet.ui.*;

class SMain extends State {
  public static inline var SCREEN_WIDTH:Int = 400;
  public static inline var SCREEN_HEIGHT:Int = 300;
  
  public var ui:UI;
  
  public var windows:Array<Window>;
  public var focused:Window;
  public var help:WHelp;
  public var lift:WLift;
  public var login:WLogin;
  public var story:WStory;
  public var settings:WSettings;
  
  public var desktop:EDesktop;
  public var bubble:EBubble;
  public var bubbleDisplay:Display;
  
  public var dragFrom:EFolder;
  public var overworld:PMaze;
  
  public var first:Bool = true;
  
  public function new(app:Main) {
    super("main", app);
    desktop = new EDesktop();
    bubble = new EBubble();
    overworld = (cast Main.puzzlesMap.get("maze0"):PMaze);
    overworld.locked = false;
    ui = new UI([]);
    ui.doubleClick = 15;
    ui.listen("displayclick", elementClick);
    ui.listen("displaydrag", elementDrag);
    ui.listen("displaydrop", elementDrop);
  }
  
  public function showHelp(id:String):Void {
    help.showHelp(id);
    showWindow(help);
  }
  
  public function startPuzzle(id:String):Void {
    var puzzle = Main.puzzlesMap.get(id);
    if (puzzle.locked) {
      Main.sound("beep");
      say(false, "That puzzle is locked!");
      return;
    }
    if (puzzle.solved) {
      say(false, "You have already solved that puzzle!");
      return;
    }
    if (Puzzle.solving >= 2) {
      say(false, "You are already solving a puzzle!");
      return;
    }
    puzzle.start();
  }
  
  public function unlockPuzzle(puzzle:String):Void {
    Main.puzzlesMap.get(puzzle).locked = false;
    overworld.updatePuzzle(puzzle);
  }
  
  public function solvePuzzle(puzzle:String):Void {
    if (Save.solved.indexOf(puzzle) == -1) {
      Main.sound("buppup");
      Save.solved.push(puzzle);
      Main.puzzlesMap.get(puzzle).solved = true;
      overworld.updatePuzzle(puzzle);
    }
  }
  
  public function say(player:Bool, text:String, ?origin:String):Void {
    ui.list.remove(bubbleDisplay);
    if (player) {
      var win = getWindow("portrait");
      win.show = true;
      focusWindow(win);
      bubble.setXY(win.x, win.y);
      WPortrait.talking = true;
    } else if (origin == null) {
      bubble.setXY(0, 50);
    }
    bubble.say(player, text, player ? Save.username : origin);
    ui.list.push(bubbleDisplay);
  }
  
  public function clickThrough():Void {
    ui.list.remove(bubbleDisplay);
    bubble.setXY(0, 310);
    bubble.say(false, "$D(click anywhere to continue)", null);
    ui.list.push(bubbleDisplay);
  }
  
  public function showWindow(win:Window):Void {
    if (win == null) {
      return;
    }
    win.show = true;
    focusWindow(win);
    if (focused.minimised) {
      focused.minimise();
      clampWindow(win);
      updateWindow(focused);
    }
  }
  
  public function focusWindow(win:Window):Void {
    if (focused != win) {
      if (focused != null) {
        focused.focused = false;
        updateWindow(focused);
        focused = null;
      }
      focused = win;
      focused.focused = true;
      updateWindow(focused);
    }
  }
  
  public function clampWindow(win:Window):Void {
    win.x = FM.clampI(win.x, 0, SCREEN_WIDTH - win.w - Interface.FRAME_WIDTH);
    win.y = FM.clampI(win.y, 0, SCREEN_HEIGHT - (win.minimised ? -4 : win.h) - Interface.FRAME_HEIGHT);
  }
  
  private function elementFocus(event:{display:Display}):Window {
    var dname = event.display.fullName.split(".");
    var window = getWindow(dname[0]);
    focusWindow(window);
    return focused;
  }
  
  private function elementClick(event:EDisplayClick):Bool {
    var dname = event.display.fullName.split(".");
    if (dname.length < 1) {
      return true;
    }
    switch (dname[0]) {
      case "desktop":
      if (focused != null) {
        focused.focused = false;
        updateWindow(focused);
        focused = null;
      }
      desktop.click(dname.slice(1), event);
      return true;
      
      case "bubble":
      bubble.click(dname.slice(1), event);
      return true;
    }
    var window = elementFocus(event);
    switch dname {
      case [_, "title", "close"]: window.close();
      case [_, "title", "minimise"]:
      window.minimise();
      clampWindow(window);
      ui.update();
      case [_, "title", "help"]: showHelp(window.help);
      
      case [_, "frame", "scrollLeft"]: scrollWindow(window, -5, 0);
      case [_, "frame", "scrollRight"]: scrollWindow(window, 5, 0);
      case [_, "frame", "scrollUp"]: scrollWindow(window, 0, -5);
      case [_, "frame", "scrollDown"]: scrollWindow(window, 0, 5);
      
      case _ if (dname.length >= 4 && dname[2] == "clip"):
      window.elementClick(dname.slice(3), event);
    }
    return true;
  }
  
  private function elementDrag(event:EDisplayDrag):Bool {
    if (event.rx == 0 && event.ry == 0) {
      return true;
    }
    var dname = event.display.fullName.split(".");
    if (dname.length < 1) {
      return true;
    }
    switch (dname[0]) {
      case "desktop":
      if (focused != null) {
        focused.focused = false;
        updateWindow(focused);
        focused = null;
      }
      desktop.drag(dname.slice(1), event);
      return true;
      
      case "bubble":
      return true;
    }
    var window = elementFocus(event);
    switch dname {
      case [_, "title"]:
      if (!window.movable) {
        return true;
      }
      window.x += event.rx;
      window.y += event.ry;
      clampWindow(window);
      updateWindow(window);
      
      case [_, "frame", "scrollBarX"]: scrollWindow(window, event.rx, 0);
      case [_, "frame", "scrollBarY"]: scrollWindow(window, 0, event.ry);
      
      case _ if (dname.length >= 4 && dname[2] == "clip"):
      window.elementDrag(dname.slice(3), event);
    }
    return true;
  }
  
  public function elementDrop(event:EDisplayDrop):Bool {
    if (dragFrom == null) {
      return true;
    }
    var dname = event.display.fullName.split(".");
    if (dname[0] == "desktop") {
      if (focused != null) {
        focused.focused = false;
        updateWindow(focused);
        focused = null;
      }
      dragFrom.acceptDrop(desktop.drop(dname.slice(1), event));
      return true;
    }
    var window = elementFocus(event);
    switch dname {
      case _ if (dname.length >= 4 && dname[2] == "clip"):
      dragFrom.acceptDrop(window.elementDrop(dname.slice(3), event));
    }
    return true;
  }
  
  public function getWindow(id:String):Window {
    if (id == "map") {
      return overworld.playerWindow;
    }
    for (w in windows) {
      if (w.id == id) {
        return w;
      }
    }
    return null;
  }
  
  public function scrollWindow(win:Window, sx:Int, sy:Int):Void {
    var panel = ui.get(win.id + ".frame.clip").children[0];
    var scrollableX = win.contentW - (win.w - 10);
    var scrollableY = win.contentH - (win.h - 10);
    panel.x = FM.clampI(panel.x - sx, -scrollableX, 0);
    panel.y = FM.clampI(panel.y - sy, -scrollableY, 0);
    if (sx != 0) {
      ui.get(win.id + ".frame.scrollBarX").x = 15 + FM.floor((panel.x / -scrollableX) * (win.w - 40));
    } else if (sy != 0) {
      ui.get(win.id + ".frame.scrollBarY").y = 23 + FM.floor((panel.y / -scrollableY) * (win.h - 30));
    }
  }
  
  public function updateWindow(win:Window):Void {
    ui.list.push(if (ui.get(win.id) != null) {
        var rem = ui.get(win.id);
        ui.list.remove(rem);
        if (win.focused) {
          windows.remove(win);
          windows.push(win);
        }
        rem;
      } else {
        windows.push(win);
        win.toUI();
      });
    win.update();
    reorder();
    ui.update();
  }
  
  private function reorder():Void {
    for (z in 0...windows.length) {
      windows[z].z = z;
    }
  }
  
  override public function to() {
    if (!first) {
      overworld.enter("The lift");
      return;
    }
    first = false;
    ui.reset();
    ui.cursors = [Interface.cursor];
    ui.list = DisplayBuilder.build([
         desktop.toUI()
        ,bubble.toUI()
      ]);
    bubbleDisplay = ui.list[1];
    windows = [];
    [
       login = new WLogin()
      ,new WPortrait()
      ,new WBattery()
      ,help = new WHelp()
      ,story = new WStory()
      ,lift = new WLift()
      ,settings = new WSettings()
    ].map(updateWindow);
    for (p in Main.puzzles) {
      p.spawn().map(updateWindow);
    }
    showWindow(login);
    
    if (Main.DEBUG) {
      login.username = "aurel";
      login.doLogin();
    }
  }
  
  override public function tick() {
    if (!login.show && !bubble.show) {
      Story.tick();
      overworld.lastClicked = NONE;
    }
    desktop.tick(ui.list[0]);
    bubble.tick(bubbleDisplay);
    for (w in windows) {
      w.tick();
    }
    app.bitmap.fill(Main.pal[3]);
    ui.render(app.bitmap);
  }
  
  override public function mouseMove(mx:Int, my:Int) {
    if (FM.withinI(mx, 0, SCREEN_WIDTH - 1)
        && FM.withinI(my, 0, SCREEN_HEIGHT - 1)) {
      flash.ui.Mouse.hide();
    } else {
      flash.ui.Mouse.show();
    }
    ui.mouseMove(mx, my);
  }
  
  override public function mouseDown(mx:Int, my:Int) {
    ui.mouseDown(mx, my);
  }
  
  override public function mouseUp(mx:Int, my:Int) {
    ui.mouseUp(mx, my);
    if (dragFrom != null) {
      dragFrom.acceptDrop(null);
    }
  }
  
  override public function keyUp(key:Key) {
    if (login.show) {
      login.keyPress(key);
    }
  }
}
