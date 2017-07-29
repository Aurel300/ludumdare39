import sk.thenet.app.*;

class SMain extends State {
  public function new(app:Main) {
    super("main", app);
  }
  
  override public function tick() {
    app.bitmap.fill(Main.pal[3]);
  }
}
