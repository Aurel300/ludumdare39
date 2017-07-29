package lib;

import haxe.ds.Vector;
import sk.thenet.FM;
import sk.thenet.bmp.*;
import sk.thenet.bmp.manip.*;
import sk.thenet.plat.Platform;

class WAssembly extends Window {
  public static inline var SCALE:Int = 3;
  public static inline var BLOCK:Int = SCALE * 8;
  
  public static var pieces:Vector<Vector<Bitmap>>;
  
  public static function init(assembly:Bitmap):Void {
    PAssembly.init();
    var bf = assembly.fluent;
    var pal = Vector.fromArrayCopy(Main.pal.slice(0, 6));
    function piece(x:Int, y:Int, w:Int, h:Int):Bitmap {
      var ovec = (bf >> new Cut(x, y, w, h)).bitmap.getVector();
      var vec = new Vector<Colour>(ovec.length * SCALE * SCALE);
      for (y in 0...h) for (x in 0...w) {
        var c = Colour.quantise(ovec[y * w + x], pal);
        for (sy in 0...SCALE) for (sx in 0...SCALE) {
          if (FM.prng.nextFloat() > .3 * (1 + sx) * (1 + sy)) {
            c = FM.clampI(c + FM.prng.nextMod(3) - 1, 0, 5);
          } else if (FM.prng.nextFloat() > .95 * (1 + sx) * (1 + sy)) {
            c = Colour.quantise(ovec[
              FM.clampI(y + FM.prng.nextMod(3) - 1, 0, h - 1) * w
              + FM.clampI(x + FM.prng.nextMod(3) - 1, 0, w - 1)], pal);
          }
          vec[y * w * SCALE * SCALE + x * SCALE + sy * w * SCALE + sx] = pal[c];
        }
      }
      var ret = Platform.createBitmap(w * SCALE, h * SCALE, 0);
      ret.setVector(vec);
      return ret;
    }
    pieces = Vector.fromArrayCopy([ for (p in PAssembly.pieces)
        Vector.fromArrayCopy([ for (sp in p)
            piece(sp[0], sp[1], sp[2], sp[3])
          ])
      ]);
  }
  
  public var puzzle:PAssembly;
  public var part:Int;
  public var bmp:Bitmap;
  
  public function new(puzzle:PAssembly, part:Int) {
    super();
    this.puzzle = puzzle;
    this.part = part;
    x = y = 50 + part * 20;
    w = contentW = pieces[puzzle.num][part].width;
    h = contentH = pieces[puzzle.num][part].height;
    id = "assembly" + part;
    title = '${puzzle.id}.pzl';
    icon = Icon.KEY;
    bmp = pieces[puzzle.num][part].fluent >> new Copy();
    contents = [
        new EBitmap(null, 0, 0, bmp)
      ];
    remap();
  }
  
  override public function drag(rx:Int, ry:Int):Void {
    puzzle.check();
  }
  
  public function edgeVert(off:Int, size:Int, right:Bool, correct:Bool):Void {
    bmp.fillRect(right ? w - 2 : 0, 2 + off * BLOCK, 2, size * BLOCK - 4, Main.pal[correct ? 9 : 8]);
  }
  
  public function edgeHori(off:Int, size:Int, down:Bool, correct:Bool):Void {
    bmp.fillRect(2 + off * BLOCK, down ? h - 2 : 0, size * BLOCK - 4, 2, Main.pal[correct ? 9 : 8]);
  }
}
