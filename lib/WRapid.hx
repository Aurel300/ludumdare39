package lib;

import sk.thenet.FM;
import sk.thenet.anim.Phaser;
import sk.thenet.ui.*;

class WRapid extends Window {
  public var puzzle:PRapid;
  
  private var fallPh:Phaser;
  
  public function new(puzzle:PRapid) {
    super();
    this.puzzle = puzzle;
    fallPh = Phaser.linear(4);
    x = y = 50;
    w = contentW = 150;
    h = contentH = 22;
    id = "rapid";
    title = '${puzzle.id}.pzl';
    icon = Icon.KEY;
    var prog = new EProgress("progress", 1, 1, 148, 20);
    contents.push(prog);
    prog.pos = 1;
    var i = 0;
    var xpos = 1;
    var ypos = 22;
    for (text in ["Fix", "Restore", "Unlock", "Repair", "Mend", "Patch"]) {
      contents.push(new EButtonText("fix" + i, xpos, ypos, 49, 15, text));
      contents.push(new EDisable("disable" + i, xpos, ypos, 49, 15));
      xpos += 49;
      if (i % 3 == 2) {
        xpos = 1;
        ypos += 16;
        h += 16;
      }
      i++;
    }
    var final = new EButtonText("unlock", 1, 1, 148, 20, "Fix!");
    final.show = false;
    contents.push(final);
    if (puzzle.instruct != null) {
      var text = new EText("instr", 0, ypos, 150, 150, puzzle.instruct);
      contents.push(text);
      h += text.textHeight;
    }
    remap();
    redisable();
    check();
  }
  
  private function redisable():Void {
    var hide:Array<Int> = [FM.prng.nextMod(6), FM.prng.nextMod(6)];
    for (i in 0...6) {
      contentsMap.get("disable" + i).show = (i == hide[0] || i == hide[1]);
    }
  }
  
  private function check():Void {
    var prog = (cast contentsMap.get("progress"):EProgress);
    if (prog.pos >= 142) {
      contentsMap.get("disable0").show
      = contentsMap.get("disable1").show
      = contentsMap.get("disable2").show
      = contentsMap.get("disable3").show
      = contentsMap.get("disable4").show
      = contentsMap.get("disable5").show = true;
      contentsMap.get("unlock").show = true;
    }
  }
  
  override public function tick():Void {
    if (fallPh.get() == 0) {
      var prog = (cast contentsMap.get("progress"):EProgress);
      prog.pos = FM.clampI(prog.pos - 1, 1, 144);
      check();
    }
    fallPh.tick();
    super.tick();
  }
  
  override public function elementClick(dname:Array<String>, event:EDisplayClick):Void {
    switch (dname[0]) {
      case "fix0" | "fix1" | "fix2" | "fix3" | "fix4" | "fix5":
      var prog = (cast contentsMap.get("progress"):EProgress);
      prog.pos = FM.clampI(prog.pos + 5, 1, 144);
      redisable();
      check();
      
      case "unlock":
      removeSelf();
      puzzle.solve();
    }
  }
}
