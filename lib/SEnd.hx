package lib;

import sk.thenet.app.*;
import sk.thenet.app.Keyboard.Key;
import sk.thenet.bmp.*;
import sk.thenet.plat.Platform;

class SEnd extends State {
  private var bmp:Bitmap;
  private var keybuf:Array<String>;
  private var endings:Array<Bool>;
  
  public function new(app:Main) {
    super("end", app);
    endings = [false, false, false, false];
  }
  
  override public function to():Void {
    bmp = Platform.createBitmap(800, 600, Main.pal[4]);
    keybuf = [];
    if (!endings[Story.ENDING - 1]) {
      Main.sound("fleep");
      endings[Story.ENDING - 1] = true;
    }
    if (Story.ENDING == 2) endings[0] = true;
    Main.font[0].render(bmp, 20, 20, "And that was ...

$MTHE " + (switch(Story.ENDING) {
        case 4:
"EGGSTRA LEEKS
$A______________________________________________________________________________
I see you are a man of good taste.

Enjoy the wreckroom.


";
        case 3:
"SECRET ENDING
$A______________________________________________________________________________
Wow, you even got this one. I wonder if you had to look through the
source code to get here?

Is there anything extra? Naah.

";
        case 2:
"GOOD ENDING
$A______________________________________________________________________________
Well done.

(Instructions for returning to the game would be here if you got the
bad ending, but you clearly don't need anything so S I L L Y .)

";
        case _:
"BAD ENDING
$A______________________________________________________________________________
There is more to do! (Not a whole lot though, don't be disappointed.)
If you want to try to get the good ending, type the following randomly
generated letter sequence:

  E  G  G  L  E  E  K
";
      }) + "
I hope you enjoyed my Ludum Dare 39 entry

$L<  BATTERYCORP  >
$A
Made in 72 hours with Haxe, plustd, and a lot of girlfriend support.
Thank you for playing!
(" + [ for (i in 0...4) (endings[i] ? '${i + 1}' : "-") ].join(" ") + ")"
+ (endings[0] && endings[1] && endings[2] && endings[3] ? " <-- all endings!" : ""), Main.font);
  }
  
  override public function tick():Void {
    app.bitmap.blitAlpha(bmp, 0, 0);
  }
  
  override public function keyUp(key:Key):Void {
    if (Keyboard.isCharacter(key)) {
      var char = Keyboard.getCharacter(key);
      if (char >= "a" && char <= "z") {
        keybuf.push(char);
        while (keybuf.length > 7) {
          keybuf.shift();
        }
        switch keybuf {
          case ["e", "g", "g", "s", "t", "r", "a"] if (Story.ENDING >= 2):
          Music.playTrack("wreckroom");
          Story.ENDING = 4;
          app.applyState(app.getStateById("end"));
          case ["e", "g", "g", "l", "e", "e", "k"]: app.applyState(app.getStateById("main"));
          case ([_, _, "s", "i", "l", "l", "y"]
            | [_, "s", "i", "l", "l", "y"]
            | ["s", "i", "l", "l", "y"]) if (Story.ENDING >= 2):
          Story.ENDING = 3;
          app.applyState(app.getStateById("end"));
          case _:
        }
      }
    }
  }
}
