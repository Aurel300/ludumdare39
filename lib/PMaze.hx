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
  SpawnFrom(title:String);
  Key;
  Lock(unlocks:RoomIcon);
}

class PMaze extends Puzzle {
  public static var mazes:Array<Array<Room>>;
  
  public static function init():Void {
    mazes = [
        [
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
        case SpawnFrom(_): NONE;
        case Key: KEY;
        case Lock(_): LOCK;
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
  
  public function checkDrag(i:Int, folder:EFolder, onto:EFolder):Bool {
    switch (folder.draggedIcon) {
      case YOU:
      if (folder != onto) {
        // error: use the doors
        return true;
      }
      switch (state[i].icons[folder.draggedTo]) {
        case DoorTo(title) | TrapdoorTo(title):
        var roomId = getRoomId(title);
        placePlayer(roomId, state[statePlayer].title);
        windows[roomId].show = true;
        windows[roomId].wm.focusWindow(windows[roomId]);
        
        case Goal:
        solve();
        
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
          return true;
        } else {
          // error: must be in the same room to pick up
        }
        folder.draggedFrom = -1;
        folder.draggedIcon = NONE;
        folder.doUpdate = true;
        inv.folder.icons[0] = KEY;
        inv.folder.doUpdate = true;
        inv.show = true;
        inv.wm.focusWindow(inv);
        return false;
        
        case LOCK:
        if (folder != inv.folder) {
          // error: must pick up the key first
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
            // error: they key doesn't fit?
          }
        } else {
          // error: must be in the same room to unlock
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
      inv.wm.focusWindow(inv);
      
      case _:
    }
    return true;
  }
  
  public function placePlayer(i:Int, from:String):Void {
    statePlayer = i;
    if (state[i].instruct != null) {
      info.el.text = state[i].instruct;
      info.el.updateText();
      if (from != "") {
        info.wm.focusWindow(info);
      }
      info.show = true;
    }
    for (j in 0...state[i].icons.length) {
      switch (state[i].icons[j]) {
        case SpawnFrom(f):
        if (f == from) {
          windows[i].folder.icons[j] = YOU;
          windows[i].folder.doUpdate = true;
          return;
        }
        case _:
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
        var f = new WFolder('maze$i', r.title, 50 + i * 10, 50 + i * 10, r.w, r.h, r.icons.map(getIcon));
        f.icon = r.icon;
        f.folder.dragFunc = checkDrag.bind(i, _, _);
        f.folder.doubleFunc = checkDouble.bind(i, _);
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
