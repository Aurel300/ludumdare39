package lib;

class WTest extends Window {
  public function new(x:Int, y:Int) {
    super();
    this.x = x;
    this.y = y;
    id = "test" + x;
  }
}
