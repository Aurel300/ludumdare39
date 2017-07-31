package lib;

class EDesktop extends EFolder {
  public function new() {
    super("desktop", 5, 5, 1, 6, [Icon.FACE, Icon.SPEECH, Icon.MAP, Icon.BATTERY, Icon.BOOK, Icon.SETTINGS]);
    dragFunc = (_, _) -> { return true; };
    doubleFunc = (folder) -> {
      var win = Main.wm.getWindow(switch (folder.icons[folder.selected]) {
          case FACE: "portrait";
          case SPEECH: "story";
          case MAP: "map";
          case BATTERY: "battery";
          case BOOK: "help";
          case SETTINGS: "settings";
          case _: "";
        });
      if (win != null) {
        Main.wm.showWindow(win);
      }
      return true;
    };
    show = false;
  }
}
