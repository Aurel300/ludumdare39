package lib;

import sk.thenet.FM;
import sk.thenet.ui.*;

class WHelp extends Window {
  static var PAGES:Array<String> = [
"Welcome to the walkthrough

If you get stuck, *please*
think twice about consulting
this guide - solving the
puzzles yourself is a lot
more fun!
Feel free to close this
window if you'd like to play
without help.",
"Welcome to the walkthrough

Every window has a ? in its
top right. Press it to open
this guide on the relevant
page.",
"Basic orientation I

In the background there is
the desktop. Should you ever
close an important window,
you can access everything
from there by double clicking
an icon.",
"Basic orientation I

The icons represent:
- Your character portrait
- Current room
- Game map
- Battery status
- This guide",
"portrait%Your character portrait

Your portrait is based on
your username. This window
has no functionality.",
"story%Current room

This window shows the room
you are currently in.",
"map%Game map

This is how you move around
the world. You can drag and
drop yourself onto other
icons, e.g. doors, to
interact with them.",
"battery%Battery status

This window shows your
progress on your mission.
Solving every puzzle restores
some power units. Your goal
is to restore all 100 PU.",
"Puzzles

On the game map you can find
icons representing puzzles
that you can solve. Double
click a puzzle piece to start
solving the puzzle.
The following pages give
hints for the puzzles.",
"lockpk0%lockpk1%Lockpick I

Set the pins (sliders) to the
correct positions. The lock
will unlock when all sliders
are green.",
"lockpk2%lockpk3%Lockpick II

This time you have to move
the pins with your lockpick.
Move the horizontal slider to
access the correct pin, then
press the button to push it
up. Press reset if you push
a pin too far.",
"lockpk4%Lockpick III

Be quick, the pins now fall
down over time! You can
move pins above their target
position, then wait for them
to fall while you set the
other pins.",
"rapid%Rapid

Click the enabled buttons to
fill the progress bar.
Be quick!",
"assembly%Assembly

Move the windows around until
they form a single gadget.
The edges of the windows turn
green if you place them next
to their correct neighbour.",
"shake%Shake

While the sentence is a
logical paradox, it probably
cannot be agreed with.

   How can you express
   disagreement?",
"avoid%Avoid

A steady hand is required!
Click Start, then move to
Fix! while avoiding any black
bits."
  ];
  static var BOOKMARKS:Map<String, Int>;
  
  public static function init():Void {
    BOOKMARKS = new Map();
    PAGES = [ for (pi in 0...PAGES.length) {
        var ps = PAGES[pi].split("%");
        while (ps.length > 1) {
          BOOKMARKS.set(ps.shift(), pi);
        }
        ps[0];
      } ];
  }
  
  public var el:EText;
  public var prev:EButtonText;
  public var next:EButtonText;
  public var cpage:Int;
  
  public function new() {
    super();
    id = "help";
    title = "Walkthrough";
    x = 120;
    y = 30;
    w = contentW = 150;
    h = contentH = 150;
    icon = Icon.BOOK;
    close = () -> { show = false; };
    contents = [
         el = new EText("text", 2, 2, w - 4, h - 4, "")
        ,prev = new EButtonText("prev", 2, h - 14, 73, 12, "<<")
        ,next = new EButtonText("next", 75, h - 14, 73, 12, ">>")
      ];
    showPage(0);
    remap();
  }
  
  private function showPage(page:Int):Void {
    cpage = page;
    el.text = "$M W$A           (" + (page + 1) + " / " + PAGES.length + ")
            alkthrough
_______   ___________________
" + PAGES[page];
    prev.show = (cpage > 0);
    next.show = (cpage < PAGES.length - 1);
  }
  
  public function showHelp(id:String):Void {
    showPage(BOOKMARKS.get(id));
  }
  
  override public function elementClick(dname:Array<String>, event:EDisplayClick):Void {
    switch (dname[0]) {
      case "prev": showPage(FM.maxI(0, cpage - 1));
      case "next": showPage(FM.minI(PAGES.length - 1, cpage + 1));
    }
  }
}
