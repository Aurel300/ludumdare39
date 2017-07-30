package lib;

import sk.thenet.FM;
import sk.thenet.anim.Phaser;
import sk.thenet.ui.*;

class WLockpick extends Window {
  public var puzzle:PLockpick;
  
  private var fallPh:Phaser;
  
  public function new(puzzle:PLockpick) {
    super();
    this.puzzle = puzzle;
    fallPh = Phaser.linear(24);
    x = y = 50;
    w = contentW = 150;
    h = contentH = 46;
    id = "lockpick";
    title = '${puzzle.id}.pzl';
    icon = Icon.KEY;
    var sxpos = (w >> 1) - puzzle.pins.length * 7;
    var xpos = sxpos;
    var ypos = 6;
    contents.push(new EButtonText("reset", xpos - 30, ypos + 8, 30, 20, "Reset"));
    for (pi in 0...puzzle.pins.length) {
      var s = new ESlider('slider$pi', xpos + 1, ypos, 12, 35, true);
      s.pos = 30;
      contents.push(s);
      contents.push(new EColour('status$pi', xpos + 1, ypos - 5, 12, 4, Main.pal[8]));
      xpos += 14;
    }
    contents.push(new EButtonText("unlock", xpos, ypos + 8, 30, 20, "Fix"));
    contents.push(new EDisable("disable", xpos, ypos + 8, 30, 20));
    ypos += 38;
    if (!puzzle.direct) {
      contents.push(new ESlider("lockselect", sxpos, ypos, puzzle.pins.length * 14, 12));
      contents.push(new EButtonText("lockpush", sxpos - 30, ypos - 7, 30, 20, "Push"));
      contents.push(new EDisable(null, sxpos, ypos - 38, puzzle.pins.length * 14, 35));
      h += 14;
      ypos += 14;
    }
    if (puzzle.instruct != null) {
      var text = new EText("instr", 0, ypos, 150, 150, puzzle.instruct);
      contents.push(text);
      h += text.textHeight;
    }
    remap();
    check();
  }
  
  private function check():Void {
    var incorrect = 0;
    for (pi in 0...puzzle.pins.length) {
      var slider = (cast contentsMap.get('slider$pi'):ESlider);
      var status = (cast contentsMap.get('status$pi'):EColour);
      if (FM.absI(slider.pos - puzzle.pins[pi]) < puzzle.tolerance) {
        status.colour = Main.pal[9];
      } else {
        status.colour = Main.pal[8];
        incorrect++;
      }
    }
    contentsMap.get("disable").show = (incorrect > 0);
  }
  
  override public function tick():Void {
    if (puzzle.fallSpeed > 0) {
      if (fallPh.get() == 0) {
        for (pi in 0...puzzle.pins.length) {
          var slider = (cast contentsMap.get('slider$pi'):ESlider);
          slider.pos = FM.minI(30, slider.pos + puzzle.fallSpeed);
        }
        check();
      }
      fallPh.tick();
    }
    super.tick();
  }
  
  override public function elementClick(dname:Array<String>, event:EDisplayClick):Void {
    switch (dname[0]) {
      case "reset":
      for (pi in 0...puzzle.pins.length) {
        (cast contentsMap.get('slider$pi'):ESlider).pos = 30;
      }
      check();
      
      case "lockpush":
      var pi = FM.floor((cast contentsMap.get("lockselect"):ESlider).pos / 14);
      var slider = (cast contentsMap.get('slider$pi'):ESlider);
      slider.pos = FM.maxI(0, slider.pos - 4);
      check();
      
      case "unlock":
      removeSelf();
      puzzle.solve();
    }
  }
  
  override public function elementDrag(dname:Array<String>, event:EDisplayDrag):Void {
    super.elementDrag(dname, event);
    check();
  }
}
