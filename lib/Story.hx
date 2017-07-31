package lib;

class Story {
  public static var PLOT:Array<PlotPoint> = [
      {t: [Once], a: [
         ShowStory("story1")
        ,SayPlayer("Another lousy Monday.")
        ,SayPlayer("They don't pay me enough for what I do around here.")
        ,SayPlayer("I have to talk to the boss about this.")
        //,PlaySound("mail")
        ,SayPlayer("Oh great, what now ...")
        ,SetPoints(100)
        ,ShowStory("story2")
        ,SayPlayer("The battery is ... leaking?!")
        ,SetPoints(70)
        ,ShowStory("story2")
        ,SayPlayer("The floors are running out?!")
        ,SetPoints(30)
        ,ShowStory("story2")
        ,SayPlayer("I can't even reach the boss' office?!")
        ,SetPoints(0)
        ,ShowStory("story2")
        ,SayPlayer("Whoever thought making the building a literal battery was a good idea?")
        ,ShowStory("story1")
        ,SayPlayer("I'd better talk to Sharon at dispatching.")
        ,StartPuzzle("maze0")
        ,OpenWindow("help")
      ]}
    ];
  
  public static var TIMELINE:Array<PlotPoint>;
  public static var QUEUE:Array<Action>;
  public static var POINTS:Int;
  public static var LIFT_FLOOR:Int;
  public static var FLAGS:Map<String, Bool>;
  
  public static function init():Void {
    TIMELINE = PLOT.copy();
    QUEUE = [];
    POINTS = 0;
    LIFT_FLOOR = 2;
    FLAGS = new Map<String, Bool>();
  }
  
  public static function tick():Void {
    if (QUEUE.length == 0) {
      function isTriggered(ts:Array<Trigger>):Bool {
        for (t in ts) if (switch (t) {
          case Solved(puzzle): (Save.solved.indexOf(puzzle) == -1);
          case GotPoints(total): (POINTS < total);
          case GotTo(id): Main.wm.story.storyId != id;
          case ClickedOn(_, _): false;
          case FlagSet(flag): (!FLAGS.exists(flag) || !FLAGS.get(flag));
          case _: false;
        }) return false;
        return true;
      }
    
      for (i in 0...TIMELINE.length) {
        var point = TIMELINE[i];
        if (isTriggered(point.t)) {
          QUEUE = QUEUE.concat(point.a);
          if (point.t[0] == Once) {
            TIMELINE.splice(i, 1);
          }
          break;
        }
      }
    }
    while (QUEUE.length > 0) if (switch (QUEUE.shift()) {
      case SayPlayer(text): Main.wm.say(true, text); true;
      case SayOrigin(text, origin): Main.wm.say(false, text, origin); true;
      case SayText(text): Main.wm.say(false, text); true;
      case UnlockPuzzle(puzzle): Main.puzzlesMap.get(puzzle).locked = false; false;
      case StartPuzzle(puzzle): Main.wm.startPuzzle(puzzle); false;
      case SetFlag(flag, value): FLAGS.set(flag, value); false;
      case ShowStory(id): Main.wm.showWindow(Main.wm.story); Main.wm.story.showStory(id); false;
      case SetPoints(total): POINTS = total; false;
      case PlaySound(id): Main.am.getSound(id).play(); false;
      case OpenWindow(id): Main.wm.showWindow(Main.wm.getWindow(id)); false;
      case _: false;
    }) break;
  }
}

typedef PlotPoint = {
     t:Array<Trigger>
    ,a:Array<Action>
  };

enum Trigger {
  Once;
  Solved(puzzle:String);
  GotPoints(total:Int);
  GotTo(room:String);
  ClickedOn(room:String, item:String);
  FlagSet(flag:String);
}

enum Action {
  SayPlayer(text:String);
  SayOrigin(text:String, origin:String);
  SayText(text:String);
  UnlockPuzzle(puzzle:String);
  StartPuzzle(puzzle:String);
  SetFlag(flag:String, value:Bool);
  ShowStory(id:String);
  SetPoints(total:Int);
  PlaySound(id:String);
  OpenWindow(id:String);
}
