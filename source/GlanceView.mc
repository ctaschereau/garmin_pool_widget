using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;
import Toybox.Lang;

var lastGoodReadText as String?;

(:glance)
class GlanceView extends Ui.GlanceView {

    function initialize() {
        Ui.GlanceView.initialize();
    }

    function onShow() {
        WatchUi.requestUpdate();
    }

    function onUpdate(dc) {
        dc.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_TRANSPARENT);
    	// dc.drawRectangle(0, 0, dc.getWidth(), dc.getHeight());
        var label = Application.loadResource( Rez.Strings.AppName );
        dc.drawText(0, 0, Gfx.FONT_GLANCE, label, Gfx.TEXT_JUSTIFY_LEFT);
        if (lastGoodReadText == null) {
            var clockTime = System.getClockTime();
            var timeString = Lang.format("$1$:$2$:$3$", [
                clockTime.hour.format("%02d"), 
                clockTime.min.format("%02d"), 
                clockTime.sec.format("%02d")
            ]);
            dc.drawText(0, 20, Gfx.FONT_SYSTEM_XTINY, "42.28 @ " + timeString, Gfx.TEXT_JUSTIFY_LEFT);
        } else {
            dc.drawText(0, 20, Gfx.FONT_SYSTEM_XTINY, lastGoodReadText, Gfx.TEXT_JUSTIFY_LEFT);
        }
    }
}