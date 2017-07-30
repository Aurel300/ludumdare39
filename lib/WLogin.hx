package lib;

import sk.thenet.FM;
import sk.thenet.anim.Phaser;
import sk.thenet.app.Keyboard;
import sk.thenet.app.Keyboard.Key;
import sk.thenet.bmp.manip.Box;
import sk.thenet.ui.*;

class WLogin extends Window {
  static var ALLOWED = "abcdefghijklmnopqrstuvwxyz".split("");
  
  public var username:String;
  
  private var blinkPh:Phaser;
  
  public function new() {
    super();
    blinkPh = Phaser.linear(30);
    w = contentW = 150;
    h = contentH = 110;
    x = (SMain.SCREEN_WIDTH - contentW - Interface.FRAME_WIDTH) >> 1;
    y = (SMain.SCREEN_HEIGHT - contentH - Interface.FRAME_HEIGHT) >> 1;
    id = "login";
    title = "batterycorp login";
    closable = false;
    minimisable = false;
    movable = false;
    icon = Icon.BATTERY;
    username = "";
    var nameBG = Interface.textBG.fluent >> new Box(Interface.buttonCut1, Interface.buttonCut2, 146, 20);
    contents = [
         new EText("label1", 2, 2, 146, 10, "Username:")
        ,new EBitmap("namebg", 2, 12, nameBG)
        ,new EText("username", 2, 18, 146, 16, "")
        ,new EColour("cursor", 4, 14, 1, 16, Main.pal[0])
        ,new EButtonText("login", 2, 32, 146, 20, "Login")
        ,new EDisable("logindisable", 2, 32, 146, 20)
        ,new EText("label2", 2, 54, 146, 10,
"Type your username. If you
forgot your username, we
sincerely apologise.")
      ];
    for (i in 0...9) {
      contents.push(new EBitmap('battery$i', 2 + i * 16, 90, Interface.icons[Icon.BATTERY]));
    }
    remap();
  }
  
  public function keyPress(key:Key):Void {
    if (key == Backspace) {
      username = username.substr(0, FM.maxI(0, username.length - 1));
    } else if (key == Enter) {
      if (username.length != 0) {
        doLogin();
      }
    } else if (Keyboard.isCharacter(key)) {
      var char = Keyboard.getCharacter(key);
      if (ALLOWED.indexOf(char) != -1) {
        username += char;
      }
    }
    if (username.length > 10) {
      username = username.substr(0, 10);
    }
    contentsMap.get("logindisable").show = (username.length == 0);
    (cast contentsMap.get("username"):EText).text = username;
  }
  
  override public function tick():Void {
    super.tick();
    (cast contentsMap.get("cursor"):EColour).colour = (blinkPh.get() < 15 ? Main.pal[4] : Main.pal[0]);
    var cpos = (cast contentsMap.get("username"):EText).textWidth;
    contentsMap.get("cursor").x = (username == "" ? 4 : cpos);
    blinkPh.tick();
  }
  
  private function doLogin():Void {
    Save.username = username;
    show = false;
    Main.wm.desktop.show = true;
  }
  
  override public function elementClick(dname:Array<String>, event:EDisplayClick):Void {
    switch (dname[0]) {
      case "login": doLogin();
    }
  }
}
