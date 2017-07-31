package lib;

import sk.thenet.app.*;
import sk.thenet.app.Keyboard.Key;
import sk.thenet.bmp.*;
import sk.thenet.plat.Platform;

class SEnd extends State {
  private var bmp:Bitmap;
  private var keybuf:Array<String>;
  
  public function new(app:Main) {
    super("end", app);
  }
  
  override public function to():Void {
    bmp = Platform.createBitmap(800, 600, Main.pal[4]);
    keybuf = [];
    Main.font[0].render(bmp, 20, 20, (switch(Story.ENDING) {
        case 3:
"And that was ...

$MTHE SECRET ENDING
$A______________________________________________________________________________
Wow, you even got this one. I wonder if you had to look through the
source code to get here?




I hope you enjoyed my Ludum Dare 39 entry

$L<  BATTERYCORP  >
$A
Made in 72 hours with Haxe, plustd, and a lot of girlfriend support.
Thank you for playing!";
        case 2:
"And that was ...

$MTHE GOOD ENDING
$A______________________________________________________________________________
Well done.

(Instructions for returning to the game would be here if you got the
bad ending, but you clearly don't need anything so S I L L Y .)


I hope you enjoyed my Ludum Dare 39 entry

$L<  BATTERYCORP  >
$A
Made in 72 hours with Haxe, plustd, and a lot of girlfriend support.
Thank you for playing!";
        case _:
"And that was ...

$MTHE BAD ENDING
$A______________________________________________________________________________
There is more to do! (Not a whole lot though, don't be disappointed.)
If you want to try to get the good ending, type the following randomly
generated letter sequence:

  E  G  G  L  E  E  K

I hope you enjoyed my Ludum Dare 39 entry

$L<  BATTERYCORP  >
$A
Made in 72 hours with Haxe, plustd, and a lot of girlfriend support.
Thank you for playing!";
      }), Main.font);
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
