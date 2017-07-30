package lib;

import sk.thenet.FM;

typedef Connect = {
     a:Int
    ,b:Int
    ,vert:Bool
    ,size:Int
    ,offA:Int
    ,offB:Int
  };

class PAssembly extends Puzzle {
  public static inline var TOLERANCE:Int = 5;
  
  public static var pieces:Array<Array<Array<Int>>>;
  public static var connects:Array<Array<Connect>>;
  
  public static function init():Void {
    pieces = [
        [
           [0, 8, 16, 24]
          ,[16, 8, 24, 16]
          ,[40, 0, 32, 32]
        ], [ for (y in 0...3) for (x in 0...3) if (y != 1 || x != 1)
          [72 + x * 24, y * 24, 24, 24]
        ]
      ].map(a -> [ for (i in 0...a.length) a[i].concat([i]) ]);
    connects = [
        [
           {a: 0, b: 1, vert: true, size: 2, offA: 0, offB: 0}
          ,{a: 1, b: 2, vert: true, size: 2, offA: 0, offB: 1}
        ], [
           {a: 0, b: 1, vert: true, size: 3, offA: 0, offB: 0}
          ,{a: 1, b: 2, vert: true, size: 3, offA: 0, offB: 0}
          ,{a: 0, b: 3, vert: false, size: 3, offA: 0, offB: 0}
          ,{a: 2, b: 4, vert: false, size: 3, offA: 0, offB: 0}
          ,{a: 3, b: 5, vert: false, size: 3, offA: 0, offB: 0}
          ,{a: 4, b: 7, vert: false, size: 3, offA: 0, offB: 0}
          ,{a: 5, b: 6, vert: true, size: 3, offA: 0, offB: 0}
          ,{a: 6, b: 7, vert: true, size: 3, offA: 0, offB: 0}
        ]
      ];
    pieces[0] = [1, 0, 2].map(i -> pieces[0][i]);
    pieces[1] = [1, 3, 7, 0, 6, 2, 5, 4].map(i -> pieces[1][i]);
  }
  
  public var num:Int;
  public var windows:Array<WAssembly>;
  
  public function new(num:Int) {
    super('assmbl$num');
    this.num = num;
    switch (num) {
      case _:
    }
  }
  
  override public function spawn():Array<Window> {
    windows = [ for (i in 0...pieces[num].length) new WAssembly(this, i) ];
    check();
    return cast windows;
  }
  
  public function check():Void {
    var incorrect = 0;
    for (c in connects[num]) {
      var winA = null;
      var winB = null;
      for (w in windows) {
        if (c.a == pieces[num][w.part][4]) winA = w;
        if (c.b == pieces[num][w.part][4]) winB = w;
      }
      
      if (c.vert) {
        if (FM.absI(winB.x - (winA.x + 5 + winA.w)) < TOLERANCE
            && FM.absI((winB.y + c.offB * WAssembly.BLOCK) - (winA.y + c.offA * WAssembly.BLOCK)) < TOLERANCE) {
          winA.edgeVert(c.offA, c.size, true, true);
          winB.edgeVert(c.offB, c.size, false, true);
        } else {
          incorrect++;
          winA.edgeVert(c.offA, c.size, true, false);
          winB.edgeVert(c.offB, c.size, false, false);
        }
      } else {
        if (FM.absI(winB.y - (winA.y + 5 + winA.h)) < TOLERANCE
            && FM.absI((winB.x + c.offB * WAssembly.BLOCK) - (winA.x + c.offA * WAssembly.BLOCK)) < TOLERANCE) {
          winA.edgeHori(c.offA, c.size, true, true);
          winB.edgeHori(c.offB, c.size, false, true);
        } else {
          incorrect++;
          winA.edgeHori(c.offA, c.size, true, false);
          winB.edgeHori(c.offB, c.size, false, false);
        }
      }
    }
    if (incorrect == 0) {
      solve();
    }
  }
}
