package lib;

import sk.thenet.FM;
import sk.thenet.anim.Phaser;
import sk.thenet.ui.*;

class WShake extends Window {
  public var puzzle:PShake;
  public var prog:EProgress;
  public var final:EButtonText;
  
  public function new(puzzle:PShake) {
    super();
    this.puzzle = puzzle;
    x = y = 90;
    w = contentW = 120;
    h = contentH = 42;
    id = "shake";
    help = "shake";
    title = '${puzzle.id}.pzl';
    icon = Icon.FACE;
    close = puzzle.stop;
    contents = [
         prog = new EProgress("progress", 1, 1, 118, 20)
        ,final = new EButtonText("unlock", 1, 1, 118, 20, "Fix!")
        ,new EText("text", 1, 22, 118, 20, "Nod if you agree:
This sentence is false.")
      ];
    prog.pos = 1;
    final.show = false;
    remap();
    check();
  }
  
  private function check():Void {
    if (prog.pos >= 112) {
      final.show = true;
    }
  }
  
  override public function tick():Void {
    var port = (cast Main.wm.getWindow("portrait"):WPortrait);
    prog.pos = FM.clampI(prog.pos + (FM.absI(port.dragX) >> 2) - (FM.absI(port.dragY) >> 2), 1, 112);
    check();
    super.tick();
  }
  
  override public function elementClick(dname:Array<String>, event:EDisplayClick):Void {
    switch (dname[0]) {
      case "unlock":
      puzzle.solve();
    }
  }
}
