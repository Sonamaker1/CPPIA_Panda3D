package;

// Script calls these; they resolve to exported C functions in your host DLL.
extern class DirectApiShim {
  @:native("direct_api_log_global_hx")
  static function log(msg:String):Void;

  @:native("direct_api_set_bg_global")
  static function setBackgroundColorRGBA(r:Single, g:Single, b:Single, a:Single):Void;

  @:native("direct_api_tick_global")
  static function tick(dt:Single):Void;
}
