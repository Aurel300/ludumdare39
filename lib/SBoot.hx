package lib;

import sk.thenet.app.*;
import sk.thenet.app.Keyboard.Key;
import sk.thenet.bmp.*;
import sk.thenet.plat.Platform;

class SBoot extends State {
  static var SEQUENCE = [
"~           Welcome to Aurel B%l&'s Ludum Dare 39 jam entry

$L<  BATTERYCORP  >
$A______________________________________________________________________

Click to boot up
",
"5~[$Hb.corp$A] sanity check ... 5 screws loose, environment sane enough",
"10~[$Hb.corp$A] boot options:",
"8~ - optical disk drive
 - $Imyopic disk drive (cannot see MDD)$A
 - magnetic tape drive",
"5~[$Hb.smtp$A] SMTP deemon might be needed",
"9~ - floppy hard drive
 - hard wobbly drive
 - army boots (G.I.)",
"10~[$Hb.corp$A] booting from HWD (C:\\nosey\\smiley)",
"15~[$Jb.corp$A] $Iwarning: power leaks detected on POST$A",
"10~[$Bb.corp$A] $Idetected leaks:$A",
"8~ - sector 3 // cylinder 31 // track 20 // page 15 // line 2 // word 3",
"1~ - sector 1 // cylinder 20 // track 40 // page 1.5 // line 21 // word 3",
"5~[$Hb.smtp$A] SMTP deamon found",
"8~ - sector 4 // cylinder 17 // track 20 // page .15 // line 2 // word e",
"4~ - sector 1 // cylinder 5 // track 70 // page 150. // line 11 // word h",
"8~ - sector 5 // cylinder B // track 20 // page 15 // line 21 // word 3",
"3~ - sector 9 // cylinder 1 // track 20 // page 15. // line 2 // word t",
"2~ - sector 6 // cylinder 1 // track 30 // page 15.. // line 12 // word o",
"2~ - sector 2 // cylinder 2 // track 20 // page 15...0 // line 12 // word o",
"2~ - sector G // cylinder 3 // track 90 // page 15 // line 2 // word 3",
"5~[$Hb.smtp$A] SMTP damon launching",
"8~ - sector O // cylinder 5 // track 90 // page 1-15 // line 21 // word m",
"5~ - sector T // cylinder 8 // track 20 // page 2-15 // line 2 // word u",
"1~ - sector E // cylinder 13 // track 80 // page 3-15 // line 112 // word c",
"1~ - sector M // cylinder 21 // track 20 // page LOVE-15 // line 22 // word h",
"15~[$Hb.corp$A] deploying anti-leak measures ...",
"10~[$Hb.corp$A] $Ianti-leak measure 1 flooded$A",
"10~[$Hb.corp$A] $Ianti-leak measure 2 wet$A",
"5~[$Hb.smtp$A] SMTP daemon launched",
"11~[$Hb.corp$A] $Ianti-leak measure 3 too tired$A",
"4~[$Hb.corp$A] $Ianti-leak measure 4 drowned$A",
"11~[$Hb.corp$A] er .....",
"11~[$Hb.corp$A] r$Ior: leaks contaminated anti-leak measures$A",
"20~[$Hb.corp$A] contingency plan ...",
"2~.",
"3~.",
"4~.",
"5~.",
"6~.",
"5~.",
"~
Click to enter visual GUI"
    ];
  
  private var userInput:Bool;
  private var timer:Int;
  private var seqPos:Int;
  private var bmp:Bitmap;
  private var lines:Array<String>;
  
  public function new(app:Main) {
    super("boot", app);
  }
  
  override public function to():Void {
    bmp = Platform.createBitmap(800, 600, 0);
    userInput = true;
    timer = 0;
    seqPos = 0;
    lines = [];
    addLines();
  }
  
  function addLines():Void {
    if (seqPos >= SEQUENCE.length) {
      app.applyState(app.getStateById("main"));
      return;
    }
    var added = SEQUENCE[seqPos].split("\n");
    var lenSplit = added[0].split("~");
    added[0] = lenSplit.slice(1).join("~");
    if (lenSplit[0] == "") {
      userInput = true;
    } else {
      userInput = false;
      timer = Std.parseInt(lenSplit[0]);
    }
    lines = lines.concat(added);
    if (lines.length > 24) {
      lines = lines.slice(-24);
    }
    seqPos++;
  }
  
  override public function tick():Void {
    if (!userInput) {
      if (timer > 0) {
        timer--;
      } else {
        addLines();
      }
    }
    bmp.fill(Main.pal[4]);
    Main.font[0].render(bmp, 20, 20, lines.join("\n"), Main.font);
    app.bitmap.blitAlpha(bmp, 0, 0);
  }
  
  override public function mouseClick(mx:Int, my:Int):Void {
    if (userInput) {
      if (seqPos == 1) {
        Music.playTrack("intro");
      }
      Main.sound("beep");
      addLines();
    }
  }
}
