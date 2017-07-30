package lib;

import haxe.ds.Vector;
import sk.thenet.FM;
import sk.thenet.anim.Phaser;
import sk.thenet.bmp.*;
import sk.thenet.bmp.manip.*;
import sk.thenet.plat.Platform;
import sk.thenet.ui.*;

class WPortrait extends Window {
  static inline var SIZE = 32;
  static inline var MARGIN = 20;
  static inline var HSIZE = 16;
  static inline var HMARGIN = 10;
  
  static var EYES:Vector<Bitmap>;
  static var NOSE:Vector<Bitmap>;
  static var HAIR:Vector<Bitmap>;
  
  public static function init(face:Bitmap):Void {
    var ff = face.fluent;
    EYES = Vector.fromArrayCopy([ for (i in 0...8) {
        var eye = ff >> new Cut(i * 16, 0, 16, 16);
        var pair = Platform.createBitmap(32, 16, 0);
        pair.blitAlpha(eye, 0, 0);
        pair.blitAlpha(eye >> new Flip(), 16, 0);
        pair;
      } ]);
    NOSE = Vector.fromArrayCopy([ for (i in 0...8) {
        ff >> new Cut(i * 16, 16, 16, 16);
      } ]);
    HAIR = Vector.fromArrayCopy([ for (i in 0...4) {
        ff >> new Cut(i * 32, 32, 32, 16);
      } ]);
  }
  
  var bg:Bitmap;
  var phEyes:Phaser;
  var phNose:Phaser;
  var phHair:Phaser;
  var dragX:Int;
  var dragY:Int;
  
  public function new() {
    super();
    x = 320;
    y = 150;
    w = h = contentW = contentH = SIZE + MARGIN;
    id = "portrait";
    title = "Face";
    icon = Icon.FACE;
    dragX = dragY = 0;
    phEyes = Phaser.linear(64, 32);
    phNose = Phaser.linear(64, 32);
    phNose.phase = 10;
    phHair = Phaser.linear(64, 32);
    phHair.phase = 14;
    bg = Platform.createBitmap(SIZE + MARGIN, SIZE + MARGIN, 0);
    close = () -> { show = false; };
    createBG();
    contents = [
        new EBitmap("bmp", 0, 0, bg)
      ];
    remap();
  }
  
  function createBG():Void {
    var vec = new Vector<Colour>(SIZE * SIZE);
    var i = 0;
    var shift = [0, 2, 1, 3];
    var shift2 = OrderedDither.BAYER_4;
    for (y in 0...SIZE) for (x in 0...SIZE) {
      var dx = x - HSIZE;
      var dy = y - HSIZE;
      var dist = FM.floor(Math.sqrt(dx * dx + dy * dy)) + (shift2[(y % 4) * 4 + (x % 4)] >> 2);
      vec[i] = Main.pal[dist > 15 ? 3 : (x + shift[y % 4] < HSIZE ? 5 : 4)];
      i++;
    }
    bg.fill(Main.pal[3]);
    bg.setVectorRect(HMARGIN, HMARGIN, SIZE, SIZE, vec);
    bg.blitAlpha(HAIR[Save.faceHair], HMARGIN - dragX, 7 + phHair.get(true) - dragY);
    dragX >>= 1;
    dragY >>= 1;
    bg.blitAlpha(EYES[Save.faceEyes], HMARGIN - dragX, HMARGIN + 7 + phEyes.get(true) - dragY);
    bg.blitAlpha(NOSE[Save.faceNose], HMARGIN + 8 - dragX, HMARGIN + 11 + phNose.get(true) - dragY);
  }
  
  override public function drag(rx:Int, ry:Int):Void {
    dragX += (rx >> 1);
    dragY += (ry >> 1);
  }
  
  override public function tick():Void {
    super.tick();
    createBG();
  }
}
