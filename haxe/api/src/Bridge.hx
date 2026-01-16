package;

// Extern-only: provides typing, but does NOT emit bytecode into cppia.
// Must match the public methods you want scripts to call.
extern class Bridge {
  public static function setBackground(r:Float, g:Float, b:Float, a:Float):Int;
  public static function tick(dt:Float):Int;
  public static function log(msg:String):Int;
}
