import sk.thenet.app.*;
import sk.thenet.app.TNPreloader;
import sk.thenet.app.asset.Bind as AssetBind;
import sk.thenet.app.asset.Bitmap as AssetBitmap;
import sk.thenet.app.asset.Sound as AssetSound;
import sk.thenet.app.asset.Trigger as AssetTrigger;
import sk.thenet.bmp.*;
import sk.thenet.bmp.manip.Recolour;
import sk.thenet.plat.Platform;
import lib.*;

class Main extends Application {
  // Globals
  public static var am:AssetManager;
  public static var pal:Array<Colour>;
  public static var font:Array<Font>;
  public static var puzzles:Array<Puzzle>;
  public static var puzzlesMap:Map<String, Puzzle>;
  
  public static function main() Platform.boot(() -> new Main());
  
  public function new() {
    super([
         Framerate(30)
        ,Surface(400, 300, 1)
        ,Assets([
             Embed.getBitmap("console_font", "png/font.png")
            ,Embed.getBitmap("interface", "png/interface.png")
            ,Embed.getBitmap("face", "png/face.png")
            ,Embed.getBitmap("assembly", "png/assembly.png")
            ,new AssetTrigger("pal", ["interface"], (am, _) -> {
                var itf = am.getBitmap("interface");
                pal = [ for (i in 0...32) itf.get(i * 8, 0) ];
                return false;
              })
            ,new AssetBind(["console_font", "pal", "face", "assembly"], (am, _) -> {
                var raw = am.getBitmap("console_font").fluent;
                font = [ for (p in pal)
                    Font.makeMonospaced(
                         raw >> new Recolour(p)
                        ,32, 160
                        ,8, 16
                        ,32
                        ,-3, -5
                      )
                  ];
                Interface.init(am.getBitmap("interface"));
                WPortrait.init(am.getBitmap("face"));
                WAssembly.init(am.getBitmap("assembly"));
                return false;
              })
          ])
        ,Keyboard
        ,Mouse
      ]);
    Save.init();
    am = assetManager;
    puzzles = [
         new PLockpick(0)
        ,new PLockpick(1)
        ,new PLockpick(2)
        ,new PLockpick(3)
        ,new PLockpick(4)
        ,new PRapid(0)
        ,new PAssembly(0)
        ,new PAssembly(1)
      ];
    puzzlesMap = new Map<String, Puzzle>();
    for (p in puzzles) {
      puzzlesMap.set(p.id, p);
    }
    preloader = new TNPreloader(this, "main", true);
    addState(new SMain(this));
    mainLoop();
  }
}
