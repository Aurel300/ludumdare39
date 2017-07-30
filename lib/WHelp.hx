package lib;

import sk.thenet.FM;
import sk.thenet.ui.*;

class WHelp extends Window {
  static var PAGES:Array<String> = [
"Welcome to the walkthrough.

If you get stuck, *please*
think twice about consulting
this guide - solving the
puzzles yourself is a lot
more fun!
Feel free to close this
window if you like to play
without help.",
"Basic orientation

Behind this window is the
desktop. Should you ever
close an important window,
you can access everything
from there by double clicking
an icon.",
"Basic orientation

The icons represent:
- Your character portrait
- Game map
- Battery status
- This guide"
  ];
  
  public var el:EText;
  public var prev:EButtonText;
  public var next:EButtonText;
  public var cpage:Int;
  
  public function new() {
    super();
    this.id = "help";
    this.title = "Walkthrough";
    x = 30;
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
  
  override public function elementClick(dname:Array<String>, event:EDisplayClick):Void {
    switch (dname[0]) {
      case "prev": showPage(FM.maxI(0, cpage - 1));
      case "next": showPage(FM.minI(PAGES.length - 1, cpage + 1));
    }
  }
}
