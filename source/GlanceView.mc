using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;

var lastGoodReadText = "24C @ 11:25";

(:glance)
class GlanceView extends Ui.GlanceView {

    function initialize() {
        Ui.GlanceView.initialize();
    }

    function onUpdate(dc) {
        dc.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_TRANSPARENT);
    	dc.drawRectangle(0, 0, dc.getWidth(), dc.getHeight());
        var label = Application.loadResource( Rez.Strings.AppName );
        dc.drawText(0, 0, Gfx.FONT_GLANCE, label, Gfx.TEXT_JUSTIFY_LEFT);
        dc.drawText(0, 20, Gfx.FONT_SYSTEM_XTINY, lastGoodReadText, Gfx.TEXT_JUSTIFY_LEFT);
    }
}