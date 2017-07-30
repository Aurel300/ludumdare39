package lib;

class WTest extends Window {
  public function new(x:Int, y:Int) {
    super();
    this.x = x;
    this.y = y;
    w = contentW = 256;
    h = contentH = 256;
    id = "test" + x;
    contents = [
        // new EButtonText("test", 5, 5, 80, 20, "bla")
        //,new ESlider("slider", 5, 30, 80, 20, true)
        new EBitmap("bmp", 0, 0, Main.am.getBitmap("story2"))
      ];
    remap();
  }
}
