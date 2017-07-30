package lib;

import sk.thenet.bmp.Bitmap;
import sk.thenet.ui.*;
import sk.thenet.ui.disp.Panel;
import sk.thenet.ui.DisplayBuilder.DisplayType;

class EFolder extends UIElement {
  public var iw:Int;
  public var ih:Int;
  public var icons:Array<Icon>;
  public var selected:Int;
  public var doUpdate:Bool;
  public var wm:SMain;
  public var draggedFrom:Int;
  public var draggedTo:Int;
  public var draggedIcon:Icon;
  public var dragFunc:EFolder->EFolder->Bool;
  public var doubleFunc:EFolder->Bool;
  
  public function new(
    id:String, x:Int, y:Int, iw:Int, ih:Int, icons:Array<Icon>
  ) {
    super(id, x, y);
    this.iw    = iw;
    this.ih    = ih;
    this.icons = icons;
    for (i in icons.length...iw * ih) {
      this.icons[i] = NONE;
    }
    selected = -1;
    doUpdate = true;
    draggedFrom = -1;
    draggedTo = -1;
    draggedIcon = NONE;
  }
  
  private function iconIndex(dname:Array<String>):Int {
    if (dname[0] == "folder") {
      dname.shift();
    }
    if (dname.length < 1) {
      return -1;
    }
    return Std.parseInt(dname[0].substr(4));
  }
  
  override public function click(dname:Array<String>, event:EDisplayClick):Void {
    var index = iconIndex(dname);
    if (index == -1 || icons[index] == NONE) {
      selected = -1;
      doUpdate = true;
      return;
    }
    selected = index;
    if (event.double && doubleFunc != null) {
      if (doubleFunc(this)) {
        selected = -1;
      }
    }
    doUpdate = true;
  }
  
  override public function drag(dname:Array<String>, event:EDisplayDrag):Void {
    var index = iconIndex(dname);
    if (index == -1 || icons[index] == NONE) {
      return;
    }
    if (wm.ui.cursors.length == 1) {
      draggedFrom = index;
      draggedIcon = icons[index];
      wm.ui.cursors.unshift(new Cursor(Interface.icons[icons[index]], -event.offX, -event.offY));
      wm.dragFrom = this;
      icons[index] = NONE;
    }
    selected = index;
    doUpdate = true;
  }
  
  override public function update(display:Display):Void {
    display.w = iw * 20;
    display.h = ih * 20;
    for (i in 0...icons.length) {
      (cast display.children[i]:Panel).bmp
        = (i == selected ? Interface.iconsSel : Interface.icons)[icons[i]];
    }
  }
  
  public function acceptDrop(onto:EFolder):Void {
    wm.ui.cursors.shift();
    wm.dragFrom = null;
    doUpdate = true;
    selected = -1;
    if (onto == null) {
      cancelDrag();
      return;
    }
    if (dragFunc != null) {
      if (dragFunc(this, onto)) {
        cancelDrag();
      }
      return;
    }
    onto.icons[onto.draggedTo] = draggedIcon;
    onto.selected = onto.draggedTo;
    onto.doUpdate = true;
    draggedFrom = -1;
    draggedIcon = NONE;
  }
  
  public function cancelDrag(?defocus:Bool = false):Void {
    icons[draggedFrom] = draggedIcon;
    if (!defocus) {
      selected = draggedFrom;
    }
    draggedFrom = -1;
    draggedIcon = NONE;
  }
  
  override public function tick(display:Display):Void {
    super.tick(display);
    if (doUpdate) {
      update(display);
      doUpdate = false;
    }
  }
  
  override public function toUI():DisplayType {
    return Panel(null, [
         WithName(id)
        ,WithXY(x, y)
        ,Table(iw, 20, 20, [ for (i in 0...icons.length)
            Panel(Interface.icons[icons[i]], [WithName('icon$i')])
          ])
      ]);
  }
  
  override public function drop(dname:Array<String>, event:EDisplayDrop):EFolder {
    var index = iconIndex(dname);
    if (index == -1 || (icons[index] != NONE && dragFunc == null)) {
      for (i in 0...icons.length) {
        if (icons[i] == NONE) {
          draggedTo = i;
          return this;
        }
      }
      return null;
    }
    draggedTo = index;
    return this;
  }
}
