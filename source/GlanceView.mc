using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;
import Toybox.Lang;
using Toybox.Application.Storage;

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

        var lastGoodReadText = Storage.getValue("lastGoodReadText");
        if (lastGoodReadText != null) {
            label += '\n' + lastGoodReadText;
        }
        dc.drawText(0, dc.getHeight() / 2, Gfx.FONT_GLANCE, label, Gfx.TEXT_JUSTIFY_LEFT | Gfx.TEXT_JUSTIFY_VCENTER);
    }
}