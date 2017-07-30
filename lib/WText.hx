package lib;

class WText extends Window {
  public var el:EText;
  
  public function new(id:String, title:String, x:Int, y:Int, text:String, ?w:Int = 150, ?h:Int = 80) {
    super();
    this.id = id;
    this.title = title;
    this.x = x;
    this.y = y;
    this.w = contentW = w;
    this.h = h;
    icon = Icon.DOCUMENT;
    el = new EText("text", 2, 2, w - 4, h - 4, text);
    contentH = el.textHeight;
    contents = [el];
    remap();
  }
  
  override public function tick():Void {
    contentH = el.textHeight;
    super.tick();
  }
}
