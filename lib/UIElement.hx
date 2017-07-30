package lib;

import sk.thenet.ui.*;
import sk.thenet.ui.DisplayBuilder.DisplayType;

class UIElement {
  public var id:String;
  public var x:Int;
  public var y:Int;
  public var show:Bool = true;
  
  public function new(id:String, x:Int, y:Int) {
    this.id = id;
    this.x = x;
    this.y = y;
  }
  
  public function toUI():DisplayType {
    return null;
  }
  
  public function tick(display:Display):Void {
    display.show = show;
  }
  
  public function click(dname:Array<String>, event:EDisplayClick):Void {}
  
  public function drag(dname:Array<String>, event:EDisplayDrag):Void {}
  
  public function drop(dname:Array<String>, event:EDisplayDrop):EFolder {
    return null;
  }
}
