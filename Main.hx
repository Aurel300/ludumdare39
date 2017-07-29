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
  
  public static function main() Platform.boot(() -> new Main());
  
  public function new() {
    super([
         Framerate(60)
        ,Surface(400, 300, 1)
        ,Assets([
             Embed.getBitmap("console_font", "png/font.png")
            ,Embed.getBitmap("interface", "png/interface.png")
            ,Embed.getBitmap("icons", "png/icons.png")
            ,new AssetTrigger("pal", ["interface"], (am, _) -> {
                var itf = am.getBitmap("interface");
                pal = [ for (i in 0...32) itf.get(i * 8, 0) ];
                return false;
              })
            ,new AssetBind(["console_font", "pal", "icons"], (am, _) -> {
                var raw = am.getBitmap("console_font").fluent;
                font = [ for (p in pal)
                    Font.makeMonospaced(
                         raw >> new Recolour(p)
                        ,32, 160
                        ,8, 16
                        ,32
                        ,-3, 0
                      )
                  ];
                Interface.init(am.getBitmap("interface"), am.getBitmap("icons"));
                return false;
              })
          ])
        ,Keyboard
        ,Mouse
      ]);
    Main.am = assetManager;
    preloader = new TNPreloader(this, "main", true);
    addState(new SMain(this));
    mainLoop();
  }
}
