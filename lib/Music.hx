package lib;

import haxe.ds.Vector;
import sk.thenet.FM;
import sk.thenet.audio.Output;
import sk.thenet.plat.Platform;
import sk.thenet.stream.prng.*;

@:enum
abstract Instrument(Int) from Int to Int {
  var Drum = 0;
  var Bass = 7;
  var Jazzy = 43;
  var Melody = 79;
}

typedef Riff = {
     instr:Instrument
    ,beat:Int
    ,start:Int
    ,repeat:Int
    ,notes:Array<Array<Int>>
  };

typedef Track = {
     riffs:Array<Riff>
    ,tempo:Int
    ,name:String
  };

class Music {
  static inline var CHANNUM:Int = 40;
  static var TRACKDATA:Array<Track>;
  static var TRACKS:Vector<Vector<Int>>;
  
  static var out:Output;
  static var gen:Generator;
  static var prng:Vector<Float>;
  static var instruments:Vector<Vector<Float>>;
  static var scale:Vector<Float>;
  
  static var channels:Vector<Int>;
  static var pos:Vector<Int>;
  static var beat:Int;
  static var tempo:Int;
  static var repeat:Bool = true;
  
  static var pattern:Vector<Int>;
  static var patpos:Int;
  static var playing:String;
  // pattern:
  //  - number of notes to trigger
  //  - n notes (instrument index)
  
  static inline function inv(a:Float):Float {
    return 1 - a;
  }
  
  static inline function sin(a:Float):Float {
    return Math.sin(a * Math.PI * 2);
  }
  
  static inline function saw(a:Float):Float {
    return a * 2 - 1;//;(a < .5 ? a * 4 - 1 : (a - .5) * 4 - 1);
  }
  
  static inline function tri(a:Float):Float {
    return (a < .5 ? a * 4 - 1 : -((-a + .75) * 4 - 1));
  }
  
  static inline function pwm(a:Float, i:Int):Float {
    return (a < sin(i / 50000) * .2 + .5 ? -1 : 1);
  }
  
  static inline function s2f(i:Float, f:Float):Float {
    return ((i / 44100) * f) % 1.0;
  }
  
  static function makeInstrument(arr:Array<Float>):Vector<Float> {
    var ret = new Vector<Float>(arr.length + 8192);
    for (i in 0...arr.length) {
      ret[i] = arr[i];
    }
    for (i in arr.length...arr.length + 8192) {
      ret[i] = 0;
    }
    for (i in 0...100) {
      ret[i] *= i / 100;
      ret[arr.length - i - 1] *= i / 100;
    }
    return ret;
  }
  
  static function initDrums():Array<Vector<Float>> {
    return [
        // Snares (shortes to longest) 0 - 3
         makeInstrument([ for (i in 0...5000) gen.nextFloat(.2 * inv(i / 5000)) ])
        ,makeInstrument([ for (i in 0...10000) gen.nextFloat(.2 * inv(i / 10000)) ])
        ,makeInstrument([ for (i in 0...20000) gen.nextFloat(.2 * inv(i / 20000)) ])
        ,makeInstrument([ for (i in 0...40000) gen.nextFloat(.2 * inv(i / 40000)) ])
        // Kick click 4
        ,makeInstrument([ for (i in 0...10000) Math.sin(i / 10000) * .25 ])
        // Kick lo 5
        ,makeInstrument([ for (i in 0...10000) Math.sin(i / (100 + i / 400)) * .25 ])
        // Kick hi 6
        ,makeInstrument([ for (i in 0...10000) Math.sin(i / (50 + i / 300)) * .25 ])
      ];
  }
  
  static function initBass():Array<Vector<Float>> {
    return [ for (freq in scale)
        makeInstrument([ for (i in 0...15000) inv(i / 15000) * (sin(s2f(i, freq)) + saw(s2f(i, freq))) * .125 ])
      ];
  }
  
  static function initJazzy():Array<Vector<Float>> {
    return [ for (freq in scale)
        makeInstrument([ for (i in 0...15000) inv(i / 25000) * (sin(s2f(i, freq)) + sin(s2f(i, freq * 2)) * .5 + sin(s2f(i, freq * 4)) * .25 + sin(s2f(i, freq * 8)) * .125) * .125 ])
      ];
  }
  
  static function initMelody():Array<Vector<Float>> {
    return [ for (freq in scale)
        makeInstrument([ for (i in 0...15000) inv(i / 25000) * (pwm(s2f(i, freq), i) + pwm(s2f(i, freq * 2), i) * .5 + pwm(s2f(i, freq * 4), i) * .25 + pwm(s2f(i, freq * 8), i) * .125) * .125 ])
      ];
  }
  
  public static function init():Void {
    var N = -1;
    function repeat(arr:Array<Int>, num:Int):Array<Int> {
      return [ for (i in 0...num) for (a in arr) a ];
    }
    TRACKDATA = [
        {name: "intro", tempo: 3096, riffs: [{
          // intro
           instr: Bass
          ,beat: 4
          ,start: 0
          ,repeat: 1
          ,notes: [
               [5, 5, N, 5, 9, N, 5, 3, 5, N, N, N, 5, 5, N, 5, 9, N, 5, 3, 5, N, N, N, 5, 5, N, 5, 9, N, 5, 3, 5, N, N, N, 5, 5, N, 5, 9, N, 5, 3, 5, N, N, N]
              ,[N, N, N, N, N, N, N, N, N, N, N, N, 17,17,N, 17,N ,N, 17,20,17,15,13,9, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N]
            ]
        }, {
          // drum bridge
           instr: Drum
          ,beat: 1
          ,start: 4 * 12
          ,repeat: 1
          ,notes: [
               [0, N, N, N]
              ,[N, 6, N, 5]
            ]
        }, {
          // drum
           instr: Drum
          ,beat: 2
          ,start: 4 + 4 * 12
          ,repeat: 6
          ,notes: [
               [0, N, 0, N, 0, 1, N, N, 0, N, 0, N, 1, N, 0, N]
              ,[N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N]
            ]
        }, {
          // melody
           instr: Melody
          ,beat: 2
          ,start: 192
          ,repeat: 1
          ,notes: [
               [5, 5, 9, 9, 3, 3, N, 5, N, 5, N, 5, 5, 9, 9, 3, 3, N, 5, N, 5, N, 5, 5, 9, 9,13,13, N,21, N,23, N, 5, 5, 9, 9, 3, 3, N, 5, N, 5, N,]
            ]
        }]}
        ,{name: "maze", tempo: 4096, riffs: [{
          // pulse
           instr: Melody
          ,beat: 16
          ,start: 0
          ,repeat: 4
          ,notes: [[5, 5, 5, 5, 2, 2, 2, 3, 9, 9, 5, 5]]
        }, {
          // drum 1
           instr: Drum
          ,beat: 1
          ,start: 0
          ,repeat: 12
          ,notes: [[N, N, N, N, N, 0, N, N, 1, N, N, 0, N, N, N, N]]
        }, {
          // pulse
           instr: Jazzy
          ,beat: 4
          ,start: 12 * 16
          ,repeat: 4
          ,notes: [[
            5, 8, 12, 4, 5, 8, 12, 4, 5, 8, 12, 4, 5, 8, 12, 4,
            2, 5, 9, 1, 2, 5, 9, 1, 2, 5, 9, 1, 3, 6, 10, 11,
            9, 12, 16, 8, 9, 12, 16, 8, 5, 8, 12, 4, 5, 8, 12, 4
          ]]
        }, {
          // drum 2
           instr: Drum
          ,beat: 1
          ,start: 12 * 16
          ,repeat: 12
          ,notes: [[0, N, 0, N, 0, N, 0, N, 1, N, 1, N, 0, N, N, 6]]
        }, {
          // drum 3
           instr: Drum
          ,beat: 1
          ,start: 24 * 16
          ,repeat: 6
          ,notes: [[N, N, N, N, N, 6, 6, 6, N, 5, 5, N, N, N, 6, N]]
        }, {
          // drum 4
           instr: Drum
          ,beat: 1
          ,start: 36 * 16
          ,repeat: 6
          ,notes: [[N, N, N, N, N, 6, 6, 6, N, 5, 5, N, N, N, 3, N]]
        }]}
        ,{name: "wreckroom", tempo: 2048, riffs: [{
          // beat intro 1
           instr: Drum
          ,beat: 4
          ,start: 0
          ,repeat: 4
          ,notes: [
             [1, N, 2, N]
            ,[5, N, 6, N]
          ]
        }, {
          // beat intro 2
           instr: Drum
          ,beat: 4
          ,start: 64
          ,repeat: 4
          ,notes: [
             [0, 0, 0, 0]
            ,[1, N, 2, N]
            ,[5, N, 6, N]
          ]
        }, {
          // beat
           instr: Drum
          ,beat: 4
          ,start: 128
          ,repeat: 21
          ,notes: [
             [0, 0, 0, 0]
            ,[5, N, 6, N]
          ]
        }, {
          // beat
           instr: Drum
          ,beat: 4
          ,start: 640
          ,repeat: 19
          ,notes: [
             [0, 0, N, N]
            ,[5, N, 6, N]
          ]
        }, {
          // bass
           instr: Bass
          ,beat: 1
          ,start: 128
          ,repeat: 2
          ,notes: [
             repeat([0, N, 1, N, N, N, N, N, 0, N, 1, N, N, N, N, N], 8)
             .concat(repeat([0, N, 2, N, 8, N, 2, N, 0, N, 1, N, N, N, N, N], 8))
          ]
        }, {
          // bass 2
           instr: Bass
          ,beat: 1
          ,start: 640
          ,repeat: 2
          ,notes: [
             repeat([0, N, 1, N, N, N, N, N], 4)
             .concat(repeat([0, N, N, N, 5, N, N, N, 9, N, N, N, 8, 9, N, N], 2))
             .concat(repeat([0, N, 1, N, N, N, N, N], 4))
             .concat(repeat([0, N, N, N, 5, N, N, N, 9, N, N, N, 8, 9, N, N], 2))
             .concat(repeat([0, N, 1, N, N, N, N, N], 4))
             .concat(repeat([9, N, N, N, 13, N, 7, N, 9, N, 13, N, 8, 9, N, N], 4))
          ]
        }]}
        ,{name: "lift", tempo: 5012, riffs: [{
          // beat
           instr: Drum
          ,beat: 8
          ,start: 0
          ,repeat: 10
          ,notes: [[4, 2, 5, 3]]
        }, {
          // chords
           instr: Jazzy
          ,beat: 4
          ,start: 16
          ,repeat: 3
          ,notes: [
            [5, 5, 9, 5, 5, 5, 9, 5, 4, 4, 7, 4, 4, 4, 7, 4, 3, 3, 6, 3, 3, 3, 6, 3, 4, 4, 7, 4, 4, 4, 7],
            [N, N,12, N, N, N,12, N, N, N,12, N, N, N,12, N, N, N,11, N, N, N,11, N, N, N,12, N, N, N,12]
          ]
        }, {
          // organ
           instr: Jazzy
          ,beat: 2
          ,start: 128 + 16
          ,repeat: 4
          ,notes: [
            [17, 25, 24, 17, 22, 24, 17, 21, 22, 17, 22, 21, 20, 19, 18, 17]
          ]
        }, {
          // organ
           instr: Jazzy
          ,beat: 2
          ,start: 128 + 128 + 16
          ,repeat: 4
          ,notes: [
            [17, 25, 24, 17, 22, 24, 17, 21, 22, 17, 22, 21, 20, 19, 18, 17]
          ]
        }, {
          // organ bass
           instr: Bass
          ,beat: 4
          ,start: 128 + 128 + 16
          ,repeat: 3
          ,notes: [
            [5, 13, 12, 5, 10, 12, 5, 9, 10, 5, 10, 9, 8, 7, 6, 5]
          ]
        }]}
        ,{name: "victory1", tempo: 3000, riffs: [{
          // drums
           instr: Drum
          ,beat: 1
          ,start: 20
          ,repeat: 1
          ,notes: [
            [0, N, N, N, N, N, N, 5, 5, 5, 6, 5, 6, 5, 0, N, 6, N, N, N, 6, N, N, N, 0, N, N, N, 1, N, N, N, 2, N, N, N, 3]
          ]
        }, {
          // da da da dah
           instr: Jazzy
          ,beat: 1
          ,start: 1
          ,repeat: 1
          ,notes: [
            [N, N, N, N, N, N, N, 29, N, 24, 25, N, N, 29, N, N, N, N, N, N, 25, 17, 25, 19, 25, 17, 25, 19, 25, 17, 25, 19, N, N, N, N, N, 29, 28, N, 29, 28, 27, N, N, 27, 29, 13]
          ]
        }, {
          // melody
           instr: Melody
          ,beat: 1
          ,start: 1
          ,repeat: 1
          ,notes: [
            [N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, 29, N, N, N, N, 17, N, 19, N, 17, N, 19, N, 17, N, 19, N, N, N, N, N, 29, 28, N, 29, 28, 27, N, N, 27, 29, 13]
          ]
        }]}
        ,{name: "victory2", tempo: 3000, riffs: [{
          // drums
           instr: Drum
          ,beat: 1
          ,start: 20
          ,repeat: 1
          ,notes: [
            [0, N, N, N, N, N, N, 5, 5, 5, 6, 5, 6, 5, 0, N, 6, N, N, N, 6, N, N, N, 0, N, N, N, 1, N, N, N, 0, N, N, N, 1, N, N, N, 2, N, N, N, 3]
          ]
        }, {
          // da da da dah
           instr: Jazzy
          ,beat: 1
          ,start: 1
          ,repeat: 1
          ,notes: [
            [N, N, N, N, N, N, N, 29, N, 24, 25, N, N, 29, N, N, N, N, N, N, 25, 17, 25, 19, 25, 17, 25, 19, 25, 17, 25, 19, N, N, N, N, N, 13, 17, N, 29, 28, 27, N, N, 17, 19, 23, N, N, 17, 19, 24, N, N, 17, 19, 26, N, N, 17, 19, 29]
          ]
        }, {
          // melody
           instr: Melody
          ,beat: 1
          ,start: 1
          ,repeat: 1
          ,notes: [
            [N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, 7, N, N, N, N, N, N, 9, N, N, N, N, N, 13, N, N, N, N, 17, N, N, N, 19, N, N, 23, N, 25, N, 23, N, 25, N, N, 19, N, N, N, 17, N, N, N, N, N, 13]
          ]
        }]}
      ];
    
    function makeTrack(t:Track):Vector<Int> {
      var len = 0;
      var riffs = [ for (r in t.riffs) {
          var end = r.start + r.notes[0].length * r.beat * r.repeat;
          if (end > len) {
            len = end;
          }
          [ for (i in 0...r.start) [] ].concat([
              for (rep in 0...r.repeat) for (note in 0...r.notes[0].length) for (b in 0...r.beat)
                (b == 0 ? [ for (layer in r.notes) if (layer[note] != -1) r.instr + layer[note] ] : [])
            ]);
        } ];
      var ret = [];
      for (i in 0...len) {
        var burst = [];
        for (r in riffs) {
          if (i < r.length) burst = burst.concat(r[i]);
        }
        ret.push(burst.length);
        for (b in burst) ret.push(b);
      }
      return Vector.fromArrayCopy(ret);
    }
    TRACKS = Vector.fromArrayCopy(TRACKDATA.map(makeTrack));
    
    var step = 1.059463094;
    var freq = 55.0;
    scale = Vector.fromArrayCopy([freq].concat([ for (i in 0...35) freq *= step ]));
    out = Platform.createAudioOutput();
    out.sample = Music.sample;
    gen = new Generator(new XORShift(0xDEAFB015));
    prng = new Vector<Float>(8192);
    beat = 0;
    for (i in 0...prng.length) {
      prng[i] = gen.nextFloat();
    }
    instruments = Vector.fromArrayCopy(
         initDrums().concat(initBass()).concat(initJazzy()).concat(initMelody())
      );
    channels = Vector.fromArrayCopy([ for (i in 0...CHANNUM) -1 ]);
    pos = Vector.fromArrayCopy([ for (i in 0...CHANNUM) 0 ]);
  }
  
  static function seek(beat:Int):Int {
    var pi = 0;
    while (pi < pattern.length && beat > 0) {
      pi += pattern[pi] + 1;
      beat--;
    }
    return pi;
  }
  
  public static function playTrack(id:String, ?repeat:Bool = true):Void {
    Music.repeat = repeat;
    if (playing == id) {
      return;
    }
    playing = id;
    for (ti in 0...TRACKDATA.length) if (TRACKDATA[ti].name == id) {
      for (i in 0...CHANNUM) {
        channels[i] = -1;
        pos[i] = 0;
      }
      pattern = TRACKS[ti];
      tempo = TRACKDATA[ti].tempo;
      patpos = 0;
      play();
    }
    //patpos = seek(100);
  }
  
  public static function play():Void {
    out.play();
  }
  
  public static function stop():Void {
    out.stop();
  }
  
  static function sample(offset:Float, buffer:Vector<Float>):Void {
    function assignChannel(instr:Int):Void {
      for (c in 0...CHANNUM) if (channels[c] == -1) {
        channels[c] = instr;
        pos[c] = -beat;
        return;
      }
    }
    
    if (pattern == null) {
      for (i in 0...8192) {
        buffer[i * 2] = 0;
        buffer[i * 2 + 1] = 0;
      }
      return;
    }
    
    for (i in 0...8192) {
      if (beat == i) {
        var num = pattern[patpos++];
        for (n in 0...num) {
          assignChannel(pattern[patpos++]);
        }
        if (patpos >= pattern.length) {
          patpos -= pattern.length;
          if (!repeat) {
            pattern = null;
            tempo = 10000;
          }
        }
        beat += tempo;
      }
      buffer[i * 2] = 0;
      buffer[i * 2 + 1] = 0;
    }
    if (pattern == null) {
      return;
    }
    for (ci in 0...channels.length) {
      if (channels[ci] == -1) {
        continue;
      }
      var instr = instruments[channels[ci]];
      var cpos = pos[ci];
      var spos = FM.maxI(0, -cpos);
      var di = spos * 2;
      for (i in spos...8192) {
        buffer[di++] += instr[cpos + i];
        buffer[di++] += instr[cpos + i];
      }
      pos[ci] += 8192;
      if (instr.length - pos[ci] < 8192) {
        channels[ci] = -1;
        pos[ci] = 0;
      }
    }
    beat -= 8192;
    for (i in 0...16384) {
      buffer[i] *= Main.volumeMusic;
    }
  }
}
