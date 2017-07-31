package lib;

class Story {
  public static var FLOOR_POINTS:Array<Int> = [
       0
      ,0
      ,30
      ,60
      ,100
    ];
  
  public static var PLOT:Array<PlotPoint> = [
      {t: [Once], a: [
         UnlockPuzzle("avoid0")
        ,StartPuzzle("avoid0")
        ,PlayMusic("intro")
         /*
         ShowStory("story1")
        ,SayPlayer("Another lousy Monday.")
        ,SayPlayer("They don't pay me enough for what I do around here.")
        ,SayPlayer("I have to talk to the boss about this.")
        ,PlaySound("fleep")
        ,SayOrigin("You've got mail!", "Computer")
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
        ,OpenWindow("help")*/
      ]}, {t: [Once, ClickedOn(SHARON), Not(FlagSet("dispatched"))], a: [
         SetFlag("dispatched", true)
        ,SayPlayer("Hey, Sharon.")
        ,SayOrigin("Oh, hi.", "Sharon")
        ,SayOrigin("Batterycorp is leaking again ...", "Sharon")
        ,SayPlayer("(again?)")
        ,SayOrigin("It seems like the fuseboxes broke down again.", "Sharon")
        ,SayPlayer("(again again?)")
        ,SayOrigin("They are all around town and everyone here is busy doing\nbusiness stuff.", "Sharon")
        ,SayPlayer("(let me guess ...)")
        ,SayOrigin("I need you to go fix the fuseboxes.", "Sharon")
        ,SayPlayer("(yup, as expected.)")
        ,SayOrigin("I'll place the markers on your map.", "Sharon")
        ,SayOrigin("Fixing the fuseboxes *probably* won't consist of solving\nmore and more difficult puzzles ...", "Sharon")
        ,SayOrigin("But, you never know!", "Sharon")
        ,SayPlayer("(what did she mean by this?)")
        ,SayOrigin("Good luck!", "Sharon")
        ,UnlockPuzzle("maze1")
        ,UnlockPuzzle("lockpk0")
        ,UnlockPuzzle("rapid0")
        ,UnlockPuzzle("assmbl0")
      ]}, {t: [Once, ClickedOn(SHARON), FlagSet("dispatched")], a: [
         SayPlayer("Hello again.")
        ,SayOrigin("Hi. How is the fixing going?", "Sharon")
        ,SayPlayer("Good. How is the business stuff going?")
        ,SayOrigin("Good.", "Sharon")
        ,SayPlayer("That's good.")
        ,SayOrigin("Yup.", "Sharon")
        ,SayPlayer("Well then, good ... bye.")
      ]}, {t: [Not(GotTo("story2")), Not(FlagSet("dispatched")), FlagSet("rem1")], a: [
        SetFlag("rem1", false)
      ]}, {t: [GotTo("story2"), Not(FlagSet("dispatched")), Not(FlagSet("rem1"))], a: [
         SetFlag("rem1", true)
        ,SayPlayer("I should go see Sharon.")
        ,SayPlayer("Dispatching is on floor 2.")
      ]}, {t: [Once, GotPoints(30)], a: [
        // PlaySound("phone")
         SayOrigin("You have restored 30 power units.\nFloor 3 is accessible now.", "Sharon (phone)")
        ,SayPlayer("Oh great, I can access my own office again.")
      ]}, {t: [Once, GotPoints(60)], a: [
        // PlaySound("phone")
         SayOrigin("You have restored 60 power units.\nFloor 4 is accessible now.", "Sharon (phone)")
        ,SayPlayer("Hm, I always wondered what that floor even is.")
      ]}, {t: [Once, GotPoints(100)], a: [
        // PlaySound("phone")
         SayOrigin("You have restored all power to Batterycorp.", "Sharon (phone)")
        ,SayOrigin("Good job. All floors are now accessible.", "Sharon (phone)")
        ,SayPlayer("Time to talk to the boss at last!")
      ]}, {t: [Once, GotTo("story2"), ClickedOn(PLANT), Not(FlagSet("eggPlant"))], a: [
        // PlaySound("egg")
         SayPlayer("There is something weird about this plant ...")
        ,SayPlayer("Ah-ha! There was a microscopic power leak in that plant.")
        ,SayText("Egg (plant) solved!\n1 power unit restored.")
        ,AddPoints(1)
        ,SetFlag("eggPlant", true)
      ]}, {t: [ClickedOn(PLANT), FlagSet("eggPlant")], a: [
         SayPlayer("No more leaks here ...")
        ,SayPlayer("It's just an office plant.")
      ]}, {t: [ClickedOn(PLANT), Not(FlagSet("eggPlant"))], a: [
        SayPlayer("It's just an office plant.")
      ]}, {t: [Once, GotTo("story6")], a: [
         SayPlayer("Ahhh yes ...")
        ,SayPlayer("I forgot we had a rec room at Batterycorp. Nobody ever comes here.")
        ,SayPlayer("I like chess but the chessboard is missing thirty pieces.")
        ,SayPlayer("At what point does a chessboard and thirty missing pieces become\na piece of paper and two rooks?")
      ]}, {t: [ClickedOn(SHADOW), Not(FlagSet("eggShadow")), Not(FlagSet("shadow1"))], a: [
         SayPlayer("I see a shadow in the corner ...")
        ,SayPlayer("Is there anybody there?")
        ,SayText("...")
        ,SetFlag("shadow1", true)
      ]}, {t: [ClickedOn(SHADOW), Not(FlagSet("eggShadow")), FlagSet("shadow1"), Not(FlagSet("shadow2"))], a: [
         SayPlayer("Hello?")
        ,SayText("...")
        ,SetFlag("shadow2", true)
      ]}, {t: [ClickedOn(SHADOW), Not(FlagSet("eggShadow")), FlagSet("shadow2"), Not(FlagSet("shadow3"))], a: [
         SayPlayer("Or is it just my imagination?")
        ,SayPlayer("There can't be a shadow without something casting it ...")
        ,SayText("...")
        ,SetFlag("shadow3", true)
      ]}, {t: [ClickedOn(SHADOW), Not(FlagSet("eggShadow")), FlagSet("shadow3")], a: [
        SayPlayer("I wonder where the light source is in this room.")
      ]}, {t: [ClickedOn(INVISIBLE), Not(FlagSet("eggShadow"))], a: [
         SayPlayer("Judging by that shadow, there should be somebody ... here!")
        ,PlaySound("wizzupI"), SayText("$M\"Spooookyy")
        ,SayPlayer("*gasp*")
        ,PlaySound("wizzupI"), SayText("$M\"What?")
        ,PlaySound("wizzupI"), SayText("$M\"Have you never")
        ,PlaySound("wizzupI"), SayText("$M\"seen an invisible")
        ,PlaySound("wizzupI"), SayText("$M\"man before?")
        ,SayPlayer("Well ... No, I don't think I have.")
        ,PlaySound("wizzupI"), SayText("$M\"Well nor will you.")
        ,SayPlayer("I ... what?")
        ,PlaySound("wizzupI"), SayText("$M\"People don't come")
        ,PlaySound("wizzupI"), SayText("$M\"here often.")
        ,PlaySound("wizzupI"), SayText("$M\"Are you lost?")
        ,SayPlayer("No, I am fixing power leaks.")
        ,PlaySound("wizzupI"), SayText("$M\"Oh. Amazing!")
        ,PlaySound("wizzupI"), SayText("$M\"Mine is broken.")
        ,PlaySound("wizzupI"), SayText("$M\"Could you fix it?")
        ,ShowStory("story7")
        ,ClickThrough
        ,SayPlayer("Er... How do I fix it?")
        ,PlaySound("wizzupI"), SayText("$M\"You're the expert")
        ,SayPlayer("Ok, how about this ...")
        ,ClickThrough
        ,SetFlag("eggShadow", true)
        ,PlaySound("boing")
        ,ClickThrough
        ,PlaySound("wizzupI"), SayText("$M\"Amazing!")
        ,PlaySound("wizzupI"), SayText("$M\"Thank you!")
        ,SayPlayer("Don't mention it ...")
        ,SayText("Egg (shadow) solved!\n1 power unit restored.")
        ,ShowStory("story6")
        ,OpenWindow("map")
        ,AddPoints(1)
      ]}, {t: [ClickedOn(INVISIBLE), FlagSet("eggShadow")], a: [
         PlaySound("wizzupI"), SayText("$M\"Thank you for")
        ,PlaySound("wizzupI"), SayText("$M\"fixing my power")
        ,PlaySound("wizzupI"), SayText("$M\"leek.")
      ]}, {t: [ClickedOn(BOSS), GotPoints(102)], a: [
         SayPlayer("Hello, boss?")
        ,SayOrigin("Oh, it's you. What do you want?", "The boss")
        ,SayPlayer("I fixed all the power leaks!")
        ,SayPlayer("Including the 2 eggstra ones!")
        ,SayOrigin("What power l-- Did you say 2 eggstra ones?!", "The boss")
        ,SayPlayer("Yes, I found them.")
        ,SayOrigin("Amazing ... I never though anyone could do it.", "The boss")
        ,SayOrigin("Now, thanks to you ... We will dominate the world!", "The boss")
        ,SayPlayer("Dominate the world?!")
        ,SayOrigin("Naah, I'm just pulling your leg.", "The boss")
        ,SayOrigin("Anyway, you should go now, do something productive today!", "The boss")
        ,ShowStory("story0")
        ,ClickThrough
        ,SayText("An hour later...")
        ,ShowStory("story9")
        ,ClickThrough
        ,SayOrigin("Did he manage?", "Voice from the phone")
        ,SayOrigin("No ... Not even this one could find the two extra leeks.", "The boss?")
        ,PlaySound("wizzupI"), SayText("$M\"EGGSTRA LEEKS")
        ,SayOrigin("We're starting to lose patience.", "Voice from the phone")
        ,SayOrigin("There is still plenty of time.", "The boss?")
        ,SayOrigin("Maybe the next one will find them?", "The boss?")
        ,SayOrigin("We can only hope. *click*", "Voice from the phone")
        ,End(2)
      ]}, {t: [ClickedOn(BOSS)], a: [
         SayPlayer("Hello, boss?")
        ,SayOrigin("Oh, it's you. What do you want?", "The boss")
        ,SayPlayer("I fixed all the power leaks!")
        ,SayPlayer("Also, the working conditions here are terrible, I deman--")
        ,SayOrigin("What power leaks?", "The boss")
        ,SayPlayer("The ... building?")
        ,SayOrigin("What about the building?", "The boss")
        ,SayPlayer("It was leaking power, right? It's a battery?")
        ,SayOrigin("It's *shaped* like a battery.", "The boss")
        ,SayPlayer("... So it's not ... Actually a battery?")
        ,SayOrigin("No, that would be a preposterous idea!", "The boss")
        ,SayOrigin("Who told you such non-sense?", "The boss")
        ,SayPlayer("Sharon dispatched me to fix all the leaks.")
        ,SayOrigin("Haha, she's a good kid.", "The boss")
        ,SayOrigin("Anyway, you should go now, do something productive today!", "The boss")
        ,ShowStory("story0")
        ,ClickThrough
        ,SayText("An hour later...")
        ,ShowStory("story9")
        ,ClickThrough
        ,SayOrigin("Did he manage?", "Voice from the phone")
        ,SayOrigin("No ... Not even this one could find the extra two.", "The boss?")
        ,SayOrigin("We're starting to lose patience.", "Voice from the phone")
        ,SayOrigin("There is still plenty of time.", "The boss?")
        ,SayOrigin("Maybe the next one will find them?", "The boss?")
        ,SayOrigin("We can only hope. *click*", "Voice from the phone")
        ,End(1)
      ]}, {t: [Once, Solved("lockpk1"), Solved("maze1")], a: [
        UnlockPuzzle("shake0")
      ]}, {t: [Once, Solved("rapid0"), Solved("assmbl1")], a: [
        UnlockPuzzle("avoid0")
      ]}
    ];
  
  public static var TIMELINE:Array<PlotPoint>;
  public static var QUEUE:Array<Action>;
  public static var POINTS:Int;
  public static var ENDING:Int;
  public static var LIFT_FLOOR:Int;
  public static var FLAGS:Map<String, Bool>;
  
  public static function init():Void {
    for (p in Main.puzzles) if (p.id != "maze0") {
      PLOT.push({t: [Once, Solved(p.id)], a: [
           SayText("Puzzle solved!\n" + p.points + " power units restored.")
          ,(p.sequel != null ? UnlockPuzzle(p.sequel) : Nop)
          ,AddPoints(p.points)
        ]});
    }
    TIMELINE = PLOT.copy();
    QUEUE = [];
    POINTS = 0;
    LIFT_FLOOR = 2;
    FLAGS = new Map<String, Bool>();
  }
  
  public static function tick():Void {
    if (QUEUE.length == 0) {
      function isTrigger(t:Trigger):Bool {
        if (switch (t) {
          case Solved(puzzle): (Save.solved.indexOf(puzzle) == -1);
          case GotPoints(total): (POINTS < total);
          case GotTo(id): Main.wm.story.storyId != id;
          case ClickedOn(icon): Main.wm.overworld.lastClicked != icon;
          case FlagSet(flag): (!FLAGS.exists(flag) || !FLAGS.get(flag));
          case Not(ot): isTrigger(ot);
          case _: false;
        }) return false;
        return true;
      }
      
      function isTriggered(ts:Array<Trigger>):Bool {
        for (t in ts) if (!isTrigger(t)) return false;
        return true;
      }
      
      var i = 0;
      while (i < TIMELINE.length) {
        var point = TIMELINE[i];
        if (isTriggered(point.t)) {
          QUEUE = QUEUE.concat(point.a);
          if (point.t[0] == Once) {
            TIMELINE.splice(i, 1);
            break;
          }
          break;
        }
        i++;
      }
    }
    while (QUEUE.length > 0) if (switch (QUEUE.shift()) {
      case Nop: false;
      case SayPlayer(text): Main.sound("wizzup"); Main.wm.say(true, text); true;
      case SayOrigin(text, origin):
      switch (origin) {
        case "Sharon": Main.sound("wizzupS");
        case _:
      }
      Main.wm.say(false, text, origin); true;
      case SayText(text): Main.wm.say(false, text); true;
      case ClickThrough: Main.wm.clickThrough(); true;
      case UnlockPuzzle(puzzle): Main.wm.unlockPuzzle(puzzle); false;
      case StartPuzzle(puzzle): Main.wm.startPuzzle(puzzle); false;
      case SetFlag(flag, value): FLAGS.set(flag, value); false;
      case ShowStory(id): Main.wm.showWindow(Main.wm.story); Main.wm.story.showStory(id); false;
      case AddPoints(add): POINTS += add; false;
      case SetPoints(total): POINTS = total; false;
      case PlaySound(id): Main.sound(id); false;
      case PlayMusic(id): Music.playTrack(id); false;
      case OpenWindow(id): Main.wm.showWindow(Main.wm.getWindow(id)); false;
      case End(num): Story.ENDING = num; Main.wm.app.applyState(Main.wm.app.getStateById("end")); true;
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
  ClickedOn(icon:Icon);
  FlagSet(flag:String);
  Not(trigger:Trigger);
}

enum Action {
  Nop;
  SayPlayer(text:String);
  SayOrigin(text:String, origin:String);
  SayText(text:String);
  ClickThrough;
  UnlockPuzzle(puzzle:String);
  StartPuzzle(puzzle:String);
  SetFlag(flag:String, value:Bool);
  ShowStory(id:String);
  AddPoints(add:Int);
  SetPoints(total:Int);
  PlaySound(id:String);
  PlayMusic(id:String);
  OpenWindow(id:String);
  End(num:Int);
}
