package;

import Bridge;

class OpenPandaWindow {
	public static function main() {
		// Call convenience method on host-side Bridge:
		Bridge.setBackground(0.1, 0.1, 0.2, 1.0);
		Bridge.log("Opened Panda Window!");
		// Or call the extern shim directly (if you expose api pointer to script types)
		// (Keeping it simple here.)
		Bridge.log("SURPRISE");

	}
}
