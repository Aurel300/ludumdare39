package lib;

import haxe.ds.Vector;
import sk.thenet.FM;
import sk.thenet.anim.Phaser;
import sk.thenet.bmp.Bitmap;
import sk.thenet.bmp.manip.*;
import sk.thenet.plat.Platform;
import sk.thenet.ui.*;

class WAvoid extends Window {
  static var avoidBmp:Bitmap;
  
  public static function init(itf:Bitmap):Void {
    var bits = Vector.fromArrayCopy([ for (i in 0...16)
        itf.fluent >> new Cut(72 + (i % 4) * 4, 24 + (i >> 2) * 4, 4, 4)
      ]);
    avoidBmp = Platform.createBitmap(128, 96, 0);
    var raw = itf.fluent >> new Cut(0, 72, 32, 24);
    for (y in 0...24) for (x in 0...32) {
      if (raw.get(x, y).ai == 0) {
        var bitVal = 0;
        bitVal |= (x != 31 ? (raw.get(x + 1, y    ).ai == 0 ? 1 : 0) : 0);
        bitVal |= (y != 23 ? (raw.get(x,     y + 1).ai == 0 ? 2 : 0) : 0);
        bitVal |= (x != 0  ? (raw.get(x - 1, y    ).ai == 0 ? 4 : 0) : 0);
        bitVal |= (y != 0  ? (raw.get(x,     y - 1).ai == 0 ? 8 : 0) : 0);
        if (bitVal != 0) {
          avoidBmp.blitAlpha(bits[bitVal], x * 4, y * 4);
        }
      }
    }
  }
  
  public var puzzle:PAvoid;
  public var start:EButtonText;
  public var startDisable:EDisable;
  public var final:EButtonText;
  public var finalDisable:EDisable;
  public var game:Bool;
  
  public function new(puzzle:PAvoid) {
    super();
    this.puzzle = puzzle;
    x = 50;
    y = 40;
    w = contentW = 128;
    h = contentH = 96;
    game = false;
    id = "avoid";
    help = "avoid";
    title = '${puzzle.id}.pzl';
    icon = Icon.PUZZLE;
    close = puzzle.stop;
    contents = [
         new EBitmap("bg", 0, 0, avoidBmp)
        ,start = new EButtonText("start", 11 * 4 + 2, 6 * 4, 9 * 4, 15, "Start")
        ,startDisable = new EDisable("startdis", 11 * 4 + 2, 6 * 4, 9 * 4, 15)
        ,final = new EButtonText("unlock", 1, 20 * 4, 126, 15, "Fix!")
        ,finalDisable = new EDisable("finaldis", 1, 20 * 4, 126, 15)
      ];
    remap();
    check();
  }
  
  @:access(sk.thenet.ui.UI)
  private function check():Void {
    if (game) {
      startDisable.show = true;
      finalDisable.show = false;
      var lmx:Int = Main.wm.ui.lmx - (this.x + 5);
      var lmy:Int = Main.wm.ui.lmy - (this.y + 13);
      if (FM.withinI(lmx, 0, avoidBmp.width - 1) && FM.withinI(lmy, 0, avoidBmp.height - 1)) {
        if (avoidBmp.get(lmx, lmy).ai != 0) {
          Main.sound("quillip");
          game = false;
        }
      }
    }
    if (!game) {
      startDisable.show = false;
      finalDisable.show = true;
    }
  }
  
  override public function tick():Void {
    check();
    super.tick();
  }
  
  override public function elementClick(dname:Array<String>, event:EDisplayClick):Void {
    switch (dname[0]) {
      case "start":
      game = true;
      
      case "unlock":
      game = false;
      puzzle.solve();
    }
  }
}
