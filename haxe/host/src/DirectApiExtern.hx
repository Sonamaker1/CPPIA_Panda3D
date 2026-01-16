package;

// Include the shim header that declares the C functions

@:include("direct_api.h")
@:include("../../../haxe/host/cpp/api_shim.h")
extern class DirectApiExtern {
	// @:include("../../../haxe/host/cpp/api_shim.h")
	// no-op: we keep this only if you want to include the header for types
}

// These are plain C exports (no pointers, CPPIA-friendly)

@:include("direct_api.h")
@:include("../../../haxe/host/cpp/api_shim.h")
extern class DirectApiShim {
	@:native("direct_api_log_global_hx")
	static function log(msg:String):Void;

	@:native("direct_api_set_bg_global")
	static function setBackgroundColorRGBA(r:Single, g:Single, b:Single, a:Single):Void;

	@:native("direct_api_tick_global")
	static function tick(dt:Single):Void;
}
