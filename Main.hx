import haxe.ds.Vector;
import sk.thenet.app.*;
import sk.thenet.app.TNPreloader;
import sk.thenet.app.asset.Bind as AssetBind;
import sk.thenet.app.asset.Bitmap as AssetBitmap;
import sk.thenet.app.asset.Sound as AssetSound;
import sk.thenet.app.asset.Trigger as AssetTrigger;
import sk.thenet.bmp.*;
import sk.thenet.bmp.manip.*;
import sk.thenet.plat.Platform;
import lib.*;

class Main extends Application {
  // Globals
  public static var am:AssetManager;
  public static var pal:Array<Colour>;
  public static var font:Array<Font>;
  public static var puzzles:Array<Puzzle>;
  public static var puzzlesMap:Map<String, Puzzle>;
  public static var wm:SMain;
  public static var volumeMusic:Float = 1;
  public static var volumeSound:Float = 1;
  
  public static function main() Platform.boot(() -> new Main());
  
  public static function sound(id:String):Void {
    Main.am.getSound(id).play(Once, volumeSound);
  }
  
  public function new() {
    var didInit = false;
    super([
         Framerate(30)
        ,Surface(400, 300, 1)
        ,Assets([
             Embed.getBitmap("console_font", "png/font.png")
            ,Embed.getBitmap("interface", "png/interface.png")
            ,Embed.getBitmap("face", "png/face.png")
            ,Embed.getBitmap("assembly", "png/assembly.png")
            ,Embed.getBitmap("story1", "png/story1.png")
            ,Embed.getBitmap("story2", "png/story2.png")
            ,Embed.getBitmap("story3", "png/story3.png")
            ,Embed.getBitmap("story4", "png/story4.png")
            ,Embed.getBitmap("story5", "png/story5.png")
            ,Embed.getBitmap("story6", "png/story6.png")
            ,Embed.getBitmap("story7", "png/story7.png")
            ,Embed.getBitmap("story8", "png/story8.png")
            ,Embed.getBitmap("story9", "png/story9.png")
            ,Embed.getSound("beep", "wav/beep.wav")
            ,Embed.getSound("boing", "wav/boing.wav")
            ,Embed.getSound("buppup", "wav/buppup.wav")
            ,Embed.getSound("fleep", "wav/fleep.wav")
            ,Embed.getSound("quillip", "wav/quillip.wav")
            ,Embed.getSound("tom", "wav/tom.wav")
            ,Embed.getSound("unlock", "wav/unlock.wav")
            ,Embed.getSound("wizzup", "wav/wizzup.wav")
            ,Embed.getSound("wizzupS", "wav/wizzupS.wav")
            ,Embed.getSound("wizzupI", "wav/wizzupI.wav")
            ,new AssetTrigger("pal", ["interface"], (am, _) -> {
                var itf = am.getBitmap("interface");
                pal = [ for (i in 0...11) itf.get(i * 8, 0) ];
                return false;
              })
            ,new AssetBind([
               "console_font", "pal", "face", "assembly"
              ,"story1", "story2", "story3", "story4", "story5"
              ,"story6", "story7", "story8", "story9"
            ], (am, _) -> {
                if (didInit) {
                  return false;
                }
                didInit = true;
                var raw = am.getBitmap("console_font").fluent;
                var itf = am.getBitmap("interface").fluent;
                font = [ for (p in pal)
                    Font.makeMonospaced(
                         raw >> new Recolour(p)
                        ,32, 160
                        ,8, 16
                        ,32
                        ,-3, -5
                      )
                  ];
                var bits = Vector.fromArrayCopy([ for (i in 0...16)
                    itf >> new Cut(72 + (i % 4) * 4, 8 + (i >> 2) * 4, 4, 4)
                  ]);
                for (italic in [false, true]) {
                  var bbig = Platform.createBitmap(raw.width * (italic ? 6 : 4), raw.height * 4, 0);
                  for (y in 0...3) for (x in 0...32) {
                    for (sy in 0...16) for (sx in 0...8) {
                      if (raw.get(x * 8 + sx, y * 16 + sy).ai != 0) {
                        bbig.fillRect(x * (italic ? 48 : 32) + sx * 4 + (italic ? 15 - sy : 0), (y * 16 + sy) * 4, 4, 4, Main.pal[0]);
                      } else {
                        var bitVal = 0;
                        bitVal |= (x != 31 && sx != 7 ?  (raw.get(x * 8 + sx + 1, y * 16 + sy).ai != 0 ? 1 : 0) : 0);
                        bitVal |= (y != 2  && sy != 15 ? (raw.get(x * 8 + sx, y * 16 + sy + 1).ai != 0 ? 2 : 0) : 0);
                        bitVal |= (x != 0  && sx != 0 ?  (raw.get(x * 8 + sx - 1, y * 16 + sy).ai != 0 ? 4 : 0) : 0);
                        bitVal |= (y != 0  && sy != 0 ?  (raw.get(x * 8 + sx, y * 16 + sy - 1).ai != 0 ? 8 : 0) : 0);
                        if (bitVal != 0) {
                          bbig.blitAlpha(bits[bitVal], x * (italic ? 48 : 32) + sx * 4 + (italic ? 15 - sy : 0), (y * 16 + sy) * 4);
                        }
                      }
                    }
                  }
                  var f = Font.makeMonospaced(
                       bbig
                      ,32, 160
                      ,italic ? 48 : 32, 64
                      ,32
                      ,italic ? -28 : -12, -30
                    );
                  f.rects[2 * Font.RECT_SIZE + 4] = -5;
                  font.push(f);
                }
                Interface.init(itf);
                WAvoid.init(itf);
                WPortrait.init(am.getBitmap("face"));
                WAssembly.init(am.getBitmap("assembly"));
                Music.init();
                return false;
              })
          ])
        ,Keyboard
        ,Mouse
      ]);
    WHelp.init();
    puzzles = [
         new PLockpick(0)
        ,new PLockpick(1)
        ,new PLockpick(2)
        ,new PLockpick(3)
        ,new PLockpick(4)
        ,new PRapid(0)
        ,new PAssembly(0)
        ,new PAssembly(1)
        ,new PMaze(0)
        ,new PMaze(1)
        ,new PMaze(2)
        ,new PShake(0)
        ,new PAvoid(0)
      ];
    puzzlesMap = new Map<String, Puzzle>();
    for (p in puzzles) {
      puzzlesMap.set(p.id, p);
    }
    Save.init();
    Story.init();
    am = assetManager;
    preloader = new TNPreloader(this, "main", true);
    addState(new SBoot(this));
    addState(wm = new SMain(this));
    addState(new SEnd(this));
    mainLoop();
  }
}
