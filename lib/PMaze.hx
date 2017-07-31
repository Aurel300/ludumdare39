package lib;

typedef Room = {
     w:Int
    ,h:Int
    ,title:String
    ,icon:Icon
    ,icons:Array<RoomIcon>
    ,instruct:String
  };

enum RoomIcon {
  None;
  Goal;
  DoorTo(title:String);
  TrapdoorTo(title:String);
  Lift;
  Batterycorp;
  SpawnFrom(title:String);
  SpawnAny;
  Sharon;
  Plant;
  Key;
  Lock(unlocks:RoomIcon);
}

class PMaze extends Puzzle {
  public static var mazes:Array<Array<Room>>;
  
  public static function init():Void {
    mazes = [
        [
          {w: 4, h: 3, title: "Your office", icon: Icon.SPEECH, icons: [
             None, None, None, None
            ,None, SpawnFrom(""), Lift, None
            ,None, None, SpawnFrom("The lift"), None
          ], instruct: null}
          ,{w: 1, h: 1, title: "The lift", icon: Icon.LIFT, icons: [
            SpawnAny
          ], instruct: null}
          ,{w: 5, h: 2, title: "Dispatching", icon: Icon.SPEECH, icons: [
             Lift, None, None, Sharon, None
            ,SpawnFrom("The lift"), None, None, None, Plant
          ], instruct: null}
          ,{w: 3, h: 6, title: "Foyer", icon: Icon.SPEECH, icons: [
             None, Lift, None
            ,None, SpawnFrom("The lift"), None
            ,None, None, None
            ,None, None, None
            ,None, None, None
            ,Plant, DoorTo("The city"), Plant
          ], instruct: null}
          ,{w: 9, h: 4, title: "The city", icon: Icon.SPEECH, icons: [
             None, None, None, None, Batterycorp, None, None, None, None
            ,None, None, None, None, SpawnAny, None, None, None, None
            ,None, None, None, None, None, None, None, None, None
            ,None, None, None, None, None, None, None, None, None
          ], instruct: null}
        ], [
          {w: 3, h: 2, title: "Start", icon: Icon.KEY, icons: [
             SpawnFrom(""), None, None
            ,None, SpawnFrom("2"), DoorTo("2")
          ], instruct:
"$M\"\"M.A.Z.E
$A_____________________________
Welcome to the fusebox maze!
Drag yourself to the door
to continue."}
          ,{w: 2, h: 4, title: "2", icon: Icon.KEY, icons: [
             SpawnFrom("Start"), DoorTo("Start")
            ,None, None
            ,None, None
            ,TrapdoorTo("3"), None
          ], instruct:
"$M\"\" MA-ZE
$A_ _ _ _ _ _ _ _ _ _ _ _ _ _ _
Wow, you did it. You can go
back through the door next
to you, or use the trapdoor!"}
          ,{w: 5, h: 3, title: "3", icon: Icon.KEY, icons: [
             None, None, None, None, None
            ,None, SpawnFrom("2"), SpawnFrom("KEYROOM"), DoorTo("KEYROOM"), None
            ,None, None, None, None, None
          ], instruct:
"$M\"\" AMAZE!
$A. . . . . . . . . . . . . . .
No way back when you enter
a trapdoor. Remember that."}
          ,{w: 3, h: 3, title: "KEYROOM", icon: Icon.KEY, icons: [
             DoorTo("3"), None, DoorTo("LOCKROOM")
            ,SpawnFrom("3"), None, SpawnFrom("LOCKROOM")
            ,None, Key, None
          ], instruct:
"Collect the key by dragging
it onto yourself. Then unlock
locks with it. (Shocking!)
? ? ? ? ? ? ? ? ? ? ? ? ? ? ?
$M\"\"MAIZE?"}
          ,{w: 5, h: 1, title: "LOCKROOM", icon: Icon.KEY, icons: [
             DoorTo("KEYROOM"), SpawnFrom("KEYROOM"), None, None, Lock(Goal)
          ], instruct:
"Drag the key from your bag
to unlock the door. You can
double click yourself to
access your items.

       Yours mazingly, DM"}
        ]
      ];
  }
  
  public var num:Int;
  public var windows:Array<WFolder>;
  public var info:WText;
  public var inv:WFolder;
  public var state:Array<Room>;
  public var statePlayer:Int;
  
  public function new(num:Int) {
    super('maze$num');
  }
  
  inline function getIcon(r:RoomIcon):Icon {
    return (switch (r) {
        case None: NONE;
        case Goal: DOOR;
        case DoorTo(_): DOOR;
        case TrapdoorTo(_): TRAPDOOR;
        case SpawnFrom(_) | SpawnAny: NONE;
        case Key: KEY;
        case Lock(_): LOCK;
        case Sharon: SHARON;
        case Plant: PLANT;
        case Lift: LIFT;
        case Batterycorp: BATTERY;
      });
  }
  
  public function getRoomId(title:String):Int {
    for (i in 0...state.length) {
      if (state[i].title == title) {
        return i;
      }
    }
    return -1;
  }
  
  public function enter(title:String):Void {
    var roomId = getRoomId(title);
    placePlayer(roomId, state[statePlayer].title);
    windows[roomId].show = true;
    Main.wm.focusWindow(windows[roomId]);
  }
  
  public function checkDrag(i:Int, folder:EFolder, onto:EFolder):Bool {
    switch (folder.draggedIcon) {
      case YOU | YOU_COLOUR:
      if (folder != onto) {
        Main.wm.say(false, "You are not in that room!");
        return true;
      }
      switch (state[i].icons[folder.draggedTo]) {
        case DoorTo(title) | TrapdoorTo(title): enter(title);
        case Lift | Batterycorp: enter("The lift");
        
        case Goal:
        solve();
        
        case Lock(_):
        Main.wm.say(false, "You need to unlock this with a key first.");
        return true;
        
        case _:
        return true;
      }
      folder.icons[folder.draggedFrom] = NONE;
      folder.draggedFrom = -1;
      folder.draggedIcon = NONE;
      folder.doUpdate = true;
      return false;
      
      case KEY:
      switch (onto.icons[onto.draggedTo]) {
        case YOU:
        if (folder != onto) {
          Main.wm.say(false, "You must be in the same room to pick up items.");
          return true;
        } else {
        }
        folder.draggedFrom = -1;
        folder.draggedIcon = NONE;
        folder.doUpdate = true;
        inv.folder.icons[0] = KEY;
        inv.folder.doUpdate = true;
        inv.show = true;
        Main.wm.focusWindow(inv);
        return false;
        
        case LOCK:
        if (folder != inv.folder) {
          Main.wm.say(false, "You need to pick up the key first.");
          return true;
        }
        if (onto == windows[statePlayer].folder) {
          switch (state[statePlayer].icons[onto.draggedTo]) {
            case Lock(unlock):
            state[statePlayer].icons[onto.draggedTo] = unlock;
            onto.icons[onto.draggedTo] = getIcon(unlock);
            folder.doUpdate = true;
            onto.doUpdate = true;
            return false;
            
            case _:
            Main.wm.say(false, "The key doesn't fit ...?");
          }
        } else {
          Main.wm.say(false, "You must be in the same room to unlock locks.");
        }
        
        case _:
      }
      
      case _:
    }
    return true;
  }
  
  public function checkDouble(i:Int, folder:EFolder):Bool {
    switch (folder.icons[folder.selected]) {
      case YOU:
      inv.show = true;
      Main.wm.focusWindow(inv);
      
      case DOOR | TRAPDOOR | LIFT | BATTERY:
      Main.wm.say(false, "Drag and drop yourself onto doors to enter them.");
      
      case _:
    }
    return true;
  }
  
  public function placePlayer(i:Int, from:String):Void {
    if (num == 0 && from != "") {
      windows[statePlayer].show = false;
    }
    statePlayer = i;
    if (state[i].instruct != null) {
      info.el.text = state[i].instruct;
      if (from != "") {
        Main.wm.focusWindow(info);
      }
      info.show = true;
    }
    if (num == 0) {
      switch (state[i].title) {
        case "Your office":
        Main.wm.story.showStory("story1");
        
        case "Foyer":
        Main.wm.story.showStory("story2");
        
        case "The lift":
        Main.wm.story.showStory("story3");
        Main.wm.showWindow(Main.wm.lift);
        
        case "Dispatching":
        Main.wm.story.showStory("story4");
      }
    }
    for (j in 0...state[i].icons.length) {
      if (switch (state[i].icons[j]) {
          case SpawnAny: true;
          case SpawnFrom(f): (f == from);
          case _: false;
        }) {
        windows[i].folder.icons[j] = (num == 0 ? YOU_COLOUR : YOU);
        windows[i].folder.doUpdate = true;
        return;
      }
    }
  }
  
  override public function spawn():Array<Window> {
    if (windows != null) {
      for (w in windows) {
        w.removeSelf();
      }
    }
    state = mazes[num].map(r -> {w: r.w, h: r.h, title: r.title, icon: r.icon, icons: r.icons.copy(), instruct: r.instruct});
    var i = 0;
    info = new WText('mazeinfo', 'maze$num.pzl', 150, 50, "");
    info.show = false;
    info.close = () -> { info.show = false; };
    inv = new WFolder('mazeinv', "Inventory", 50, 150, 4, 1, []);
    inv.icon = Icon.BAG;
    inv.folder.dragFunc = checkDrag.bind(-1, _, _);
    inv.folder.doubleFunc = checkDouble.bind(-1, _);
    inv.show = false;
    inv.close = () -> { inv.show = false; };
    windows = [ for (r in state) {
        var f = new WFolder('maze$i', r.title, 50 + (i % 7) * 10, 50 + (i % 6) * 10, r.w, r.h, r.icons.map(getIcon));
        f.icon = r.icon;
        f.folder.dragFunc = checkDrag.bind(i, _, _);
        f.folder.doubleFunc = checkDouble.bind(i, _);
        if (num == 0) {
          f.closable = false;
        }
        f.close = (function (ci:Int):Void {
          if (ci == statePlayer) {
            return;
          }
          f.show = false;
        }).bind(i);
        f.show = (i == 0);
        i++;
        f;
      } ];
    placePlayer(0, "");
    return (cast windows).concat([info, inv]);
  }
  
  override public function solve():Void {
    super.solve();
    inv.removeSelf();
    info.removeSelf();
    windows.map(w -> w.removeSelf());
    inv = null;
    info = null;
    windows = null;
  }
}
