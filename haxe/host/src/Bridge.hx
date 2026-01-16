package;

import haxe.CallStack;
import DirectApiExtern;

@:buildXml("
<files id='haxe'>
  <compilerflag value='-I../../include'/>
  <file name='../../haxe/host/cpp/api_shim.cpp'/>
  <file name='../../haxe/host/cpp/bridge_exports.cpp'/>
</files>
")
class Bridge {
  public static function main():Int return 0;

  @:keep
  public static function boot():Int {
    DirectApiShim.log("Bridge.boot() ok");
    return 0;
  }

  @:keep
  public static function runCppiaFile(path:String):Int {
    DirectApiShim.log("Running cppia: " + path);

    try {
      cpp.cppia.Host.runFile(path);
      DirectApiShim.log("Cppia finished OK.");
      return 0;
    } catch (e:Dynamic) {
      DirectApiShim.log("Cppia threw: " + Std.string(e));
      DirectApiShim.log("Stack:\n" + CallStack.toString(CallStack.exceptionStack()));
      return 1;
    }
  }

  @:keep
  public static function tick(dt:Float):Int {
    DirectApiShim.tick(dt);
    return 0;
  }

  @:keep
  public static function setBackground(r:Float, g:Float, b:Float, a:Float):Int {
    DirectApiShim.setBackgroundColorRGBA(r, g, b, a);
    return 0;
  }

  @:keep
  public static function log(msg:String):Int {
    DirectApiShim.log("Log: " + msg);
    return 0;
  }
}

