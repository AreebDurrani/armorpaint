package arm.ui;

import haxe.io.Bytes;
import zui.Zui;
import zui.Ext;
import zui.Id;
import kha.Blob;
import iron.data.Data;
import arm.sys.Path;
import arm.io.ImportAsset;
import arm.App.tr;
using StringTools;

class TabScript {

	public static var hscript = Id.handle();

	@:access(zui.Zui)
	public static function draw() {
		var ui = UITrait.inst.ui;
		if (ui.tab(UITrait.inst.statustab, tr("Script")) && UITrait.inst.statush > UITrait.defaultStatusH * ui.SCALE()) {

			ui.row([1 / 20, 1 / 20, 1 / 20, 1 / 20]);
			if (ui.button(tr("Run"))) {
				try {
					untyped eval(hscript.text);
				}
				catch(e: Dynamic) {
					Log.trace(e);
				}
			}
			if (ui.button(tr("Clear"))) {
				hscript.text = "";
			}
			if (ui.button(tr("Import"))) {
				UIFiles.show("js", false, function(path: String) {
					Data.getBlob(path, function(b: Blob) {
						hscript.text = b.toString();
						Data.deleteBlob(path);
					});
				});
			}
			if (ui.button(tr("Export"))) {
				var str = hscript.text;
				UIFiles.show("js", true, function(path: String) {
					var f = UIFiles.filename;
					if (f == "") f = tr("untitled");
					path = path + Path.sep + f;
					if (!path.endsWith(".js")) path += ".js";
					Krom.fileSaveBytes(path, Bytes.ofString(str).getData());
				});
			}

			var _font = ui.ops.font;
			var _fontSize = ui.fontSize;
			Data.getFont("font_mono_ascii.ttf", function(f: kha.Font) { ui.ops.font = f; }); // Sync
			ui.fontSize = 15;
			Ext.textArea(ui, hscript);
			ui.ops.font = _font;
			ui.fontSize = _fontSize;
		}
	}
}
